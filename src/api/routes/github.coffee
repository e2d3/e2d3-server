express = require 'express'
httpProxy = require 'http-proxy'

router = express.Router()
proxy = httpProxy.createProxyServer {}

router.get '/:user/:project/:revision/*:path', (req, res) ->
  user = req.param 'user'
  project = req.param 'project'
  revision = req.param 'revision'
  path = req.param 'path'

  req.headers.host = 'raw.githubusercontent.com'

  delete req.headers['accept-encoding']

  proxy.web req, res, target: 'https://raw.githubusercontent.com/'

module.exports = router
