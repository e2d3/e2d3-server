crypto = require 'crypto'
Promise = require 'bluebird'

db = require '../index'

parameters = db.collection 'parameters'

get = (id) ->
  parameters.get id
    .then (result) ->
      Promise.resolve result.parameters

put = (params) ->
  sha256 = crypto.createHash 'sha256'
  sha256.update JSON.stringify(params)
  id = sha256.digest 'hex'

  doc =
    id: id
    parameters: params

  parameters.put id, doc
    .then () ->
      Promise.resolve id

module.exports =
  get: get
  put: put
