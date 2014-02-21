fs       = require 'fs'
SocketIO = require 'socket.io'
Source   = require './source'

class Unix2WS

  constructor: (params={}) ->
    # Port to open for socket.io
    @port = params.port ? 10000

    # Debug incoming data to console
    @debug = params.debug ? false
    # Decode received lines as JSON objects?
    @json = params.json ? true
    # Do we send to a room?
    @room = params.room
    # Or to a namespace?
    @namespace = params.namespace
    #
    @sourceDesc = params.socket ? params.fifo 

    ##
    unless @sourceDesc?
      throw new Error("At least one input method must be chosen")

    @sourceFactory = switch
      when params.socket?      then Source.socket
      when params.fifo?        then Source.fifo

  # Propagate data to socket.io client
  propagate: (data) =>
    if @json
      try
        data = JSON.parse(data)      
      catch e
        console.error "Error while parsing JSON", data, e
        console.error "Propagating it in its raw format"

    if @namespace?
      @namespace.emit("data", data)
    
    if @room?
      @room.emit('data', data)

    # root namespace
    @io.sockets.emit("data", data)
  
  ## Start the tool
  ## Will call the callback (if given) with the socket.io main object
  ## (used for backend mocking for instance)
  start: (callback) =>
    # Create socket.io server
    @io = SocketIO.listen(@port, { log: @debug })

    # Create namespace or room if specified
    if @room?
      @room = @io.sockets.in(@room)

    if @namespace?
      console.log("Creating namespace /" + @namespace)
      @namespace = @io.of('/' + @namespace)

    @source = @sourceFactory @sourceDesc, (stream) =>
      data = ""
      # Process the received content and convert it to 
      # a line by line propagation
      stream.on "data", (chunk) =>
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
      finish = ->
        if data != ""
          this.propagate(data)

    # Read the source 
    @source.read()

    # 
    callback(@io) if callback?

  ## Stop the tool
  stop: () =>
    @source.close()

module.exports = Unix2WS