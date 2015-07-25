config = require 'config'

db =
  switch config.databaseType
    when 'azure' then require './impl/azurestoragetable'
    when 'redis' then require './impl/redisdb'
    when 'mongodb' then require './impl/mongodb'
    else require './impl/mockdb'

module.exports = db
