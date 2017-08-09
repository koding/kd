debug = require('debug') 'kd:data'
KD = require './kd'
KDEventEmitter = require './eventemitter'

createSymbol = (key) ->
  (window.Symbol? key) || "__#{key}__"

createProxy = (data, handler) ->
  if window.Proxy?
    return new Proxy data, handler
  else
    console.warn 'Proxies are not supported on this platform!'
    return new Object data

isValid = (value) ->
  value and typeof value is 'object' and value not instanceof Date


module.exports = class KDData

  @EMITTER = createSymbol 'kddata'
  @NAME    = createSymbol 'name'

  constructor: (data = {}, options = {}) ->

    @emitter = new KDEventEmitter
    @emitter.__data__  = data
    @emitter.__event__ = options.updateEvent ? 'update'
    @emitter.maxDepth  = options.maxDepth ? 2

    @proxy = createProxy data, KDData::proxyHandler.call this
    Object.defineProperty @proxy, KDData.EMITTER, {
      value: @emitter, configurable: yes
    }

    initialize = (data, key = null, depth = 0) =>
      return  if not isValid data

      depth += 1
      for _key, child of data
        path = if key then "#{key}.#{_key}" else _key
        if depth < @emitter.maxDepth and isValid child
          initialize child, path, depth
          KD.utils.JsPath.setAt @proxy, path, child

    initialize data
    @initialized = yes

    return @proxy


  @isSupported = -> !!window.Proxy?


  @getEmitter = (data) ->

    return  unless data?
    return  emitter  if emitter = data[KDData.EMITTER]

    if typeof data.on is 'function' and typeof data.off is 'function'
      return data


  emit: (updates) ->

    return  if not @initialized
    @emitter.emit @emitter.__event__, [ updates ]


  createObjectProxy: (obj, key) ->

    value = createProxy obj, @proxyHandler.call this
    return value  unless key

    Object.defineProperty value, KDData.NAME, {
      value: key, configurable: yes
    }
    return value


  proxify: (value, key, depth = 0) ->

    return value  if not isValid value

    depth += 1

    for _key, child of value
      path = if key then "#{key}.#{_key}" else _key
      debug 'path on', _key, path
      if depth < @emitter.maxDepth and isValid child
        value[_key] = @createObjectProxy child, path
        @proxify child, path, depth

    debug 'creating proxy', value, key

    if isValid value
      return @createObjectProxy value, key
    else
      return value


  proxyHandler: ->

    set: (target, key, value, receiver) =>

      debug 'setting', key, value

      if isArray = Array.isArray target
        currentLength = target.length

      if parent = receiver[KDData.NAME] ? ''
        path = "#{parent}.#{key}"

      target[key] = @proxify value, path ? key

      if isArray
        lengthChanged = target.length isnt currentLength
        return true  if key is 'length' and not lengthChanged

      @emit path ? key

      if lengthChanged and key isnt 'length'
        @emit if parent then "#{parent}.length" else 'length'

      return true
