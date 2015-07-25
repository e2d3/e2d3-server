azure = require 'azure-storage'
Promise = require 'bluebird'

config = require 'config'

blobService = azure.createBlobService()

class AzureStorageBlobClient
  constructor: () ->

  container: (name) ->
    new AzureStorageBlobContainer name

class AzureStorageBlobContainer
  constructor: (name) ->
    @name = name

  put: (path, options, buffer) ->
    new Promise (resolve, reject) =>
      blobService.createBlockBlobFromText @name, path, buffer, options, (err, result) ->
        return reject err if err
        resolve path

module.exports = new AzureStorageBlobClient
