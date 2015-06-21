express = require 'express'
vhost = require 'vhost'

config = require './config'

api = require './api'
share = require './share'

app = express()

app.use(vhost(config.domainApi, api))
app.use(vhost(config.domainShare, share))

module.exports = app
