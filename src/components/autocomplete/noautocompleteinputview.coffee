KDMultipleInputView = require './multipleinputview.coffee'

module.exports = class NoAutocompleteInputView extends KDMultipleInputView

  keyUp: (event) ->
    if event.keyCode is 13
      @inputAddCurrentValue()

  setDomElement:(cssClass)->
    {placeholder} = @getOptions()
    @domElement = $ "<div class='#{cssClass}'><input type='text' class='main' placeholder='#{placeholder or ''}' /></div>"

  addItemToSubmitQueue: (item) ->
    no
