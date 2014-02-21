Unix2WS.js
==========

Unix2WS allows you to easily stream data from any input to socket.io.

This tool supports TCP, UNIX sockets as input, or named-pipe (FIFO)

## Installation

<pre>
  npm install -g unix2ws
</pre>

## Usage

The command line tool _unix2ws_ opens a socket.io server. Any content received through the specified source will be sent to all the Socket.IO clients.

I created this tool to be able to easily stream any line by line output from a command-line application to the browser.

By default, unix2ws will try to parse every line received as a JSON object.

<pre>
Usage: unix2ws

Examples:
  unix2ws -s 10001 --ws-port 10000
  unix2ws -s unix.sock --ws-port 10000
  unix2ws -f fifo --ws-port 10000


Options:
  -d, --debug        Prints debugging information     [default: false]
  -j, --json         Try to JSON.parse input lines    [default: true]
  -p, --ws-port      Port to use for socket.io        [default: 10000]
  -s, --from-socket  Opens TCP/UNIX socket for input
  -f, --from-fifo    Creates named pipe for input
</pre>

## Example

Open the example HTML file in your browser and give it a try, you'll see it's pretty simple

## Limitations

* It's at the moment impossible to create Unix FIFOs from node ([See this message on stackoverlow](http://stackoverflow.com/a/18226566)), I create it in a nasty way at the moment
* UNIX sockets & UNIX FIFOs are, of course, not supported on windows

## TODO

I'll probably add the following features in a near future:

* New parameter --event to specify the event name used to propagate the data (which is "data" at the moment)
* I'd like to add a new feature allowing me to give a node.js script as parameter, this script would expose a function receiving the socket object. I could therefore define (or reuse) some backend-side code (handshake, authentication, ...)

<pre>
module.exports = function(socket){
  socket.on("authenticate", function(data){
    return true;
  });
}
</pre>

* I have a lot of other ideas, but at the same time I think it would be cool to keep that tool simple and light
