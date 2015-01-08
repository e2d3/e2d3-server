express = require 'express'

router = express.Router()

router.use '/github', require './github'

module.exports = router
