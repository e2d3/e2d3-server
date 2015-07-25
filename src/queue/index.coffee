config = require 'config'

queue =
  switch config.queueType
    when 'azure' then require './impl/azurestoragequeue'
    when 'redis' then require './impl/redisqueue'
    else require './impl/mockqueue'

module.exports = queue
