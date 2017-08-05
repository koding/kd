KDEventEmitter = require './eventemitter'

module.exports = class KDData extends KDEventEmitter

  proxyHandler = (base) ->

    get: (target, key) ->

      value = target[key]
      return value  if typeof key isnt 'string' or key[0..1] is '__'

      if value and dataValue = base.__data__[key]
        if dataValue instanceof Object and value not instanceof Date
          proxy = new Proxy value, proxyHandler base
          proxy.__prefix__ = key
          return proxy

      return value


    set: (target, key, value, receiver) ->

      target[key] = value

      if receiver.__prefix__
        key = "#{receiver.__prefix__}.#{key}"

      unless /^__|__$/.test key
        base.emit 'update', [ key ]

      return true


  constructor: (data = {}) ->

    super {}

    this.__data__  = data
    this.__proxy__ = new Proxy data, proxyHandler this
    this.__proxy__.__proxy__ = {}

    for key, val of this when key not in ['constructor', '__data__']
      this.__proxy__.__proxy__[key] = val

    return this.__proxy__
