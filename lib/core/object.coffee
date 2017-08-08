KD             = require './kd'
KDEventEmitter = require './eventemitter'

module.exports = class KDObject extends KDEventEmitter

  [ NOTREADY, READY ] = [ 0, 1 ]

  utils: KD.utils

  constructor: (options = {}, data) ->

    super

    @setId options.id or KD.utils.getUniqueId()

    @setOptions options
    @setDelegate options.delegate  if options.delegate

    @setData data  if data

    @on   'error', console.error.bind console
    @once 'ready', => @readyState = READY


  define: (property, options) ->
    options = { get: options }  if 'function' is typeof options
    Object.defineProperty this, property, options

  bound: (method) ->
    unless 'function' is typeof @[method]
      throw new Error "bound: unknown method! #{method}"
    boundMethod = "__bound__#{method}"
    boundMethod of this or Object.defineProperty(
      this, boundMethod, value: @[method].bind this
    )
    return @[boundMethod]

  lazyBound: (method, rest...) -> @[method].bind this, rest...

  forwardEvent: (target, eventName, prefix='') ->
    target.on eventName, @lazyBound 'emit', "#{prefix}#{eventName}"

  forwardEvents: (target, eventNames, prefix='') ->
    @forwardEvent target, eventName, prefix  for eventName in eventNames

  ready: (listener) ->
    if Promise?::nodeify
      new Promise (resolve) =>
        resolve() if @readyState is READY
        @once 'ready', resolve
      .nodeify listener
    else if @readyState is READY then @utils.defer listener
    else @once 'ready', listener

  registerSingleton:KD.registerSingleton

  getSingleton:KD.getSingleton

  getInstance: (instanceId) ->
    return KD.getAllKDInstances()[instanceId]

  setData: (data) ->
    @data = data
    return @data

  getData: ->
    return @data

  setOptions: (options = {}) ->
    @options = options
    return @options

  setOption: (option, value) ->
    return @options[option] = value

  unsetOption: (option) ->
    delete @options[option]

  getOptions: ->
    return @options

  getOption: (key) ->
    return @options[key] ? null

  setId: (id) ->
    KD.deleteInstance id  if @id
    @id = id
    KD.registerInstance @
    return @id

  getId: ->
    return @id

  setDelegate: (delegate) ->
    @delegate = delegate
    return @delegate

  getDelegate: ->
    return @delegate

  destroy:->
    @isDestroyed = yes
    @emit 'KDObjectWillBeDestroyed'
    KD.deleteInstance @id
    # good idea but needs some refactoring
    # @[prop] = null  for own prop of this
