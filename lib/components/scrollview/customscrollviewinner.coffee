$                = require 'jquery'
KD               = require '../../core/kd'
KDCustomHTMLView = require '../../core/customhtmlview'
KDScrollView     = require './scrollview'
KDScrollThumb    = require './scrollthumb'
KDScrollTrack    = require './scrolltrack'
Hammer           = require 'hammerjs'

module.exports = class KDCustomScrollViewWrapper extends KDScrollView

  SPACEBAR  = 32
  PAGEUP    = 33
  PAGEDOWN  = 34
  END       = 35
  HOME      = 36
  UPARROW   = 38
  DOWNARROW = 40

  PAGE_KEY_DURATION  = 300
  ARROW_KEY_DURATION = 150
  ARROW_KEY_STEP     = 50

  constructor: (options = {}, data) ->

    options.bind = KD.utils.curry 'keydown', options.bind
    options.attributes ?= {}
    options.attributes.tabindex ?= "0"

    @globalKeydownEventBound = no

    super options, data

    @on 'MutationHappened', @bound "toggleGlobalKeydownEventOnSizeCheck"

    return unless KD.utils.isTouchDevice()

    hammer = new Hammer @getElement()
    hammer.get('pan').set direction: Hammer.DIRECTION_ALL
    prevDeltaX = prevDeltaY = 0

    # temp solution
    calculateEvent = (event) ->
      event.stopPropagation = ->
      event.preventDefault = ->
      { velocityX, velocityY, deltaX, deltaY, direction } = event

      currentDeltaX = deltaX
      currentDeltaY = deltaY
      currentVeloX  = Math.min .5, (velocityX * if direction is 16 then -1 else 1)
      currentVeloY  = Math.min .5, (velocityY * if direction is 16 then -1 else 1)
      event.deltaX  = (currentDeltaX - prevDeltaX) * currentVeloX
      event.deltaY  = (currentDeltaY - prevDeltaY) * currentVeloY
      prevDeltaX    = currentDeltaX
      prevDeltaY    = currentDeltaY

      return event

    hammer.on 'panend pancancel', (event) -> prevDeltaX = prevDeltaY = 0
    hammer.on 'panup pandown', (event) =>

      @mouseWheel calculateEvent event


  scroll: (event) ->

    if @verticalThumb.beingDragged or @horizontalThumb.beingDragged

      return KD.utils.stopDOMEvent event


  mouseWheel: (event) ->

    super

    {deltaX, deltaY, deltaFactor} = event

    return yes  if @getElement().dataset.innerItemWillScroll

    speed = deltaFactor or @getOptions().mouseWheelSpeed or 1
    x     = -deltaX
    y     = -deltaY

    resX  = if x isnt 0 and @getScrollWidth() > @horizontalThumb.getTrackSize()
    then  @_scrollHorizontally {speed, velocity : x}
    else  no
    resY  = if y isnt 0 and @getScrollHeight() > @verticalThumb.getTrackSize()
    then  @_scrollVertically {speed, velocity : y}
    else  no

    stop  = if Math.abs(x) > Math.abs(y) then resX else resY

    KD.utils.stopDOMEvent event  unless stop

    return !stop


  _scrollVertically: do ->

    lastPosition = 0

    ({speed, velocity})->

      stepInPixels = velocity * speed
      actPosition  = @getScrollTop()
      newPosition  = actPosition + stepInPixels
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
      newPosition  = actPosition - stepInPixels
      shouldStop   = if velocity > 0
      then lastPosition < newPosition
      else lastPosition > newPosition

      @setScrollLeft lastPosition = newPosition

      return shouldStop


  toggleGlobalKeydownEventOnSizeCheck: ->

    winHeight = $(window).height()
    needToBind = @getHeight() >= winHeight
    @toggleGlobalKeydownEvent needToBind


  toggleGlobalKeydownEvent: (needToBind) ->

    eventName = "keydown.customscroll#{@getId()}"

    if needToBind
      $(document).on eventName, @bound "keyDown"  unless @globalKeydownEventBound
    else
      $(document).off eventName  if @globalKeydownEventBound

    @globalKeydownEventBound = needToBind


  destroy: ->

    @toggleGlobalKeydownEvent no
    super


  pageUp: ->

    @scrollTo
      top      : Math.max @getScrollTop() - @getHeight(), 0
      duration : @getAnimationDuration()


  pageDown: ->

    @scrollTo
      top      : @getScrollTop() + @getHeight()
      duration : @getAnimationDuration()


  scrollOnUpArrow: ->

    @scrollTo
      top      : Math.max @getScrollTop() - ARROW_KEY_STEP, 0
      duration : @getAnimationDuration yes


  scrollOnDownArrow: ->

    @scrollTo
      top      : @getScrollTop() + ARROW_KEY_STEP
      duration : @getAnimationDuration yes


  getAnimationDuration: (isArrowKey) ->

    duration = if isArrowKey then ARROW_KEY_DURATION else PAGE_KEY_DURATION
    timeDifference = new Date() - @lastKeyTime

    # if time passed after the last key down is quite short,
    # for example, user is steadily pressing down arrow key,
    # then disable scrolling animation
    return duration  if not @lastKeyTime or timeDifference > duration


  keyDown: (event) ->

    keyboardElements = "input,textarea,select,datalist,keygen,[contenteditable='true'],button"

    return yes  if ($ document.activeElement).is keyboardElements
    return yes  if not(@getDomElement().is ":visible")
    return yes  if @getScrollHeight() <= @verticalThumb.getTrackSize()

    shouldPropagate = no
    if event.which is SPACEBAR and event.shiftKey
      @pageUp()
    else if event.metaKey or event.ctrlKey
      switch event.which
        when UPARROW   then @scrollToTop @getAnimationDuration()
        when DOWNARROW then @scrollToBottom @getAnimationDuration()
        else shouldPropagate = yes
    else
      switch event.which
        when PAGEUP then @pageUp()
        when SPACEBAR, PAGEDOWN then @pageDown()
        when END then @scrollToBottom @getAnimationDuration()
        when HOME then @scrollToTop @getAnimationDuration()
        when UPARROW then @scrollOnUpArrow()
        when DOWNARROW then @scrollOnDownArrow()
        else shouldPropagate = yes

    @lastKeyTime = new Date()

    return shouldPropagate