Promise = require 'bluebird'

error = require 'error'
logger = require 'logger'
queue = require 'queue/kind/thumbnail'
storage = require 'storage/container/thumbnail'

takeScreenShot = require './take-screen-shot'

retrieveRequestFromQueueAndTakeScreenShot = () ->
  queue.get()
    .then (message) ->
      logger.info 'Remove message from queue', message
      message.delete()
        .then () ->
          Promise.resolve message
    .then (message) ->
      chart = message.value()
      storage.exists chart.path
        .then () ->
          logger.info 'Already exits', chart
          Promise.resolve message
        .catch error.NotFoundError, () ->
          logger.info 'Take screenshot', chart
          takeScreenShot chart.url
            .then (buffer) ->
              logger.info 'Upload screenshot to \'%s\'', chart.path
              storage.put chart.path, buffer
            .then () ->
              Promise.resolve message
    .then () ->
      logger.info 'Succeeded & go next'
      retrieveRequestFromQueueAndTakeScreenShot()
      undefined
    .catch error.NotAvailableError, (err) ->
      process.exit 0
    .catch (err) ->
      logger.error err
      process.exit 1

retrieveRequestFromQueueAndTakeScreenShot()
