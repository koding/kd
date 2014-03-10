KDListItemView = require './../list/listitemview.coffee'

module.exports = class KDFileUploadThumbItemView extends KDListItemView
  constructor:(options,data)->
    super options,data
    @setClass "kdfileuploadthumbitem clearfix"
    @active = no

  click:(e)->
    if $(e.target).is "span.iconic.x"
      @emit "removeFile", orgEvent : e

  viewAppended:->
    @$().append @partial @data
    # @addSubView new KDInputView
    #   type          : "hidden"
    #   name          : "file-name"
    #   defaultValue  : @data.name
    # @addSubView new KDInputView
    #   type          : "hidden"
    #   name          : "file-data"
    #   defaultValue  : @data.data


  partial:(file)->
    imageType = /image.*/
    fileUrl = if file.type.match imageType then window.URL.createObjectURL file else "./a/images/icon.file.png"

    $ "<img class='thumb' src='#{fileUrl}'/>
       <p class='meta'>
        <span class='file-title'>#{file.name}</span>
        <span class='file-size'>#{(file.size / 1024).toFixed(2)}kb</span>
        <span class='close-icon'></span>
       </p>"