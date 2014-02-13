fs             = require 'fs'
sys            = require 'sys'
net            = require 'net'
{exec}         = require 'child_process'
{EventEmitter} = require 'events'

#
class Source

# NetSource (udp, tcp, unix)
class NetSource
  constructor: (@port, @callback) ->
    @desc = "SOCKET(#{@port})"
    this.destroy()

    @server = net.createServer (@socket) =>
      @callback(@socket)
    
  read: =>
    @server.listen(@port)

  close: =>
    @server.close()
    this.destroy()

  destroy: =>
    if fs.existsSync(@port)
      fs.unlinkSync(@port)
  
# FileSource (fifo)
class FileSource
  constructor: (@fd, @callback) ->
    this.destroy()
    @desc = "FILE(#{@fd})"
    
  read: =>
    exec "mkfifo #{@fd}", =>
      @stream = fs.createReadStream(@fd)
      @stream.on 'close', this.read
      @callback @stream

  close: =>
    @stream.close()
    this.destroy()

  destroy: =>
    if fs.existsSync(@fd)
      fs.unlinkSync(@fd)


## Create a socket stream
Source.socket = (port, callback) ->
  new NetSource(port, callback)

## Create a named-pipe stream
Source.fifo = (path, callback) ->
  new FileSource(path, callback)

module.exports = Source