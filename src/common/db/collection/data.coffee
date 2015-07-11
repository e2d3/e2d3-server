crypto = require 'crypto'
Promise = require 'bluebird'

db = require '../index'

data = db.collection 'data'

get = (id) ->
  data.get id
    .then (item) ->
      if item?
        Promise.resolve item.data
      else
        throw new db.NotFoundError(id)

put = (tsv) ->
  sha256 = crypto.createHash 'sha256'
  sha256.update tsv
  id = sha256.digest 'hex'

  data.put id, data: tsv
    .then () ->
      Promise.resolve id

module.exports =
  get: get
  put: put
