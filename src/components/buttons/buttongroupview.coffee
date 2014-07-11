KDView = require './../../core/view.coffee'

### *
 * # KDButtonGroupView
 *
 * A view that creates buttons in a group.
 *
 * ## Usage
 *
 * ```coffee
 * view = new KDButtonGroupView
 *   buttons:
 *     "Button One!":
 *       cssClass: "clean-red"
 *       callback: ->
 *         new KDNotificationView
 *           content: "You clicked the red button, we're doomed!"
 *     "Button Two!"
 *       cssClass: "cupid-green"
 *       callback: ->
 *         new KDNotificationView
 *           content: "You clicked the green button, we're saved!"
 *
 * appView.addSubView view
 * ```
 *
 * In this example we create a `KDButtonGroupView` and pass in a options object.
 * This buttons object has a key `"buttons"`, with the value of an object also.
 *
 * Each key in the buttons object is a button title, and the value for that key is
 * the settings for that button. So, in the above example `"Button One!"` is the
 * title of a button, and the object within are settings passed directly to the
 * button being created.
 *
 * `KDButtonGroupView` will take these button objects, and create instances of
 * KDButtonView for each one.
###
module.exports = class KDButtonGroupView extends KDView

  ###*
   * Options supports the following keys:
   * - **options.buttons**: An object containing settings for the
   *  KDButtonViews that KDButtonGroupView will create. Each key is the
   *  title of a button to be created, and the value is yet another object
   *  that will be given as options to the KDButtonView.
   *
   * @param {Object} options
   * @param {Object} data
  ###
  constructor:(options = {},data)->

    {cssClass} = options
    cssClass   = if cssClass then " #{cssClass}" else ""
    options.cssClass   = "kdbuttongroup#{cssClass}"
    options.buttons  or= {}

    super options,data
    @buttons = {}
    @createButtons options.buttons

  createButtons:(allButtonOptions)->

    for own buttonTitle, buttonOptions of allButtonOptions
      buttonClass = buttonOptions.buttonClass or KDButtonView
      buttonOptions.title = buttonTitle
      buttonOptions.style = ""
      @addSubView @buttons[buttonTitle] = new buttonClass buttonOptions
      @buttons[buttonTitle].on "click", (event)=>
        @buttonReceivedClick @buttons[buttonTitle], event

  buttonReceivedClick:(button, event)->
    for own title, otherButton of @buttons
      otherButton.unsetClass "toggle"
    button.setClass "toggle"



