express = require 'express'

datacollection = require '../../../common/db/collection/data'

router = express.Router()

router.post '/', (req, res) ->
  return res.sendStatus 400 if !req.body?.data?

  datacollection.put req.body.data
    .then (hash) ->
      res.json id: hash
    .catch (error) ->
      res.status(500).json
        code: 500
        detail: error

module.exports = router
