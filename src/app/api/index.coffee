express = require 'express'
path = require 'path'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
cors = require 'cors'

config = require 'config'
cacher = require 'cache/frontend'

app = express()

app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: false
app.use cookieParser()

app.use cors origin: config.corsOrigin

app.use (require 'connect-livereload')() if process.env.NODE_ENV == 'development'

app.use '/api', cacher.cache 'minutes', 1
app.use '/files', cacher.cache 'minutes', 10

app.use '/api', require './routes/api'
app.use '/files', require './routes/files'

app.use express.static path.join __dirname, '..', '..', '..', 'e2d3', 'dist'

module.exports = app
