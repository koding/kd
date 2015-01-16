KDFileUploadThumbItemView = require './fileuploadthumbitemview'
KDFileUploadListView = require './fileuploadlistview'

module.exports = class KDFileUploadThumbListView extends KDFileUploadListView
  constructor:(options,data)->
    options.itemClass ?= KDFileUploadThumbItemView
    super options,data
    @setClass "kdfileuploadthumblist"
