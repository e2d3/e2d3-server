azure = require 'azure-storage'

blobService = azure.createBlobService()

currentToken = null

listThumbnails = (currentToken) ->
  blobService.listBlobsSegmented 'thumbnails', currentToken, (err, result) ->
    return if err

    for entry in result.entries
      console.log entry.name

    listThumbnails(result.continuationToken) if result.continuationToken != null

listThumbnails null
