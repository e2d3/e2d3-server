Cacher = require 'cacher'
CacherRedis = require 'cacher-redis'

options =
  host: process.env.REDIS_HOST ? '127.0.0.1'
  port: process.env.REDIS_PORT ? 6379
  auth_pass: process.env.REDIS_AUTH_PASS

cacher = new Cacher new CacherRedis options.port, options.host, options

module.exports = cacher
