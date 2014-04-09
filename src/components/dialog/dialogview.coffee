KDView        = require './../../core/view.coffee'
KDOverlayView = require './../overlay/overlayview.coffee'
KDButtonView  = require './../buttons/buttonview.coffee'

module.exports = class KDDialogView extends KDView

  constructor: (options = {}, data) ->

    options.cssClass    = KD.utils.curry 'kddialogview', options.cssClass
    options.offset     ?= yes
    options.container or= null
    options.buttons   or=
      Cancel            :
        style           : 'clean-red'
        callback        : @bound 'hide'

    super options, data

    @bindTransitionEnd()
    @setButtons()

  show:->

    KD.utils.defer =>

      @overlay?.destroy()

      {container} = @getOptions()
      @overlay = new KDOverlayView
        click     : @bound 'hide'
        container : container

      @setClass 'in'


  hide:->

    log 'hiding'

    @once 'transitionend', =>
      @overlay.destroy()
      @destroy()

    @unsetClass 'in'


  setButtons:->

    {buttons} = @getOptions()
    @buttons = {}
    @buttonHolder = new KDView {cssClass : "kddialog-buttons clearfix"}
    @addSubView @buttonHolder

    for own buttonTitle, buttonOptions of buttons
      @createButton buttonTitle,buttonOptions


  createButton:(title,buttonOptions)->

    @buttonHolder.addSubView button = new KDButtonView
      title       : title
      loader      : buttonOptions.loader    if buttonOptions.loader?
      style       : buttonOptions.style     if buttonOptions.style?
      callback    : buttonOptions.callback  if buttonOptions.callback?

    @buttons[title] = button
