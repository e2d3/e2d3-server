fs = require 'fs'
request = require 'request-json'
Promise = require 'bluebird'

cache = require '../caches'

options = {}

options.qs =
  client_id: process.env.GITHUB_CLIENT_ID
  client_secret: process.env.GITHUB_CLIENT_SECRET

if process.env.PROXY_DEBUG
  options.proxy = 'http://localhost:8888'
  options.ca = fs.readFileSync('/Users/chimera/charles-ssl-proxying-certificate.crt')

GITHUB_API_URL = process.env.GITHUB_API_URL || 'https://api.github.com/'
ETAG_CACHE_PREFIX = 'etag:'
TTL_CACHE_PREFIX = 'ttl:'

class GithubJsonClient extends request.JsonClient
  constructor: (url, options) ->
    super url, options

    @headers['user-agent'] = 'E2D3/0.4.0'

    @makeCachableUsingEtag 'get'
    @makeCachableUsingTTL 'get'

    Promise.promisifyAll @

  ###
  # 保存されているキャッシュからデータを取得
  ###
  getFromCache: (path, options, callback, parse) ->
    key = TTL_CACHE_PREFIX + path

    if typeof options == 'function'
      [options, callback, parse] = [{}, options, callback]

    cache.get key, (err, result) =>
      return callback err, null, null if err

      if result
        return callback err, { headers: result.headers }, result.body

      @get path, options, callback, parse

  ###
  # 指定された取得メソッドをETagで変更されているかチェックして取得ようにする
  ###
  makeCachableUsingEtag: (name) ->
    originalFunction = @[name]

    @[name] = (path, options, callback, parse) =>
      key = ETAG_CACHE_PREFIX + path

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

          # console.log res.headers

          if res.statusCode == 304
            return callback err, res, cached.body

          caching =
            headers: res.headers
            body: body
          cache.set key, caching, {}, () ->
            callback err, res, body

        originalFunction.call @, path, options, proxy, parse

  makeCachableUsingTTL: (name) ->
    originalFunction = @[name]

    @[name] = (path, options, callback, parse) =>
      key = TTL_CACHE_PREFIX + path

      # normalize arguments
      if typeof options == 'function'
        [options, callback, parse] = [{}, options, callback]

      cache.get key, (err, result) =>
        return callback err, null, null if err

        if result
          return callback err, { headers: result.headers }, result.body

        # override callback
        proxy = (err, res, body) ->
          return callback err, res, body if err

          caching =
            headers: res.headers
            body: body
          cacheOptions =
            ttl: 60
          cache.set key, caching, cacheOptions, (err) ->
            callback err, res, body

        originalFunction.call @, path, options, proxy, parse


github = new GithubJsonClient GITHUB_API_URL, options

module.exports = github
