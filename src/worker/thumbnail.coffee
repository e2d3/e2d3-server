webshot = require 'webshot'
Promise = require 'bluebird'

common = require '../common'
thumbnail = require '../common/queue/kind/thumbnail'

takeScreenShot = (chart) ->
  options =
    windowSize:
      width: 1200
      height: 630
    defaultWhiteBackground: true
    timeout: 20 * 1000
    takeShotOnCallback: true
    errorIfStatusIsNot200: true
    zoomFactor: 2.0

  new Promise (resolve, reject) ->
    webshot chart.url, 'thumbnail.png', options, (error) ->
      if !error
        resolve 'success'
      else
        reject error

retrieveRequestAndTakeScreenShot = () ->
  thumbnail.get()
    .then (message) ->
      takeScreenShot message.value()
        .then (result) ->
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
