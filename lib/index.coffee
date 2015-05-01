morgan = require 'morgan'

merge = require 'lodash.merge'

logger = require 'a-file-logger-property'

{ resolve, dirname } = require 'path'

{ createWriteStream, writeFileSync, existsSync } = require 'fs'

{ sync: mkdirSync } = require 'mkdirp'

module.exports = (next) ->

  @config.console = merge require('./config'), @config?.console or {}

  process.on "a-http-server:shutdown:dettach", () ->

    process.emit "a-http-server:shutdown:dettached", "console"

  { format, logfile } = @config.console

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
