config = require 'config'

queue =
  switch config.queueType
    when 'azure' then require './impl/azurestoragequeue'
    else require './impl/mockqueue'

module.exports = queue
