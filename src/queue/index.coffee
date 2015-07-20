config = require 'config'

queue =
  switch config.queueType
    when 'azure' then require './azurestoragequeue'
    else require './mockqueue'

module.exports = queue
