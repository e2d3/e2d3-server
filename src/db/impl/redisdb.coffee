###
# For development purposes only
###

redis = require 'util/redis'
Promise = require 'bluebird'

error = require 'error'

KEY_PREFIX = 'db:'

class RedisDBClient
  constructor: () ->

  collection: (name) ->
    new RedisDBCollection KEY_PREFIX + name

  clear: () ->
    redis.clear KEY_PREFIX

class RedisDBCollection
  constructor: (name) ->
    @name = name

  get: (id) ->
    new Promise (resolve, reject) =>
      # scan only 1000 keys
      redis.hscan @name, '0', 'MATCH', "#{id}*", 'COUNT', '1000', (err, reply) ->
        return reject err if err
        resolve reply[1][0]
    .then (key) =>
      throw new error.NotFoundError(@name, id) if !key
      new Promise (resolve, reject) =>
        redis.hget @name, key, (err, reply) ->
          return reject err if err
          resolve reply
    .then (json) ->
      throw new error.NotFoundError(@name, id) if !json
      Promise.resolve JSON.parse json

  put: (id, doc) ->
    new Promise (resolve, reject) =>
      redis.hset @name, id, JSON.stringify(doc), (err, reply) ->
        return reject err if err
        resolve doc

module.exports = new RedisDBClient
