###
# For development purposes only
###

mongodb = require 'mongodb'
_ = require 'lodash'
Promise = require 'bluebird'

MongoClient = mongodb.MongoClient

config = require '../../config'
common = require '../index'

connect = () ->
  Promise.resolve MongoClient.connect config.databaseUrl

class MongoDBClient
  constructor: () ->

  collection: (name) ->
    new MongoDBCollection name

class MongoDBCollection
  constructor: (name) ->
    @name = name

  get: (id) ->
    connect()
      .then (db) =>
        db.collection(@name).findOne _id: $regex: new RegExp("^#{id}")
      .then (entity) =>
        console.log new common.NotFoundError(@name, id)
        throw new common.NotFoundError(@name, id) if !entity
        Promise.resolve entity

  put: (id, doc) ->
    connect()
      .then (db) =>
        db.collection(@name).save _.assign(_id: id, doc)

module.exports = new MongoDBClient
