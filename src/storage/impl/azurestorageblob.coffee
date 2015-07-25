azure = require 'azure-storage'
_ = require 'lodash'
Promise = require 'bluebird'

config = require 'config'

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
      blobService.createBlockBlobFromText @name, path, buffer, options, (err, result) ->
        if !err
          resolve path
        else
          reject err

module.exports = new AzureStorageBlobClient
