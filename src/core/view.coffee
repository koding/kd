KDObject      = require './object.coffee'

###*
 * KDView is the base class for all GUI components.
 *
 *
 * ## Usage
 *
 * ```coffee
 * view = new KDView
 *   partial:    "I'm a view!"
 *   cssClass:  'foo'
 *
 * appView.addSubView view
 * ```
 *
 * When rendered, this will display approximately:
 *
 * ```html
 * <div class="foo">I'm a view!</div>
 * ```
###
module.exports = class KDView extends KDObject

# #
# CLASS LEVEL STUFF
# #

  {defineProperty} = Object

  deprecated = (methodName)-> warn "#{methodName} is deprecated from KDView if you need it override in your subclass"

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


  overrideAndMergeObjects = (objects)->
    for own title,item of objects.overridden
      continue if objects.overrider[title]
      objects.overrider[title] = item
    objects.overrider

  appendToDomBody: ->
    @parentIsInDom = yes
    unless @lazy
      $("body").append @$()
      @utils.defer => @emit "viewAppended"

  @appendToDOMBody = (view) ->
    console.warn "KDView.appendToDOMBody is deprecated; use #appendToDomBody instead"
    view.appendToDomBody()

# #
# INSTANCE LEVEL
# #

  ###*
   * Options supports the following keys.
   * - **options.tagName**: The name of the html tag. Defaults to `"div"`
   * - **options.domId**: The HTML ID of the element. `null`
   * - **options.cssClass**: The class string for the html element.
   * - **options.parent**: The parent KDView for this view.
   * - **options.partial**: The contents of this HTML element, such as `"Hello"`
   *   or `"<h1>Hello!</h1>"`.
   * - **options.pistachio**: A string of pistachio to add to the contents of this
   *   HTML element.
   * - **options.size**: An object with `width` and `height` properties
   *   representing the size of this view, in pixels. Example:
   *   ```
   *   {width: 10, height: 10}
   *   ```
   * - **options.position**: An object with top/right/bottom/left properties
   *   representing the css top/right/bottom/left offset properties. Example:
   *   ```
   *   {top: 5, left: 5}
   *   ```
   * - **options.attributes**: The HTML attributes for this view. These can be
   *   custom, or standard attributes such as `href` or `src`. Example:
   *   ```
   *   {href:"https://koding.com"}
   *   ```
   * - **options.tooltip**: Options that will be passed to the KDTooltip, which is
   *   internally created if options are specified.
   *
   * @param {Object} options
   * @param {Object} data
  ###
  constructor:(options = {},data)->

    o = options
    o.tagName     or= "div"     # a String of a HTML tag
    o.domId       or= null      # a String
    o.cssClass    or= ""        # a String
    o.parent      or= null      # a KDView Instance
    o.partial     or= null      # a String of HTML or text
    o.delegate    or= null      # a KDView Instance
    o.bind        or= ""        # a String of space seperated javascript dom events to be listened on instantiated view
    o.draggable   or= null      # an Object holding draggable options and/or events !!! NOT HTML5 !!!
    o.droppable   or= null      # TBDL
    o.size        or= null      # an Object holding width and height properties
    o.position    or= null      # an Object holding top/right/bottom/left properties (would force view to be positioned absolutely)
    o.attributes  or= null      # an Object holding attribute key/value pairs e.g. {href:'#',title:'my picture'}
    o.prefix      or= ""        # a String
    o.suffix      or= ""        # a String
    o.tooltip     or= null      # an Object of kdtooltip options

    # TO BE IMPLEMENTED
    o.resizable   or= null      # TBDL
    super o, data

    data?.on? 'update', @bound 'render'

    {@domId, @parent} = options
    @subViews         = []

    @defaultInit options,data

  defaultInit:(options, data)->

    @setDomElement options.cssClass
    @setDataId()
    @setDomId options.domId               if options.domId
    @setAttributes options.attributes     if options.attributes
    @setSize options.size                 if options.size
    @setPosition options.position         if options.position
    @updatePartial options.partial        if options.partial
    @setClass 'kddraggable'               if options.draggable

    @addEventHandlers options

    @setLazyLoader options.lazyLoadThreshold  if options.lazyLoadThreshold

    @setTooltip options.tooltip      if options.tooltip
    @setDraggable options.draggable  if options.draggable

    @bindEvents()

    @on 'childAppended', @childAppended.bind this

    @on 'viewAppended', =>
      @setViewReady()
      @viewAppended()
      @childAppended this
      @parentIsInDom = yes

      fireViewAppended = (child)->
        unless child.parentIsInDom
          child.parentIsInDom = yes
          child.emit 'viewAppended'  unless child.lazy

      # temp fix for KDTreeView
      # subviews are stored in an object not in an array
      # hmm not really sth weirder going on...
      subViews = @getSubViews()
      if Array.isArray subViews
        fireViewAppended child for child in subViews
      else if subViews? and 'object' is typeof subViews
        fireViewAppended child for own key, child of subViews


  getDomId:-> @domElement.attr "id"


