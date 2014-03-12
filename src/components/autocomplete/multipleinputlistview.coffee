KDListView           = require './../list/listview.coffee'
MultipleListItemView = require './multiplelistitemview.coffee'

module.exports = class MultipleInputListView extends KDListView
  setDomElement: ->
    @domElement = $ "<p class='search-tags clearfix'></p>"

  addItems: (items) ->
    for item in items
      newItem = new MultipleListItemView {delegate: @}, item
      @addItemView newItem

  removeListItem: (instance) ->
    super instance
    @getDelegate().inputRemoveValue instance.getData()
