fs = require 'fs'
request = require 'request-json'
Promise = require 'bluebird'

logger = require 'logger'

redis = require 'util/redis'

e2d3server = require '../../../../package.json'

options = {}

options.qs =
  client_id: process.env.GITHUB_CLIENT_ID
  client_secret: process.env.GITHUB_CLIENT_SECRET

if process.env.PROXY_DEBUG
  options.proxy = 'http://localhost:8888'
  options.ca = fs.readFileSync('/Users/chimera/charles-ssl-proxying-certificate.crt')

GITHUB_API_URL = process.env.GITHUB_API_URL || 'https://api.github.com'
ETAG_CACHE_PREFIX = 'github:'
CHECK_CACHE_PREFIX = 'github-check:'
CACHE_AGE = 60 * 1000

###
# Github API用クライアント
#
# APIアクセス制限を回避するためにETagでの変更検出を行う
# 以前は一定期間の無条件のキャッシュも行っていたが、
# それはフロントで行うようにした (app.coffee参照)
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

        if cached
          options.headers ?= {}
          options.headers['if-none-match'] = cached.headers.etag

        # override callback
        loader = (err, res, body) ->
          # if error
          return callback? err, res, body if err
          # if not ok
          return callback? err, res, body if res.statusCode != 200 && res.statusCode != 304

          # if modified
          if res.statusCode == 200
            cached =
              statusCode: res.statusCode
              headers: res.headers
              body: body
            checker =
              lastChecked: now
            redis.mset etagKey, JSON.stringify(cached), checkKey, JSON.stringify(checker), (err, reply) ->
              logger.warn err if err
          else if res.statusCode == 304
            checker =
              lastChecked: now
            redis.set checkKey, JSON.stringify(checker), (err, reply) ->
              logger.warn err if err

          return callback? null, cached, cached.body

        if cached? && checker?.lastChecked? && now - checker.lastChecked < CACHE_AGE
          return callback null, cached, cached.body
        else if cached
          [originalCallback, callback] = [callback, null]
          originalFunction.call @, path, options, loader
          return originalCallback null, cached, cached.body
        else
          return originalFunction.call @, path, options, loader

module.exports = new GithubJsonClient GITHUB_API_URL, options
