azure = require 'azure-storage'
_ = require 'lodash'
Promise = require 'bluebird'

config = require 'config'
error = require 'error'

tableService = azure.createTableService()
entGen = azure.TableUtilities.entityGenerator
TableQuery = azure.TableQuery

class AzureStorageTableClient
  constructor: () ->

  collection: (name) ->
    new AzureStorageTableCollection name

class AzureStorageTableCollection
  constructor: (name) ->
    @name = name

  get: (id) ->
    new Promise (resolve, reject) =>
      tableQuery = new TableQuery()
        .top 1
        .where 'PartitionKey >= ? and PartitionKey < ?', id, id + '~'

      tableService.queryEntities @name, tableQuery, null, (err, result) ->
        return reject err if err
        entity = result.entries[0]
        for own key, value of entity
          entity[key] = value['_']
        resolve entity
    .then (entity) =>
      throw new error.NotFoundError(@name, id) if !entity
      Promise.resolve entity

  put: (id, doc) ->
    new Promise (resolve, reject) =>
      entity =
        PartitionKey: entGen.String id
        RowKey: entGen.String ''

      for own key, value of doc
        switch typeof value
          when 'string' then entity[key] = entGen.String value
          when 'number' then entity[key] = entGen.Int32 value
          when 'boolean' then entity[key] = entGen.Boolean value
          else
            if value instanceof Date
              entity[key] = entGen.DateTime value
            else
              entity[key] = entGen.String JSON.stringify value

      tableService.insertOrReplaceEntity @name, entity, (err, result) ->
        return reject err if err
        resolve result

module.exports = new AzureStorageTableClient
