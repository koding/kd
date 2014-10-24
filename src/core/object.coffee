KD             = require './kd.coffee'
KDEventEmitter = require './eventemitter.coffee'

module.exports = class KDObject extends KDEventEmitter

  [NOTREADY, READY] = [0,1]

  include = (context, mixin) ->
    mixin = require mixin  if typeof mixin is 'string'
    mixin.call context

  @include = (mixin) -> include this.prototype, mixin

  include: (mixin) -> include this, mixin

  utils: KD.utils

  constructor:(options = {}, data)->

    @id or= options.id or KD.utils.getUniqueId()
    @setOptions options
    @setData data  if data
    @setDelegate options.delegate if options.delegate
    @registerKDObjectInstance()

    super

    if options.testPath
      KD.registerInstanceForTesting this

    @on 'error', error
    @once 'ready', => @readyState = READY

  bound: (method)->
    unless 'function' is typeof @[method]
      throw new Error "bound: unknown method! #{method}"
    boundMethod = "__bound__#{method}"
    boundMethod of this or Object.defineProperty(
      this, boundMethod, value: @[method].bind this
    )
    return @[boundMethod]

  lazyBound: (method, rest...)-> @[method].bind this, rest...

  forwardEvent: (target, eventName, prefix="") ->
    target.on eventName, @lazyBound 'emit', prefix + eventName

  forwardEvents: (target, eventNames, prefix="") ->
    @forwardEvent target, eventName, prefix  for eventName in eventNames

  ready:(listener)->
    if Promise?::nodeify
      new Promise (resolve) =>
        resolve() if @readyState is READY
        @once 'ready', resolve
      .nodeify listener
    else if @readyState is READY then @utils.defer listener
    else @once 'ready', listener

  registerSingleton:KD.registerSingleton

  getSingleton:KD.getSingleton

  getInstance:(instanceId)->
    KD.getAllKDInstances()[instanceId] ? null

  registerKDObjectInstance: -> KD.registerInstance @

  setData:(@data)->

  getData:-> @data

  setOptions:(@options = {})->

  setOption:(option, value)-> @options[option] = value

  unsetOption:(option)-> delete @options[option] if @options[option]

  getOptions:-> @options
  getOption:(key)-> @options[key] ? null

  changeId:(id)->
    KD.deleteInstance id
    @id = id
    KD.registerInstance @

  getId:->@id

  setDelegate:(@delegate)->

  getDelegate:->@delegate

  destroy:->
    @isDestroyed = yes
    @emit 'KDObjectWillBeDestroyed'
    KD.deleteInstance @id
    # good idea but needs some refactoring
    # @[prop] = null  for own prop of this

  chainNames:(options)->
    options.chain
    options.newLink
    "#{options.chain}.#{options.newLink}"
