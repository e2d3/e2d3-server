azure = require 'azure-storage'
Promise = require 'bluebird'

config = require 'config'
error = require 'error'

queueService = azure.createQueueService()

class AzureStorageQueueClient
  constructor: () ->

  kind: (name) ->
    new AzureStorageQueue name

class AzureStorageQueue
  constructor: (name) ->
    @name = name

  get: () ->
    new Promise (resolve, reject) =>
      queueService.getMessages @name, (err, result) =>
        if !err
          resolve new AzureStorageQueueMessage @name, result[0]
        else
          reject err
    .then (message) =>
      throw new error.NotAvailableError(@name) if !message.message
      Promise.resolve message

  post: (doc) ->
    new Promise (resolve, reject) =>
      queueService.createMessage @name, JSON.stringify(doc), (err, result) ->
        if !err
          resolve doc
        else
          reject err

class AzureStorageQueueMessage
  constructor: (name, message) ->
    @name = name
    @message = message

  value: () ->
    JSON.parse @message.messagetext

  delete: () ->
    new Promise (resolve, reject) =>
      queueService.deleteMessage @name, @message.messageid, @message.popreceipt, (err, result) ->
        if !err
          resolve result
        else
          reject err

module.exports = new AzureStorageQueueClient
