morgan = require 'morgan'

logger = require 'a-file-logger-property'

configFn = require 'a-http-server-config-fn'

{ resolve, dirname } = require 'path'

{ createWriteStream, writeFileSync, existsSync } = require 'fs'

{ sync: mkdirSync } = require 'mkdirp'

module.exports = (next) ->

  configFn @config, "#{__dirname}/config"

  process.on "a-http-server:shutdown:dettach", () ->

    process.emit "a-http-server:shutdown:dettached", "console"

  { format, logfile } = @config.plugins.console

  logstream = (f) ->

    lf = resolve f

    dir = dirname lf

    if not existsSync dir then  mkdirSync dir

    if not existsSync lf then writeFileSync lf, ''

    createWriteStream lf, { flags: 'a' }

  stream = stream: logstream logfile

  logger.bind(@) stream, (err) =>

    if err then return next err

    @app.use morgan format, stream

    process.emit "a-http-server:shutdown:attach", "console"

    next null
