express = require 'express'
path = require 'path'
logger = require 'morgan'

app = express()

app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'

app.locals.pretty = true

app.use logger 'dev'

app.use (require 'connect-livereload')() if process.env.NODE_ENV == 'development'

app.use '/libs', express.static path.join __dirname, '..', '..', 'e2d3', 'dist', 'lib'

app.use '/data', require './routes/data'
app.get '/:chart/:data', require './routes/shares'

module.exports = app
