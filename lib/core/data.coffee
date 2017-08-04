KDEventEmitter = require './eventemitter'

module.exports = class KDData extends KDEventEmitter

  proxyHandler = (base) ->

    get: (target, key) ->

      value = target[key]
      if base.__data__[key]?
        return value

      isObject = typeof value is 'object'
      if value and isObject and value not instanceof Date
        proxy = new Proxy value, proxyHandler base
        proxy.__prefix__ = key  if isObject
        return proxy

      return value

    set: (target, key, value, receiver) ->

      target[key] = value
      prefix = if receiver.__prefix__ then "#{receiver.__prefix__}." else ''
      path = "#{prefix}#{key}"
      base.emit 'update', [ path ]  if base.__data__[path]?

      return true


  constructor: (data) ->

    super {}

    this.__data__  = data
    this.__proxy__ = new Proxy data, proxyHandler this
    this.__proxy__[key] = val for key, val of this when key isnt 'constructor'

    return this.__proxy__
