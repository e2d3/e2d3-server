express = require 'express'

github = require '../../adapters/github'

router = express.Router()

router.get '/*', (req, res) ->
  path = req.params[0]

  github.getAsync "/repos/#{path}"
    .spread (apires, body) ->
      if apires.statusCode == 200 || apires.statusCode == 304
        res.type(body.name).send(new Buffer(body.content, body.encoding))
      else
        res.status(apires.statusCode).end()
      undefined
    .catch (err) ->
      res.status(500).json err

module.exports = router
