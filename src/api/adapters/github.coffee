fs = require 'fs'
request = require 'request-json'
Promise = require 'bluebird'

cache = require './cache'

options = {}

options.qs =
  client_id: process.env.GITHUB_CLIENT_ID
  client_secret: process.env.GITHUB_CLIENT_SECRET

if process.env.PROXY_DEBUG
  options.proxy = 'http://localhost:8888'
  options.ca = fs.readFileSync('/Users/chimera/charles-ssl-proxying-certificate.crt')

GITHUB_API_URL = process.env.GITHUB_API_URL || 'https://api.github.com/'


class GithubJsonClient extends request.JsonClient
  constructor: (url, options) ->
    super url, options

    @headers['user-agent'] = 'E2D3/0.4.0'

    @makeCachable 'get'

  getFromCache: (path, options, callback, parse) ->
      if typeof options == 'function'
        callback = options

      cache.get path, (err, result) =>
        return callback err, null, null if err

        callback err, { headers: result.headers }, result.body

  makeCachable: (name) ->
    @[name] = (path, options, callback, parse) =>
      # normalize arguments
      if typeof options == 'function'
        parse = callback
        callback = options
        options = {}

      # get etag and body from cache
      cache.get path, (err, result) =>
        return callback err, null, null if err

        cached = null # cached object
        if result
          cached = result
          options.headers ?= {}
          options.headers['if-none-match'] = result.headers.etag

        originalCallback = callback

        # override callback
        callback = (err, res, body) ->
          return originalCallback err, res, body if err

          if res.statusCode == 304
            originalCallback err, res, cached.body
          else
            caching =
              headers: res.headers
              body: body
            cache.set path, caching, {}, () ->
              originalCallback err, res, body

        request.JsonClient.prototype[name].call @, path, options, callback, parse

github = Promise.promisifyAll new GithubJsonClient GITHUB_API_URL, options

module.exports = github
