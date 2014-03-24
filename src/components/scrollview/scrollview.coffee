require('jquery-mousewheel') $
KDView           = require './../../core/view.coffee'
KDCustomHTMLView = require './../../core/customhtmlview.coffee'
KDScrollThumb    = require './scrollthumb.coffee'
KDScrollTrack    = require './scrolltrack.coffee'

module.exports = class KDScrollView extends KDView

  DIRECTIONS = ['up', 'right', 'down', 'left']

  constructor:(options = {}, data)->

    options.ownScrollBars   ?= no
    options.naturalScroll   ?= yes
    options.bind           or= "mouseenter"
    options.isWrapper       ?= no
    options.mouseWheelSpeed ?= 3
    options.cssClass         = KD.utils.curry "kdscrollview", options.cssClass

    super options, data

    { @ownScrollBars, @isWrapper } = @getOptions()

    @once 'viewAppended', @bound '_createScrollBars'  if @ownScrollBars

    @stopScrolling = no
    @on 'click', -> KD.getSingleton('windowController').enableScroll()


  bindEvents:->

    @$().bind "mousewheel scroll", (event, delta, deltaX, deltaY)=>
      event._delta = {delta, deltaX, deltaY}  if delta
      @handleEvent event

    super


  hasScrollBars:-> @getScrollHeight() > @getHeight()


  getScrollHeight:-> @getElement().scrollHeight
  getScrollWidth:->  @getElement().scrollWidth
  getScrollTop:->    @getElement().scrollTop
  getScrollLeft:->   @getElement().scrollLeft

  setScrollHeight:(val)-> @getElement().scrollHeight = val
  setScrollWidth:(val)->  @getElement().scrollWidth = val
  setScrollTop:(val)->    @getElement().scrollTop = val
  setScrollLeft:(val)->   @getElement().scrollLeft = val


  scroll:(event)->

    return yes  unless @verticalThumb

    if @verticalThumb.beingDragged or @horizontalThumb.beingDragged
      return KD.utils.stopDOMEvent event


  scrollTo:({top, left, duration},callback)->
    top      or= 0
    left     or= 0
    duration or= null

    if duration
      @$().animate
        scrollTop  : top
        scrollLeft : left
      , duration
      , callback
    else
      @setScrollTop top
      @setScrollLeft left
      callback?()

  scrollToSubView:(subView)->

    viewTop       = @getY()
    viewHeight    = @getHeight()
    viewScrollTop = @getScrollTop()
    subViewTop    = subView.getY()
    subViewHeight = subView.getHeight()
    subViewRelTop = subViewTop - viewTop + viewScrollTop

    # log "item is in visible area"
    if subViewTop - viewTop + subViewHeight < viewHeight and subViewTop - viewTop >= 0
      # log "item is in visible area"
      return

    # log "item is above visible area"
    else if subViewTop - viewTop < 0
      @scrollTo top : subViewRelTop

    # log "item is below visible area"
    else if subViewTop - viewTop + subViewHeight > viewHeight
      @scrollTo top : subViewRelTop - viewHeight + subViewHeight

  fractionOfHeightBelowFold:({view})->
    viewHeight = view.getHeight()
    viewGlobalOffset = view.$().offset().top
    scrollViewGlobalOffset = @$().offset().top
    viewOffsetFromScrollView = viewGlobalOffset - scrollViewGlobalOffset
    (viewHeight + viewOffsetFromScrollView - @getHeight())/@getHeight()

  mouseWheel:(event)->

    return no  if @stopScrolling

    if @ownScrollBars
      {_delta, deltaFactor} = event

      return  unless _delta

      speed = deltaFactor or @getOptions().mouseWheelSpeed
      x     = _delta.deltaX
      y     = _delta.deltaY

      resX  = if x isnt 0 and @getScrollWidth() > @getWidth()
      then  @_scrollHorizontally {speed, velocity : x}
      else  no
      resY  = if y isnt 0 and @getScrollHeight() > @getHeight()
      then  @_scrollVertically {speed, velocity : y}
      else  no

      stop  = if Math.abs(x) > Math.abs(y) then resX else resY

      return !stop


  _scrollVertically: do ->

    lastPosition = 0

    ({speed, velocity})->

      stepInPixels = velocity * speed
      actPosition  = @getScrollTop()
      newPosition  = actPosition - stepInPixels
      shouldStop   = if velocity > 0
      then lastPosition > newPosition
      else lastPosition < newPosition

      @setScrollTop lastPosition = newPosition

      return shouldStop

  _scrollHorizontally: do ->

    lastPosition = 0

    ({speed, velocity})->

      stepInPixels = velocity * speed
      actPosition  = @getScrollLeft()
      newPosition  = actPosition + stepInPixels
      shouldStop   = if velocity < 0
      then lastPosition >= newPosition
      else lastPosition <= newPosition

      @setScrollLeft lastPosition = newPosition

      return shouldStop


  _createScrollBars:->

    return  if @isWrapper

    log "has-own-scrollbars"
    {mouseWheelSpeed} = @getOptions()
    @observeMutations()

    @setClass "has-own-scrollbars"

    @wrapper = new KDCustomHTMLView {
      isWrapper : yes
      cssClass  : 'own-scrollbars-wrapper'
      mouseWheelSpeed
    }
    @parent.addSubView @wrapper
    @detach()
    @wrapper.attach this

    @verticalTrack = new KDScrollTrack
      cssClass : 'kdscrolltrack ver'
      delegate : this

    @wrapper.addSubView @verticalTrack

    @horizontalTrack = new KDScrollTrack
      cssClass : 'kdscrolltrack hor'
      delegate : this

    @wrapper.addSubView @horizontalTrack

    @verticalTrack.addSubView @verticalThumb = new KDScrollThumb
      cssClass : 'kdscrollthumb'
      type     : 'vertical'
      track    : @verticalTrack

    @horizontalTrack.addSubView @horizontalThumb = new KDScrollThumb
      cssClass : 'kdscrollthumb'
      type     : 'horizontal'
      track    : @horizontalTrack

    @on 'MutationHappened', @verticalThumb.bound 'handleMutation'
    @on 'MutationHappened', @horizontalThumb.bound 'handleMutation'

    @scrollBarsCreated = yes




