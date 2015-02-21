$ = require 'jquery'
KD = require '../../core/kd'
KDButtonView = require './buttonview'

module.exports = class KDToggleButton extends KDButtonView

  constructor:(options = {}, data)->

    options = $.extend
      dataPath     : null          # a JsPath String
      defaultState : null          # a String
      states       : []            # an Array of Objects in form of stateName : callback key/value pairs
    , options

    super options, data

    @setState options.defaultState

  getStateIndex:(name)->

    {states} = @getOptions()
    unless name
      return 0
    else
      for state, index in states
        if name is state.title
          return index

  decorateState:(name)->
    @setTitle @state.title
    @setIconClass @state.iconClass  if @state.iconClass?

    if @state.cssClass? or @lastUsedCssClass?
      @unsetClass @lastUsedCssClass  if @lastUsedCssClass?
      @setClass @state.cssClass
      @lastUsedCssClass = @state.cssClass
    else
      delete @lastUsedCssClass

  getState:-> @state

  setState:(name)->

    {states} = @getOptions()
    @stateIndex = index = @getStateIndex name
    @state      = states[index]
    @decorateState name

    @setCallback states[index].callback.bind @, @toggleState.bind @

  toggleState:(err)->

    {states}  = @getOptions()
    nextState = states[@stateIndex + 1] or states[0]
    unless err
      @setState nextState.title
    else
      unless err.name is 'AccessDenied'
        KD.warn err.message or \
          "There was an error, couldn't switch to #{nextState.title} state!"

    @hideLoader?()
