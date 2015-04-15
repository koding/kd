KD = require '../../core/kd'
KDView = require '../../core/view'

module.exports = class KDSpotlightView extends KDView

  constructor:(options = {}, data)->

    options.cssClass     = KD.utils.curry "kdspotlightview", options.cssClass
    options.margin      ?= 50
    options.radial      ?= yes
    options.isRemovable ?= yes

    super options, data

    @setClass "shadow"  unless options.radial
    @createElements()
    @appendToDomBody()

  createElements: ->
    {isRemovable} = @getOptions()

    for position, boundaries of @getBoundaries()
      { width, height, top, left } = boundaries
      if width > 0 and height > 0
        view       = new KDView
          cssClass : KD.utils.curry "kdoverlay", position
          position : { top,   left   }
        view.setWidth width
        view.setHeight height

        if isRemovable
          view.on "click", =>
            @destroy()
            @emit "OverlayDestroyed"

        @addSubView view

  getBoundaries: ->
    {radial}     = @getOptions()
    delegate     = @getDelegate()
    top          = delegate.getY()
    left         = delegate.getX()
    width        = delegate.getWidth()
    height       = delegate.getHeight()
    margin       = @getOption "margin"
    windowWidth  = window.innerWidth
    windowHeight = window.innerHeight
    width        = height = Math.min width, height  if radial
    topHeight    = top  - margin
    leftWidth    = left - margin
    bottomHeight = windowHeight - (top + height + margin)
    boundaries   =
      top        :
        top      : 0
        left     : 0
        width    : windowWidth
        height   : topHeight
      left       :
        top      : topHeight
        left     : 0
        width    : leftWidth
        height   : windowHeight - top + margin
      bottom     :
        top      : top + height + margin
        left     : leftWidth
        width    : windowWidth - left + margin
        height   : bottomHeight
      right      :
        top      : topHeight
        left     : left + width + margin
        width    : windowWidth  - (left + width + margin)
        height   : windowHeight - (bottomHeight + topHeight)
      main       :
        top      : topHeight
        left     : leftWidth
        width    : width  + margin + margin
        height   : height + margin + margin

    return boundaries
