KDListItemView = require './../list/listitemview.coffee'

module.exports = class KDFileUploadListItemView extends KDListItemView
  constructor:(options,data)->
    super options,data
    @setClass "kdfileuploadlistitem clearfix"
    @active = no

  click:(e)->
    if $(e.target).is "span.iconic.x"
      @emit "removeFile", orgEvent : e

  viewAppended:->
    @$().append @partial @data

  partial:(file)->
    $ "<span class='file-title'>#{file.name}</span>
       <span class='file-size'>#{(file.size / 1024).toFixed(2)}kb</span>
       <span class='x'></span>"
