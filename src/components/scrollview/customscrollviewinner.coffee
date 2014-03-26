require('jquery-mousewheel') $
KDCustomHTMLView = require './../../core/customhtmlview'
KDScrollView     = require './scrollview'
KDScrollThumb    = require './scrollthumb'
KDScrollTrack    = require './scrolltrack'

module.exports = class KDCustomScrollViewWrapper extends KDScrollView

  scroll:(event)->

    if @verticalThumb.beingDragged or @horizontalThumb.beingDragged
      return KD.utils.stopDOMEvent event


  mouseWheel:(event)->

    super

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
