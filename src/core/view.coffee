KDObject      = require './object.coffee'

module.exports = class KDView extends KDObject

DOMOperations = require './mixins/domoperations'
DOMEvents     = require './mixins/domevents'
Draggable     = require './mixins/draggable'
Overlayable   = require './mixins/overlayable'
Tooltipable   = require './mixins/tooltipable'


  constructor:(options = {},data)->
  @include DOMOperations
  @include DOMEvents
  @include Draggable
  @include Overlayable
  @include Tooltipable

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
  removeSubView: (subView) -> subView.destroy()

  getSubViews: ->
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

  setParent: (parent) ->
    { defineProperty } = Object
    if @parent? then error 'View already has a parent', this, @parent
    else
      if defineProperty
        defineProperty this, 'parent', value : parent, configurable : yes
      else
        @parent = parent

  unsetParent: -> @parent = null

  embedChild: (placeholderId, child, isCustom) ->

    @addSubView child, '#' + placeholderId, no
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


  viewAppended: ->

  childAppended: (child) -> @parent?.emit 'childAppended', child

  setViewReady: -> @viewIsReady = yes

  isViewReady: -> @viewIsReady or no

  observeMutations: ->

    return  unless MutationSummary

    MutationObserver = window.MutationObserver or window.WebKitMutationObserver or window.MozMutationObserver

    observerSummary = new MutationSummary
      callback : (rest...) => @emit 'MutationHappened', rest...
      rootNode : @getElement()
      queries  : [
        { all  : true }
      ]


  @appendToDOMBody = (view) ->
    console.warn "KDView.appendToDOMBody is deprecated; use #appendToDomBody instead"
    view.appendToDomBody()


  @setElementClass = (el, addOrRemove, cssClass) ->
    el.classList[addOrRemove] cl for cl in cssClass.split(' ') when cl isnt ''


  _windowDidResize:->

  listenWindowResize: (state = yes) ->

    if state
    then KD.singletons.windowController.registerWindowResizeListener this
    else KD.singletons.windowController.unregisterWindowResizeListener this


  setKeyView: -> KD.singletons.windowController.setKeyView this

  unsetKeyView: -> KD.singletons.windowController.setKeyView null

  activateKeyView: -> @emit? 'KDViewBecameKeyView'


