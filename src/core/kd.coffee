utils = window.utils = require './utils.coffee'
require './support'

# KD Global
window.KD or= {}

noop = window.noop = ->

KD.log   = window.log   = console.log.bind console
KD.warn  = window.warn  = console.warn.bind console
KD.error = window.error = console.error.bind console

unless window.event?
  try
    # warn when the global "event" property is accessed.
    Object.defineProperty window, "event", get:->
      KD.warn "Global \"event\" property is accessed. Did you forget a parameter in a DOM event handler?"
  catch e
    log "we fail silently!", e

window.KD = $.extend (window.KD), do ->
  create = (constructorName, options, data)->
    konstructor = @classes[constructorName] \
                ? @classes["KD#{constructorName}"]
    new konstructor options, data  if konstructor?

  create          : create
  new             : create

  debugStates     : {}
  instances       : {}
  singletons      : {}
  subscriptions   : []
  classes         : {}
  utils           : utils
  lastFuncCall    : null
  instancesToBeTested: {}

  registerInstance : (anInstance)->
    warn "Instance being overwritten!!", anInstance  if @instances[anInstance.id]
    @instances[anInstance.id] = anInstance

  unregisterInstance: (anInstanceId)->
    # warn "Instance being unregistered doesn't exist in registry!!", anInstance unless @instances[anInstance.id]

    # FIXME (sb) - delete puts JITs into SLOW mode for that object, forever. We
    # should consider using _.omit for cases like this
    delete @instances[anInstanceId]

  deleteInstance:(anInstanceId)->
    @unregisterInstance anInstanceId
    # anInstance = null #FIXME: Redundant? See unregisterInstance

  extend:(obj)->
    for key, val of obj
      if @[key] then throw new Error "#{key} is already registered"
      else @[key] = val

  registerSingleton:(singletonName,object,override = no)->
    if (existingSingleton = KD.singletons[singletonName])?
      if override
        warn "singleton overriden! KD.singletons[\"#{singletonName}\"]"
        existingSingleton.destroy?()
        KD.singletons[singletonName] = object
      else
        error "KD.singletons[\"#{singletonName}\"] singleton exists! if you want to override set override param to true]"
        KD.singletons[singletonName]
      KDObject.emit "singleton.#{singletonName}.registered"
    else
      # log "singleton registered! KD.singletons[\"#{singletonName}\"]"
      KD.singletons[singletonName] = object

  getSingleton:(singletonName)->
    if KD.singletons[singletonName]?
      KD.singletons[singletonName]
    else
      warn "\"#{singletonName}\" singleton doesn't exist!"
      null

  getAllKDInstances  :-> KD.instances

  getKDViewInstanceFromDomElement:(el)-> @instances[el.getAttribute "data-id"]

  exportKDFramework:->
    (window[item] = KD.classes[item] for own item of KD.classes)
    KD.exportKDFramework = -> "Already exported."
    "KDFramework loaded successfully."

  registerInstanceForTesting:(instance)->
    key = instance.getOption 'testPath'
    @instancesToBeTested[key] = instance
    instance.on 'KDObjectWillBeDestroyed', => delete @instancesToBeTested[key]

  getInstanceForTesting:(key)-> @instancesToBeTested[key]

module.exports = KD
