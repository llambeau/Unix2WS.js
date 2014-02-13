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

  destroy: =>
    if fs.existsSync(@port)
      fs.unlinkSync(@port)
  
# FileSource (fifo)
class FileSource
  constructor: (@fd, @desc, @callback) ->
    this.destroy()
    @desc = "FILE(#{@fd})"
    exec "mkfifo #{@fd}"

  read: =>
    @stream = fs.createReadStream(@fd)
    @stream.on 'close', this.read
    @callback @stream

  destroy: =>
    if fs.existsSync(@fd)
      fs.unlinkSync(@fd)


## Create a unix socket stream
Source.unix = (path, callback) ->
  new NetSource(path, callback)

## Create a tcp socket stream
Source.tcp = (port, callback) ->
  new NetSource(port, callback)

## Create a named-pipe stream
Source.fifo = (path, callback) ->
  new FileSource(path, "FIFO #{path}", callback)

module.exports = Source