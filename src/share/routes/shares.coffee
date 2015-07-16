Promise = require 'bluebird'

config = require '../../config'
common = require '../../common'
chartpath = require '../../common/chartpath'
charts = require '../../common/db/collection/chart'
data = require '../../common/db/collection/data'

module.exports = (req, res) ->
  promises =
    chart: charts.get req.params.chart

  Promise.props promises
    .then (result) ->
      params =
        baseUrl: chartpath result.chart
        dataUrl: "#{config.dataBase}/#{req.params.data}"
        scriptType: result.chart.type
        dataType: 'tsv'
      res.render 'standalone', params
    .catch common.NotFoundError, (error) ->
      res.status(404).json
        code: 404
        detail: error
    .catch (error) ->
      res.status(500).json
        code: 500
        detail: error
