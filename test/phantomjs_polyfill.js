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

console = {}
console.log = function() {}
console.warn = function() {}
console.error = function() {}