# #
# DOM ELEMENT CREATION
# #


  setDomElement:(cssClass='')->
    {domId, tagName} = @getOptions()

    if domId
      el = document.getElementById domId

    @lazy = unless el?
      el    = document.createElement tagName
      el.id = domId  if domId
      no
    else yes

    for klass in "kdview #{cssClass}".split ' ' when klass.length
      el.classList.add klass

    @domElement = $ el

    if @lazy
      # warn "lazyElement found with id #{domId}"
      @utils.defer => @emit 'viewAppended'

  setDomId:(id)->
    @domElement.attr "id",id

  setData: (data) ->
    @data?.off? 'update', @bound 'render'
    super data
    @data?.on? 'update', @bound 'render'
    @render()  if @parentIsInDom

  setDataId:->
    @domElement.data "data-id",@getId()

  getAttribute:(attr)->
    @getElement().getAttribute attr

  setAttribute:(attr, val)->
    @getElement().setAttribute attr, val

  setAttributes:(attributes)->
    @setAttribute attr, val for own attr, val of attributes

  isInDom:do ->
    findUltimateAncestor =(el)->
      ancestor = el
      while ancestor.parentNode
        ancestor = ancestor.parentNode
      ancestor
    -> findUltimateAncestor(@$()[0]).body?

# #
# TRAVERSE DOM ELEMENT
# #
  Object.defineProperty @::, "$$", get : @::$
  Object.defineProperty @::, "el", get : @::getElement

  getDomElement:-> @domElement

  getElement:-> @getDomElement()[0]

  getTagName:-> @options.tagName || 'div'

  # shortcut method for @getDomElement()

  $:(selector)->
    if selector
    then @getDomElement().find(selector)
    else @getDomElement()

# #
# MANIPULATE DOM ELEMENT
# #

  # TODO: DRY these out.
  append:(child, selector)->
    @$(selector).append child.$()
    if @parentIsInDom
      child.emit 'viewAppended'
    this

  appendTo:(parent, selector)->
    @$().appendTo parent.$(selector)
    if @parentIsInDom
      @emit 'viewAppended'
    this

  appendToSelector:(selector)->
    $(selector).append @$()
    @emit 'viewAppended'

  prepend:(child, selector)->
    @$(selector).prepend child.$()
    if @parentIsInDom
      child.emit 'viewAppended'
    this

  prependTo:(parent, selector)->
    @$().prependTo parent.$(selector)
    if @parentIsInDom
      @emit 'viewAppended'
    this

  prependToSelector:(selector)->
    $(selector).prepend @$()
    @emit 'viewAppended'

  setPartial:(partial,selector)->
    @$(selector).append partial
    this

  updatePartial: (partial, selector) ->
    @$(selector).html partial

  clear:-> @getElement().innerHTML = ''

  # UPDATE PARTIAL EXPERIMENT TO NOT TO ORPHAN SUBVIEWS

  # updatePartial: (partial, selector) ->
  #   subViews = @getSubViews()
  #   subViewSelectors = for subView in subViews
  #     subView.$().parent().attr "class"
  #
  #   @$(selector).html partial
  #
  #   for subView,i in subViews
  #     @$(subViewSelectors[i]).append subView.$()


