debug = require('debug') 'kd:buttons:buttonview'
$ = require 'jquery'
KD = require '../../core/kd'
KDView       = require '../../core/view'
KDLoaderView = require '../loader/loaderview'

###*
 * KDButtonView implements a `<button>` DOM element, with the ability to subscribe
 * to click events.
 *
 * ## Usage
 *
 * ```coffee
 * view = new KDButtonView
 *   title: 'Click me!'
 *   cssClass: 'cupid-green'
 *   callback: ->
 *     alert 'I got clicked!'
 *
 * appView.addSubView view
 * ```
 *
 * This example will render a green button, with the text `"Click me!"`. When the
 * button is pressed by the user, an alert will pop up with the message `"I got
 * clicked!"`
 *
 * While this example is fine for an immediate action, what if we wanted our
 * button to load a project? For that, we tell the button to use a
 * [KDLoaderView](./kdloaderview.md). Lets see how this looks.
 *
 * ```coffee
 * view = new KDButtonView
 *   title: 'Take a long time.'
 *   cssClass: 'clean-red'
 *   loader: {}
 *   callback: ->
 *     longTimeDone = =>
 *       @hideLoader()
 *     setTimeout longTimeDone, 2000
 *
 * appView.addSubView view
 * ```
 *
 * In this example, a couple things are different. First, we define a loader
 * object. This is an object full of options that are passed to a
 * [KDLoaderView](./kdloaderview.md) instance. You'll note that we don't actually
 * define any options, but the empty object will cause a loader to be used with
 * the default options.
 *
 * Secondly, in our callback we turn the loader off with the
 * [hideLoader](#hideloader) method, after a `setTimeout` of 2000.
 *
 * The end result of these changes is that when our button is clicked, it starts
 * the loader *(with the options we define)*. When we want to turn it off, we call
 * the `@hideLoader()` method. Easy!
 *
 * ## Styling
 *
 * While not complete, the following list contains some useful built-in
 * css classes to style your button with.
 *
 * - **small-gray**: A small, gray button.
 * - **small-blue**: A small, blue button.
 * - **clean-gray**: A clean gray button, the default button style.
 * - **clean-red**: A clean red button.
 * - **cupid-green**: A green button.
 * - **transparent**: And no surprise, a transparent button.
###
module.exports = class KDButtonView extends KDView

  ###*
   * Options supports the following keys:
   * - **options.title**: The title of the button.
   * - **options.callback**: The function to be called when the button is pressed.
   * - **options.loader**: The options to use for a loader on this button. If
   *   false, this button will not use a loader by default. See
   *   KDLoaderView for the supported options.
   *
   * @param {Object} options
   * @param {Object} data
  ###
  constructor:(options = {}, data)->

    options.callback  or= KD.noop       # a Function
    options.title     or= ""            # a String
    # options.style     or= "clean-gray"  # a String of one of button styles ==> DEPRECATE THIS
    options.type      or= "button"      # a String of submit, reset, button
    options.cssClass  or= options.style or= "clean-gray"            # a String
    options.icon       ?= no            # a Boolean value
    options.iconOnly   ?= no            # a Boolean value
    options.iconClass or= ""            # a String
    options.disabled   ?= no            # a Boolean value
    options.hint      or= null          # a String of HTML ---> not yet implemented
    options.loader     ?= no

    super options,data

    @setClass options.style

    @setCallback options.callback
    @setTitle options.title
    @setIconClass options.iconClass if options.iconClass
    @showIcon()                     if options.icon or options.iconOnly
    @setIconOnly options.iconOnly   if options.iconOnly
    @disable()                      if options.disabled

    if options.focus
      @once "viewAppended", @bound "setFocus"

    if options.loader
      @once "viewAppended", @bound "setLoader"

  setFocus:-> @$().trigger 'focus'

  setDomElement:(cssClass)->
    {lazyDomId, tagName} = @getOptions()

    if lazyDomId
      el = document.getElementById lazyDomId
      for klass in "kdview #{cssClass}".split ' ' when klass.length
        el.classList.add klass

    unless el?
      debug "missing lazy dom element #{lazyDomId}"  if lazyDomId
      el =
      """
      <button type='#{@getOptions().type}' class='kdbutton #{cssClass}' id='#{@getId()}'>
        <span class='icon hidden'></span>
        <span class='button-title'>Title</span>
      </button>
      """

    @domElement = $ el


  setTitle:(title)->
    @buttonTitle = title
    @$('.button-title').html title

  getTitle:-> @buttonTitle

  setCallback:(callback)->
    @buttonCallback = callback

  getCallback:-> @buttonCallback

  showIcon:->
    @setClass "with-icon"
    @$('span.icon').removeClass 'hidden'

  hideIcon:->
    @unsetClass "with-icon"
    @$('span.icon').addClass 'hidden'

  setIconClass:(iconClass)->
    @$('.icon').attr 'class','icon'
    @$('.icon').addClass iconClass
    # @setClass iconClass

  setIconOnly:->
    @unsetClass "with-icon"
    @$().addClass('icon-only')
    $icon = @$('span.icon')
    @$().html $icon

  setLoader:->
    @setClass "w-loader"
    {loader} = @getOptions()
    loaderSize = @getHeight()/2
    @loader = new KDLoaderView
      size          :
        width       : loader.diameter  ? loaderSize
      loaderOptions :
        color       : loader.color    or "#ffffff"
        shape       : loader.shape    or "spiral"
        diameter    : loader.diameter  ? loaderSize
        density     : loader.density   ? 30
        range       : loader.range     ? 0.4
        speed       : loader.speed     ? 1.5
        FPS         : loader.FPS       ? 24

    @addSubView @loader, null, yes
    @loader.$().css
      position    : "absolute"
      left        : loader.left or "50%"
      top         : loader.top or "50%"
      marginTop   : -(loader.diameter/2)
      marginLeft  : -(loader.diameter/2)
    @loader.hide()

    @showLoader()  if loader.show

  ###*
   * Show the KDLoaderView on this button, if any. Note that the loader is
   * shown by default when the button is clicked.
  ###
  showLoader:->

    unless @loader
      debug 'missing loader'

    {icon, iconOnly} = @getOptions()
    @setClass "loading"
    @loader.show()
    @hideIcon() if icon and not iconOnly

  ###*
   * Hide the KDLoaderView on this button, if any.
  ###
  hideLoader:->

    unless @loader
      debug 'missing loader'

    {icon, iconOnly} = @getOptions()
    @unsetClass "loading"
    @loader.hide()
    @showIcon() if icon and not iconOnly

  disable:-> @$().attr "disabled", yes

  enable:-> @$().attr "disabled", no

  focus:-> @$().trigger "focus"

  blur:-> @$().trigger "blur"

  click:(event)->

    return @utils.stopDOMEvent()  if @loader?.active

    @showLoader()          if @loader and not @loader.active
    @utils.stopDOMEvent()  if @getOption('type') is "button"

    @getCallback().call @, event

    return no

  triggerClick:-> @doOnSubmit()
