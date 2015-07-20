config = require 'config'

storage =
  switch config.storageType
    when 'azure' then require './azurestorageblob'
    else require './mockstorage'

module.exports = storage
