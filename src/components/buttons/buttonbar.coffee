KDView = require './../../core/view.coffee'

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

  createButton:(options)->
    options.itemClass or= KDButtonView
    o = $.extend {}, options
    delete o.itemClass
    button = new options.itemClass o
