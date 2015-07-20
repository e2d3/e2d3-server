webshot = require 'webshot'
Promise = require 'bluebird'
concat = require 'concat-stream'

common = require '../common'
queue = require '../common/queue/kind/thumbnail'
storage = require '../common/storage/container/thumbnail'

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
    webshot url, options, (error, stream) ->
      if !error
        stream.pipe concat (buffer) ->
          resolve buffer
      else
        reject error

retrieveRequestAndTakeScreenShot = () ->
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
      retrieveRequestAndTakeScreenShot()
      undefined
    .catch common.NotAvailableError, (error) ->
      console.log 'not available'
    .catch (error) ->
      console.log error

retrieveRequestAndTakeScreenShot()
