express = require 'express'

logger = require 'logger'

headers = require 'util/headers'
aliases = require 'util/aliases'

github = require '../../adapters/github'

router = express.Router()

router.get '/*', (req, res) ->
  path = req.params[0]
  path = aliases path

  github.getAsync "/repos/#{path}"
    .spread (apires, body) ->
      if apires.statusCode == 200
        res
          .type(body.name)
          .set(headers.cloneValidHeaders(apires.headers))
          .send(new Buffer(body.content, body.encoding))
      else
        res
          .status(apires.statusCode)
          .set(headers.cloneValidHeaders(apires.headers))
          .send('')
      undefined
    .catch (err) ->
      logger.error 'Error on getting files from GitHub', err
      res.status(500).json err

module.exports = router
