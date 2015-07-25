###
# For development purposes only
###

redis = require 'util/redis'
Promise = require 'bluebird'

error = require 'error'

KEY_PREFIX = 'storage:'

class RedisStorageClient
  constructor: () ->

  container: (name) ->
    new RedisStorageContainer KEY_PREFIX + name

  clear: () ->
    redis.clear KEY_PREFIX

class RedisStorageContainer
  constructor: (name) ->
    @name = name

  get: (path) ->
    new Promise (resolve, reject) =>
      redis.hget @name, path, (err, reply) ->
        return reject err if err
        resolve reply
    .then (json) =>
      throw new error.NotFoundError(@name, path) if !json
      doc = JSON.parse json
      doc.data = new Buffer doc.data, 'base64'
      Promise.resolve doc

  put: (path, options, buffer) ->
    new Promise (resolve, reject) =>
      doc =
        options: options
        data: buffer.toString 'base64'
      redis.hset @name, path, JSON.stringify(doc), (err, reply) ->
        return reject err if err
        resolve path

module.exports = new RedisStorageClient
