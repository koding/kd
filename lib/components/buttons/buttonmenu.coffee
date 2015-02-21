$ = require 'jquery'
KD = require '../../core/kd'
JContextMenuTreeView = require '../contextmenu/contextmenutreeview'
KDContextMenu = require '../contextmenu/contextmenu'

module.exports = class JButtonMenu extends KDContextMenu

  constructor:(options = {}, data)->

    options.cssClass        = @utils.curry "kdbuttonmenu", options.cssClass
    # options.type            = "buttonmenu"
    options.listViewClass or= JContextMenuTreeView
    # options.offset        or= {}
    # options.offset.top    or= 0
    # options.offset.left   or= 0

    super options, data

  viewAppended:->
    super
    @setPartial "<div class='chevron-ghost-wrapper'><span class='chevron-ghost'></span></div>"
    @positionContextMenu()

  positionContextMenu: KD.utils.debounce 10, ->

    # options       = @getOptions()
    button        = @getDelegate()
    mainHeight    = $(window).height()
    mainScroll    = $(window).scrollTop()
    buttonHeight  = button.getHeight()
    buttonWidth   = button.getWidth()
    top           = button.getY() + buttonHeight
    menuHeight    = @getHeight()
    menuWidth     = @getWidth()

    # Determine if the menu will be off screen or not
    ghostCss = if top + menuHeight > mainHeight + mainScroll
      top = button.getY() - menuHeight
      @setClass "top-menu"
      top     : "100%"
      height  : buttonHeight
    else
      top     : -(buttonHeight + 1)
      height  : buttonHeight

    @$(".chevron-ghost-wrapper").css ghostCss

    @$().css
      top       : top + mainScroll
      left      : button.getX() + buttonWidth - menuWidth

    # left here for reference to be able to put menu left or right for button menus
    # it needs some work decided to be left as TBDL - SY

    # @$().css
    #   top       : top + options.offset.top
    #   left      : button.getX() + buttonWidth - menuWidth + options.offset.left
