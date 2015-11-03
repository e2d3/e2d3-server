webshot = require 'webshot'
Promise = require 'bluebird'
concat = require 'concat-stream'

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
    zoomFactor: 1.5
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

module.exports = takeScreenShot
