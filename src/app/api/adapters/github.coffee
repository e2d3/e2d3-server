fs = require 'fs'
request = require 'request-json'
Promise = require 'bluebird'

config = require 'config'
logger = require 'logger'

redis = require 'util/redis'

e2d3server = require '../../../../package.json'

clientOptions = {}

clientOptions.qs =
  client_id: 'b83c999af546ee06597e'
  client_secret: 'a3989b980d6ed1597a988784b0a256b99d1b1732'

if process.env.PROXY_DEBUG
  clientOptions.proxy = 'http://localhost:8888'
  clientOptions.ca = fs.readFileSync('/Users/chimera/charles-ssl-proxying-certificate.crt')

GITHUB_API_URL = process.env.GITHUB_API_URL || 'https://api.github.com'
ETAG_CACHE_PREFIX = 'github:'
CHECK_CACHE_PREFIX = 'github-check:'
CACHE_AGE = config.cacheAgeGitHub

###
# Github API用クライアント
###
class GithubJsonClient extends request.JsonClient
  constructor: (url, options) ->
    super url, options

    @headers['user-agent'] = "E2D3/#{e2d3server.version}"

    @makeCachableUsingEtag 'get'

    @hostMatch = new RegExp "^#{@host}"

    Promise.promisifyAll @

  ###
  # キャッシュキー生成
  ###
  createKey: (prefix, path) ->
    prefix + path.replace @hostMatch, ''

  ###
  # 保存されているキャッシュからデータを取得
  ###
  getFromETagCache: (path, options, callback) ->
    etagKey = @createKey ETAG_CACHE_PREFIX, path

    [options, callback] = [{}, options] if typeof options == 'function'

    redis.get etagKey, (err, reply) =>
      return callback err, null, null if err

      if reply
        return callback err, reply, reply.body

      @get path, options, callback

  ###
  # 指定された取得メソッドをETagで変更されているかチェックして取得ようにする
  ###
  makeCachableUsingEtag: (name) ->
    originalFunction = @[name]

    @[name] = (path, options, callback) =>
      etagKey = @createKey ETAG_CACHE_PREFIX, path
      checkKey = @createKey CHECK_CACHE_PREFIX, path

      # normalize arguments
      [options, callback] = [{}, options] if typeof options == 'function'

      # get etag and body from cache
      redis.mget etagKey, checkKey, (err, result) =>
        return callback err, null, null if err

        cached = if result[0] then JSON.parse result[0] else null
        checker = if result[1] then JSON.parse result[1] else null
        now = Date.now()

        setupCacheHeaders = (cached, checker) ->
          maxAge = Math.floor((checker?.lastChecked + CACHE_AGE - now) / 1000)
          maxAge = 0 if maxAge < 0
          cached.headers['cache-control'] = "max-age=#{maxAge}"

        # override callback
        loader = (err, res, body) ->
          # if error
          return callback? err, res, body if err
          # if not ok
          # return callback? err, res, body if res.statusCode != 200 && res.statusCode != 304

          if res.statusCode != 304
            # modified
            cached =
              statusCode: res.statusCode
              headers: res.headers
              body: body
            checker =
              lastChecked: now
            redis.mset etagKey, JSON.stringify(cached), checkKey, JSON.stringify(checker), (err, reply) ->
              logger.warn err if err
          else
            # not modified
            checker =
              lastChecked: now
            redis.set checkKey, JSON.stringify(checker), (err, reply) ->
              logger.warn err if err

          setupCacheHeaders cached, checker
          return callback? null, cached, cached.body

        if cached? && checker?.lastChecked? && now - checker.lastChecked < CACHE_AGE
          setupCacheHeaders cached, checker
          return callback null, cached, cached.body
        else if cached
          # return cached data immediately & reload data in background
          options.headers ?= {}
          options.headers['if-none-match'] = cached.headers.etag if cached.headers.etag
          [originalCallback, callback] = [callback, null]
          originalFunction.call @, path, options, loader
          setupCacheHeaders cached, checker
          return originalCallback null, cached, cached.body
        else
          return originalFunction.call @, path, options, loader

module.exports = new GithubJsonClient GITHUB_API_URL, clientOptions
