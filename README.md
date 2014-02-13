Unix2WS.js
==========

Unix2WebSocket allows you to easily stream incoming data on a UNIX socket to clients connected through websockets

## Usage

The command line tool _u2ws_ creates a unix socket and opens a Socket.IO server. Any content received through the unix socket will be sent to all the WebSocket clients connected.

I created this tool to be able to easily stream any line by line output from a command-line application to the browser.

By default, u2ws will try to parse every line received as a JSON object.

<pre>
<code>./bin/u2ws --debug --socket unix.sock --port 10000 --json</code>
</pre>

## Example

Have a look at the example, you'll see that it's pretty simple

![ScreenShot](/example/screenshot.png)
