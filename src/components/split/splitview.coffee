KD               = require './../../core/kd.coffee'
KDView           = require './../../core/view.coffee'
KDSplitViewPanel = require './splitpanel.coffee'
KDSplitResizer   = require './splitresizer.coffee'

module.exports = class KDSplitView extends KDView

  constructor:(options = {},data)->

    options.type      or= "vertical"         # "vertical" or "horizontal"
    options.resizable  ?= yes                # yes or no
    options.sizes     or= [.5, .5]           # an Array of Strings such as ["50%","50%"] or ["500px","150px",null] and null for the available rest area
    options.minimums  or= [0, 0]             # an Array of Strings
    options.maximums  or= ['100%', '100%']   # an Array of Strings
    options.views     or= []                 # an Array of KDViews
    options.fixed     or= []                 # an Array of Booleans
    options.duration  or= 200                # a Number in miliseconds
    options.separator or= null               # a KDView instance or null for default separator
    options.colored    ?= no                 # a Boolean
    options.type        = options.type.toLowerCase()
    options.cssClass    = KD.utils.curry "kdsplitview kdsplitview-#{options.type}", options.cssClass

    super options,data

    {@type, @resizable} = @getOptions()
    @panels             = []
    @resizer            = null
    @sizes              = []
    @minimums           = []
    @maximums           = []
    @size               = 0

  viewAppended:->

    @_calculateSizes()
    @_createPanels()

    @_putPanels()
    @_resizePanels()

    @_putViews()

    @_createResizer()  if @resizable and @panels[1]

    @listenWindowResize()
    @parent?.on "PanelDidResize", KD.utils.debounce 10, @bound '_windowDidResize'


  _createPanels:->

    @_createPanel 0
    @_createPanel 1 if @sizes[1]?


  _createPanel:(index)->

    {fixed, panelClass} = @getOptions()
    panel = new (panelClass or KDSplitViewPanel)
      cssClass : "kdsplitview-panel panel-#{index}"
      index    : index
      type     : @type
      size     : @sizes[index]
      fixed    : !!fixed[index]

    panel.on "KDObjectWillBeDestroyed", => @_panelIsBeingDestroyed panel
    @emit "SplitPanelCreated", panel
    @panels[index] = panel

    return panel


  _putPanels:->

    @addSubView @panels[0]
    @addSubView @panels[1]

    if @getOptions().colored
      @panels[0].setCss backgroundColor : KD.utils.getRandomRGB()
      @panels[1].setCss backgroundColor : KD.utils.getRandomRGB()


  _resizePanels:-> @resizePanel @sizes[0]


  _panelIsBeingDestroyed:(panel)->

    {views}              = @getOptions()
    {index}              = panel
    @panels[index]       = null
    @sizes[index]        = null
    @minimums[index]     = null
    @maximums[index]     = null
    views[index]         = null


  _createResizer:->

    {type}   = @getOptions()
    @resizer = @addSubView new KDSplitResizer
      cssClass : "kdsplitview-resizer #{type}"
      type     : @type
      panel0   : @panels[0]
      panel1   : @panels[1]

    @_repositionResizer()


  _repositionResizer:-> @resizer._setOffset @sizes[0]


  _putViews:->

    {views} = @getOptions()

    return  unless views

    @setView views[0], 0  if views[0]
    @setView views[1], 1  if views[1]


  _calculateSizes:->

    @_setMinsAndMaxs()

    {sizes} = @getOptions()
    ss      = @_getSize()
    s       = []
    s[0]    = @_getLegitPanelSize @_sanitizeSize(sizes[0]), 0
    s[1]    = @_getLegitPanelSize @_sanitizeSize(sizes[1]), 1
    st      = s[0] + s[1]

    if st > ss
      s[1] = ss - s[0]
    else if st < ss
      if sizes[0] and (not sizes[1] or sizes[1] is 'auto')
        s[1] = ss - s[0]
      else if sizes[1] and (not sizes[0] or sizes[0] is 'auto')
        s[0] = ss - s[1]

    @size  = ss
    @sizes = s


  _sanitizeSize: (size) ->

    return if "number" is typeof size
      if 1 > size > 0
      then @_getSize() * size
      else size
    else if /px$/.test size then parseInt size, 10
    else if /%$/.test size
    then @_getSize() / 100 * parseInt size, 10
    else null


  _setMinsAndMaxs:->

    {minimums, maximums} = @getOptions()

    @minimums[0] = @_sanitizeSize minimums[0]
    @minimums[1] = @_sanitizeSize minimums[1]
    @maximums[0] = @_sanitizeSize maximums[0]
    @maximums[1] = @_sanitizeSize maximums[1]


  _getSize:->

    if @size then @size
    else if @isVertical()
    then @getWidth()
    else @getHeight()


  _setSize:(size)->

    if @isVertical()
    then @setWidth size
    else @setHeight size


  _getParentSize:->

    if @isVertical()
      if @parent
      then @parent.getWidth()
      else window.innerWidth
    else
      if @parent
      then @parent.getHeight()
      else window.innerHeight


  _getLegitPanelSize: (size, index) ->

    min = @minimums[index] or 0
    max = @maximums[index] or @_getSize()

    return Math.min Math.max(min, size), max


  _windowDidResize: ->

    @size = null
    @_setSize @_getParentSize()
    @_calculateSizes()
    @_resizePanels()

    # find a way to do that for when parent get resized and split reachs a min-width
    # if @getWidth() > @_getParentSize() then @setClass "min-width-reached" else @unsetClass "min-width-reached"
    @_repositionResizer()  if @resizable

  mouseUp: (event) ->

    @$().unbind "mousemove.resizeHandle"
    @_resizeDidStop event


  _panelReachedMinimum:(index)->

    panel = @panels[index]
    panel.emit "PanelReachedMinimum"
    @emit "PanelReachedMinimum", {panel}


  _panelReachedMaximum:(index)->

    panel = @panels[index]
    panel.emit "PanelReachedMaximum"
    @emit "PanelReachedMaximum", {panel}


  _resizeDidStart:(event)->

    @emit "ResizeDidStart", event
    document.body.classList.add "resize-in-action"



  _resizeDidStop: do ->

    unsetResizeInAction = KD.utils.throttle 1000, (view)->
      document.body.classList.remove "resize-in-action"

    (event)->

      s1 = @sizes[0]/@_getSize()
      s2 = @sizes[1]/@_getSize()

      @setOption 'sizes', [s1, s2]
      @emit "ResizeDidStop", event

      unsetResizeInAction this


  isVertical:-> @type is "vertical"


  getPanelIndex: (panel)-> panel.index


  hidePanel: (index, callback = noop)->

    panel = @panels[index]
    panel._lastSize = panel._getSize()
    @resizePanel 0, index, callback.bind this, {panel, index}


  showPanel:(index,callback = noop)->

    panel           = @panels[index]
    newSize         = panel._lastSize or @sizes[index] or 200
    panel._lastSize = null
    @resizePanel newSize, index, callback.bind this, {panel, index}


  resizePanel:(value = 0, index = 0, callback = noop)->

    return  unless @sizes[1]?
    return  if @beingResized

    @_resizeDidStart()

    value         = @_sanitizeSize value
    value         = @_getSize() if value > @_getSize()
    askedPanel    = @panels[index]
    affectedPanel = @panels[index+1%2]

    if askedPanel._getSize() is value
      @_resizeDidStop()
      callback()
      return

    @beingResized = yes

    value  = @_getLegitPanelSize value, index
    sizes  = [value, @_getSize() - value]
    offset = if index then sizes[1] else sizes[0]

    askedPanel._setSize sizes[0]
    affectedPanel._setSize sizes[1]

    @panels[1]._setOffset offset
    @resizer._setOffset offset  if @resizer
    @_resizeDidStop()
    @beingResized = no


  splitPanel:(index, options = {})->

    view            = @panels[index].subViews.first
    @panels[index].subViews = []
    if view
      view.detach()
      view.unsetParent()
      options.views = [view]
    # options.colored = yes
    # options.type    = ['vertical','horizontal'][KD.utils.getRandomNumber(2)-1]

    {splitClass}    = @getOptions()
    split           = new (splitClass or KDSplitView) options

    @setView split, index

    return split


  removePanel:(index)->


  setView: (view, index) ->

    return warn "view is missing at KDSplitView::setView"   unless view
    return warn "index is missing at KDSplitView::setView"  if index > @panels.length
    return warn "index is missing at KDSplitView::setView"  unless view instanceof KDView

    @panels[index].addSubView view


  # deprecated methods
  deprecated = -> warn 'deprecated method invoked'
  _repositionPanels: deprecated
  _repositionResizers: deprecated
  _setPanelPositions: deprecated
