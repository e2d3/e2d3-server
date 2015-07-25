express = require 'express'
Promise = require 'bluebird'

config = require 'config'
logger = require 'logger'

charts = require 'db/collection/chart'
data = require 'db/collection/data'
thumbnail = require 'queue/kind/thumbnail'
chartpath = require 'util/chartpath'

router = express.Router()

router.post '/', (req, res) ->
  return res.sendStatus 400 if !req.body?

  chart =
    path: chartpath.encode req.body.chart.baseUrl
    type: req.body.chart.scriptType

  promises =
    chart: charts.put chart
    data: data.put req.body.data

  Promise.props promises
    .then (result) ->
      path = "#{result.chart[0...7]}/#{result.data[0...32]}"
      message =
        path: path
        url: "#{config.shareBase}/#{path}"
      thumbnail.post message
    .then (chart) ->
      res.json chart
    .catch (err) ->
      res.status(500).json
        code: 500
        detail: err

module.exports = router