# #
# CSS METHODS
# #

  @setElementClass = (el, addOrRemove, cssClass)->
    el.classList[addOrRemove] cl for cl in cssClass.split(' ') when cl isnt ''

  setCss:(property, value)->

    @$().css property, value

  setStyle:(properties)->

    @$().css property, value for own property, value of properties

  setClass:(cssClass)->

    return unless cssClass
    KDView.setElementClass @getElement(), "add", cssClass
    return this

  unsetClass:(cssClass)->

    return unless cssClass
    KDView.setElementClass @getElement(), "remove", cssClass
    return this

  ###*
   * Toggle the css class on the element.
  ###
  toggleClass:(cssClass)->
    @$().toggleClass cssClass
    return this

  hasClass:(cssClass)->
    @getElement().classList.contains cssClass

  ###*
   * Get the bounds of this view.
   * ## Returns
   *
   * An object containing the x, y, width, height, and name of the view.
   *
   * Example:
   *
   * ```coffee
   * {
   *   x: 10
   *   y: 10
   *   w: 50
   *   h: 50
   *   n: "HelloWorldView"
   * }
   * ```
  ###
  getBounds:->
    #return false unless @viewDidAppend
    bounds =
      x : @getX()
      y : @getY()
      w : @getWidth()
      h : @getHeight()
      n : @constructor.name

  setRandomBG:->@getDomElement().css "background-color", KD.utils.getRandomRGB()

  ###*
   * Hide this view by applying the `hidden` css class to it.
  ###
  hide:(duration)->
    @setClass 'hidden'
    # @$().hide duration
    #@getDomElement()[0].style.display = "none"

  ###*
   * If this class is hidden, show this view by removing the `hidden` css
   * class from it.
  ###
  show:(duration)->
    @unsetClass 'hidden'
    # @$().show duration
    #@getDomElement()[0].style.display = "block"

  # setSize: do->
  #   counter = 0
  #   isPredefinedSize = (size)->
  #     # we have predefined classes for 0 to 1000px
  #     return !isNaN(size) and (1000 >= size >= 0)

  #   (sizes)->
  #     if sizes.width?
  #       if isPredefinedSize sizes.width
  #       then @setClass "w#{sizes.width}"
  #       else @setWidth sizes.width

  #     if sizes.height?
  #       if isPredefinedSize sizes.height
  #       then @setClass "h#{sizes.height}"
  #       else @setHeight  sizes.height

  setSize: (sizes)->
    if sizes.width?
      @setWidth sizes.width

    if sizes.height?
      @setHeight sizes.height

  setPosition:->
    positionOptions = @getOptions().position
    positionOptions.position = "absolute"
    @$().css positionOptions

  getWidth:-> @$().outerWidth no

  setWidth:(w, unit = "px")->
    @getElement().style.width = "#{w}#{unit}"
    @emit "ViewResized", {newWidth : w, unit}

  getHeight:->
    @getDomElement().outerHeight no

  setHeight:(h, unit = "px")->
    @getElement().style.height = "#{h}#{unit}"
    @emit "ViewResized", {newHeight : h, unit}

  setX:(x)-> @$().css left : x
  setY:(y)-> @$().css top : y
  getX:-> @$().offset().left
  getY:-> @$().offset().top
  getRelativeX:-> @$().position().left
  getRelativeY:-> @$().position().top

  destroyChild: (prop) ->
    if @[prop]?
      @[prop].destroy?()
      delete @[prop]
      yes
    else no

