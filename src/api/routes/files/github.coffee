express = require 'express'
httpProxy = require 'http-proxy'
mime = require 'mime-types'

router = express.Router()
proxy = httpProxy.createProxyServer {}

proxy.on 'proxyRes', (proxyRes, req, res) ->
  for own key of proxyRes.headers
    if (key.indexOf 'x-') == 0
      delete proxyRes.headers[key]

  proxyRes.headers['content-type'] = mime.lookup req.url

router.get '/:user/:project/:revision/*:path', (req, res) ->
  req.headers.host = 'raw.githubusercontent.com'

  delete req.headers['accept-encoding']

  proxy.web req, res, target: 'https://raw.githubusercontent.com/'

module.exports = router
