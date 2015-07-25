config = require 'config'

db =
  switch config.databaseType
    when 'azure' then require './impl/azurestoragetable'
    when 'redis' then require './impl/redisdb'
    else require './impl/mockdb'

module.exports = db
