config = require 'config'

storage =
  switch config.storageType
    when 'azure' then require './impl/azurestorageblob'
    when 'redis' then require './impl/redisstorage'
    else require './impl/mockstorage'

module.exports = storage
