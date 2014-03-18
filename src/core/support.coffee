# Pollyfils for older browsers, most of this is probably depreacted

# FIXME (sb) - these cases should be converted to use _.bind
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

# FIXME: add to utils.coffee
String.prototype.capitalize   = ()-> this.charAt(0).toUpperCase() + this.slice(1)
# FIXME: 
String.prototype.trim         = ()-> this.replace(/^\s+|\s+$/g,"")


do (arrayProto = Array.prototype, {defineProperty} = Object)->
  # set up .first and .last getters for Array prototype

  "last" of arrayProto or
    defineProperty arrayProto, "last", { get: -> @[@length-1] }

  "first" of arrayProto or
    defineProperty arrayProto, "first", { get: -> @[0] }



