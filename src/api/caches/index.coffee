cacheManager = require 'cache-manager'

cache = cacheManager.caching
  store: 'memory'
  max: 200
  ttl: 3600

module.exports = cache
