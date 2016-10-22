debug = require('debug') 'kd'
utils = require '../utils'

debugStates = {}
instances = {}
singletons = {}
subscriptions = []
lastFuncCall = null
instancesToBeTested = {}

getSingleton = (name) ->
  if singletons[name]?
    singletons[name]
  else
    debug "could not find singleton #{name}"
    null

module.exports =
  extend: (obj) ->
    for key, val of obj
      if @[key] then throw new Error "#{key} is already registered"
      else @[key] = val

  deleteSingletons: -> singletons = []

  registerSingleton: (name, obj, override = no)->
    if (existing = singletons[name])?
      if override
        debug "overriding singleton #{name}"
        existing.destroy?()
        singletons[name] = obj
      else
        debug "cowardly refusing to override singleton #{name} without being explicitly told to do so"
        singletons[name]
    else
      debug "registered singleton #{name}"
      singletons[name] = obj

  registerInstance: (inst) ->
    debug "overriding instance #{inst.id}"  if instances[inst.id]
    instances[inst.id] = inst

  unregisterInstance: (id) ->
    delete instances[id]

  deleteInstance: (id) ->
    delete instances[id]

  deleteInstances: -> instances = []

  getSingleton: getSingleton

  singleton: getSingleton

  getAllKDInstances: -> instances

  getInstanceForTesting: (key) -> instancesToBeTested[key]

  registerInstanceForTesting: (inst) ->
    key = inst.getOption 'testPath'
    instancesToBeTested[key] = inst
    inst.on 'KDObjectWillBeDestroyed', => delete instancesToBeTested[key]

  noop: ->
  log: -> console.log.apply console, arguments
  warn: -> console.warn.apply console, arguments
  error: -> console.error.apply console, arguments
  info: -> console.info.apply console, arguments
  time: -> console.time.apply console, arguments
  timeEnd: -> console.timeEnd.apply console, arguments

  debugStates: debugStates
  instances: instances
  singletons: singletons
  subscriptions: subscriptions
  lastFuncCall: lastFuncCall
  instancesToBeTested: instancesToBeTested

  utils: utils
