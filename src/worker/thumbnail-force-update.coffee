Promise = require 'bluebird'

config = require 'config'
error = require 'error'
logger = require 'logger'
storage = require 'storage/container/thumbnail'

takeScreenShot = require './take-screen-shot'

path = process.argv[3]

chart =
  path: path
  url: "#{config.shareBase}/#{path}"

retrieveRequestFromArgumentAndTakeScreenShot = () ->
  logger.info 'Take screenshot', chart
  takeScreenShot chart.url
    .then (buffer) ->
      logger.info 'Upload screenshot to \'%s\'', chart.path
      storage.put chart.path, buffer
  .then () ->
    logger.info 'Succeeded'
    process.exit 0
  .catch (err) ->
    logger.error err
    process.exit 1

retrieveRequestFromArgumentAndTakeScreenShot()
