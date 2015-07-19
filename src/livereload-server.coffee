
ws = require 'ws'


class Client

  constructor: (@socket) ->
    @send
      command: 'hello'
      protocols: ['http://livereload.com/protocols/official-7']
      serverName: 'Wintersmith LiveReload'

  send: (data) ->
    @socket.send JSON.stringify data

class Server

  constructor: (options) ->
    @wss = new ws.Server {port: options.port}
    @wss.on 'connection', @handleConnection.bind(this)
    @clients = []

  handleConnection: (socket) ->
    client = new Client socket
    @clients.push client
    socket.on 'close', =>
      idx = @clients.indexOf client
      @clients.splice idx, 1

  send: (data) ->
    c.send data for c in @clients


module.exports = Server
