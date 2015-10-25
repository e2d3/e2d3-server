express = require 'express'
path = require 'path'
morgan = require 'morgan'

config = require 'config'

app = express()

app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'

app.locals.pretty = true

app.use morgan 'dev'

app.use (require 'connect-livereload')() if config.isInDevelopment

app.use '/lib', express.static path.join(__dirname, '..', '..', '..', 'e2d3', 'dist', 'lib'), maxAge: config.cacheAgeStatic

app.use '/data', require './routes/data'
app.use '/thumbnails', require './routes/thumbnail'
app.get '/:chart/:data', require './routes/shares'
app.get '/:chart/:parameter/:data', require './routes/shares'

module.exports = app
