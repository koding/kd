require('jquery-mousewheel') $
KDView = require './../../core/view.coffee'

module.exports = class KDScrollView extends KDView

  DIRECTIONS = ['up', 'right', 'down', 'left']

  constructor:(options = {}, data)->

    options.ownScrollBars   ?= no
    options.naturalScroll   ?= yes
    options.bind           or= "mouseenter"
    options.mouseWheelSpeed ?= 3
    options.cssClass         = KD.utils.curry "kdscrollview", options.cssClass

    super options, data

    { @ownScrollBars } = @getOptions()

    if @ownScrollBars
      @once 'viewAppended', @bound '_createScrollBars'


    @stopScrolling = no
    @on 'click', -> KD.getSingleton('windowController').enableScroll()


  bindEvents:->

    #FIXME: mousewheel works in FF, IE??
    @$().bind "mousewheel", (event, delta, deltaX, deltaY)=>
      event._delta = {delta, deltaX, deltaY}  if delta
      @handleEvent event

    super


  hasScrollBars:-> @getScrollHeight() > @getHeight()


  getScrollHeight:-> @getElement().scrollHeight
  getScrollWidth:->  @getElement().scrollWidth
  getScrollTop:->    @getElement().scrollTop
  getScrollLeft:->   @getElement().scrollTop

  setScrollHeight:(val)-> @getElement().scrollHeight = val
  setScrollWidth:(val)->  @getElement().scrollWidth = val
  setScrollTop:(val)->    @getElement().scrollTop = val
  setScrollLeft:(val)->   @getElement().scrollTop = val


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
      { _delta }         = event
      { deltaX, deltaY } = _delta

      factor = event.deltaFactor or @getOptions().mouseWheelSpeed
      log factor, deltaX * factor, -deltaY * factor
      # // return true if there was no movement so rest of screen can scroll
      # return dX == horizontalDragPosition && dY == verticalDragPosition;

    #   direction = if event._delta.delta > 0 then "up" else "down"
    #   @_scrollUponVelocity event._delta.delta, direction
    #   return no

  scroll:(event)->
    log 'scroll'
    # if @getOptions().ownScrollBars
    #   scrollOffset = @getScrollTop()
    #   @_vTrack.$().css marginTop : scrollOffset
    # yes

  _scrollUponVelocity:(velocity, direction)->

    stepInPixels     = velocity * 50
    actInnerPosition = @getScrollTop()
    newInnerPosition = stepInPixels + actInnerPosition

    @$().scrollTop newInnerPosition

  _createScrollBars:->

    log "has-own-scrollbars"
    @observeMutations()


    @setClass "has-own-scrollbars"

    @_wrapper = new KDCustomHTMLView
      cssClass : 'own-scrollbars-wrapper'
    # log @_wrapper
    # debugger
    @$().wrap @_wrapper.$()
    @_wrapper.emit 'viewAppended'

    @_vTrack = new KDView
      cssClass : 'kdscrolltrack ver'
      delegate : this

    @_wrapper.addSubView @_vTrack

    @_vTrack.setRandomBG()

    @_vTrack.addSubView @_vThumb = new KDScrollThumb
      cssClass : 'kdscrollthumb'
      type     : 'vertical'
      delegate : @_vTrack

    @on 'MutationHappened', @_vThumb.bound '_calculateSize'
    @scrollBarsCreated = yes




