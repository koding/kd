KDView = require './../../core/view.coffee'

module.exports = class KDSplitResizer extends KDView

  constructor:(options = {}, data)->

    @isVertical = options.type.toLowerCase() is "vertical"

    axis = if @isVertical then "x" else "y"

    options.draggable ?= { axis }

    super options, data

    {@panel0, @panel1} = @getOptions()

    @on "DragFinished", @dragFinished
    @on "DragInAction", @dragInAction
    @on "DragStarted",  @dragStarted

  _setOffset:(offset)->
    offset = 0 if offset < 0
    if @isVertical then @$().css left : offset-5 else @$().css top : offset-5

  _getOffset:(offset)->
    if @isVertical then @getRelativeX() else @getRelativeY()

  _animateTo:(offset)->
    d = @parent.options.duration
    if @isVertical
      offset -= @getWidth() / 2
      @$().animate left : offset,d
    else
      offset -= @getHeight() / 2
      @$().animate top : offset,d

  dragFinished:(event, dragState)->

    @parent._resizeDidStop event

  dragStarted:(event, dragState)->

    @parent._resizeDidStart()
    @rOffset  = @_getOffset()
    @p0Size   = @panel0._getSize()
    @p1Size   = @panel1._getSize()
    @p1Offset = @panel1._getOffset()

  dragInAction:(x, y)->

    if @isVertical
      if @panel0._wouldResize x + @p0Size
        @parent.resizePanel x + @p0Size
      else
        @_setOffset @panel1._getOffset()

    else
      if @panel0._wouldResize y + @p0Size
        @parent.resizePanel y + @p0Size
      else
        @_setOffset @panel1._getOffset()
