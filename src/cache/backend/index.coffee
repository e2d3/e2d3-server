cacheManager = require 'cache-manager'
redisStore = require './redis_store'

cache = cacheManager.caching
  store: redisStore,
  host: process.env.REDIS_HOST ? '127.0.0.1'
  port: process.env.REDIS_PORT ? 6379
  auth_pass: process.env.REDIS_AUTH_PASS
  db: 0,
  ttl: 0

module.exports = cache
