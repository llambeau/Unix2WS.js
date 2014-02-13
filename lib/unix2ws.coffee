fs       = require 'fs'
net      = require 'net'
SocketIO = require 'socket.io'

class Unix2WS

  constructor: (params={}) ->
    # Socket file
    @socket = params.socket ? "socket.sock"
    
    # Port to open for websocket connections
    @port = params.port ? 10000
    
    # Debug incoming data to console
    @debug = params.debug ? false

    # Decode received lines as JSON objects?
    @json = params.json ? true

    # Delete socket if already present
    if fs.existsSync(@socket)
      fs.unlink(@socket)
    
    # Create unix server
    @unixServer = net.createServer (socket) =>
      data = ""

      # Process the received content and convert it to 
      # a line by line propagation
      socket.on "data", (chunk) =>
        if @debug == true
          console.log "Data chunk received: #{chunk.toString()}"

        data += chunk.toString()
        lines = data.split("\n")
        
        last_chunk = lines.pop()

        for idx, line of lines
          this.propagate(line)

        data = last_chunk

      # Propagate the last chunk of data (if any)
      # when the client closes the connection
      socket.on "close", -> 
        if data != ""
          this.propagate(data)

  # Propagate data to websocket client
  propagate: (data) =>
    if @json
      try
        data = JSON.parse(data)      
      catch e
        console.error "Error while parsing JSON", data, e
        console.error "Propagating it in its raw format"

    if @debug
      console.log "Propagating: " + data

    @io.sockets.emit("data", data)
  
  ## Start the tool
  start: =>
    console.log "Starting Unix2WebSocket, UNIX socket: #{@socket}, WS port: #{@port}"

    # Open the unix socket and start the server
    @unixServer.listen(@socket)
    
    # Create socket.io server
    @io = SocketIO.listen(@port, { log: @debug })
    
  stop: =>
    @io.server.close()
    @unixServer.close()
    fs.unlink @socket

module.exports = Unix2WS