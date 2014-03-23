KDView = require './../../core/view.coffee'

module.exports = class KDScrollThumb extends KDView
  constructor:(options,data)->
    options = $.extend
      type      : "vertical"    # "vertical" or "horizontal"
    ,options
    super options,data

    @_track = @getDelegate()
    @_view = @_track.getDelegate()

    @on "viewAppended", @_calculateSize.bind @

    @_view.on "scroll", @bound "_calculatePosition"

  isDraggable:->yes

  dragOptions:->
    o = @getOptions()
    dragOptions =
      drag : @_drag
    if o.type = "vertical"
      dragOptions.axis = "y"
    else
      dragOptions.axis = "x"

    dragOptions


  _drag:->
    log "dragged"

  _setSize:(size)->
    o = @getOptions()
    if o.type = "vertical"
      @setHeight size
    else
      @setWidth size

  _setOffset:(offset)->
    o = @getOptions()
    if o.type = "vertical"
      @$().css "marginTop" : offset
    else
      @$().css "marginLeft" : offset

  _calculateSize:->
    o = @getOptions()

    if o.type = "vertical"
      @_trackSize = @_view.getHeight()
      @_scrollSize = @_view.getScrollHeight()
      @_thumbMargin = @getY() - @_track.getY()
    else
      @_scrollSize = @parent.parent.getScrollWidth()
      @_thumbMargin = @getX() - @_track.getX()
      @_trackSize = @parent.getWidth()

    # @_track.hide() if @_trackSize >= @_scrollSize

    @_thumbRatio = @_trackSize / @_scrollSize
    @_thumbSize = @_trackSize * @_thumbRatio - 2 * @_thumbMargin

    @_setSize @_thumbSize

  _calculatePosition:->
    viewScrollTop = @_view.$().scrollTop()
    thumbTopOffset = viewScrollTop * @_thumbRatio + @_thumbMargin
    @_setOffset thumbTopOffset
