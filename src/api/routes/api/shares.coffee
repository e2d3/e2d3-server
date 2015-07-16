express = require 'express'
Promise = require 'bluebird'

config = require '../../../config'

charts = require '../../../common/db/collection/chart'
data = require '../../../common/db/collection/data'

thumbnail = require '../../../common/queue/kind/thumbnail'

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
    .catch (error) ->
      res.status(500).json
        code: 500
        detail: error

module.exports = router
