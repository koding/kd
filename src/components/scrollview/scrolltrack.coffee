KDView = require './../../core/view'
KDScrollThumb = require './scrollthumb.coffee'

module.exports = class KDScrollTrack extends KDView

  constructor:(options = {}, data)->

    options.type   or= 'vertical'
    options.cssClass = KD.utils.curry "kdscrolltrack #{options.type} out", options.cssClass

    super options, data

    {@type} = @getOptions()

    @scrollView = @getDelegate()

    @addSubView @thumb = new KDScrollThumb
      cssClass : 'kdscrollthumb'
      type     : @type
      track    : this


  click: (event) ->

    return  unless 'kdscrolltrack' in event.target.classList

    if @type is 'vertical'
      scrollHeight = @scrollView.getScrollHeight()
      thumbHeight  = @thumb.getHeight()
      @scrollView.scrollTo
        top : (event.offsetY - thumbHeight / 2) / @getHeight() * scrollHeight

    else
      scrollWidth = @scrollView.getScrollWidth()
      thumbWidth  = @thumb.getWidth()
      @scrollView.scrollTo
        left : (event.offsetX - thumbWidth / 2) / @getWidth() * scrollWidth


  show:->

    @getDelegate().emit 'ScrollTrackShown', @type
    @unsetClass 'invisible'


  hide:->

    @getDelegate().emit 'ScrollTrackHidden', @type
    @setClass 'invisible'

