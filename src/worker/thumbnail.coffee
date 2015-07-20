webshot = require 'webshot'
Promise = require 'bluebird'
concat = require 'concat-stream'

error = require 'error'
logger = require 'logger'
queue = require 'queue/kind/thumbnail'
storage = require 'storage/container/thumbnail'

retrieveRequestFromQueueAndTakeScreenShot = () ->
  queue.get()
    .then (message) ->
      chart = message.value()
      logger.info 'Take screenshot', chart
      takeScreenShot chart.url
        .then (buffer) ->
          logger.info 'Upload screenshot to \'%s\'', chart.path
          storage.put chart.path, buffer
        .then () ->
          Promise.resolve message
    .then (message) ->
      logger.info 'Remove message from queue', message
      message.delete()
    .then () ->
      logger.info 'Succeeded & go next'
      retrieveRequestFromQueueAndTakeScreenShot()
      undefined
    .catch error.NotAvailableError, (err) ->
      logger.info 'Not available'
    .catch (err) ->
      logger.error err

takeScreenShot = (url) ->
  options =
    windowSize:
      width: 1200
      height: 630
    defaultWhiteBackground: true
    streamType: 'png'
    timeout: 20 * 1000
    takeShotOnCallback: true
    errorIfStatusIsNot200: true
    zoomFactor: 2.0

  new Promise (resolve, reject) ->
    webshot url, options, (err, stream) ->
      if !err
        stream.pipe concat (buffer) ->
          resolve buffer
      else
        reject err

retrieveRequestFromQueueAndTakeScreenShot()
