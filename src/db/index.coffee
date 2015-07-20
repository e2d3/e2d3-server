config = require 'config'

db =
  switch config.databaseType
    when 'mongodb' then require './mongodb'
    when 'azure' then require './azurestoragetable'
    else require './mockdb'

module.exports = db
