JsPath         = require 'jspath'
KDAutoComplete = require './autocomplete'

module.exports = class KDSimpleAutocomplete extends KDAutoComplete
  addItemToSubmitQueue: (item) ->
    itemValue = JsPath.getAt item.getData(), @getOptions().itemDataPath
    @setValue itemValue

  keyUp: (event) ->
    return if event.keyCode is 13
    super

  showNoDataFound: ->
    @dropdown.removeAllItems()
    @hideDropdown()

