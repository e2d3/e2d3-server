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

app.use '/api', require './routes/api'
app.use '/files', require './routes/files'

app.get '/App/*', (req, res) ->
  res.redirect '/'

app.use express.static path.join __dirname, '..', 'e2d3', 'dist'

module.exports = app
