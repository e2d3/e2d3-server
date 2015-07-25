express = require 'express'

error = require 'error'
logger = require 'logger'
data = require 'db/collection/data'

router = express.Router()

router.get '/:id', (req, res) ->
  data.get req.params.id
    .then (tsv) ->
      res
        .header 'content-type', 'text/plain'
        .send tsv
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
