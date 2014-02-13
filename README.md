Unix2WS.js
==========

Unix2WebSocket allows you to easily stream incoming data on a UNIX socket to clients connected through websockets

## Usage

The command line tool _u2ws_ creates a unix socket and opens a Socket.IO server. Any content received through the unix socket will be sent to all the WebSocket clients connected.

<pre>
<code>./bin/u2ws --debug --socket unix.sock --port 10000</code>
</pre>

## Example

Have a look at the example, you'll see that it's pretty simple

![ScreenShot](/example/screenshot.png)
