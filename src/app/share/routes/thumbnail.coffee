express = require 'express'

error = require 'error'
logger = require 'logger'

thumbnail = require 'storage/container/thumbnail'

router = express.Router()

router.get '/:chart/:data', (req, res) ->
  thumbnail.get "#{req.params.chart}/#{req.params.data}"
    .then (buffer) ->
      res
        .header 'content-type', 'image/png'
        .end buffer.toString('binary'), 'binary'
    .catch error.NotFoundError, (err) ->
      res.status(404).json
        code: 404
        detail: err
    .catch (err) ->
      logger.error 'Error on send data', err
      res.status(500).json
        code: 500
        detail: err

router.get '/:chart/:parameter/:data', (req, res) ->
  thumbnail.get "#{req.params.chart}/#{req.params.parameter}/#{req.params.data}"
    .then (buffer) ->
      res
        .header 'content-type', 'image/png'
        .end buffer.toString('binary'), 'binary'
    .catch error.NotFoundError, (err) ->
      res.status(404).json
        code: 404
        detail: err
    .catch (err) ->
      logger.error 'Error on send data', err
      res.status(500).json
        code: 500
        detail: err

module.exports = router
