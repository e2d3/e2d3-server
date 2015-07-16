azure = require 'azure-storage'
_ = require 'lodash'
Promise = require 'bluebird'

config = require '../../config'
common = require '../index'

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
      queueService.getMessages @name, (error, result) =>
        if !error
          resolve new AzureStorageQueueMessage @name, result[0]
        else
          reject error
    .then (message) =>
      throw new common.NotAvailableError(@name) if !message.message
      Promise.resolve message


  post: (doc) ->
    new Promise (resolve, reject) =>
      queueService.createMessage @name, JSON.stringify(doc), (error, result) ->
        if !error
          resolve result
        else
          reject error

class AzureStorageQueueMessage
  constructor: (name, message) ->
    @name = name
    @message = message

  value: () ->
    JSON.parse @message.messagetext

  delete: () ->
    new Promise (resolve, reject) =>
      queueService.deleteMessage @name, @message.messageid, @message.popreceipt, (error, result) ->
        if !error
          resolve result
        else
          reject error

module.exports = new AzureStorageQueueClient
