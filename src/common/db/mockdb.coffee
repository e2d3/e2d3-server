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
    re = new RegExp("^#{id}")
    ret = null
    for own key, value of @data
      if re.test key
        ret = value
        break
    Promise.resolve ret

  put: (id, doc) ->
    @data[id] = doc
    Promise.resolve doc

module.exports = new MockDBClient
