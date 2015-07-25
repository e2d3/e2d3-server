error = {}

error.NotFoundError = (name, id) ->
  @type = 'NotFoundError'
  @name = name
  @id = id
  @stack = Error().stack
error.NotFoundError.prototype = Object.create(Error.prototype)

error.NotAvailableError = (name) ->
  @type = 'NotAvailableError'
  @name = name
  @stack = Error().stack
error.NotAvailableError.prototype = Object.create(Error.prototype)

error.NotSupportedError = (name) ->
  @type = 'NotSupportedError'
  @name = name
  @stack = Error().stack
error.NotSupportedError.prototype = Object.create(Error.prototype)

module.exports = error
