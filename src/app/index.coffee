express = require 'express'
vhost = require 'vhost'

config = require 'config'

app = express()

app.use(vhost(config.domainApi, (require './api')))
app.use(vhost(config.domainShare, (require './share')))

module.exports = app
