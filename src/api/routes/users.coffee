express = require 'express'

router = express.Router()

router.get '/', (req, res) ->
  res.json charts: [ { type: 'cs', baseUrl: '/files/github/e2d3/e2d3-contrib/master/sample' } ]

module.exports = router
