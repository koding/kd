KD = require '../../core/kd'
KDListView = require '../list/listview'

module.exports = class JTreeView extends KDListView

  constructor:(options = {}, data)->

    options.animated ?= no
    options.cssClass  = KD.utils.curry 'jtreeview expanded', options.cssClass

    super options, data


  toggle:(callback)->

    if @expanded then @collapse callback else @expand callback


  expand:(callback)->

    if @getOptions().animated
      @$().slideDown 150, =>
        @setClass "expanded"
        callback?()
    else
      @show()
      @setClass "expanded"
      callback?()


  collapse:(callback)->

    if @getOptions().animated
      @$().slideUp 100, =>
        @unsetClass "expanded"
        callback?()
    else
      @hide()
      @unsetClass "expanded"
      callback?()


  mouseDown:->

    KD.getSingleton("windowController").setKeyView this
    no


  keyDown:(event)->

    @emit "KeyDownOnTreeView", event


  destroy:->

    KD.getSingleton("windowController").revertKeyView this

    super
