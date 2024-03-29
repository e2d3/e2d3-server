express = require 'express'
Promise = require 'bluebird'

config = require 'config'
logger = require 'logger'

charts = require 'db/collection/chart'
parameters = require 'db/collection/parameter'
data = require 'db/collection/data'
datastorage = require 'storage/container/data'
thumbnail = require 'queue/kind/thumbnail'
chartpath = require 'chartpath'

router = express.Router()

router.post '/', (req, res) ->
  return res.sendStatus 400 if !req.body?

  chartinfo =
    path: req.body.chart.path
    type: req.body.chart.scriptType

  promises =
    chart: charts.put chartinfo
    parameter: parameters.put req.body.parameter
    data: data.put req.body.data

  Promise.props promises
    .then (result) ->
      datastorage.put result.data, req.body.data
        .then (storagepath) ->
          path = "#{result.chart[0...7]}/#{result.parameter[0...7]}/#{result.data[0...32]}"
          message =
            path: path
            url: "#{config.shareBase}/#{path}"
          thumbnail.post message
    .then (chart) ->
      res.json chart
    .catch (err) ->
      logger.error 'Error on share data', err
      res.status(500).json
        code: 500
        detail: err

module.exports = router
