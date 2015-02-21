KD               = require '../../core/kd'
KDCustomHTMLView = require '../../core/customhtmlview'
KDScrollView     = require './scrollview'
KDScrollThumb    = require './scrollthumb'
KDScrollTrack    = require './scrolltrack'
Hammer           = require 'hammerjs'

module.exports = class KDCustomScrollViewWrapper extends KDScrollView


  constructor: (options = {}, data) ->

    super options, data

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
