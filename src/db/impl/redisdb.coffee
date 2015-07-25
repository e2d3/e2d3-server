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
    new Promise (resolve, reject) ->
      redis.keys "#{KEY_PREFIX}*", (err, replies) ->
        return reject err if err
        return resolve 0 if replies.length == 0
        redis.del replies, (err, reply) ->
          return reject err if err
          resolve reply

class RedisDBCollection
  constructor: (name) ->
    @name = name

  get: (id) ->
    new Promise (resolve, reject) =>
      redis.hscan @name, '0', 'MATCH', "#{id}*", 'COUNT', '1', (err, reply) ->
        return reject err if err
        resolve reply[1][0]
    .then (key) =>
      throw new error.NotFoundError(@name, id) if !key
      new Promise (resolve, reject) =>
        redis.hget @name, key, (err, reply) ->
          return reject err if err
          resolve reply
    .then (entity) ->
      throw new error.NotFoundError(@name, id) if !entity
      Promise.resolve JSON.parse entity

  put: (id, doc) ->
    new Promise (resolve, reject) =>
      redis.hset @name, id, JSON.stringify(doc), (err, reply) ->
        return reject err if err
        resolve doc

module.exports = new RedisDBClient
