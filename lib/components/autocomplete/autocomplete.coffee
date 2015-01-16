$ = require 'jquery'
KD = require '../../core/kd'
KDInputView = require '../inputs/inputview'

module.exports = class KDAutoComplete extends KDInputView
  mouseDown: ->
    @focus()

  setDomElement:->
    @domElement = $ "<div class='kdautocompletewrapper clearfix'><input type='text' placeholder='#{@getOptions().placeholder}' class='kdinput text'/></div>"

  setDomId:->
    @$input().attr 'id', @getDomId()
    @$input().attr 'name', @getName()
    @$input().data 'data-id', @getId()

  setDefaultValue:(value) ->
    @inputDefaultValue = value
    @setValue value

  $input:-> @$("input").eq(0)
  getValue:-> @$input().val()
  setValue:(value)-> @$input().val(value)

  bindEvents:->
    super @$input()

  blur: (event) ->
    @unsetClass 'focus'
    yes

  focus: (event) ->
    @setClass "focus"
    super

  keyDown: (event) ->
    (KD.getSingleton "windowController").setKeyView this
    yes

  getLeftOffset:->
    @$input().prev().width()

  setPlaceholder:(value)->
    @$input()[0].setAttribute "placeholder", value

  setFocus:->
    super
    @$input().trigger "focus"

  setBlur:->
    super
    @$input().trigger "blur"
