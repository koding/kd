module.exports = do ->

  document.write = document.writeln = ->
    throw new Error 'document.[write|writeln] is nisht-nisht'

  Function::bind or= (context) ->
    if 1 < arguments.length
      args = [].slice.call arguments, 1
      return => @apply context, if arguments.length then args.concat [].slice.call arguments else args
    => if arguments.length then @apply context, arguments else @call context

  # Cross-Browser DOM dependencies
  window.URL                   ?= window.webkitURL                   ? null
  window.BlobBuilder           ?= window.WebKitBlobBuilder           ? window.MozBlobBuilder           ? null
  window.requestFileSystem     ?= window.webkitRequestFileSystem     ? null
  window.requestAnimationFrame ?= window.webkitRequestAnimationFrame ? window.mozRequestAnimationFrame ? null

  String.prototype.capitalize = ->
    return "#{@charAt(0).toUpperCase()}#{@slice 1}"

  String.prototype.trim = ->
    return @replace /^\s+|\s+$/g, ''

  do (arrayProto = Array.prototype, { defineProperty } = Object) ->
    'last' of arrayProto or
      defineProperty arrayProto, 'last', { get: -> @[@length-1] }

    'first' of arrayProto or
      defineProperty arrayProto, 'first', { get: -> @[0] }
