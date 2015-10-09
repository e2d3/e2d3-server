Promise = require 'bluebird'

config = require 'config'
error = require 'error'
logger = require 'logger'

charts = require 'db/collection/chart'
data = require 'db/collection/data'
chartpath = require 'chartpath'

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
        baseUrl: chartpath.decodeWithBase result.chart.path
        dataUrl: "#{config.dataBase}/#{req.params.data}"
        scriptType: result.chart.type
        dataType: 'tsv'
        thumbnailUrl: "#{config.thumbnailBase}/#{path}"
      res
        .header 'cache-control', "public, max-age=#{config.cacheAgeStatic/1000}"
        .render 'standalone', params
    .catch error.NotFoundError, (err) ->
      res.status(404).json
        code: 404
        detail: err
    .catch (err) ->
      logger.error 'Error on send chart', err
      res.status(500).json
        code: 500
        detail: err
