express = require 'express'

logger = require 'logger'

headers = require 'util/headers'

github = require 'app/api/adapters/github'

router = express.Router()

router.get '/:id/:name', (req, res) ->
  github.getAsync "/gists/#{req.params.id}"
    .spread (apires, body) ->
      if apires.statusCode == 200
        file = body.files[req.params.name]
        if file?
          res
            .type(file.filename)
            .set(headers.cloneValidHeaders(apires.headers, file.size))
            .send(new Buffer(file.content, 'utf8'))
        else
          res
            .status(404)
            .set(headers.cloneValidHeaders(apires.headers))
            .send('')
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
