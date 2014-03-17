KDScrollView = require './../../core/scrollview.coffee'

module.exports = class KDSplitViewPanel extends KDScrollView

  constructor:(options = {}, data)->

    options.fixed  ?= no
    options.view  or= null

    super options, data

    {type} = @getOptions()

    @vertical = type.toLowerCase() is "vertical"

    {@fixed, @size, @index} = @getOptions()


  _getSize:-> if @vertical then @getWidth() else @getHeight()


  _setSize:(size)->
    if @_wouldResize size
      size = 0 if size < 0
      if @vertical then @setWidth size else @setHeight size
      @parent.sizes[@index] = @size = size
      @parent.emit "PanelDidResize", panel: @
      @emit "PanelDidResize", newSize : size
      size
    else
      no

  _wouldResize:(size)->
    minimum = @parent.minimums[@index] ? 0
    maximum = @parent.maximums[@index] ? 999999

    if maximum > size > minimum
    then yes
    else
      if size < minimum
        @parent._panelReachedMinimum @index
      else if size > maximum
        @parent._panelReachedMaximum @index
      no


  _setOffset:(offset)->

    offset = Math.max offset, 0
    if @vertical then @setX offset else @setY offset


  _getOffset:->

    if @vertical
    then parseInt @getElement().style.left, 10
    else parseInt @getElement().style.top, 10
