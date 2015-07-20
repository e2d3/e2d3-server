Promise = require 'bluebird'

config = require 'config'
error = require 'error'
chartpath = require 'util/chartpath'
charts = require 'db/collection/chart'
data = require 'db/collection/data'

module.exports = (req, res) ->
  promises =
    chart: charts.get req.params.chart

  Promise.props promises
    .then (result) ->
      path = "#{req.params.chart}/#{req.params.data}"
      params =
        title: "#{result.chart.path} - E2D3"
        path: path
        selfUrl: "#{config.shareBase}/#{path}"
        baseUrl: chartpath result.chart
        dataUrl: "#{config.dataBase}/#{req.params.data}"
        scriptType: result.chart.type
        dataType: 'tsv'
      res.render 'standalone', params
    .catch error.NotFoundError, (err) ->
      res.status(404).json
        code: 404
        detail: err
    .catch (err) ->
      res.status(500).json
        code: 500
        detail: err
