express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'

port = process.env.PORT or 3000

app = express()

app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: false
app.use cookieParser()

app.use (require 'connect-livereload')() if process.env.NODE_ENV == 'development'

app.use express.static path.join __dirname, 'public'
app.use '/apps', express.static path.join __dirname, '..', 'e2d3', 'dist'

app.use '/api/users', require './routes/users'
app.use '/files', require './routes/files'

module.exports = app
