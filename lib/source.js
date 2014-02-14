(function() {
  var EventEmitter, FileSource, NetSource, Source, exec, fs, net, sys,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  fs = require('fs');

  sys = require('sys');

  net = require('net');

  exec = require('child_process').exec;

  EventEmitter = require('events').EventEmitter;

  Source = (function() {
    function Source() {}

    return Source;

  })();

  NetSource = (function() {
    function NetSource(port, callback) {
      this.port = port;
      this.callback = callback;
      this.destroy = __bind(this.destroy, this);
      this.close = __bind(this.close, this);
      this.read = __bind(this.read, this);
      this.desc = "SOCKET(" + this.port + ")";
      this.destroy();
      this.server = net.createServer((function(_this) {
        return function(socket) {
          _this.socket = socket;
          return _this.callback(_this.socket);
        };
      })(this));
    }

    NetSource.prototype.read = function() {
      return this.server.listen(this.port);
    };

    NetSource.prototype.close = function() {
      this.server.close();
      return this.destroy();
    };

    NetSource.prototype.destroy = function() {
      if (fs.existsSync(this.port)) {
        return fs.unlinkSync(this.port);
      }
    };

    return NetSource;

  })();

  FileSource = (function() {
    function FileSource(fd, callback) {
      this.fd = fd;
      this.callback = callback;
      this.destroy = __bind(this.destroy, this);
      this.close = __bind(this.close, this);
      this.read = __bind(this.read, this);
      this.destroy();
      this.desc = "FILE(" + this.fd + ")";
    }

    FileSource.prototype.read = function() {
      return exec("mkfifo " + this.fd, (function(_this) {
        return function() {
          _this.stream = fs.createReadStream(_this.fd);
          _this.stream.on('close', _this.read);
          return _this.callback(_this.stream);
        };
      })(this));
    };

    FileSource.prototype.close = function() {
      this.stream.close();
      return this.destroy();
    };

    FileSource.prototype.destroy = function() {
      if (fs.existsSync(this.fd)) {
        return fs.unlinkSync(this.fd);
      }
    };

    return FileSource;

  })();

  Source.socket = function(port, callback) {
    return new NetSource(port, callback);
  };

  Source.fifo = function(path, callback) {
    return new FileSource(path, callback);
  };

  module.exports = Source;

}).call(this);
