KD = require '../../core/kd'
KDView                         = require '../../core/view'
KDCustomHTMLView               = require '../../core/customhtmlview'
JContextMenuTreeViewController = require './contextmenutreeviewcontroller'

module.exports = class KDContextMenu extends KDView

  constructor:(options = {}, data)->

    options.cssClass        = @utils.curry "kdcontextmenu", options.cssClass
    options.menuMaxWidth  or= "auto"
    options.menuMinWidth  or= "auto"
    options.menuWidth     or= 172
    options.offset        or= {}
    options.offset.left   or= 0
    options.offset.top    or= 0
    options.arrow          ?= no
    options.sticky         ?= no

    super options, data

    @topMargin  = 0
    @leftMargin = 0

    o = @getOptions()
    @sticky = o.sticky

    KD.getSingleton("windowController").addLayer @

    @on 'ReceivedClickElsewhere', => @destroy() unless @sticky

    if data
      @treeController = new JContextMenuTreeViewController
        type              : o.type
        view              : o.view
        delegate          : @
        treeItemClass     : o.treeItemClass
        listViewClass     : o.listViewClass
        itemChildClass    : o.itemChildClass
        itemChildOptions  : o.itemChildOptions
        addListsCollapsed : o.addListsCollapsed
        putDepthInfo      : o.putDepthInfo
        lazyLoad          : o.lazyLoad ? no
      , data
      @addSubView @treeController.getView()
      @treeController.getView().on 'ReceivedClickElsewhere', => @destroy() unless @sticky

      @treeController.on "NodeExpanded", @bound "positionSubMenu"

    if options.arrow
      @on "viewAppended", @bound "addArrow"

    @appendToDomBody()

  changeStickyState: (state)-> @sticky = state

  childAppended:->

    super
    @positionContextMenu()

    if @getOption "deferPositioning"
      KD.utils.defer => @positionContextMenu()
    else
      @positionContextMenu()

  addArrow:->

    o = @getOptions().arrow
    o.placement or= "top"
    o.margin     ?= 0

    if o.placement in ['top', 'bottom']
      o.margin += @leftMargin
    else
      o.margin += @topMargin

    @arrow = new KDCustomHTMLView
      tagName  : "span"
      cssClass : "arrow #{o.placement}"

    @arrow.$().css switch o.placement
      when "top"
        rule = {}
        if o.margin > 0 then rule.left = o.margin else rule.right = -(o.margin)
        rule
      when "bottom"
        rule = {}
        if o.margin > 0 then rule.left = o.margin else rule.right = -(o.margin)
        rule
      when "right"
        rule = {}
        if o.margin > 0 then rule.top = o.margin else rule.bottom = -(o.margin)
        rule
      when "left"
        rule = {}
        if o.margin > 0 then rule.top = o.margin else rule.bottom = -(o.margin)
        rule
      else {}

    @addSubView @arrow

  positionContextMenu: KD.utils.debounce 10, ->

    options     = @getOptions()
    event       = options.event or {}
    mainView    = KD.getSingleton 'mainView'

    mainHeight  = mainView.getHeight()
    mainWidth   = mainView.getWidth()

    { menuWidth, menuHeight, menuMaxWidth, menuMinWidth } = options

    menuHeight ?= @getHeight()
    menuWidth  ?= @getWidth()

    top         = (options.y or event.pageY or 0) + options.offset.top
    left        = (options.x or event.pageX or 0) + options.offset.left

    expectedTop  = top
    expectedLeft = left

    if top + menuHeight > mainHeight
      top  = mainHeight - menuHeight + options.offset.top

    if left + menuWidth > mainWidth
      left  = mainWidth - menuWidth + options.offset.left

    @topMargin  = expectedTop  - top
    @leftMargin = expectedLeft - left


    style   =
      width : "#{menuWidth}px"
      top   : top
      left  : left

    if menuMaxWidth
      style.maxWidth = "#{menuMaxWidth}px"

    style.minWidth = "#{menuMinWidth}px"  if menuMinWidth

    @getDomElement().css style

  positionSubMenu: (nodeView)->
    {children, id} = nodeView.getData()
    if children
      expandView = @treeController.listControllers[id].getView()
      fullViewHeight = expandView.getY() + expandView.getHeight()
      if fullViewHeight > window.innerHeight
        expandView.$().css "bottom", 0
      fullViewWidth = expandView.getX() + expandView.getWidth()
      if fullViewWidth > window.innerWidth
        expandView.$().css "left", - expandView.getWidth()
        expandView.setClass "left-aligned"
