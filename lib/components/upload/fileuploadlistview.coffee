KDListView = require '../list/listview'
KDFileUploadListItemView = require './fileuploadlistitemview'

module.exports = class KDFileUploadListView extends KDListView
  constructor:(options,data)->
    options.itemClass ?= KDFileUploadListItemView
    super options,data
    @setClass "kdfileuploadlist"
    @itemsByName = {}

  addItem:(file)->
    itemInstance = new (@getOptions().itemClass) {delegate : @},file
    @getDelegate().on "removeFile", @getDelegate().removeFile
    @addItem itemInstance
    @itemsByName[file.name] = itemInstance
