express = require 'express'
fs = require 'fs'
path = require 'path'

router = express.Router()

files = fs.readdirSync __dirname
  .filter (v) -> /\.js$/.test v

for file in files
  modulename = path.basename file, '.js'
  continue if modulename == 'index'
  router.use '/' + modulename, require './' + modulename

e2d3 = require '../../../e2d3/package.json'
e2d3server = require '../../../package.json'

router.get '/', (req, res) ->
  res.json
    versions:
      'e2d3': e2d3.version
      'e2d3-server': e2d3server.version

module.exports = router
