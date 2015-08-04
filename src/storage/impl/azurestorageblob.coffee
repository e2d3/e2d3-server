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

  exists: (path) ->
    new Promise (resolve, reject) =>
      blobService.getBlobMetadata @name, path, (err, result) ->
        return reject err if err
        resolve path
    .catch (err) =>
      throw new error.NotFoundError(@name, path) if err.message == 'NotFound'
      Promise.reject err

  get: (path) ->
    new Promise (resolve, reject) =>
      blobService.getBlobToText @name, path, (err, result) ->
        return reject err if err
        doc =
          data: result
        resolve doc
    .catch (err) =>
      throw new error.NotFoundError(@name, path) if err.message == 'NotFound'
      Promise.reject err

  put: (path, options, buffer) ->
    new Promise (resolve, reject) =>
      blobService.createBlockBlobFromText @name, path, buffer, options, (err, result) ->
        return reject err if err
        resolve path

module.exports = new AzureStorageBlobClient
