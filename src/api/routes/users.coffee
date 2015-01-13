express = require 'express'

router = express.Router()

router.get '/', (req, res) ->
  res.json charts: [ { baseUrl: '/files/github/e2d3/e2d3-contrib/master/sample', scriptType: 'coffeescript', dataType: 'csv' } ]

module.exports = router
