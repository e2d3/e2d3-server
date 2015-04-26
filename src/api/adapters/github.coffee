fs = require 'fs'
request = require 'request-json'
Promise = require 'bluebird'

cache = require '../caches'

options = {}

options.qs =
  client_id: 'b83c999af546ee06597e'
  client_secret: 'a3989b980d6ed1597a988784b0a256b99d1b1732'

if process.env.PROXY_DEBUG
  options.proxy = 'http://localhost:8888'
  options.ca = fs.readFileSync('/Users/chimera/charles-ssl-proxying-certificate.crt')

GITHUB_API_URL = process.env.GITHUB_API_URL || 'https://api.github.com'
ETAG_CACHE_PREFIX = 'github:'

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

    @headers['user-agent'] = 'E2D3/0.4.0'

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
  getFromETagCache: (path, options, callback, parse) ->
    key = @createKey ETAG_CACHE_PREFIX, path

    if typeof options == 'function'
      [options, callback, parse] = [{}, options, callback]

    cache.get key, (err, result) =>
      return callback err, null, null if err

      if result
        return callback err, result, result.body

      @get path, options, callback, parse

  ###
  # 指定された取得メソッドをETagで変更されているかチェックして取得ようにする
  ###
  makeCachableUsingEtag: (name) ->
    originalFunction = @[name]

    @[name] = (path, options, callback, parse) =>
      key = @createKey ETAG_CACHE_PREFIX, path

      # normalize arguments
      if typeof options == 'function'
        [options, callback, parse] = [{}, options, callback]

      # get etag and body from cache
      cache.get key, (err, result) =>
        return callback err, null, null if err

        cached = null # cached object
        if result
          cached = result
          options.headers ?= {}
          options.headers['if-none-match'] = result.headers.etag

        # override callback
        proxy = (err, res, body) ->
          return callback err, res, body if err

          # if not modified
          if res.statusCode == 304
            return callback err, res, cached.body

          # if not ok
          if res.statusCode != 200
            return callback err, res, body

          caching =
            statusCode: res.statusCode
            headers: res.headers
            body: body
          cache.set key, caching, {}, () ->
            callback err, res, body

        originalFunction.call @, path, options, proxy, parse

github = new GithubJsonClient GITHUB_API_URL, options

module.exports = github