# #
# ADD/DESTROY VIEW INSTANCES
# #

  attach:(view) ->
    @getElement().appendChild view.getElement()

  detach: ->
    @parent?.getElement().removeChild @getElement()

  destroy: ->

    # good idea but needs some refactoring see KDObject::destroy
    # return if @isDestroyed

    # instance destroys own subviews
    @destroySubViews()  if @getSubViews().length > 0

    # instance drops itself from its parent's subviews array

    if @parent?.subViews and (index = @parent.subViews.indexOf @) >= 0
      @parent.subViews.splice index, 1
      @unsetParent()

    # instance removes itself from DOM
    @getDomElement().remove()

    @removeOverlay()  if @$overlay?

    # call super to remove instance subscriptions
    # and delete instance from KD.instances registry
    super

  destroySubViews: ->
    view.destroy?() for view in @getSubViews().slice()
    return

  ###*
   * Add another KDView to this KDView instance.
   *
   * @param {KDView} subView The view to add to this instance.
   * @param {Object} selector
   * @param {Boolean} shouldPrepend Should the view being added be prepended, or appended, to this view's list of children.
  ###
  addSubView:(subView,selector,shouldPrepend)->
    throw new Error 'no subview was specified' unless subView?

    # this is a performance killer
    # and we dont know whom it belongs to
    # let's see if it was really needed -> SY

    # if subView.parent and subView.parent instanceof KDView
    #   index = subView.parent.subViews.indexOf subView
    #   if index > -1
    #     subView.parent.subViews.splice index, 1

    @subViews.push subView
    subView.setParent this
    subView.parentIsInDom = @parentIsInDom

    unless subView.lazy
      if shouldPrepend
      then @prepend subView, selector
      else @append subView, selector
    # else log "lazy view", subView

    subView.on "ViewResized", -> subView.parentDidResize()

    @template.addSymbol subView  if @template?

    return subView

  # here for backwards compatibility - SY
  removeSubView:(subView)-> subView.destroy()

  getSubViews:->
    ###
    FIX: NEEDS REFACTORING
    used in @destroy
    not always sub views stored in @subviews but in @items, @itemsOrdered etc
    see KDListView KDTreeView etc. and fix it.
    ###
    subViews = @subViews
    if @items?
      subViews = subViews.concat [].slice.call @items
    subViews

  setParent:(parent)->
    if @parent? then error 'View already has a parent', this, @parent
    else
      if defineProperty
        defineProperty @, 'parent', value : parent, configurable : yes
      else
        @parent = parent

  unsetParent:-> delete @parent

  embedChild:(placeholderId, child, isCustom)->

    @addSubView child, '#'+placeholderId, no
    unless isCustom
      @$('#'+placeholderId).replaceWith child.$()

  render: (fields) ->
    @template.update fields  if @template?
    # removes e.g. on actions on status updates such as like and comment
    # as in the backend they trigger 'update'
    # else if 'function' is typeof @partial and data = @getData()
    #   @updatePartial @partial data


