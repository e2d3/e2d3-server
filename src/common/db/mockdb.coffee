###
# For development purposes only
###

Promise = require 'bluebird'

class MockDBClient
  constructor: () ->

  collection: (name) ->
    new MockDBCollection name

class MockDBCollection
  constructor: (name) ->
    @col = name
    @data = {}

  get: (id) ->
    new Promise (resolve, reject) =>
      if @data[id]?
        resolve @data[id]
      else
        reject 'notfound'

  put: (id, doc) ->
    @data[id] = doc
    Promise.resolve 'success'

module.exports = new MockDBClient
