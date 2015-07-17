Promise = require 'bluebird'

storage = require '../index'

thumbnail = storage.container 'thumbnail'

put = (path, buffer) ->
  options =
    contentType: 'image/png'
  thumbnail.put path, options, buffer

module.exports =
  put: put
