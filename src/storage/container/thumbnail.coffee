Promise = require 'bluebird'

storage = require '../index'

thumbnail = storage.container 'thumbnails'

exists = (path) ->
  thumbnail.exists path

get = (path) ->
  thumbnail.get path
    .then (doc) ->
      Promise.resolve doc.data

put = (path, buffer) ->
  options =
    contentType: 'image/png'
  thumbnail.put path, options, buffer

module.exports =
  exists: exists
  get: get
  put: put
