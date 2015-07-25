###
# For development purposes only
###

Promise = require 'bluebird'

error = require 'error'

class MockStorageClient
  constructor: () ->
    @data = {}

  container: (name) ->
    @data[name] = {} if !@data[name]
    new MockStorageContainer @data[name], name

  clear: () ->
    @data = {}
    Promise.resolve @data

class MockStorageContainer
  constructor: (data, name) ->
    @data = data
    @name = name

  get: (path) ->
    new Promise (resolve, reject) =>
      doc = @data[path]
      throw new error.NotFoundError(@name, path) if !doc
      resolve doc

  put: (path, options, buffer) ->
    doc =
      options: options
      data: buffer
    @data[path] = doc
    Promise.resolve path

module.exports = new MockStorageClient
