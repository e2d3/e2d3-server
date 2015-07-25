config = require 'config'

db =
  switch config.databaseType
    when 'mongodb' then require './impl/mongodb'
    when 'azure' then require './impl/azurestoragetable'
    else require './impl/mockdb'

module.exports = db
