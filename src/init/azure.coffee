azure = require 'azure-storage'

tableService = azure.createTableService()
queueService = azure.createQueueService()
blobService = azure.createBlobService()


createTable = (name) ->
  tableService.createTableIfNotExists name, (err) ->
    if !err
      console.log "Table '#{name}' created or exists."
    else
      console.log "'#{name}': #{err}"

createQueue = (name) ->
  queueService.createQueueIfNotExists name, (err) ->
    if !err
      console.log "Queue '#{name}' created or exists."
    else
      console.log "'#{name}': #{err}"

createPrivateBlob = (name) ->
  blobService.createContainerIfNotExists name, (err) ->
    if !err
      console.log "Blob '#{name}' created or exists."
    else
      console.log "'#{name}': #{err}"

createPublicBlob = (name) ->
  blobService.createContainerIfNotExists name, { publicAccessLevel : 'blob' }, (err) ->
    if !err
      console.log "Blob '#{name}' created or exists."
    else
      console.log "'#{name}': #{err}"


createTable 'charts'
createTable 'data'
createQueue 'thumbnails'
createPrivateBlob 'data'
createPublicBlob 'thumbnails'
