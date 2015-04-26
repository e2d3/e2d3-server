express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'

app = express()

app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: false
app.use cookieParser()

app.use (require 'connect-livereload')() if process.env.NODE_ENV == 'development'

options =
  host: process.env.REDIS_HOST ? '127.0.0.1'
  port: process.env.REDIS_PORT ? 6379
  auth_pass: process.env.REDIS_AUTH_PASS

Cacher = require 'cacher'
CacherRedis = require 'cacher-redis'
cacher = new Cacher new CacherRedis options.port, options.host, options

app.use '/api', cacher.cache 'minutes', 1
app.use '/files', cacher.cache 'minutes', 10

app.use '/api', require './routes/api'
app.use '/files', require './routes/files'

# DEPRECATED
app.use '/App', express.static path.join __dirname, '..', 'e2d3', 'dist'

app.use express.static path.join __dirname, '..', 'e2d3', 'dist'

module.exports = app
