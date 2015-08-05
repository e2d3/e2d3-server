Promise = require 'bluebird'

storage = require '../index'

data = storage.container 'data'

exists = (path) ->
  data.exists path

get = (path) ->
  data.get path
    .then (doc) ->
      Promise.resolve doc.data.toString('utf8')

put = (path, tsv) ->
  options =
    contentType: 'text/tab-separated-values'
  data.put path, options, new Buffer(tsv, 'utf8')

module.exports =
  exists: exists
  get: get
  put: put
