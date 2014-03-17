KDScrollView = require './../../core/scrollview.coffee'

module.exports = class KDSplitViewPanel extends KDScrollView

  constructor:(options = {}, data)->

    options.fixed    ?= no
    options.minimum or= null
    options.maximum or= null
    options.view    or= null

    super options,data

    @isVertical = @getOptions().type.toLowerCase() is "vertical"
    @isFixed    = @getOptions().fixed

    {@size, @minimum, @maximum} = @options

  _getIndex:-> @parent.getPanelIndex @

  _getSize:-> if @isVertical then @getWidth() else @getHeight()

  _setSize:(size)->
    if @_wouldResize size
      size = 0 if size < 0
      if @isVertical then @setWidth size else @setHeight size
      @parent.sizes[@_getIndex()] = @size = size
      @parent.emit "PanelDidResize", panel: @
      @emit "PanelDidResize", newSize : size
      size
    else
      no

  _wouldResize:(size)->
    @minimum ?= -1
    @maximum ?= 99999
    # log size,@minimum,@maximum if @parent.options.domId is "content-area-split-view"
    if size > @minimum and size < @maximum
      # log size,@parent.options.domId
      yes
    else
      if size < @minimum
        @parent._panelReachedMinimum @_getIndex()
      else if size > @maximum
        @parent._panelReachedMaximum @_getIndex()
      no

  _setOffset:(offset)->
    offset = 0 if offset < 0
    if @isVertical then @$().css(left : offset) else @$().css(top : offset)
    @parent.panelsBounds[@_getIndex()] = offset

  _getOffset:->
    if @isVertical then @getRelativeX() else @getRelativeY()

