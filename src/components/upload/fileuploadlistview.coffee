KDListView = require './../list/listview.coffee'

module.exports = class KDFileUploadListView extends KDListView
  constructor:(options,data)->
    options.itemClass ?= KDFileUploadItemView
    super options,data
    @setClass "kdfileuploadlist"
    @itemsByName = {}

  addItem:(file)->
    itemInstance = new (@getOptions().itemClass) {delegate : @},file
    @getDelegate().on "removeFile", @getDelegate().removeFile
    @addItemView itemInstance
    @itemsByName[file.name] = itemInstance
