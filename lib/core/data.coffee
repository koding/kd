KD = require './kd'
KDEventEmitter = require './eventemitter'

module.exports = class KDData

  @EMITTER = '__kddata__'
  @NAME    = '__name__'

  constructor: (data = {}) ->

    emitter = new KDEventEmitter
    emitter.__data__ = data
    emitter.isArray  = Array.isArray data

    proxy = new Proxy data, proxyHandler emitter
    Object.defineProperty proxy, KDData.EMITTER, value: emitter

    return proxy


  @getEmitter = (data) ->

    return  unless data?
    return  data  if typeof data.off is 'function'
    return  emitter  if emitter = data[KDData.EMITTER]


  getFullPath = (parent, child) ->

    if root = parent[KDData.NAME]
      return "#{root}.#{child}"
    return child


  proxyHandler = (base) ->

    get: (target, key) ->

      value = target[key]
      return value  if typeof key isnt 'string' or key[0..1] is '__'

      key = getFullPath target, key

      if value and dataValue = KD.utils.JsPath.getAt base.__data__, key
        if dataValue instanceof Object and value not instanceof Date
          proxy = new Proxy value, proxyHandler base
          Object.defineProperty proxy, KDData.NAME, {
            value: key, configurable: yes
          }
          return proxy

      return value


    set: (target, key, value, receiver) ->

      if base.isArray
        currentLength = target.length

      target[key] = value

      if base.isArray
        lengthChanged = target.length isnt currentLength
        return true  if key is 'length' and not lengthChanged

      if root = receiver[KDData.NAME]
        key = "#{root}.#{key}"
      else
        root = ''

      return true  if /^__|__$/.test key

      if lengthChanged
        prefix = if key.indexOf('.') >= 0 then "#{root}." else ''
        base.emit 'update', [ "#{prefix}length" ]

      base.emit 'update', [ key ]
      return true


    getPrototypeOf: (target) ->

      return KDData.prototype
