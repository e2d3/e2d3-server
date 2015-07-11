###
# For development purposes only
###

mongodb = require 'mongodb'
_ = require 'lodash'
Promise = require 'bluebird'

MongoClient = mongodb.MongoClient

config = require '../../config'

connect = () ->
  Promise.resolve MongoClient.connect config.databaseUrl

class MongoDBClient
  constructor: () ->

  collection: (name) ->
    new MongoDBCollection name

class MongoDBCollection
  constructor: (name) ->
    @col = name

  get: (id) ->
    connect()
      .then (db) =>
        db.collection(@col).findOne _id: id

  put: (id, doc) ->
    connect()
      .then (db) =>
        db.collection(@col).save _.assign(_id: id, doc)

module.exports = new MongoDBClient
