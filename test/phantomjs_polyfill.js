// 139 bytes gzipped
/*! (C) WebReflection, Mit Style License */
(function (P) {
 'use strict';
 if (!P.bind) {
   P.bind = function (s) {
     var
       c = this,
       l = [].slice,
       a = l.call(arguments, 1);
     return function bind() {
       return c.apply(s, a.concat(l.call(arguments)));
     };
   };
 }
}(Function.prototype));

// Mocha needs a process.stdout.write in order to change the cursor position.
Mocha.process = Mocha.process || {};
Mocha.process.stdout = Mocha.process.stdout || process.stdout;
Mocha.process.stdout.write = function(s) { window.callPhantom({"Mocha.process.stdout.write":s}); }

// Mocha needs the formating feature of console.log so copy node's format function and
// monkey-patch it into place. This code is copied from node's, links copyright applies.
// https://github.com/joyent/node/blob/master/lib/util.js
console.format = function(f) {
  if (typeof f !== 'string') {
    var objects = [];
    for (var i = 0; i < arguments.length; i++) {
      objects.push(JSON.stringify(arguments[i]));
    }
    return objects.join(' ');
  }
  var i = 1;
  var args = arguments;
  var len = args.length;
  var str = String(f).replace(/%[sdj%]/g, function(x) {
    if (x === '%%') return '%';
    if (i >= len) return x;
    switch (x) {
      case '%s': return String(args[i++]);
      case '%d': return Number(args[i++]);
      case '%j': return JSON.stringify(args[i++]);
      default:
        return x;
    }
  });
  for (var x = args[i]; i < len; x = args[++i]) {
    if (x === null || typeof x !== 'object') {
      str += ' ' + x;
    } else {
      str += ' ' + JSON.stringify(x);
    }
  }
  return str;
};
var origError = console.error;
console.error = function(){ origError.call(console, console.format.apply(console, arguments)); };
var origLog = console.log;
console.log = function(){ origLog.call(console, console.format.apply(console, arguments)); };
var origWarn = console.warn;
console.warn = function(){ origWarn.call(console, console.format.apply(console, arguments)); };
window.event = {}

