config = require '../../config'

db =
  switch config.databaseType
    when 'mongodb' then require './mongodb'
    when 'documentdb' then require './documentdb'
    when 'azurestorage' then require './azurestorage'
    else require './mockdb'

db.NotFoundError = (key) -> @key = key
db.NotFoundError.prototype = Object.create(Error.prototype)

module.exports = db
