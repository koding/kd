$ = require 'jquery'
KDButtonView = require '../buttons/buttonview'
KDCustomHTMLView = require '../../core/customhtmlview'
KDView = require '../../core/view'
KDNoAutocompleteInputView = require './noautocompleteinputview'

module.exports = class NoAutocompleteMultipleListView extends KDView
  constructor: (options, data) ->
    options ?= {}
    defaults =
      cssClass: 'common-view input-with-extras'
    options = $.extend defaults, options
    super options, data

  viewAppended: ->
    {icon,input,button} = @options

    if icon
      @setClass "with-icon"
      options =
        tagName  : "span"
        cssClass : "icon #{icon}"
      @addSubView @icon   = new KDCustomHTMLView options

    if input
      @addSubView @input  = new KDNoAutocompleteInputView input

    if button
      defaults =
        callback:(event)=>
          event.preventDefault()
          event.stopPropagation()
          @input.inputAddCurrentValue()

      button = $.extend defaults, button
      @addSubView @button = new KDButtonView button
