express = require 'express'
Promise = require 'bluebird'

charts = require '../../../common/db/collection/chart'
data = require '../../../common/db/collection/data'

router = express.Router()

router.post '/', (req, res) ->
  return res.sendStatus 400 if !req.body?

  promises =
    chart: charts.put req.body.chart
    data: data.put req.body.data

  Promise.props promises
    .then (result) ->
      res.json path: "#{result.chart}/#{result.data}"
    .catch (error) ->
      res.status(500).json
        code: 500
        detail: error

module.exports = router
