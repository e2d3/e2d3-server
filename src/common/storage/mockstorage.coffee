###
# For development purposes only
###

Promise = require 'bluebird'

config = require '../../config'

class MockStorageClient
  constructor: () ->

  container: (name) ->
    new MockStorageCollection name

class MockStorageCollection
  constructor: (name) ->
    @name = name

  put: (path, options, buffer) ->
    new Promise (resolve, reject) ->
      resolve path

module.exports = new MockStorageClient
