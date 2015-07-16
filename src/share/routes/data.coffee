express = require 'express'

common = require '../../common'
data = require '../../common/db/collection/data'

router = express.Router()

router.get '/:id', (req, res) ->
  data.get req.params.id
    .then (tsv) ->
      res
        .header 'content-type', 'text/plain'
        .send tsv
    .catch common.NotFoundError, (error) ->
      res.status(404).json
        code: 404
        detail: error
    .catch (error) ->
      res.status(500).json
        code: 500
        detail: error

module.exports = router
