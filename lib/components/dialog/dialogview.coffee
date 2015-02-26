$ = require 'jquery'
KD = require '../../core/kd'
KDView        = require '../../core/view'
KDOverlayView = require '../overlay/overlayview'
KDButtonView  = require '../buttons/buttonview'

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

    $(window).one "keydown.kddialogview",(event) =>
      @hide()  if event.which is 27


  show:->

    KD.utils.defer =>

      @overlay?.destroy()

      {container} = @getOptions()
      @overlay = new KDOverlayView
        click     : @bound 'hide'
        container : container

      @setClass 'in'


  hide:->

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
      loader      : buttonOptions.loader
      style       : buttonOptions.style
      callback    : buttonOptions.callback

    @buttons[title] = button


  destroy: ->

    $(window).off "keydown.kddialogview"
    super
