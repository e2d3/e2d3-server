crypto = require 'crypto'
Promise = require 'bluebird'

db = require '../index'

data = db.collection 'data'

get = (id) ->
  data.get id

put = (tsv) ->
  sha256 = crypto.createHash 'sha256'
  sha256.update tsv
  id = sha256.digest 'hex'

  doc =
    id: id
    type: 'tsv'

  data.put id, doc
    .then () ->
      Promise.resolve id

module.exports =
  get: get
  put: put
