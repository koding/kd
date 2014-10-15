KDObject      = require './object.coffee'

module.exports = class KDView extends KDObject


  @appendToDOMBody = (view) ->
    console.warn "KDView.appendToDOMBody is deprecated; use #appendToDomBody instead"
    view.appendToDomBody()
DOMOperations = require './mixins/domoperations'
DOMEvents     = require './mixins/domevents'

# #
# INSTANCE LEVEL
# #

  constructor:(options = {},data)->
  @include DOMOperations
  @include DOMEvents

    options.tagName           or= "div"     # a String of a HTML tag
    options.domId             or= null      # a String
    options.cssClass          or= ""        # a String
    options.parent            or= null      # a KDView Instance
    options.partial           or= null      # a String of HTML or text
    options.delegate          or= null      # a KDView Instance
    options.bind              or= ""        # a String of space separated javascript dom events to be listened
    options.draggable         or= null      # an Object holding draggable options and/or events !!! NOT HTML5 !!!
    options.size              or= null      # an Object holding width and height properties
    options.position          or= null      # an Object holding top/right/bottom/left properties (would force view to be positioned absolutely)
    options.attributes        or= null      # an Object holding attribute key/value pairs e.g. {href:'#',title:'my picture'}
    options.prefix            or= ""        # a String
    options.suffix            or= ""        # a String
    options.tooltip           or= null      # an Object of kdtooltip options
    options.lazyLoadThreshold  ?= no
    # TO BE IMPLEMENTED
    options.droppable         or= null      # TBDL
    options.resizable         or= null      # TBDL

    super options, data

    data?.on? 'update', @bound 'render'

    @defaultInit()

  defaultInit:->

    options           = @getOptions()
    {@domId, @parent} = options
    @subViews         = []

    { cssClass, attributes, size, position
      partial, draggable, pistachio, pistachioParams
      lazyLoadThreshold, tooltip, draggable, tagName
    } = options

    @setDomElement cssClass
    @setDataId()
    @setDomId @domId          if @domId
    @setAttributes attributes if attributes
    @setPosition position     if position
    @updatePartial partial    if partial
    @setClass 'kddraggable'   if draggable

    @addEventHandlers options

    @setLazyLoader lazyLoadThreshold  if lazyLoadThreshold
    @setTooltip tooltip               if tooltip
    @setDraggable draggable           if draggable

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


  setData: (data) ->
    @data?.off? 'update', @bound 'render'
    super data
    @data?.on? 'update', @bound 'render'
    @render()  if @parentIsInDom


  orphanize: ->

    if @parent?.subViews and (index = @parent.subViews.indexOf @) >= 0
      @parent.subViews.splice index, 1
      @unsetParent()


  destroy: ->

    # good idea but needs some refactoring see KDObject::destroy
    # return if @isDestroyed

    # instance destroys own subviews
    @destroySubViews()  if @getSubViews().length > 0

    # instance drops itself from its parent's subviews array
    @orphanize()

    # instance removes itself from DOM
    @getDomElement().remove()

    @removeOverlay()  if @$overlay?

    # call super to remove instance subscriptions
    # and delete instance from KD.instances registry
    super

  destroySubViews: ->
    view.destroy?() for view in @getSubViews().slice()
    return

  addSubView: (subView, selector, shouldPrepend) ->

    throw new Error 'no subview was specified' unless subView?

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


  parentDidResize: (parent, event) ->
    if @getSubViews()
      (subView.parentDidResize(parent,event) for subView in @getSubViews())



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

    return  unless MutationSummary

    MutationObserver = window.MutationObserver or window.WebKitMutationObserver or window.MozMutationObserver

    observerSummary = new MutationSummary
      callback : (rest...) => @emit 'MutationHappened', rest...
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


  unsetTooltip: ->

    @tooltip?.destroy()
    @tooltip = null


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
    o.permanent  ?= no
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