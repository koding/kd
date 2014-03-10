KDFileUploadListView = require './fileuploadlistview.coffee'

module.exports = class KDFileUploadThumbListView extends KDFileUploadListView
  constructor:(options,data)->
    options.itemClass ?= KDFileUploadThumbItemView
    super options,data
    @setClass "kdfileuploadthumblist"
