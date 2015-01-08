express = require 'express'

router = express.Router()

router.get '/', (req, res) ->
  # res.json name: "e2d3-server", version: "0.3.0"
  res.json charts: [ { baseUrl: "/github/chimerast/e2d3-sample/master" } ]

module.exports = router
