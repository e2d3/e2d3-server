azure = require 'azure-storage'
_ = require 'lodash'
Promise = require 'bluebird'

config = require '../../config'
common = require '../index'

blobService = azure.createBlobService()

class AzureStorageBlobClient
  constructor: () ->

  container: (name) ->
    new AzureStorageBlobCollection name

class AzureStorageBlobCollection
  constructor: (name) ->
    @name = name

  put: (path, options, buffer) ->
    new Promise (resolve, reject) =>
      blobService.createBlockBlobFromText @name, path, buffer, options, (error, result) ->
        if !error
          resolve path
        else
          reject error

module.exports = new AzureStorageBlobClient
