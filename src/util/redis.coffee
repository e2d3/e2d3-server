redis = require 'redis'
logger = require 'logger'
Promise = require 'bluebird'

client = redis.createClient()

client.on 'error', (err) ->
  logger.error 'Error on redis', err

client.clear = (prefix) ->
  new Promise (resolve, reject) ->
    client.keys "#{prefix}*", (err, replies) ->
      return reject err if err
      return resolve 0 if replies.length == 0
      client.del replies, (err, reply) ->
        return reject err if err
        resolve reply

module.exports = client
