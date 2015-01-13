express = require 'express'

router = express.Router()

router.get '/', (req, res) ->
  res.json charts: [
    baseUrl: '/files/github/E2D3/e2d3-contrib/master/japanmap-coffeescript'
    scriptType: 'coffee'
    dataType: 'csv'
  ,
    baseUrl: '/files/github/E2D3/e2d3-contrib/master/japanmap-javascript'
    scriptType: 'js'
    dataType: 'tsv'
  ,
    baseUrl: '/files/github/E2D3/e2d3-contrib/master/barchart-javascript'
    scriptType: 'js'
    dataType: 'csv'
  ]

module.exports = router
