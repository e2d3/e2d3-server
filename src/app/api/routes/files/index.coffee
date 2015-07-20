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

module.exports = router
