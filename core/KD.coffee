Function::bind or= (context) ->
  if 1 < arguments.length
    args = [].slice.call arguments, 1
    return => @apply context, if arguments.length then args.concat [].slice.call arguments else args
  => if arguments.length then @apply context, arguments else @call context

Function::swiss = (parent, names...)->
  for name in names
    @::[name] = parent::[name]
  @

# Cross-Browser DOM dependencies
window.URL                   ?= window.webkitURL                   ? null
window.BlobBuilder           ?= window.WebKitBlobBuilder           ? window.MozBlobBuilder           ? null
window.requestFileSystem     ?= window.webkitRequestFileSystem     ? null
window.requestAnimationFrame ?= window.webkitRequestAnimationFrame ? window.mozRequestAnimationFrame ? null

# FIXME: add to utils.coffee
String.prototype.capitalize   = ()-> this.charAt(0).toUpperCase() + this.slice(1)
String.prototype.decapitalize = ()-> this.charAt(0).toLowerCase() + this.slice(1)
String.prototype.trim         = ()-> this.replace(/^\s+|\s+$/g,"")

# Dict = Object.create.bind null, null, Object.create null

do (arrayProto = Array.prototype, {defineProperty} = Object)->
  # set up .first and .last getters for Array prototype

  "last" of arrayProto or
    defineProperty arrayProto, "last", { get: -> @[@length-1] }

  "first" of arrayProto or
    defineProperty arrayProto, "first", { get: -> @[0] }

# KD Global
KD = @KD or {}

noop  = ->

KD.log   = log   = noop
KD.warn  = warn  = noop
KD.error = error = noop


unless window.event?
  try
    # warn when the global "event" property is accessed.
    Object.defineProperty window, "event", get:->
      KD.warn "Global \"event\" property is accessed. Did you forget a parameter in a DOM event handler?"
  catch e
    log "we fail silently!", e

@KD = $.extend (KD), do ->
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
  utils           : __utils
  lastFuncCall    : null
  instancesToBeTested: {}

  registerInstance : (anInstance)->
    warn "Instance being overwritten!!", anInstance  if @instances[anInstance.id]
    @instances[anInstance.id] = anInstance

  unregisterInstance: (anInstanceId)->
    # warn "Instance being unregistered doesn't exist in registry!!", anInstance unless @instances[anInstance.id]
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

prettyPrint = noop