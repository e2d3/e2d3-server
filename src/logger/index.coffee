winston = require 'winston'

config = require 'config'

logger = new winston.Logger
  transports: [
    new winston.transports.Console
      colorize: config.isInDevelopment
      prettyPrint: true
      depth: 2
  ]

# winston.cli()

module.exports = logger
