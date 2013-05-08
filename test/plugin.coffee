vows = require 'vows'
assert = require 'assert'
wintersmith = require 'wintersmith'

suite = vows.describe 'Plugin'

suite.addBatch
  'wintersmith environment':
    topic: -> wintersmith './example/config.json'
    'loaded ok': (env) ->
      assert.instanceOf env, wintersmith.Environment
    'contents':
      topic: (env) -> env.load @callback
      'loaded ok': (result) ->
        assert.instanceOf result.contents, wintersmith.ContentTree
      'has plugin instances': (result) ->
        assert.instanceOf result.contents['hello.txt'], wintersmith.ContentPlugin
        assert.isArray result.contents._.text
        assert.lengthOf result.contents._.text, 2
      'contains the right text': (result) ->
        for item in result.contents._.text
          assert.isString item.text
          assert.match item.text, /^Wintersmith is awesome!\n/

suite.export module
