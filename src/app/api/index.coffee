express = require 'express'
path = require 'path'
morgan = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
cors = require 'cors'

config = require 'config'

app = express()

app.use morgan 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: false
app.use cookieParser()

app.use cors origin: config.corsOrigin

app.use (require 'connect-livereload')() if config.isInDevelopment

app.use '/api', require './routes/api'
app.use '/files', require './routes/files'

app.use express.static path.join __dirname, '..', '..', '..', 'e2d3', 'dist'

module.exports = app
