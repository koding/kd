KDView = require './../../core/view.coffee'

module.exports = class KDOverlayView extends KDView

  constructor: (options = {}, data) ->

    options.isRemovable      ?= yes
    options.animated         ?= no
    options.color            ?= no
    options.transparent      ?= no
    options.opacity          ?= 0.5
    options.appendToDomBody  ?= yes
    options.cssClass          = KD.utils.curry "kdoverlay", options.cssClass

    super options, data

    @setClass "animated"    if options.animated
    @setClass "transparent" if options.transparent

    if options.color
      @setStyle
        backgroundColor : options.color
        opacity         : options.opacity

    if options.container instanceof KDView
      options.container.addSubView this
      @setCss "position", "absolute"
    else if options.appendToDomBody
      @appendToDomBody()

    if options.animated
      @utils.defer => @setClass "in"
      @utils.wait 300, =>
        @emit "OverlayAdded", this
    else
      @emit "OverlayAdded", this

    if options.isRemovable
      if options.animated
        @once "click", =>
          @unsetClass "in"
          @utils.wait 300, => @remove()
      else
        @once "click", => @remove()

  remove: ->
    @emit "OverlayWillBeRemoved"
    @destroy()
    @emit "OverlayRemoved", this
