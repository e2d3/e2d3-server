azure = require 'azure-storage'
Promise = require 'bluebird'

error = require 'error'

blobService = azure.createBlobService()

class AzureStorageBlobClient
  constructor: () ->

  container: (name) ->
    new AzureStorageBlobContainer name

class AzureStorageBlobContainer
  constructor: (name) ->
    @name = name

  get: (path) ->
    new Promise (resolve, reject) =>
      throw new error.NotSupportedError @name

  put: (path, options, buffer) ->
    new Promise (resolve, reject) =>
      blobService.createBlockBlobFromText @name, path, buffer, options, (err, result) ->
        return reject err if err
        resolve path

module.exports = new AzureStorageBlobClient
