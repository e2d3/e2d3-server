###
# For development purposes only
###

Promise = require 'bluebird'

error = require 'error'

class MockDBClient
  constructor: () ->
    @data = {}

  collection: (name) ->
    @data[name] = {} if !@data[name]
    new MockDBCollection @data[name], name

  clear: () ->
    @data = {}
    Promise.resolve @data

class MockDBCollection
  constructor: (data, name) ->
    @data = data
    @name = name

  get: (id) ->
    new Promise (resolve, reject) =>
      re = new RegExp("^#{id}")
      entity = null
      for own key, value of @data
        if re.test key
          entity = value
          break
      throw new error.NotFoundError(@name, id) if !entity
      resolve entity

  put: (id, doc) ->
    @data[id] = doc
    Promise.resolve doc

module.exports = new MockDBClient
