KDListItemView = require './../list/listitemview.coffee'

module.exports = class MultipleListItemView extends KDListItemView
  click: (event) ->
    if $(event.target).hasClass 'removeIcon'
      @getDelegate().removeListItem @

  setDomElement: ->
    @domElement = $ '<span />'
  partial: ->
    "#{@getData()} <cite class='removeIcon'>x</cite>"
