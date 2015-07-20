webshot = require 'webshot'
Promise = require 'bluebird'
concat = require 'concat-stream'

error = require 'error'
queue = require 'queue/kind/thumbnail'
storage = require 'storage/container/thumbnail'

retrieveRequestFromQueueAndTakeScreenShot = () ->
  queue.get()
    .then (message) ->
      chart = message.value()
      console.log chart
      takeScreenShot chart.url
        .then (buffer) ->
          storage.put chart.path, buffer
        .then () ->
          Promise.resolve message
    .then (message) ->
      message.delete()
    .then () ->
      console.log 'succeeded & go next'
      retrieveRequestFromQueueAndTakeScreenShot()
      undefined
    .catch error.NotAvailableError, (err) ->
      console.log 'not available'
    .catch (err) ->
      console.log err

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
    console.log options
    webshot url, options, (err, stream) ->
      if !err
        stream.pipe concat (buffer) ->
          resolve buffer
      else
        reject err

retrieveRequestFromQueueAndTakeScreenShot()
