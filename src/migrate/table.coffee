require('app-module-path').addPath(__dirname + '/..')

azure = require 'azure-storage'
Promise = require 'bluebird'

tableService = azure.createTableService()
entGen = azure.TableUtilities.entityGenerator
TableQuery = azure.TableQuery

data = require 'db/collection/data'
datastorage = require 'storage/container/data'

tableService.queryEntities 'data', null, null, (err, result) ->
  list = []
  for r in result.entries
    continue if !r.data

    id = r.PartitionKey._
    tsv = r.data._

    p = data.put tsv
      .then (id) ->
        datastorage.put id, tsv

    list.push p

  Promise.all list
    .then (result) ->
      console.log 'succcess'
      console.log result
    .catch (err) ->
      console.log err
