azure = require 'azure-storage'

tableService = azure.createTableService()
queueService = azure.createQueueService()
blobService = azure.createBlobService()


createTable = (name) ->
  tableService.createTableIfNotExists name, (error) ->
    if !error
      console.log "Table '#{name}' created or exists."
    else
      console.log "'#{name}': #{error}"

createQueue = (name) ->
  queueService.createQueueIfNotExists name, (error) ->
    if !error
      console.log "Queue '#{name}' created or exists."
    else
      console.log "'#{name}': #{error}"

createPrivateBlob = (name) ->
  blobService.createContainerIfNotExists name, (error) ->
    if !error
      console.log "Blob '#{name}' created or exists."
    else
      console.log "'#{name}': #{error}"

createPublicBlob = (name) ->
  blobService.createContainerIfNotExists name, { publicAccessLevel : 'blob' }, (error) ->
    if !error
      console.log "Blob '#{name}' created or exists."
    else
      console.log "'#{name}': #{error}"


createTable 'chart'
createTable 'data'
createQueue 'thumbnail'
createPublicBlob 'thumbnail'
