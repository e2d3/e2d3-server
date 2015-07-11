###
# For development purposes only
###

Promise = require 'bluebird'

class MockDBClient
  constructor: () ->
    @data = {}

  collection: (name) ->
    new MockDBCollection @data, name

  clear: () ->
    Promise.try () ->
      @data = {}
      @data

class MockDBCollection
  constructor: (data, name) ->
    @data = data
    @col = name

  get: (id) ->
    Promise.resolve @data[id]

  put: (id, doc) ->
    @data[id] = doc
    Promise.resolve doc

module.exports = new MockDBClient
