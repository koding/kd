require('jquery-mousewheel') $
KDView = require './../../core/view.coffee'

module.exports = class KDScrollView extends KDView

  constructor: (options = {}, data) ->

    options.bind     = KD.utils.curry 'mousewheel scroll', options.bind
    options.cssClass = KD.utils.curry 'kdscrollview', options.cssClass

    super options, data

    @stopScrolling = no


  hasScrollBars: -> @hasVerticalScrollBars() or @hasHorizontalScrollBars()

  hasVerticalScrollBars: -> @getScrollHeight() > @getHeight()

  hasHorizontalScrollBars: -> @getScrollWidth() > @getWidth()

  getScrollHeight: -> @getElement().scrollHeight

  getScrollWidth: -> @getElement().scrollWidth

  getScrollTop: -> @getElement().scrollTop

  getScrollLeft: -> @getElement().scrollLeft

  setScrollHeight: (val) -> @getElement().scrollHeight = val

  setScrollWidth: (val) -> @getElement().scrollWidth = val

  setScrollTop: (val) -> @getElement().scrollTop = val

  setScrollLeft: (val) -> @getElement().scrollLeft = val


  scrollTo: (options, callback) ->

    { top, left, duration } = options

    top      or= 0
    left     or= 0

    if duration?
      @$().animate
        scrollTop  : top
        scrollLeft : left
      , duration
      , callback
    else
      @setScrollTop top
      @setScrollLeft left
      callback?()


  scrollToBottom: -> @scrollTo top : @getScrollHeight() - @getHeight()


  scrollToSubView: (subView) ->

    viewTop       = @getY()
    viewHeight    = @getHeight()
    viewScrollTop = @getScrollTop()
    subViewTop    = subView.getY()
    subViewHeight = subView.getHeight()
    subViewRelTop = subViewTop - viewTop + viewScrollTop

    # subview is in visible area
    if subViewTop - viewTop + subViewHeight < viewHeight and subViewTop - viewTop >= 0
      # subview is in visible area
      return

    # subview is above visible area
    else if subViewTop - viewTop < 0
      @scrollTo top : subViewRelTop

    # subview is below visible area
    else if subViewTop - viewTop + subViewHeight > viewHeight
      @scrollTo top : subViewRelTop - viewHeight + subViewHeight


  isAtBottom: -> @getScrollTop() + @getHeight() >= @getScrollHeight()

  mouseWheel: ->

    return no  if @stopScrolling

    return yes
