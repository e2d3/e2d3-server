azure = require 'azure-storage'
Promise = require 'bluebird'

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
        return reject err if err
        resolve new AzureStorageQueueMessage @name, result[0]
    .then (message) =>
      throw new error.NotAvailableError(@name) if !message.message
      Promise.resolve message

  post: (doc) ->
    new Promise (resolve, reject) =>
      queueService.createMessage @name, JSON.stringify(doc), (err, result) ->
        return reject err if err
        resolve doc

class AzureStorageQueueMessage
  constructor: (name, message) ->
    @name = name
    @message = message

  value: () ->
    JSON.parse @message.messagetext

  delete: () ->
    new Promise (resolve, reject) =>
      queueService.deleteMessage @name, @message.messageid, @message.popreceipt, (err, result) ->
        return reject err if err
        resolve @message.messagetext

module.exports = new AzureStorageQueueClient
