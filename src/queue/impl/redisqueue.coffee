###
# For development purposes only
###

redis = require 'util/redis'
Promise = require 'bluebird'

error = require 'error'

KEY_PREFIX = 'queue:'

class RedisQueueClient
  constructor: () ->

  kind: (name) ->
    new RedisQueue KEY_PREFIX + name

  clear: () ->
    redis.clear KEY_PREFIX

class RedisQueue
  constructor: (name) ->
    @name = name

  get: () ->
    new Promise (resolve, reject) =>
      redis.lindex @name, -1, (err, reply) ->
        return reject err if err
        resolve reply
    .then (message) =>
      throw new error.NotAvailableError(@name) if !message
      Promise.resolve new RedisQueueMessage @name, message

  post: (doc) ->
    new Promise (resolve, reject) =>
      redis.lpush @name, JSON.stringify(doc), (err, reply) ->
        return reject err if err
        resolve doc

class RedisQueueMessage
  constructor: (name, message) ->
    @name = name
    @message = message

  value: () ->
    JSON.parse @message

  delete: () ->
    new Promise (resolve, reject) =>
      redis.rpop @name, (err, reply) ->
        return reject err if err
        resolve reply

module.exports = new RedisQueueClient
