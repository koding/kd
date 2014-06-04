###
todo:

  - make addLayer implementation more clear, by default adding a layer
    should set a listener for next ReceivedClickElsewhere and remove the layer automatically
    2012/5/21 Sinan

###

KDController = require './controller.coffee'

module.exports = class KDWindowController extends KDController

  @keyViewHistory = []
  superKey        = if navigator.userAgent.indexOf("Mac OS X") is -1 then "ctrl" else "command"
  addListener     = (eventName, listener, capturePhase=yes)->
    window.addEventListener eventName, listener, capturePhase

  # Finding vendor prefixes for visibility
  getVisibilityProperty = ->
    prefixes = ["webkit", "moz", "o"]
    return "hidden" if `"hidden" in document`
    return "#{prefix}Hidden" for prefix in prefixes when `prefix + "Hidden" in document`
    return ""

  getVisibilityEventName = ->
    return "#{getVisibilityProperty().replace(/[Hh]idden/, '')}visibilitychange"

  constructor:(options,data)->

    @windowResizeListeners = {}
    @keyEventsToBeListened = ['keydown', 'keyup', 'keypress']
    @currentCombos         = {}
    @keyView               = null
    @dragView              = null
    @scrollingEnabled      = yes
    @layers                = []
    @unloadListeners       = {}
    @focusListeners        = []

    @bindEvents()

    super options, data

  addLayer: (layer)->

    unless layer in @layers
      # log "layer added", layer
      @layers.push layer
      layer.on 'KDObjectWillBeDestroyed', =>
        @removeLayer layer

  removeLayer: (layer)->

    if layer in @layers
      # log "layer removed", layer
      index = @layers.indexOf(layer)
      @layers.splice index, 1

  bindEvents:->

    for eventName in @keyEventsToBeListened
      addEventListener eventName, @bound 'key'

    addEventListener 'resize', @bound 'notifyWindowResizeListeners'

    document.addEventListener 'scroll', do =>
      timer  = null
      {body} = document
      _.throttle (event)=>
        @emit "ScrollHappened", event
      , 50
    , no

    addListener "dragenter", (event)=>
      unless @dragInAction
        @emit 'DragEnterOnWindow', event
        @setDragInAction yes

    addListener "dragleave", (event)=>
      unless 0 < event.clientX < @winWidth and
             0 < event.clientY < @winHeight
        @emit 'DragExitOnWindow', event
        @setDragInAction no

    addListener "drop", (event)=>
      @emit 'DragExitOnWindow', event
      @emit 'DropOnWindow', event
      @setDragInAction no

    layers = @layers

    addListener 'mousedown', (e)=>

      lastLayer = layers.last

      if lastLayer and $(e.target).closest(lastLayer?.$()).length is 0
        lastLayer.emit 'ReceivedClickElsewhere', e
        @removeLayer lastLayer

    addListener 'mouseup', (e)=>
      @unsetDragView e if @dragView
      @emit 'ReceivedMouseUpElsewhere', e

    addListener 'mousemove', (e)=>
      @redirectMouseMoveEvent e if @dragView

    # internal links (including "#") should prevent default, so we don't end
    # up with duplicate entries in history: e.g. /Activity and /Activity#
    # also so that we don't redirect the browser
    (addListener 'click', (e)->
      nearestLink = KD.utils.getNearestElementByTagName e.target, 'a'

      if nearestLink?.target?.length is 0 # links with a target attribute should work as normal.
        href   = nearestLink.getAttribute "href"
        isHttp = href?.indexOf("http") is 0
        if isHttp
          nearestLink.target = "_blank"
        else
          e.preventDefault()
          if href and not /^#/.test href
            KD.getSingleton("router").handleRoute href
    , no)

    window.addEventListener 'beforeunload', @bound "beforeUnload"

    document.addEventListener getVisibilityEventName(), (event)=>
      @focusChange event, @isFocused()

  addUnloadListener:(key, listener)->
    @unloadListeners[key] or= []
    @unloadListeners[key].push listener

  clearUnloadListeners: (key)->
    if key
      @unloadListeners[key] = []
    else
      @unloadListeners = {}

  isFocused: -> !Boolean document[getVisibilityProperty()]

  addFocusListener: (listener)-> @focusListeners.push listener

  focusChange: (event, state)->

    return unless event
    listener state, event for listener in @focusListeners

  beforeUnload:(event)->

    return unless event

    # all the listeners make their checks if it is safe or not to reload the page
    # they either return true or false if any of them returns false we intercept reload

    for own key, listeners of @unloadListeners
      for listener in listeners
        if listener() is off
          message = unless key is "window" then " on #{key}" else ""
          return "Please make sure that you saved all your work#{message}."

  setDragInAction:(@dragInAction = no)->
    $('body')[if @dragInAction then "addClass" else "removeClass"] "dragInAction"

  setMainView:(@mainView)->

  getMainView:(view)-> @mainView

  revertKeyView:(view)->

    unless view
      warn "you must pass the view as a param, which doesn't want to be keyview anymore!"
      return

    if view is @keyView and @keyView isnt @oldKeyView
      @setKeyView @oldKeyView

  superizeCombos = (combos)->

    safeCombos = {}
    for own combo, cb of combos
      if /\bsuper(\+|\s)/.test combo
        combo = combo.replace /super/g, superKey
      safeCombos[combo] = cb

    return safeCombos

  viewHasKeyCombos:(view)->

    return unless view

    o      = view.getOptions()
    combos = {}

    for e in @keyEventsToBeListened
      if "object" is typeof o[e]
        for own combo, cb of o[e]
          combos[combo] = cb

    return if Object.keys(combos).length > 0 then combos else no

  registerKeyCombos:(view)->
    combos = @viewHasKeyCombos view
    if combos?
      @comboMap = new KDKeyboardMap { combos }
      KDKeyboardListener.current().addComboMap @comboMap

  unregisterKeyCombos:->
    KDKeyboardListener.current().removeComboMap @comboMap
    @keyView.unsetClass "mousetrap" if @keyView

  setKeyView:(keyView)->
    keyView?.activateKeyView?()
    return if keyView is @keyView
    # unless keyView
    # log keyView, "keyView" if keyView

    @unregisterKeyCombos()
    @oldKeyView = @keyView
    @keyView    = keyView
    @registerKeyCombos keyView

    @constructor.keyViewHistory.push keyView

    keyView?.activateKeyView?()
    @emit 'WindowChangeKeyView', keyView

  setDragView:(dragView)->

    @setDragInAction yes
    @dragView = dragView

  unsetDragView:(e)->

    @setDragInAction no
    @dragView.emit "DragFinished", e
    @dragView = null


  redirectMouseMoveEvent:(event)->

    view = @dragView

    {pageX, pageY}   = event
    {initial}        = view.dragState.position
    initialX         = initial.x
    initialY         = initial.y

    delta =
      x : pageX - initialX
      y : pageY - initialY

    view.drag event, delta

  getKeyView:-> @keyView

  key:(event)->
    # log event.type, @keyView.constructor.name, @keyView.getOptions().name
    # if Object.keys(@currentCombos).length > 0
    #   return yes
    # else
    @emit event.type, event
    @keyView?.handleEvent event

  enableScroll:-> @scrollingEnabled = yes

  disableScroll:-> @scrollingEnabled = no

  registerWindowResizeListener:(instance)->
    @windowResizeListeners[instance.id] = instance
    instance.on "KDObjectWillBeDestroyed", =>
      delete @windowResizeListeners[instance.id]

  unregisterWindowResizeListener:(instance)->
    delete @windowResizeListeners[instance.id]

  setWindowProperties:(event)->
    @winWidth  = window.innerWidth
    @winHeight = window.innerHeight

  notifyWindowResizeListeners:(event, throttle = no, duration = 17)->
    event or= type : "resize"
    fireResizeHandlers = =>
      for own key, instance of @windowResizeListeners when instance._windowDidResize
        instance._windowDidResize event
    if throttle
      KD.utils.killWait @resizeNotifiersTimer
      @resizeNotifiersTimer = KD.utils.wait duration, fireResizeHandlers
    else do fireResizeHandlers

do ->
  KD = require './kd.coffee'
  KD.registerSingleton "windowController", new KDWindowController