
module.exports = KDDomEvents = ->

  eventNames =
    ///
    ^(
    (dbl)?click|
    key(up|down|press)|
    mouse(up|down|over|enter|leave|move)|
    drag(start|end|enter|leave|over)|
    blur|change|focus|
    drop|
    contextmenu|
    scroll|
    paste|
    error|
    load
    )$
    ///

  eventToMethodMap = ->
    dblclick      : "dblClick"
    keyup         : "keyUp"
    keydown       : "keyDown"
    keypress      : "keyPress"
    mouseup       : "mouseUp"
    mousedown     : "mouseDown"
    mouseenter    : "mouseEnter"
    mouseleave    : "mouseLeave"
    mousemove     : "mouseMove"
    mousewheel    : "mouseWheel"
    wheel         : "mouseWheel"
    mouseover     : "mouseOver"
    contextmenu   : "contextMenu"
    dragstart     : "dragStart"
    dragenter     : "dragEnter"
    dragleave     : "dragLeave"
    dragover      : "dragOver"
    paste         : "paste"
    transitionend : "transitionEnd"


  @addEventHandlers = (options)->
    for own eventName, cb of options
      if eventNames.test(eventName) and "function" is typeof cb
        @on eventName, cb


  @bindEvents = ($elm)->
    $elm or= @getDomElement()
    defaultEvents = "mousedown mouseup click dblclick"
    instanceEvents = @getOptions().bind

    eventsToBeBound = if instanceEvents
      eventsToBeBound = defaultEvents.trim().split(" ")
      instanceEvents  = instanceEvents.trim().split(" ")
      for event in instanceEvents
        eventsToBeBound.push event unless event in eventsToBeBound
      eventsToBeBound.join(" ")
    else
      defaultEvents

    $elm.bind eventsToBeBound, (event)=>
      willPropagateToDOM = @handleEvent event
      event.stopPropagation() unless willPropagateToDOM
      yes

    eventsToBeBound


  # until we find a better way of handling
  # vendor specific events - SY
  @bindTransitionEnd = ->

    el          = document.createElement 'fakeelement'
    transitions =
      'OTransition'     : 'oTransitionEnd'
      'MozTransition'   : 'transitionend'
      'webkitTransition': 'webkitTransitionEnd'

    transitionEvent = 'transitionend'
    for own key, val of transitions when key of el.style
      transitionEvent = val
      break

    @bindEvent transitionEvent

    # redirect event if it has vendor specific
    unless transitionEvent is "transitionend"
      @on transitionEvent, @emit.bind @, "transitionend"


  @bindEvent = ($elm, eventName) ->
    [eventName, $elm] = [$elm, @$()] unless eventName

    $elm.bind eventName, (event)=>
      shouldPropagate = @handleEvent event
      event.stopPropagation() unless shouldPropagate
      yes


  @handleEvent = (event) ->
    methodName      = eventToMethodMap()[event.type] or event.type
    shouldPropagate = if @[methodName]? then @[methodName] event else yes

    @emit event.type, event  unless shouldPropagate is no

    return shouldPropagate


  @submit      = (event) -> no #propagations leads to window refresh
  @scroll      = (event) -> yes
  @load        = (event) -> yes
  @error       = (event) -> yes
  @keyUp       = (event) -> yes
  @keyDown     = (event) -> yes
  @keyPress    = (event) -> yes
  @dblClick    = (event) -> yes
  @click       = (event) -> yes
  @contextMenu = (event) -> yes
  @mouseMove   = (event) -> yes
  @mouseEnter  = (event) -> yes
  @mouseLeave  = (event) -> yes
  @mouseUp     = (event) -> yes
  @mouseOver   = (event) -> yes
  @mouseWheel  = (event) -> yes
  @mouseDown   = (event) -> yes
  @paste       = (event) -> yes
  @dragEnter   = (event) -> KD.utils.stopDOMEvent event
  @dragOver    = (event) -> KD.utils.stopDOMEvent event
  @dragLeave   = (event) -> KD.utils.stopDOMEvent event
  @drop        = (event) -> KD.utils.stopDOMEvent event

  # if threshold is greater than 1 it is treated as pixel value
  setLazyLoader: (threshold = .75) ->

    {bind} = @getOptions()

    unless /scroll/.test bind
      @getOptions().bind = KD.utils.curry 'scroll', bind

    view = this
    @on 'scroll', do ->
      lastRatio = 0
      (event) ->
        el = @getElement()
        {scrollHeight, scrollTop} = el

        dynamicThreshold = if threshold > 1
        then (scrollHeight - threshold) / scrollHeight
        else threshold

        ratio = (scrollTop + view.getHeight()) / scrollHeight

        if dynamicThreshold < ratio > lastRatio
          @emit 'LazyLoadThresholdReached', {ratio}

        lastRatio = ratio


