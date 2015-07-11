express = require 'express'
path = require 'path'
logger = require 'morgan'

app = express()

app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'

app.use logger 'dev'

app.use (require 'connect-livereload')() if process.env.NODE_ENV == 'development'

app.use '/s', require './share'
app.use '/l', express.static path.join __dirname, '..', '..', 'e2d3', 'dist', 'lib'

app.use '/d', require './routes/data'

module.exports = app
