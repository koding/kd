KD = require '../../core/kd'
KDView = require '../../core/view'
KDScrollThumb = require './scrollthumb'

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

    thumbSize = @thumb.getSize yes

    if @type is 'vertical'
      scrollHeight = @scrollView.getScrollHeight()
      offset = event.originalEvent.layerY or event.offsetY
      @scrollView.scrollTo
        top : (offset - thumbSize / 2) / @getHeight() * scrollHeight

    else
      scrollWidth = @scrollView.getScrollWidth()
      offset = event.originalEvent.layerX or event.offsetX
      @scrollView.scrollTo
        left : (offset - thumbSize / 2) / @getWidth() * scrollWidth


  show:->

    @getDelegate().emit 'ScrollTrackShown', @type
    @unsetClass 'invisible'


  hide:->

    @getDelegate().emit 'ScrollTrackHidden', @type
    @setClass 'invisible'