# #
# EVENT BINDING/HANDLING
# #

  addEventHandlers:(options)->
    for own eventName, cb of options
      if eventNames.test(eventName) and "function" is typeof cb
        @on eventName, cb


  parentDidResize:(parent,event)->
    if @getSubViews()
      (subView.parentDidResize(parent,event) for subView in @getSubViews())

  # if threshold is greater than 1 it is treated as pixel value
  setLazyLoader:(threshold=.75)->
    @getOptions().bind += ' scroll' unless /\bscroll\b/.test @getOptions().bind
    view = this
    @on 'scroll', do ->
      lastRatio = 0
      (event)->
        el = view.$()[0]
        {scrollHeight, scrollTop} = el

        dynamicThreshold = if threshold > 1
        then (scrollHeight - threshold) / scrollHeight
        else threshold

        ratio = (scrollTop + view.getHeight()) / scrollHeight

        if dynamicThreshold < ratio > lastRatio
          @emit 'LazyLoadThresholdReached', {ratio}

        lastRatio = ratio

  bindEvents:($elm)->
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
  bindTransitionEnd:->

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

  bindEvent:($elm, eventName)->
    [eventName, $elm] = [$elm, @$()] unless eventName

    $elm.bind eventName, (event)=>
      shouldPropagate = @handleEvent event
      event.stopPropagation() unless shouldPropagate
      yes

  handleEvent:(event)->
    methodName      = eventToMethodMap()[event.type] or event.type
    shouldPropagate = if @[methodName]? then @[methodName] event else yes

    @emit event.type, event  unless shouldPropagate is no

    return shouldPropagate

  scroll:(event)->     yes

  load:(event)->       yes

  error:(event)->      yes

  keyUp:(event)->      yes

  keyDown:(event)->    yes

  keyPress:(event)->   yes

  dblClick:(event)->   yes

  click:(event)->      yes

  contextMenu:(event)->yes

  mouseMove:(event)->  yes

  mouseEnter:(event)-> yes

  mouseLeave:(event)-> yes

  mouseUp:(event)->    yes

  mouseOver:(event)->  yes

  mouseWheel:(event)-> yes

  mouseDown:(event)->
    @unsetKeyView()
    yes

  paste:(event)->      yes

  # HTML5 DND
  dragEnter:(e)->

    e.preventDefault()
    e.stopPropagation()

  dragOver:(e)->

    e.preventDefault()
    e.stopPropagation()

  dragLeave:(e)->

    e.preventDefault()
    e.stopPropagation()

  drop:(event)->

    event.preventDefault()
    event.stopPropagation()
    # no

  submit:(event)-> no #propagations leads to window refresh

  setEmptyDragState:(moveBacktoInitialPosition = no)->

    if moveBacktoInitialPosition and @dragState
      el = @$()
      el.css 'left', 0
      el.css 'top' , 0

    @dragState =
      containment : null     # a parent KDView
      handle      : null     # a parent KDView or a child selector
      axis        : null     # a String 'x' or 'y' or 'diagonal'
      direction   :
        current   :
          x       : null     # a String 'left' or 'right'
          y       : null     # a String 'up'   or 'down'
        global    :
          x       : null     # a String 'left' or 'right'
          y       : null     # a String 'up'   or 'down'
      position    :
        relative  :
          x       : 0        # a Number
          y       : 0        # a Number
        initial   :
          x       : 0        # a Number
          y       : 0        # a Number
        global    :
          x       : 0        # a Number
          y       : 0        # a Number
      meta        :
        top       : 0        # a Number
        right     : 0        # a Number
        bottom    : 0        # a Number
        left      : 0        # a Number


  setDraggable:(options = {})->

    options = {} if options is yes

    @setEmptyDragState()
    handle = if options.handle instanceof KDView then options.handle else this

    @on "DragFinished", (e) => @beingDragged = no

    handle.on "mousedown", (event)=>
      if "string" is typeof options.handle
        return if $(event.target).closest(options.handle).length is 0

      @dragIsAllowed = yes
      @setEmptyDragState()

      dragState = @dragState

      if options.containment

        dragState.containment = {}
        dragState.containment.m = w: @getWidth(), h: @getHeight()

        {view} = options.containment

        bounds = if 'string' is typeof view
        then @[view].getBounds()
        else if view instanceof KDView
        then view.getBounds()
        else @parent.getBounds()

        dragState.containment.viewBounds = bounds

        padding = top : 0, right : 0, bottom : 0, left : 0

        oPad = options.containment.padding
        if 'number' is typeof oPad
        then v = oPad for own p, v of padding
        else if 'object' is typeof oPad
        then KD.utils.extend padding, oPad

        dragState.containment.padding = padding


      # TODO: should move these lines
      dragState.handle      = options.handle
      dragState.axis        = options.axis

      dragMeta              = dragState.meta
      dragEl                = @getElement()
      dragMeta.top          = parseInt(dragEl.style.top,    10) or 0
      dragMeta.right        = parseInt(dragEl.style.right,  10) or 0
      dragMeta.bottom       = parseInt(dragEl.style.bottom, 10) or 0
      dragMeta.left         = parseInt(dragEl.style.left,   10) or 0

      dragPos = @dragState.position
      dragPos.initial.x     = event.pageX
      dragPos.initial.y     = event.pageY

      KD.getSingleton('windowController').setDragView this
      @emit "DragStarted", event, @dragState
      event.stopPropagation()
      event.preventDefault()
      return no

  drag:(event, delta)->

    {directionX, directionY, axis, containment} = @dragState

    {x, y}       = delta
    dragPos      = @dragState.position
    dragRelPos   = dragPos.relative
    dragInitPos  = dragPos.initial
    dragGlobPos  = dragPos.global
    dragDir      = @dragState.direction
    dragGlobDir  = dragDir.global
    dragCurDir   = dragDir.current
    {axis}       = @getOptions().draggable

    draggedDistance = if axis
      if axis is "x" then Math.abs x else Math.abs y
    else Math.max Math.abs(x), Math.abs(y)

    @dragIsAllowed = @beingDragged = !(draggedDistance < 20 and not @beingDragged)

    if x > dragRelPos.x
      dragCurDir.x  = 'right'
    else if x < dragRelPos.x
      dragCurDir.x  = 'left'

    if y > dragRelPos.y
      dragCurDir.y  = 'bottom'
    else if y < dragRelPos.y
      dragCurDir.y  = 'top'

    dragGlobPos.x = dragInitPos.x + x
    dragGlobPos.y = dragInitPos.y + y

    dragGlobDir.x = if x > 0 then 'right'  else 'left'
    dragGlobDir.y = if y > 0 then 'bottom' else 'top'

    if @dragIsAllowed
      el = @$()
      dragMeta   = @dragState.meta
      targetPosX = if dragMeta.right  and not dragMeta.left then 'right'  else 'left'
      targetPosY = if dragMeta.bottom and not dragMeta.top  then 'bottom' else 'top'

      newX = if targetPosX is 'left' then dragMeta.left + dragRelPos.x else dragMeta.right  - dragRelPos.x
      newY = if targetPosY is 'top'  then dragMeta.top  + dragRelPos.y else dragMeta.bottom - dragRelPos.y

      if containment
        m  = containment.m                    # My sizes
        p  = containment.viewBounds           # Containment's sizes
        cp = containment.padding              # Containment paddings
        if newX <= cp.left then newX = cp.left
        if newY <= cp.top  then newY = cp.top
        if newX + m.w >= p.w - cp.right  then newX = p.w - m.w - cp.right
        if newY + m.h >= p.h - cp.bottom then newY = p.h - m.h - cp.bottom

      el.css targetPosX, newX unless axis is 'y'
      el.css targetPosY, newY unless axis is 'x'

    dragRelPos.x = x
    dragRelPos.y = y

    @emit "DragInAction", x, y

