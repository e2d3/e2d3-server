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
      process.exit 1

takeScreenShot = (url) ->
  options =
    windowSize:
      width: 1200
      height: 630
    phantomConfig:
      'ignore-ssl-errors': 'true'
    defaultWhiteBackground: true
    streamType: 'png'
    timeout: 20 * 1000
    takeShotOnCallback: true
    errorIfStatusIsNot200: true
    zoomFactor: 2.0
    onResourceReceived: (response) ->
      if (/\/main.css$/.test response.url) && response.stage == 'end'
        window.onmaincssload?()
    onResourceError: (resourceError) ->
      if (/\/main.css$/.test resourceError.url)
        window.onmaincsserror?()

  new Promise (resolve, reject) ->
    webshot url, options, (err, stream) ->
      return reject err if err
      options = encoding: 'buffer'
      stream.pipe concat options, (buffer) ->
        resolve buffer

retrieveRequestFromQueueAndTakeScreenShot()
