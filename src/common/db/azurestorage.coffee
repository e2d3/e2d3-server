azure = require 'azure-storage'
_ = require 'lodash'
Promise = require 'bluebird'

config = require '../../config'

tableService = azure.createTableService()
entGen = azure.TableUtilities.entityGenerator
TableQuery = azure.TableQuery

class MongoDBClient
  constructor: () ->

  collection: (name) ->
    new MongoDBCollection name

class MongoDBCollection
  constructor: (name) ->
    @col = name

  get: (id) ->
    new Promise (resolve, reject) =>
      tableQuery = new TableQuery()
        .top 1
        .where 'PartitionKey >= ? and PartitionKey < ?', id, id + '~'
      tableService.queryEntities @col, tableQuery, null, (error, result) ->
        if !error
          entity = result.entries[0]
          if entity
            for own key, value of entity
              entity[key] = value['_']
          resolve entity
        else
          reject error

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

      tableService.insertOrReplaceEntity @col, entity, (error, result) ->
        if !error
          resolve result
        else
          reject error

module.exports = new MongoDBClient
