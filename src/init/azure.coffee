azure = require 'azure-storage'

tableService = azure.createTableService()
queueService = azure.createQueueService()


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


createTable 'chart'
createTable 'data'
createQueue 'thumbnail'
