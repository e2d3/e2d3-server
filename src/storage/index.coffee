config = require 'config'

storage =
  switch config.storageType
    when 'azure' then require './impl/azurestorageblob'
    else require './impl/mockstorage'

module.exports = storage
