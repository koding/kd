KDScrollView         = require './../scrollview/scrollview.coffee'
KDTabHandleContainer = require './tabhandlecontainer.coffee'
KDTabHandleMoveNav   = require './tabhandlemovenav.coffee'

module.exports = class KDTabView extends KDScrollView

  constructor:(options = {}, data)->

    options.resizeTabHandles     ?= no
    options.maxHandleWidth       ?= 128
    options.minHandleWidth       ?= 30
    options.lastTabHandleMargin  ?= 0
    options.sortable             ?= no
    options.hideHandleContainer  ?= no
    options.hideHandleCloseIcons ?= no
    options.enableMoveTabHandle  ?= no
    options.detachPanes          ?= yes
    options.tabHandleContainer   ?= null
    options.tabHandleClass      or= KDTabHandleView
    options.paneData            or= []
    options.cssClass              = KD.utils.curry "kdtabview", options.cssClass

    # Is there a reason why are we setting those before super? ~ GG

    @handles                      = []
    @panes                        = []
    @selectedIndex                = []
    @tabConstructor               = options.tabClass ? KDTabPaneView
    @lastOpenPaneIndex            = 0

    # ---

    super options, data

    @activePane           = null
    @handlesHidden        = no
    @blockTabHandleResize = no

    @setTabHandleContainer options.tabHandleContainer
    @setTabHandleMoveNav()  if options.enableMoveTabHandle

    @hideHandleCloseIcons() if options.hideHandleCloseIcons
    @hideHandleContainer()  if options.hideHandleContainer

    @on "PaneRemoved", => @resizeTabHandles()
    @on "PaneAdded", =>
      @blockTabHandleResize = no
      @resizeTabHandles()
    @on "PaneDidShow", @bound "setActivePane"

    if options.paneData.length > 0
      @on "viewAppended", => @createPanes options.paneData

    @tabHandleContainer.on "mouseleave", =>
      if @blockTabHandleResize
        @blockTabHandleResize = no
        @resizeTabHandles()

  # ADD/REMOVE PANES
  createPanes:(paneData = @getOptions().paneData)->
    for paneOptions in paneData
      @addPane new @tabConstructor paneOptions, null

  addPane:(paneInstance, shouldShow = paneInstance.getOptions().shouldShow ? yes) ->

    unless paneInstance instanceof KDTabPaneView
      {name} = paneInstance?.constructor?
      warn "You can't add #{name if name} as a pane, use KDTabPaneView instead"
      return no


    { tabHandleClass, sortable, detachPanes } = @getOptions()

    paneInstance.setOption 'detachable', detachPanes
    @panes.push paneInstance

    { name, title, hiddenHandle, tabHandleView, closable, lazy } = paneInstance.getOptions()

    newTabHandle = paneInstance.tabHandle or new tabHandleClass
      pane       : paneInstance
      title      : name or title
      hidden     : hiddenHandle
      cssClass   : KD.utils.slugify name.toLowerCase()
      view       : tabHandleView
      closable   : closable
      sortable   : sortable
      mousedown  : (event) ->
        {pane} = @getOptions()
        tabView = pane.getDelegate()
        tabView.handleClicked event, this

    @addHandle newTabHandle

    paneInstance.tabHandle = newTabHandle
    @appendPane paneInstance

    @showPane paneInstance  if shouldShow and not lazy

    @emit 'PaneAdded', paneInstance

    {minHandleWidth, maxHandleWidth} = @getOptions()

    newTabHandle.getDomElement().css
      maxWidth : maxHandleWidth
      minWidth : minHandleWidth

    newTabHandle.on 'HandleIndexHasChanged', @bound 'resortTabHandles'

    return paneInstance


  resortTabHandles: (index, dir) ->
    return if (index is 0 and dir is 'left')                    or \
              (index is @handles.length - 1 and dir is 'right') or \
              (index >= @handles.length) or (index < 0)

    @handles[0].unsetClass 'first'

    if dir is 'right'
      methodName  = 'insertAfter'
      targetIndex = index + 1
    else
      methodName  = 'insertBefore'
      targetIndex = index - 1
    @handles[index].$()[methodName] @handles[targetIndex].$()

    newIndex       = if dir is 'left' then index - 1 else index + 1
    splicedHandle  = @handles.splice index, 1
    splicedPane    = @panes.splice index, 1

    @handles.splice newIndex, 0, splicedHandle[0]
    @panes.splice   newIndex, 0, splicedPane[0]

    @handles[0].setClass 'first'

    @emit 'TabsSorted'

  removePane:(pane, shouldDetach = no)->
    pane.emit "KDTabPaneDestroy"
    index = @getPaneIndex pane
    isActivePane = @getActivePane() is pane
    @panes.splice index, 1
    handle = @getHandleByIndex index
    @handles.splice index, 1

    if shouldDetach
      @panes   = @panes.filter   (p)-> p isnt pane
      @handles = @handles.filter (h)-> h isnt handle
      pane.detach()
      handle.detach()
    else
      pane.destroy()
      handle.destroy()

    if isActivePane
      if prevPane = @getPaneByIndex @lastOpenPaneIndex
        @showPane prevPane
      else if firstPane = @getPaneByIndex 0
        @showPane firstPane

    @emit "PaneRemoved", { pane, handle }
    return { pane, handle }

  removePaneByName:(name)->
    for pane in @panes
      if pane.name is name
        @removePane pane
        break

  appendHandleContainer:->
    @addSubView @tabHandleContainer

  appendPane:(pane)->
    pane.setDelegate this
    @addSubView pane

  appendHandle:(tabHandle)->
    @handleHeight or= @tabHandleContainer.getHeight()
    tabHandle.setDelegate this
    @tabHandleContainer.tabs.addSubView tabHandle

    {enableMoveTabHandle, maxHandleWidth} = @getOptions()
    if enableMoveTabHandle
      @_tabsWidth = @handles.length * maxHandleWidth

    # unless tabHandle.options.hidden
    #   tabHandle.$().css {marginTop : @handleHeight}
    #   tabHandle.$().animate({marginTop : 0},300)


  # ADD/REMOVE HANDLES

  addHandle: (handle) ->

    unless handle instanceof KDTabHandleView
      {name} = handle?.constructor?
      warn "You can't add #{name if name?} as a pane, use KDTabHandleView instead"
      return no

    @handles.push handle
    @appendHandle handle
    handle.setClass 'hidden'  if handle.getOptions().hidden
    return handle


  removeHandle:->


  #SHOW/HIDE ELEMENTS
  showPane:(pane)->

    return unless pane
    activePane = @getActivePane()
    return if pane is activePane

    @lastOpenPaneIndex = @getPaneIndex activePane  if activePane
    @hideAllPanes()
    pane.show()
    index  = @getPaneIndex pane
    handle = @getHandleByIndex index
    handle.makeActive()
    pane.emit "PaneDidShow"
    @emit "PaneDidShow", pane, index
    return pane


  hideAllPanes:->
    pane.hide()           for pane   in @panes   when pane
    handle.makeInactive() for handle in @handles when handle

  hideHandleContainer:->
    @tabHandleContainer.hide()
    @handlesHidden = yes

  showHandleContainer:->
    @tabHandleContainer.show()
    @handlesHidden = no

  toggleHandleContainer:(duration = 0)->
    @tabHandleContainer.$().toggle duration

  hideHandleCloseIcons:->
    @tabHandleContainer.$().addClass "hide-close-icons"

  showHandleCloseIcons:->
    @tabHandleContainer.$().removeClass "hide-close-icons"

  handleMouseDownDefaultAction:(clickedTabHandle, event)->
    for handle, index in @handles when clickedTabHandle is handle
      @handleClicked index, event

  # DEFAULT ACTIONS
  handleClicked: (event, handle) ->

    {pane} = handle.getOptions()

    # fixme: make close icon a kdview and check the view instead.
    if $(event.target).hasClass 'close-tab'
      @blockTabHandleResize = yes
      @removePane pane
      return no

    @showPane pane

  # DEFINE CUSTOM or DEFAULT tabHandleContainer
  setTabHandleContainer:(aViewInstance)->

    if aViewInstance?
      @tabHandleContainer.destroy() if @tabHandleContainer?
      @tabHandleContainer = aViewInstance
    else
      @tabHandleContainer = new KDTabHandleContainer
      @appendHandleContainer()

    @tabHandleContainer.setClass "kdtabhandlecontainer"

  getTabHandleContainer:-> @tabHandleContainer

  setTabHandleMoveNav:->
    @tabHandleContainer.addSubView new KDTabHandleMoveNav delegate : this

  #TRAVERSING PANES/HANDLES
  checkPaneExistenceById:(id)->
    result = false
    for pane in @panes
      result = true if pane.id is id
    result

  getPaneByName:(name)->
    #FIXME: if there is a space in tabname it doesnt work
    result = false
    for pane in @panes
      result = pane if pane.name is name
    result

  getPaneById:(id)->
    paneInstance = null
    for pane in @panes
      paneInstance = pane if pane.id is id
    paneInstance

  getActivePane: -> @activePane
  getActivePaneIndex: -> @getPaneIndex @getActivePane()

  setActivePane:(@activePane)->

  getPaneByIndex:(index)-> @panes[index]
  getHandleByIndex:(index)-> @handles[index]

  getPaneIndex:(aPane)->
    throw new Error "no pane provided!"  unless aPane

    @panes.indexOf aPane

  #NAVIGATING
  showPaneByIndex:(index)->
    @showPane @getPaneByIndex index

  showPaneByName:(name)->
    @showPane @getPaneByName name

  showNextPane:->
    activePane  = @getActivePane()
    activeIndex = @getPaneIndex activePane
    @showPane @getPaneByIndex activeIndex + 1

  showPreviousPane:->
    activePane  = @getActivePane()
    activeIndex = @getPaneIndex activePane
    @showPane @getPaneByIndex activeIndex - 1

  #MODIFY PANES/HANDLES
  setPaneTitle:(pane,title)->
    handle = @getHandleByPane pane
    handle.getDomElement().find("b").text title
    handle.setAttribute "title", title

  getHandleByPane: (pane) ->
    index  = @getPaneIndex pane
    handle = @getHandleByIndex index

  hideCloseIcon:(pane)->
    index  = @getPaneIndex pane
    handle = @getHandleByIndex index
    handle.getDomElement().addClass "hide-close-icon"

  getVisibleHandles: ->
    return @handles.filter (handle) -> handle.isHidden() is no

  getVisibleTabs: ->
    return @panes.filter (pane) -> pane.tabHandle.isHidden() is no


  resizeTabHandles: ->
    return if not @getOptions().resizeTabHandles or \
                  @_tabHandleContainerHidden     or @blockTabHandleResize

    { lastTabHandleMargin } = @getOptions()

    visibleHandles   = []
    visibleTotalSize = 0
    outerWidth       = @tabHandleContainer.tabs.getElement().offsetWidth

    return if outerWidth <= 0

    containerSize    = outerWidth - lastTabHandleMargin
    containerMargin  = 100 - (100 * lastTabHandleMargin / containerSize)

    for handle in @handles when not handle.isHidden()
      visibleHandles.push handle
      visibleTotalSize += handle.getElement().offsetWidth

    possiblePercent = (containerMargin / visibleHandles.length).toFixed 2

    handle.setWidth(possiblePercent, "%") for handle in visibleHandles
