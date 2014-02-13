Unix2WS.js
==========

Unix2WS allows you to easily stream data from any input to socket.io.

This tool supports TCP, UNIX sockets as input, or named-pipe (FIFO)

## Usage

The command line tool _u2ws_ opens a Socket.IO server. Any content received through the specified source will be sent to all the Socket.IO clients.

I created this tool to be able to easily stream any line by line output from a command-line application to the browser.

By default, u2ws will try to parse every line received as a JSON object.

<pre>
Usage: coffee ./bin/u2ws

Examples:
  coffee ./bin/u2ws -s 10001 --ws-port 10000
  coffee ./bin/u2ws -s unix.sock --ws-port 10000
  coffee ./bin/u2ws -f fifo --ws-port 10000


Options:
  -d, --debug        Prints debugging information     [default: false]
  -j, --json         Try to JSON.parse input lines    [default: true]
  -p, --ws-port      Port to use for socket.io        [default: 10000]
  -s, --from-socket  Opens TCP/UNIX socket for input
  -f, --from-fifo    Creates named pipe for input
</pre>

## Example

Open the example HTML file in your browser and give it a try, you'll see it's pretty simple