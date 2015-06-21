express = require 'express'

config = require '../config'

router = express.Router()

router.get '/test', (req, res) ->
  params =
    baseUrl: config.fileBase + '/github/e2d3/e2d3-contrib/contents/barchart-javascript'
    scriptType: 'js'
    dataType: 'csv'

  res.render 'standalone', params

module.exports = router
