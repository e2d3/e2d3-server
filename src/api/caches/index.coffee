cacheManager = require 'cache-manager'
redisStore = require './redis_store'

#cache = cacheManager.caching store: 'memory', max: 200, ttl: 3600
cache = cacheManager.caching store: redisStore, db: 0, ttl: 0

module.exports = cache
