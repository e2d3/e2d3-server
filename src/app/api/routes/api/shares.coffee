express = require 'express'
Promise = require 'bluebird'

config = require 'config'

charts = require 'db/collection/chart'
data = require 'db/collection/data'

thumbnail = require 'queue/kind/thumbnail'

router = express.Router()

router.post '/', (req, res) ->
  return res.sendStatus 400 if !req.body?

  promises =
    chart: charts.put req.body.chart
    data: data.put req.body.data

  Promise.props promises
    .then (result) ->
      path = "#{result.chart[0...7]}/#{result.data[0...32]}"
      chart =
        path: path
        url: "#{config.shareBase}/#{path}"
      thumbnail.post chart
    .then (chart) ->
      res.json chart
    .catch (err) ->
      res.status(500).json
        code: 500
        detail: err

module.exports = router
