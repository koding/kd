$ = require 'jquery'
KDListView           = require '../list/listview'
MultipleListItemView = require './multiplelistitemview'

module.exports = class MultipleInputListView extends KDListView
  setDomElement: ->
    @domElement = $ "<p class='search-tags clearfix'></p>"

  addItems: (items) ->
    for item in items
      newItem = new MultipleListItemView {delegate: @}, item
      @addItem newItem

  removeListItem: (instance) ->
    super instance
    @getDelegate().inputRemoveValue instance.getData()
