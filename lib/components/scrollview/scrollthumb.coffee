KD = require '../../core/kd'
KDView = require '../../core/view'

module.exports = class KDScrollThumb extends KDView

  constructor:(options = {}, data) ->

    options.type      or= 'vertical'
    options.cssClass    = KD.utils.curry 'kdscrollthumb', options.cssClass
    options.draggable  ?=
      axis              : if options.type is 'vertical' then 'y' else 'x'
      containment       : this

    super options, data

    {@type, @track} = @getOptions()

    @view = @track.getDelegate()

    @on 'viewAppended', @bound 'calculateSize'
    @on 'DragInAction', @bound 'handleDrag'
    @view.on 'scroll',  @bound 'calculatePosition'

    @listenWindowResize()


  resetSizes: ->

    @size       = null
    @trackSize  = null
    @scrollSize = null


  reset: ->

    @resetSizes()
    @calculateSize()
    @calculatePosition()


  handleDrag: ->

    size        = @getSize()
    offset      = @getOffset()
    thumbDiff   = @getSize(yes) - @size # in case of given min-height/width with css
    trackSize   = @getTrackSize() - thumbDiff
    availOffset = trackSize - size
    ratio       = Math.min Math.max(0, offset/availOffset), 1

    if @isVertical()
    then @view.setScrollTop  (@view.getScrollHeight() - trackSize) * ratio
    else @view.setScrollLeft (@view.getScrollWidth()  - trackSize) * ratio


  isVertical: -> @type is 'vertical'


  getTrackSize: ->

    if @trackSize then @trackSize
    else if @isVertical()
    then @track.getHeight()
    else @track.getWidth()


  setSize: (size) ->

    if @isVertical()
    then @setHeight size
    else @setWidth size
    @size = size


  getSize: (force) ->

    if @size and not force then @size
    else if @isVertical()
    then @getHeight()
    else @getWidth()


  setOffset: (offset) ->

    @setStyle if @isVertical()
    then top  : offset
    else left : offset


  getOffset: ->

    if @isVertical()
    then @getY() - @track.getY()
    else @getX() - @track.getX()


  getScrollOffset: ->

    if @isVertical()
    then @view.getScrollTop()
    else @view.getScrollLeft()


  getScrollSize: ->

    if @scrollSize then @scrollSize
    else if @isVertical()
    then @view.getScrollHeight()
    else @view.getScrollWidth()


  calculateSize: ->

    @trackSize  = @getTrackSize()
    @scrollSize = @getScrollSize()

    @setTrackVisibility()
    @setSize @trackSize * @trackSize / @scrollSize


  calculatePosition: (event) ->

    ratio     = @getScrollOffset() / @getScrollSize()
    thumbDiff = @getSize(yes) - @size # in case of given min-height/width with css
    trackSize = @getTrackSize()
    @setTrackVisibility()
    @setOffset (trackSize - thumbDiff) * ratio


  setTrackVisibility: ->

    if @getTrackSize() >= @getScrollSize()
    then @track.hide()
    else @track.show()

  # I assume, this would fire a lot
  # we may throttle this in case - SY
  _windowDidResize: -> @reset()
