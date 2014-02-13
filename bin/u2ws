#!/usr/bin/env coffee
minimist = require 'minimist'
Unix2WS  = require '../lib/unix2ws.coffee'

argv = minimist(process.argv.slice(2), {
  string: 'socket',
  boolean: ['debug', 'debug']
})

tool = new Unix2WS(argv)
tool.start()

process.on 'SIGINT', ->
  console.log "\nGracefully shutting down from SIGINT (Ctrl-C)"
  tool.stop()
  process.exit()