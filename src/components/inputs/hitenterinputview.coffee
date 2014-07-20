###
todo:

  - on enter should validation fire by default??? Sinan - 6/6/2012

###


###*
 * KDHitEnterInputView is convenience KDInputView. It creates a
 * simple input view and when the user presses enter, the callback is fired with
 * the value.
 *
 * ## Usage
 *
 * ```coffee
 * view = new KDHitEnterInputView
 *   type: 'text'
 *   name: 'enterinput'
 *   placeholder: 'Type something here, and hit enter!'
 *   callback: (value) ->
 *     new KDNotificationView
 *       content: "You wrote: #{value}"
 *
 * appView.addSubView view
 * ```
 *
 * In this example we create an input text view. When the user presses enter in
 * your text field, a notification pops up with the string that the user wrote.
###
KDInputView = require './inputview.coffee'

module.exports = class KDHitEnterInputView extends KDInputView

  ###*
   * Options supports the following keys.
   * - **options.type**: The type of this input field. Useful values are
   *   `"textarea"` and `"text"`. Defaults to `"textarea"`
   * - **options.callback**: A function, called when the user presses enter within
   *   the input field. Defaults to `null`
   *
   * @param {Object} options
   * @param {Object} data
  ###
  constructor:(options = {}, data)->

    options.type            or= "textarea"
    options.button          or= null
    options.showButton       ?= no
    options.label           or= null
    options.placeholder     or= ""
    options.callback        or= null
    options.togglerPartials or= ["quick update disabled","quick update enabled"]

    super options,data

    @setClass "hitenterview"

    @button = @getOptions().button ? null
    @enableEnterKey()
    @setToggler() if options.label?
    @disableEnterKey() if @getOptions().showButton

    @on "ValidationPassed", =>
      @blur()
      @getOptions().callback?.call @,@getValue()

  ###*
   * Enable the callback on enter key.
  ###
  enableEnterKey:->
    @setClass "active"
    @hideButton() if @button
    @inputEnterToggler.$().html(@getOptions().togglerPartials[1]) if @inputEnterToggler?
    @enterKeyEnabled = yes

  ###*
   * Disable the callback on enter key.
  ###
  disableEnterKey:->
    @unsetClass "active"
    @showButton() if @button
    @inputEnterToggler.$().html(@getOptions().togglerPartials[0]) if @inputEnterToggler?
    @enterKeyEnabled = no

  setToggler:->
    o = @getOptions()
    @inputEnterToggler = new KDCustomHTMLView
      tagName  : "a"
      cssClass : "hitenterview-toggle"
      partial  : if o.showButton then o.togglerPartials[0] else o.togglerPartials[1]
      click    : @bound "toggleEnterKey"

    @inputLabel.addSubView @inputEnterToggler

  hideButton:-> @button.hide()

  showButton:-> @button.show()

  toggleEnterKey:->
    if @enterKeyEnabled then @disableEnterKey() else @enableEnterKey()

  keyDown:(event)->
    if event.which is 13 and (event.altKey or event.shiftKey) isnt true and @enterKeyEnabled
      event.preventDefault()
      @emit "EnterPerformed"
      @validate()
      no
    else if event.which is 27 # escape
      @emit "EscapePerformed"
