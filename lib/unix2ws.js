(function() {
  var SocketIO, Source, Unix2WS, fs,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  fs = require('fs');

  SocketIO = require('socket.io');

  Source = require('./source');

  Unix2WS = (function() {
    function Unix2WS(params) {
      var _ref, _ref1, _ref2, _ref3;
      if (params == null) {
        params = {};
      }
      this.stop = __bind(this.stop, this);
      this.start = __bind(this.start, this);
      this.propagate = __bind(this.propagate, this);
      this.port = (_ref = params.port) != null ? _ref : 10000;
      this.debug = (_ref1 = params.debug) != null ? _ref1 : false;
      this.json = (_ref2 = params.json) != null ? _ref2 : true;
      this.room = params.room;
      this.namespace = params.namespace;
      this.sourceDesc = (_ref3 = params.socket) != null ? _ref3 : params.fifo;
      if (this.sourceDesc == null) {
        throw new Error("At least one input method must be chosen");
      }
      this.sourceFactory = (function() {
        switch (false) {
          case params.socket == null:
            return Source.socket;
          case params.fifo == null:
            return Source.fifo;
        }
      })();
    }

    Unix2WS.prototype.propagate = function(data) {
      var e;
      if (this.json) {
        try {
          data = JSON.parse(data);
        } catch (_error) {
          e = _error;
          console.error("Error while parsing JSON", data, e);
          console.error("Propagating it in its raw format");
        }
      }
      if (this.namespace != null) {
        this.namespace.emit("data", data);
      }
      if (this.room != null) {
        this.room.emit('data', data);
      }
      return this.io.sockets.emit("data", data);
    };

    Unix2WS.prototype.start = function() {
      this.io = SocketIO.listen(this.port, {
        log: this.debug
      });
      if (this.room != null) {
        this.room = this.io.sockets["in"](this.room);
      }
      if (this.namespace != null) {
        console.log("Creating namespace /" + this.namespace);
        this.namespace = this.io.of('/' + this.namespace);
      }
      this.source = this.sourceFactory(this.sourceDesc, (function(_this) {
        return function(stream) {
          var data, finish;
          data = "";
          stream.on("data", function(chunk) {
            var idx, last_chunk, line, lines;
            if (_this.debug === true) {
              console.log("Data chunk received: " + (chunk.toString()));
            }
            data += chunk.toString();
            lines = data.split("\n");
            last_chunk = lines.pop();
            for (idx in lines) {
              line = lines[idx];
              _this.propagate(line);
            }
            return data = last_chunk;
          });
          return finish = function() {
            if (data !== "") {
              return this.propagate(data);
            }
          };
        };
      })(this));
      return this.source.read();
    };

    Unix2WS.prototype.stop = function() {
      return this.source.close();
    };

    return Unix2WS;

  })();

  module.exports = Unix2WS;

}).call(this);
