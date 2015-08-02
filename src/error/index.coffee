error = {}

class NotFoundError extends Error
  constructor: (@container, @id) ->
    @name = 'NotFoundError'
    @message = "'#{@id}' on '#{@container}'"
    Error.captureStackTrace(this, NotFoundError)

class NotAvailableError extends Error
  constructor: (@container) ->
    @name = 'NotAvailableError'
    @message = "on '#{@container}'"
    Error.captureStackTrace(this, NotAvailableError)

class NotSupportedError extends Error
  constructor: (@container) ->
    @name = 'NotSupportedError'
    @message = "on '#{@container}'"
    Error.captureStackTrace(this, NotSupportedError)

module.exports =
  NotFoundError: NotFoundError
  NotAvailableError: NotAvailableError
  NotSupportedError: NotSupportedError