# #
# VIEW READY EVENTS
# #

  viewAppended:->

  childAppended:(child)->
    # bubbling childAppended event
    @parent?.emit 'childAppended', child

  setViewReady:->
    @viewIsReady = yes

  isViewReady:->
    @viewIsReady or no

# #
# HELPER METHODS
# #

  observeMutations: ->

    MutationSummary = require './../../libs/mutation-summary.js'

    MutationObserver = window.MutationObserver or window.WebKitMutationObserver or window.MozMutationObserver

    observerSummary = new MutationSummary
      callback : (rest)=> @emit 'MutationHappened', rest...
      rootNode : @getElement()
      queries  : [
        { all  : true }
      ]



  putOverlay: (options = {}) ->
    options.delegate = this

    KDOverlayView = require './../components/overlay/overlayview.coffee'
    @overlay = new KDOverlayView options

  removeOverlay:->
    @overlay?.destroy()

  unsetTooltip:(o = {})->
    @tooltip?.destroy()
    delete @tooltip

  setTooltip:(o = {})->

    placementMap =
      above      : "s"
      below      : "n"
      left       : "e"
      right      : "w"

    o.title     or= ""
    o.cssClass  or= ""
    o.placement or= "top"
    o.direction or= "center"
    o.offset    or=
      top         : 0
      left        : 0
    o.delayIn   or= 0
    o.delayOut  or= 0
    o.html       ?= yes
    o.animate    ?= no
    o.selector  or= null
    o.gravity   or= placementMap[o.placement]
    o.fade      or= o.animate
    o.fallback  or= o.title
    o.view      or= null
    o.sticky     ?= no
    o.delegate  or= this
    o.events    or= ['mouseenter','mouseleave','mousemove']

    @unsetTooltip()
    KDTooltip = require './../components/tooltip/tooltip.coffee'
    @tooltip  = new KDTooltip o, {}

  getTooltip:-> @tooltip

  _windowDidResize:->

  listenWindowResize: (state = yes) ->

    if state
    then KD.singletons.windowController.registerWindowResizeListener this
    else KD.singletons.windowController.unregisterWindowResizeListener this


  setKeyView: -> KD.singletons.windowController.setKeyView this

  unsetKeyView: -> KD.singletons.windowController.setKeyView null

  activateKeyView: -> @emit? 'KDViewBecameKeyView'
