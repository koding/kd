KDView = require './../../core/view.coffee'
KDButtonView = require './buttonview'

module.exports = class KDButtonBar extends KDView
  constructor: (options = {}, data) ->
    options.cssClass = KD.utils.curry "formline button-field clearfix", options.cssClass

    super options, data

    @buttons = {}

    { buttons } = options

    for buttonOptions in @utils.objectToArray buttons
      button = @createButton buttonOptions
      @addSubView button
      @buttons[buttonOptions.key] = button

  _itemClass: KDButtonView

  createButton:(options)->
    options or= {}
    options.itemClass or= @_itemClass
    o = $.extend {}, options
    delete o.itemClass
    button = new options.itemClass o
