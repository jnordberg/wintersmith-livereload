### A Wintersmith plugin. ###

fs = require 'fs'

module.exports = (env, callback) ->
  # *env* is the current wintersmith environment
  # *callback* should be called when the plugin has finished loading

  class MyPlugin extends env.ContentPlugin
    ### Prepends 'Wintersmith is awesome' to text files. ###

    constructor: (@filepath, text) ->
      @text = 'Wintersmith is awesome\n' + text

    getFilename: ->
      # filename where plugin is rendered to, this plugin uses the
      @filepath.relative

    getView: -> (env, locals, contents, templates, callback) ->
      # note that this function returns a function, you can also return a string
      # to use a view already added to the env, see env.registerView for more

      # this view simply passes the text to the renderer
      callback null, new Buffer(@text) # you can also pass a stream

  MyPlugin.fromFile = (filepath, callback) ->
    fs.readFile filepath.full, (error, result) ->
      if not error?
        plugin = new MyPlugin filepath, result.toString()
      callback error, plugin

  # register the plugin to intercept .txt and .text files using a glob pattern
  # the first argument is the content group the plugin will belong to
  # i.e. directory grouping, contents.somedir._.text is an array of all
  #      plugin instances beloning to the text group in somedir
  env.registerContentPlugin 'text', '**/*.*(txt|text)', MyPlugin

  # tell plugin manager we are done
  callback()
