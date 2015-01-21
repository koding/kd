utils = require './utils'
dom = require 'kd-dom'

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
    console.warn "[getSingleton] #{name} doesn't exist"
    null

module.exports =
  extend: (obj) ->
    for key, val of obj
      if @[key] then throw new Error "#{key} is already registered"
      else @[key] = val

  registerSingleton: (name, obj, override = no)->
    if (existing = singletons[name])?
      if override
        console.warn "[registerSingleton] overriding #{name}"
        existing.destroy?()
        singletons[name] = obj
      else
        console.error "[registerSingleton] #{name} exists. if you want to override set override param to true."
        singletons[name]
      # KDObject.emit "singleton.#{name}.registered"
    else
      # log "singleton registered! KD.singletons[\"#{name}\"]"
      singletons[name] = obj

  registerInstance: (inst) ->
    console.warn '[registerInstance] instance is being overwritten' if instances[inst.id]
    instances[inst.id] = inst

  unregisterInstance: (id) ->
    delete instances[id]

  deleteInstance: (id) ->
    delete instances[id]

  getSingleton: getSingleton

  singleton: getSingleton

  getAllKDInstances: -> instances

  getInstanceForTesting: (key) -> instancesToBeTested[key]

  registerInstanceForTesting: (inst) ->
    key = inst.getOption 'testPath'
    instancesToBeTested[key] = inst
    inst.on 'KDObjectWillBeDestroyed', => delete instancesToBeTested[key]

  noop: ->
  log: console.log.bind console
  warn: console.warn.bind console
  error: console.error.bind console
  info: console.info.bind console
  time: console.time.bind console
  timeEnd: console.timeEnd.bind console

  debugStates: debugStates
  instances: instances
  singletons: singletons
  subscriptions: subscriptions
  lastFuncCall: lastFuncCall
  instancesToBeTested: instancesToBeTested

  utils: utils
  dom: dom

