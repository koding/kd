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

module.exports = class KDData

  @EMITTER = createSymbol 'kddata'
  @NAME    = createSymbol 'name'

  constructor: (data = {}) ->

    emitter = new KDEventEmitter
    emitter.__data__ = data
    emitter.isArray  = Array.isArray data

    proxy = createProxy data, proxyHandler emitter
    Object.defineProperty proxy, KDData.EMITTER, value: emitter

    return proxy

  @isSupported = -> !!window.Proxy?

  @getEmitter = (data) ->

    return  unless data?
    return  emitter  if emitter = data[KDData.EMITTER]

    if typeof data.on is 'function' and typeof data.off is 'function'
      return data


  getFullPath = (parent, child) ->

    if root = parent[KDData.NAME]
      return "#{root}.#{child}"
    return child


  proxyHandler = (base) ->

    set: (target, key, value, receiver) ->

      if base.isArray
        currentLength = target.length

      if value instanceof Object and value not instanceof Date
        if root = receiver[KDData.NAME]
          key = "#{root}.#{key}"
        value = createProxy value, proxyHandler base
        Object.defineProperty value, KDData.NAME, {
          value: key, configurable: yes
        }

      target[key] = value

      if base.isArray
        lengthChanged = target.length isnt currentLength
        return true  if key is 'length' and not lengthChanged

      return true  if typeof key is 'symbol' or /^__|__$/.test key

      if root = receiver[KDData.NAME]
        key = "#{root}.#{key}"
      else
        root = ''

      if lengthChanged
        prefix = if key.indexOf('.') >= 0 then "#{root}." else ''
        base.emit 'update', [ "#{prefix}length" ]

      base.emit 'update', [ key ]
      return true
