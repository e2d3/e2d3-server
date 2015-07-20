crypto = require 'crypto'
Promise = require 'bluebird'

db = require '../index'

charts = db.collection 'charts'

get = (id) ->
  charts.get id

put = (params) ->
  sha256 = crypto.createHash 'sha256'
  sha256.update params.type + ':' + params.path + '#' + params.revision
  id = sha256.digest 'hex'

  doc =
    path: params.path
    revision: params.revision
    type: params.type

  charts.put id, doc
    .then () ->
      Promise.resolve id

module.exports =
  get: get
  put: put
