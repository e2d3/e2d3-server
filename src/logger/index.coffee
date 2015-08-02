winston = require 'winston'
moment = require 'moment'

config = require 'config'

logger = new winston.Logger
  transports: [
    new winston.transports.Console
      timestamp: () -> moment().toISOString()
      colorize: config.isInDevelopment
      prettyPrint: true
      depth: 2
  ]

# winston.cli()

module.exports = logger
