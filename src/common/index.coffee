common = {}

common.NotFoundError = (name, id) ->
  @name = name
  @id = id
common.NotFoundError.prototype = Object.create(Error.prototype)

common.NotAvailableError = (name) ->
  @name = name
common.NotAvailableError.prototype = Object.create(Error.prototype)

module.exports = common
