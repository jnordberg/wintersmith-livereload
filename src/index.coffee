LivereloadServer = require './livereload-server'

server = undefined

module.exports = (env, callback) ->
  env.helpers.livereload = -> ''
  return callback() if env.mode isnt 'preview'

  defaults =
    port: 35729
    clientScript: 'livereload.js'
    liveCSS: true
    includeIgnored: true

  options = env.config.livereload or {}
  for key of defaults
    options[key] ?= defaults[key]

  scriptPath = require.resolve '../livereload.js'

  clientScript = new env.plugins.StaticFile
    full: scriptPath
    relative: options.clientScript
  clientScript.__env = env

  unless server?
    server = new LivereloadServer
      port: options.port

  env.helpers.livereload = ->
    """<script src="#{ clientScript.url }?port=#{ options.port }" type="text/javascript"></script>"""

  env.locals.livereloadScript ?= env.helpers.livereload()

  env.registerGenerator 'livereload', (contents, callback) ->
    callback null, {livereload: clientScript}

  env.on 'change', (filename, ignored) ->
    if ignored
      return unless options.includeIgnored
      # small hack to allow changes to ignored style files to be hotloaded
      filename = filename.replace /\.(styl|less|scss|sass)$/i, '.css'
    server.send
      command: 'reload'
      path: filename ? ''
      liveCSS: options.liveCSS

  env.logger.info "LiveReload socket running on port #{ options.port }"
  callback()
