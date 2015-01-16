KD = require '../../core/kd'
KDCustomHTMLView          = require '../../core/customhtmlview'
KDScrollTrack             = require './scrolltrack'
KDCustomScrollViewWrapper = require './customscrollviewinner'

module.exports = class KDCustomScrollView extends KDCustomHTMLView

  constructor: (options = {}, data) ->

    options.bind             = KD.utils.curry 'mouseenter mouseleave', options.bind
    options.cssClass         = KD.utils.curry 'kdcustomscrollview', options.cssClass
    options.mouseWheelSpeed ?= 3

    super options, data

    {mouseWheelSpeed, lazyLoadThreshold, wrapperClass} = @getOptions()

    @listenWindowResize()  if options.offscreenIndicatorClassName?

    Wrapper = wrapperClass or KDCustomScrollViewWrapper

    @wrapper = new Wrapper {
      tagName  : 'main'
      lazyLoadThreshold
      mouseWheelSpeed
      scroll:
        if options.offscreenIndicatorClassName?
        then @bound 'updateOffscreenIndicators'
    }

    @verticalTrack   = new KDScrollTrack delegate : @wrapper
    @horizontalTrack = new KDScrollTrack delegate : @wrapper, type : 'horizontal'
    @wrapper.verticalThumb   = @verticalTrack.thumb
    @wrapper.horizontalThumb = @horizontalTrack.thumb

    @wrapper.on 'ScrollTrackShown',  (type) => @setClass   "has-#{type}"
    @wrapper.on 'ScrollTrackHidden', (type) => @unsetClass "has-#{type}"

    @wrapper.on 'MutationHappened', =>
      @verticalTrack.thumb.reset()
      @horizontalTrack.thumb.reset()

    @on 'mouseenter', @bound 'showTracks'
    @on 'mouseleave', @bound 'hideTracks'

  _windowDidResize: ->
    @updateOffscreenIndicators()

  updateOffscreenIndicators: ->
    wrapperEl = @wrapper.getElement()
    { offscreenIndicatorClassName } = @getOptions()
    { above, below } = [].slice.call(
      wrapperEl.getElementsByClassName(offscreenIndicatorClassName))
        .reduce (memo, child) ->
          [_, y] = KD.utils.relativeOffset child, wrapperEl
          if y < wrapperEl.scrollTop
            memo.above.push child
          else if y > wrapperEl.scrollTop + wrapperEl.offsetHeight
            memo.below.push child
          return memo
        , { above: [], below: [] }
    if above.length > 0
      @emit 'OffscreenItemsAbove', above
    else
      @emit 'NoOffscreenItemsAbove'
    if below.length > 0
      @emit 'OffscreenItemsBelow', below
    else
      @emit 'NoOffscreenItemsBelow'

  viewAppended: ->

    @addSubView @wrapper
    @addSubView @verticalTrack
    @addSubView @horizontalTrack

    @wrapper.observeMutations()


  intent = null

  hideTracks: ->

    intent = KD.utils.wait 1000, =>
      @verticalTrack.setClass 'out'
      @horizontalTrack.setClass 'out'


  showTracks: ->

    KD.utils.killWait intent  if intent

    @verticalTrack.unsetClass 'out'
    @horizontalTrack.unsetClass 'out'