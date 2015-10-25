Promise = require 'bluebird'

config = require 'config'
error = require 'error'
logger = require 'logger'

charts = require 'db/collection/chart'
parameters = require 'db/collection/parameter'
data = require 'db/collection/data'
chartpath = require 'chartpath'

module.exports = (req, res) ->
  promises = {}
  promises.chart = charts.get req.params.chart
  promises.parameter = parameters.get req.params.parameter if req.params.parameter?

  Promise.props promises
    .then (result) ->

      if req.params.parameter?
        path = "#{req.params.chart}/#{req.params.parameter}/#{req.params.data}"
      else
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
        parameter: JSON.stringify(result.parameter ? {})
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
