redis = require 'redis'
logger = require 'logger'

client = redis.createClient()

client.on 'error', (err) ->
  logger.error 'Error on redis', err

module.exports = client
