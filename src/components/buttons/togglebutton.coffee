KDButtonView = require './buttonview.coffee'

###*
 * KDToggleButton is a KDButtonView that has a state of on or off, which can
 * be toggled.
 *
 * ## Usage
 *
 * ```coffee
 * view = new KDToggleButton
 *   defaultState: 'foo'
 *   states: [
 *     {title: 'foo', callback: -> @toggleState()}
 *     {title: 'bar', callback: -> @toggleState()}
 *   ]
 *
 * appView.addSubView view
 * ```
 *
 * In this example we are creating a button with two states, `"foo"` and `"bar"`.
 * Each state in the `states` list is an object with varying properties, two of
 * which *(`title` and `callback`)* are required.
 *
 * In this example, when a user clicks out ToggleButton, we use the method
 * toggleState to cycle through the states of the view.
###
module.exports = class KDToggleButton extends KDButtonView

  ###*
   * Options supports the following keys:
   * - **options.defaultState**: The title of the default state that this
   *  button will use
   *   when rendered.
   * - **options.states**: A list of state objects, containing a `title` and
   *  `callback` key.
   *    - Example:
   *      ```
   *      [{title: 'State 1', callback: ->}, {title: 'State 2', callback: ->}]
   *      ```
   *
   * @param {Object} options
   * @param {Object} data
  ###
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

  ###*
   * Cycle through the states of this button. Note that this supports any
   * number of states, not just two as the name implies.
   *
   * @param {Object} err An error object. If present, a warning with the
   *  error details will be raised.
  ###
  toggleState:(err)->

    {states}  = @getOptions()
    nextState = states[@stateIndex + 1] or states[0]
    unless err
      @setState nextState.title
    else
      unless err.name is 'AccessDenied'
        warn err.message or \
          "There was an error, couldn't switch to #{nextState.title} state!"

    @hideLoader?()
