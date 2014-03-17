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

    @panels       = []
    @panelsBounds = []
    @resizers     = []
    @sizes        = []
    @minimums     = []
    @maximums     = []
    @size               = 0

  viewAppended:->

    @_sanitizeSizes()

    @_createPanels()
    @_calculatePanelBounds()
    @_putPanels()
    @_setPanelPositions()
    @_putViews()

    if @getOptions().resizable and @panels.length
      @_createResizers()

    @listenWindowResize()

  # CREATE/REMOVE PANELS
  _createPanels:->

    panelCount = @getOptions().sizes.length
    @panels    = [@_createPanel(0), @_createPanel(1)]

  _createPanel:(index)->

    log @sizes[index],"////////"
    {type, fixed} = @getOptions()
    panel = new KDSplitViewPanel
      cssClass : "kdsplitview-panel panel-#{index}"
      index    : index
      type     : type
      size     : @sizes[index]
      fixed    : !!fixed[index]
      minimum  : @minimums[index]
      maximum  : @maximums[index]

    panel.on "KDObjectWillBeDestroyed", => @_panelIsBeingDestroyed panel
    @emit "SplitPanelCreated", panel
    return panel

  _calculatePanelBounds:->
    @panelsBounds = for size,i in @sizes
      if i is 0
        0
      else
        offset = 0
        for prevSize in [0...i]
          offset += @sizes[prevSize]
        offset

  _putPanels:->
    for panel in @panels
      @addSubView panel
      if @getOptions().colored
        panel.$().css backgroundColor : KD.utils.getRandomRGB()

  _setPanelPositions:->

    for panel,i in @panels
      panel._setSize @sizes[i]
      panel._setOffset @panelsBounds[i]

    no

  _panelIsBeingDestroyed:(panel)->

    index         = @getPanelIndex panel
    o             = @getOptions()
    @panels       = @panels.slice(0,index).concat(@panels.slice(index+1))
    @sizes        = @sizes.slice(0,index).concat(@sizes.slice(index+1))
    @panelsBounds = @panelsBounds.slice(0,index).concat(@panelsBounds.slice(index+1))

    @minimums[index] = 0
    @maximums[index] = @_getSize()
    o.views[index]   = null  if o.views[index]?

  # CREATE RESIZERS

  _createResizers:->

    @resizers = for i in [1...@sizes.length]
      @_createResizer i
    @_repositionResizers()

  _createResizer:(index)->

    @addSubView resizer = new KDSplitResizer
      cssClass : "kdsplitview-resizer #{@getOptions().type}"
      type     : @getOptions().type
      panel0   : @panels[index-1]
      panel1   : @panels[index]

    return resizer

  _repositionResizers:->
    resizer._setOffset @panelsBounds[i+1] for resizer,i in @resizers

  # PUT VIEWS
  _putViews:->
    @getOptions().views ?= []
    for view,i in @getOptions().views
      if view instanceof KDView
        @setView view,i

  # HELPERS
  _sanitizeSizes:->

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
    log s, sizes, '-----------'
    @sizes = s


  _sanitizeSize: (size) ->

    size = if "number" is typeof size then size
    else if /px$/.test size    then parseInt size, 10
    else if /%$/.test size
    then @_getSize() / 100 * parseInt size, 10
    else @_getSize() / 2
    size

  _setMinsAndMaxs:->

    {minimums, maximums} = @getOptions()

    @minimums[0] = @_sanitizeSize minimums[0]
    @minimums[1] = @_sanitizeSize minimums[1]
    @maximums[0] = @_sanitizeSize maximums[0]
    @maximums[1] = @_sanitizeSize maximums[1]


  _getSize:->

    if @size then @size
    else if @getOptions().type is "vertical"
    then @getWidth()
    else @getHeight()


  _setSize:(size)->
    if @getOptions().type is "vertical" then @setWidth size else @setHeight size

  _getParentSize:->
    type    = @getOptions().type
    $parent = @$().parent()
    if type is "vertical" then $parent.width() else $parent.height()


  _getLegitPanelSize: (size, index) ->

    min = @minimums[index] or 0
    max = @maximums[index] or @_getSize()
    log min, max, size, Math.min Math.max(min, size), max
    return Math.min Math.max(min, size), max


  _resizePanels:->

    @_sanitizeSizes()

  _repositionPanels:->

    @_calculatePanelBounds()
    @_setPanelPositions()

  # EVENT HANDLING

  _windowDidResize:(event)->

    @_setSize @_getParentSize()
    @_resizePanels()
    @_repositionPanels()
    @_setPanelPositions()

    # find a way to do that for when parent get resized and split reachs a min-width
    # if @getWidth() > @_getParentSize() then @setClass "min-width-reached" else @unsetClass "min-width-reached"
    if @getOptions().resizable
      @_repositionResizers()

  mouseUp:(event)->
    @$().unbind "mousemove.resizeHandle"
    @_resizeDidStop event

  _panelReachedMinimum:(panelIndex)->
    @panels[panelIndex].emit "PanelReachedMinimum"
    @emit "PanelReachedMinimum", panel : @panels[panelIndex]

  _panelReachedMaximum:(panelIndex)->
    @panels[panelIndex].emit "PanelReachedMaximum"
    @emit "PanelReachedMaximum", panel : @panels[panelIndex]

  _resizeDidStart:(event)->
    $('body').addClass "resize-in-action"
    @emit "ResizeDidStart", orgEvent : event

  _resizeDidStop:(event)->
    @emit "ResizeDidStop", orgEvent : event
    @utils.wait 300, ->
      $('body').removeClass "resize-in-action"

  ### PUBLIC METHODS ###

  isVertical:-> @getOptions().type is "vertical"

  getPanelIndex:(panel)->

    for p,i in @panels
      if p.getId() is panel.getId()
        return i

  hidePanel:(panelIndex,callback = noop)->

    panel = @panels[panelIndex]
    panel._lastSize = panel._getSize()
    @resizePanel 0,panelIndex,()=>
      callback.call @,(panel : panel, index : panelIndex )

  showPanel:(panelIndex,callback = noop)->

    panel = @panels[panelIndex]
    newSize = panel._lastSize or @getOptions().sizes[panelIndex] or 200
    panel._lastSize = null
    @resizePanel newSize,panelIndex,()->
      callback.call @,(panel : panel, index : panelIndex )

  resizePanel:(value = 0,panelIndex = 0,callback = noop)->

    @_resizeDidStart()

    value     = @_sanitizeSize value
    panel0    = @panels[panelIndex]
    isReverse = no

    if panel0.size is value
      @_resizeDidStop()
      callback()
      return

    # get the secondary panel and resizer which will be resized/positioned accordingly
    panel1 = unless @panels.length - 1 is panelIndex
      p1index = panelIndex + 1
      resizer = @resizers[panelIndex] if @getOptions().resizable
      @panels[p1index]
    else
      isReverse = yes
      p1index   = panelIndex-1
      resizer   = @resizers[p1index] if @getOptions().resizable
      @panels[p1index]

    # stop if it's not doable

    # totalActionArea = panel0._getSize() + panel1._getSize() # trying to improve performance here
    totalActionArea = panel0.size + panel1.size

    return no if value > totalActionArea

    p0size    = @_getLegitPanelSize(value,panelIndex)
    surplus   = panel0.size - p0size
    p1newSize = panel1.size + surplus
    p1size    = @_getLegitPanelSize(p1newSize,p1index)

    raceCounter = 0
    race = ()=>
      raceCounter++
      if raceCounter is 2
        @_resizeDidStop()
        callback()

    unless isReverse
      p1offset = (panel1._getOffset() - surplus)
      if @getOptions().animated
        panel0._animateTo p0size,race
        panel1._animateTo p1size,p1offset,race
        resizer._animateTo p1offset if resizer
      else
        panel0._setSize p0size
        race()
        panel1._setSize p1size,
        panel1._setOffset p1offset
        race()
        resizer._setOffset p1offset if resizer

    else
      p0offset = (panel0._getOffset() + surplus)
      if @getOptions().animated
        panel0._animateTo p0size,p0offset,race
        panel1._animateTo p1size,race
        resizer._animateTo p0offset if resizer
      else
        panel0._setSize p0size
        panel0._setOffset p0offset
        race()
        panel1._setSize p1size
        race()
        resizer._setOffset p0offset if resizer

  splitPanel:(index, options)->

    newPanelOptions = {}
    o               = @getOptions()
    isLastPanel     = if @resizers[index] then no else yes

    # DO PANEL

    # CREATE NEW PANEL
    panelToBeSplitted = @panels[index]
    @panels.splice index + 1, 0, newPanel = @_createPanel(index)
    @sizes.splice index + 1, 0, @sizes[index]/2
    @sizes[index] = @sizes[index]/2

    # MINS AND MAXS ARE NOT FUNCTIONAL YET ON NEWLY CREATED PANELS
    # BUT TO AVOID CONFLICTS WE UPDATE THEM HERE
    o.minimums.splice index + 1, 0, newPanelOptions.minimum
    o.maximums.splice index + 1, 0, newPanelOptions.maximum
    o.views.splice index + 1, 0, newPanelOptions.view
    o.sizes = @sizes

    # MIMIC @addSubView(newPanel)
    @subViews.push newPanel
    newPanel.setParent @
    panelToBeSplitted.$().after newPanel.$()
    newPanel.emit 'viewAppended'

    # POSITION NEW PANEL
    newSize = panelToBeSplitted._getSize() / 2
    panelToBeSplitted._setSize newSize
    newPanel._setSize newSize
    newPanel._setOffset panelToBeSplitted._getOffset() + newSize
    @_calculatePanelBounds()

    # COLORIZE PANELS
    # panelToBeSplitted.$().css backgroundColor : KD.utils.getRandomRGB()
    # newPanel.$().css backgroundColor : KD.utils.getRandomRGB()

    # RE-ENUMERATE PANELS
    for panel,i in @panels[index+1...@panels.length]
      panel.index = newIndex = index+1+i
      panel.unsetClass("panel-#{index+i}").setClass("panel-#{newIndex}")

    # DO RESIZER
    if @getOptions().resizable
      unless isLastPanel
        # POSITION OLD RESIZER
        oldResizer = @resizers[index]
        oldResizer._setOffset @panelsBounds[index+1]
        oldResizer.panel0 = panelToBeSplitted
        oldResizer.panel1 = newPanel
        # CREATE NEW RESIZER
        @resizers.splice index+1, 0, newResizer = @_createResizer index+2
        # POSITION NEW RESIZER
        newResizer._setOffset @panelsBounds[index+2]
      else
        # CREATE NEW RESIZER
        @resizers.push newResizer = @_createResizer index+1
        # POSITION NEW RESIZER
        newResizer._setOffset @panelsBounds[index+1]

    @emit "panelSplitted", newPanel
    return newPanel

  removePanel:(index)->

    l = @panels.length
    if l is 1
      warn "this is the only panel left"
      return no

    panel = @panels[index]
    panel.destroy()

    if index is 0
      # log "FIRST ONE"
      r = @resizers.shift()
      r.destroy()
      if res = @resizers[0]
        res.panel0 = @panels[0]
        res.panel1 = @panels[1]
      # nextPanel._setOffset nextPanel._getOffset() - panel._getSize()
      # nextPanel._setSize   nextPanel._getSize() + panel._getSize()

    else if index is l - 1
      # log "LAST ONE"
      r = @resizers.pop()
      r.destroy()
      if res = @resizers[l-2]
        res.panel0 = @panels[l-2]
        res.panel1 = @panels[l-1]

      # prevPanel = @panels[length - 2]
      # prevPanel._setSize prevPanel._getSize() + panel._getSize()

    else
      # log "ONE IN THE MIDDLE"
      [r] = @resizers.splice index - 1, 1
      r.destroy()
      @resizers[index - 1].panel0 = @panels[index-1]
      @resizers[index - 1].panel1 = @panels[index]

      # prevPanel = @panels[index - 1]
      # prevPanel._setSize prevPanel._getSize() + panel._getSize()


    return yes

  setView:(view,index)->
    if index > @panels.length or not view
      warn "Either 'view' or 'index' is missing at KDSplitView::setView!"
      return
    @panels[index].addSubView view
