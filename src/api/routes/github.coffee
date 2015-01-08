express = require 'express'
httpProxy = require 'http-proxy'

router = express.Router()
proxy = httpProxy.createProxyServer {}

proxy.on 'proxyRes', (proxyRes, req, res) ->
  endsWith = (str, suffix) ->
    str.indexOf(suffix, str.length - suffix.length) != -1

  if endsWith req.url, '.js'
    proxyRes.headers['content-type'] = 'application/javascript'
  else if endsWith req.url, '.coffee'
    proxyRes.headers['content-type'] = 'text/coffeescript'

router.get '/:user/:project/:revision/*:path', (req, res) ->
  user = req.param 'user'
  project = req.param 'project'
  revision = req.param 'revision'
  path = req.param 'path'

  req.headers.host = 'raw.githubusercontent.com'

  delete req.headers['accept-encoding']

  proxy.web req, res, target: 'https://raw.githubusercontent.com/'

module.exports = router
