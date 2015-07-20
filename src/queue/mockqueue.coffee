###
# For development purposes only
###

Promise = require 'bluebird'

error = require 'error'

class MockQueueClient
  constructor: () ->
    @data = {}

  kind: (name) ->
    @data[name] = [] if !@data[name]
    new MockQueue @data[name], name

  clear: () ->
    Promise.try () ->
      @data = {}
      @data

class MockQueue
  constructor: (data, name) ->
    @data = data
    @name = name

  get: () ->
    new Promise (resolve, reject) =>
      message = @data.shift()
      throw new error.NotAvailableError(@name) if !message
      resolve new MockQueueMessage @name, message

  post: (doc) ->
    new Promise (resolve, reject) =>
      @data.push JSON.stringify(doc)
      resolve doc

class MockQueueMessage
  constructor: (name, message) ->
    @name = name
    @message = message

  value: () ->
    JSON.parse @message

  delete: () ->
    Promise.resolve()

module.exports = new MockQueueClient
