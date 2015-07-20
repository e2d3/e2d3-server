error = {}

error.NotFoundError = (name, id) ->
  @name = name
  @id = id
error.NotFoundError.prototype = Object.create(Error.prototype)

error.NotAvailableError = (name) ->
  @name = name
error.NotAvailableError.prototype = Object.create(Error.prototype)

module.exports = error
