debug = require('debug') 'kd:inputs:inputview'
$ = require 'jquery'
KD = require '../../core/kd'
KDNotificationView = require '../notifications/notificationview'
KDView           = require '../../core/view'
KDInputValidator = require './inputvalidator'
Encoder          = require 'htmlencode'

###*
 * The base input field view. Similar to the classic `<input type="foo">`
 * element, but with additional options such as validation.
 *
 * ## Usage
 *
 * ```coffee
 * view = new KDInputView
 *   placeholder: 'Type something here for an inspiring message!'
 *
 * view.on 'keyup', (e) ->
 *   if e.keyCode is 13 #13==Enter
 *     new KDNotificationView
 *       content: "You said #{e.target.value}!"
 *
 * appView.addSubView view
 * ```
 *
 * Create a simple text input view, with a placeholder. When the `keyup`
 * event is fired, we check what the key is. If the keyCode is `13`
 * *(An Enter key)*, we create a notification with the value of the field.
###
module.exports = class KDInputView extends KDView

  ###*
   * Options supports the following keys.
   * - **options.type**: The type of this input. All html input types are
   *   supported. It should be noted that `"textarea"` and `"select"` do not
   *   create `<input>` elements, but rather they create `<textarea>` and
   *   `<select>` respectively.
   *
   *   Supports the options `"text"`, `"password"`, `"hidden"`, `"checkbox"`,
   *   `"range"`, `"textarea"`, and `"select"`.
   * - **options.name**: The `name="foo"` attribute of this `<input>` element.
   * - **options.label**: The label instance for this input field.
   * - **options.defaultValue**: The default value for this instance.
   * - **options.placeholder**: The HTML5 placeholder for this input.
   * - **options.disabled**: Whether or not this input is disabled. Defaults to
   *   `false`
   * - **options.selectOptions**: If this input is of the type `"select"`, this
   *   list populates the select options. Defaults to `null`
   * - **options.validate**: An object containing validation options, which are
   *   passed to the KDInputValidator for this input. Note that the validator is
   *   created internally, you do not need to create it. Defaults to `null`
   * - **options.autogrow**: If the input type can grow, such as a `textarea`,
   *   this will cause the input to grow to the content size, rather than scroll.
   *   Defaults to `false`
   * - **options.bind**: A string of event names, separated by a space. Defaults
   *   to `" blur change focus"`
   * - **options.forceCase**: Force either uppercase, or lowercase for this field
   *   type. If `null`, case is not enforced. Supports the options: `"uppercase"`,
   *   `"lowercase"`, `null`
   *
   * @param {Object} options
   * @param {Object} data
  ###
  constructor:(o = {}, data)->

    o.type                    or= "text"        # a String of one of input types "text","password","select", etc...
    o.name                    or= ""            # a String
    o.label                   or= null          # a KDLabelView instance
    o.cssClass                or= ""            # a String
    o.callback                or= null          # a Function
    o.defaultValue             ?= ""            # a String or a Boolean value depending on type
    o.placeholder             or= ""            # a String
    o.disabled                 ?= no            # a Boolean value
    # o.readonly               ?= no            # a Boolean value
    o.selectOptions           or= null          # an Array of Strings
    o.validate                or= null          # an Object of Validation options see KDInputValidator for details
    o.decorateValidation       ?= yes            # a Boolean value
    o.hint                    or= null          # a String of HTML
    o.autogrow                 ?= no            # a Boolean
    o.enableTabKey             ?= no            # a Boolean # NOT YET READY needs some work
    o.forceCase               or= null          # a String of either "lowercase" or "uppercase"
    o.bind                      = KD.utils.curry 'blur change focus paste cut input copy', o.bind

    @setType o.type

    super o, data

    options = @getOptions()

    @validationNotifications = {}
    @valid = yes
    @inputCallback = null
    @previousHeight= null
    @setName options.name
    @setLabel()
    @setCallback()
    @setDefaultValue options.defaultValue
    @setPlaceholder options.placeholder
    @makeDisabled() if options.disabled
    if options.selectOptions? and 'function' isnt typeof options.selectOptions
      @setSelectOptions options.selectOptions
    @setAutoGrow() if options.autogrow
    @enableTabKey() if options.enableTabKey
    @setCase options.forceCase if options.forceCase

    if options.required
      do (v = options.validate ?= {}) ->
        v.rules ?= {}
        v.messages ?= {}
        v.rules.required = yes
        v.messages.required = options.required

    @setValidation options.validate  if options.validate


    @bindValidationEvents()

    if options.type is "select" and options.selectOptions
      @on "viewAppended", =>
        o = @getOptions()
        if 'function' is typeof o.selectOptions
          kallback = @bound "setSelectOptions"
          o.selectOptions.call @, kallback
        else unless o.selectOptions.length
          @setValue o.selectOptions[Object.keys(o.selectOptions)[0]][0].value unless o.defaultValue
        else
          @setValue o.selectOptions[0].value unless o.defaultValue

    if o.autogrow
      @once "focus", =>
        @initialHeight = @$().height()  unless @initialHeight

  setDomElement:(cssClass = "")->
    name = "name='#{@options.name}'"
    @domElement = switch @getType()
      when "text"     then $ "<input #{name} type='text' class='kdinput text #{cssClass}'/>"
      when "password" then $ "<input #{name} type='password' class='kdinput text #{cssClass}'/>"
      when "hidden"   then $ "<input #{name} type='hidden' class='kdinput hidden #{cssClass}'/>"
      when "checkbox" then $ "<input #{name} type='checkbox' class='kdinput checkbox #{cssClass}'/>"
      when "textarea" then $ "<textarea #{name} class='kdinput text #{cssClass}'></textarea>"
      when "select"   then $ "<select #{name} class='kdinput select #{cssClass}'/>"
      when "range"    then $ "<input #{name} type='range' class='kdinput range #{cssClass}'/>"
      else                 $ "<input #{name} type='#{@getType()}' class='kdinput #{@getType()} #{cssClass}'/>"

  bindValidationEvents:->
    @on "ValidationError", @bound "giveValidationFeedback"
    @on "ValidationPassed", @bound "giveValidationFeedback"
    @on "focus", @bound "clearValidationFeedback"

  setLabel:(label = @getOptions().label)->

    return  unless label

    @inputLabel = label
    @inputLabel.$()[0].setAttribute "for", @getName()
    @inputLabel.$().bind "click",()=>
      @$().trigger "focus"
      @$().trigger "click"

  getLabel:-> @inputLabel

  setCallback:-> @inputCallback = @getOptions().callback
  getCallback:-> @inputCallback

  setType:(@inputType = "text")->
  getType:-> @inputType

  setName:(@inputName)->
  getName:-> @inputName

  setFocus:->
    (KD.getSingleton "windowController").setKeyView this
    @$().trigger 'focus'

  setBlur:->
    (KD.getSingleton "windowController").setKeyView null
    @$().trigger 'blur'

  setSelectOptions:(options)->
    unless options.length
      for own optGroup, subOptions of options
        $optGroup = $ "<optgroup label='#{optGroup}'/>"
        @$().append $optGroup
        for option in subOptions
          $optGroup.append "<option value='#{option.value}'>#{option.title}</option>"
    else if options.length
      for option in options
        @$().append "<option value='#{option.value}'>#{option.title}</option>"
    else
      debug "got invalid arguments"

    @$().val @getDefaultValue()

  setDefaultValue:(value)->
    return  if not value? and value isnt ''
    KDInputView::setValue.call this, value
    @inputDefaultValue = value

  getDefaultValue:-> @inputDefaultValue

  setPlaceholder:(value)->
    if @$().is("input") or @$().is("textarea")
      @$().attr "placeholder",value
      @options.placeholder = value

  ###*
   * Disable this input field.
  ###
  makeDisabled:->
    @getDomElement().attr "disabled","disabled"

  ###*
   * Enable this input field.
  ###
  makeEnabled:->
    @getDomElement().removeAttr "disabled"

  ###*
   * Get the value of this input field.
  ###
  getValue:->
    if @getOption("type") is "checkbox"
      value = @$().is ':checked'
    else
      value = @getDomElement().val()
      {forceCase} = @getOptions()
      if forceCase
        value = if forceCase.toLowerCase() is 'uppercase'
        then value.toUpperCase()
        else value.toLowerCase()

    return value

  ###*
   * Set the value of this input field.
  ###
  setValue:(value)->
    $el = @$()
    el  = $el[0]
    if @getOption("type") in ["checkbox", "radio"]
      if value
      then el.setAttribute "checked", "checked"
      else el.removeAttribute "checked"
    else $el.val value

  setCase:(forceCase)->
    cb = =>
      $el = @getDomElement()
      el = $el[0]
      val = @getValue()
      return if val is $el.val()

      start = el.selectionStart
      end = el.selectionEnd
      @setValue val
      # FIXME: setSelectionRange not supported in IE < 9 - need polyfill
      el.setSelectionRange(start, end) if el.setSelectionRange

    @on "keyup", cb
    @on "blur", cb

  unsetValidation:-> @setValidation {}

  setValidation:(ruleSet)->

    @valid                 = no
    @currentRuleset        = ruleSet
    @validationCallbacks or= {}
    @createRuleChain ruleSet

    for own oldEventName, oldCallbacks of @validationCallbacks
      for oldCallback in oldCallbacks
        @off oldEventName, oldCallback

    @ruleChain.forEach (rule)=>
      eventName = \
        if ruleSet.events
          if ruleSet.events[rule] then ruleSet.events[rule]
          else if ruleSet.event   then ruleSet.event
        else if ruleSet.event     then ruleSet.event

      if eventName
        @validationCallbacks[eventName] or= []
        @validationCallbacks[eventName].push cb = (event)=>
          @validate rule, event  if rule in @ruleChain

        @on eventName, cb


  validate:(rule, event = {})->

    @ruleChain          or= []
    @validationResults  or= {}
    rulesToBeValidated    = if rule then [rule] else @ruleChain
    ruleSet               = @currentRuleset or @getOptions().validate

    if @ruleChain.length > 0
      rulesToBeValidated.forEach (rule)=>
        if KDInputValidator["rule#{rule.capitalize()}"]?
          result = KDInputValidator["rule#{rule.capitalize()}"] @, event
          @setValidationResult rule, result
        else if "function" is typeof ruleSet.rules[rule]
          ruleSet.rules[rule] @, event
    else
      @valid = yes

    allClear = yes
    for own result, errMsg of @validationResults
      if errMsg then allClear = no

    @valid = if allClear then yes else no
    @emit "ValidationPassed" if @valid
    @emit "ValidationResult", @valid

    return @valid


  createRuleChain:(ruleSet)->

    {rules} = ruleSet
    @validationResults or= {}
    @ruleChain = if typeof rules is "object" then (rule for own rule,value of rules) else [rules]
    for rule in @ruleChain
      @validationResults[rule] = null


  setValidationResult:(rule, err, showNotification=yes)->

    if err
      @validationResults[rule] = err
      @showValidationError err if @getOptions().validate.notifications and showNotification
      @emit "ValidationError", err
      @valid = no
    else
      @validationResults[rule] = null
      # if there is any true on validation results' values then is not valid

      @valid = not(
        (v for own k, v of @validationResults)
        .map((result)-> Boolean result)
        .indexOf(true) > -1
      )


  showValidationError:(message)->

    @validationNotifications[message]?.destroy()

    {container, notifications} = @getOption('validate')

    if notifications?.type is 'tooltip'

      if @tooltip
        str = "- #{message}<br>#{@tooltip.getOption 'title'}"

      @unsetTooltip()

      notifications =
        cssClass  : notifications.cssClass  or 'input-validation'
        delegate  : notifications.delegate  or this
        title     : notifications.title     or str or message
        placement : notifications.placement or 'right'
        direction : notifications.direction or 'left'
        forcePosition : yes

      @validationNotifications[message] = notice = @setTooltip notifications

      notice.show()

    else if notifications

      @validationNotifications[message] = notice = new KDNotificationView
        container : container
        title     : message
        type      : 'growl'
        cssClass  : 'mini'
        duration  : 2500

    notice.on "KDObjectWillBeDestroyed", =>
      message = notice.getOptions().title
      delete @validationNotifications[message]

  clearValidationFeedback:->

    @unsetClass "validation-error validation-passed"
    @emit "ValidationFeedbackCleared"

  giveValidationFeedback:(err)->
    return  unless @getOption "decorateValidation"
    if err
      @setClass "validation-error"
    else
      @setClass "validation-passed"
      @unsetClass "validation-error"


  setCaretPosition:(pos)-> @selectRange pos, pos

  getCaretPosition:->
    el = @$()[0]
    # modern
    if el.selectionStart
      return el.selectionStart
    # ie
    else if document.selection
      el.focus()
      r = document.selection.createRange()
      return 0 unless r
      re = el.createTextRange()
      rc = re.duplicate()
      re.moveToBookmark r.getBookmark()
      rc.setEndPoint 'EndToStart', re

      return rc.text.length
    return 0

  selectAll:-> @getDomElement().select()

  selectRange:(selectionStart, selectionEnd)->

    input = @$()[0]

    if input.setSelectionRange
      input.focus()
      input.setSelectionRange selectionStart, selectionEnd

    else if input.createTextRange
      range = input.createTextRange()
      range.collapse yes
      range.moveEnd 'character', selectionEnd
      range.moveStart 'character', selectionStart
      range.select()

  setAutoGrow:->

    $input = @$()

    $input.css 'overflow', 'hidden'

    @setClass 'autogrow'

    # input content is copied into clone
    # element to get calculated height
    @_clone = $ '<div/>', class : 'invisible'

    @on 'focus', =>
      @_clone.appendTo 'body'
      @_clone.css
        height        : 'auto'
        zIndex        : 100000
        width         : $input.css 'width'
        boxSizing     : $input.css 'box-sizing'
        borderTop     : $input.css 'border-top'
        borderRight   : $input.css 'border-right'
        borderBottom  : $input.css 'border-bottom'
        borderLeft    : $input.css 'border-left'
        minHeight     : $input.css 'minHeight'
        maxHeight     : $input.css 'maxHeight'
        paddingTop    : $input.css 'padding-top'
        paddingRight  : $input.css 'padding-right'
        paddingBottom : $input.css 'padding-bottom'
        paddingLeft   : $input.css 'padding-left'
        wordBreak     : $input.css 'wordBreak'
        fontSize      : $input.css 'fontSize'
        fontWeight    : $input.css 'fontWeight'
        lineHeight    : $input.css 'lineHeight'
        whiteSpace    : 'pre-line'

    @on 'blur', => @_clone.detach()

    @on 'input', (event) => KD.utils.defer => @resize event


  resize: (event) ->

    return  unless @_clone

    @_clone.appendTo 'body' unless document.body.contains @_clone[0]
    val = @getElement().value.replace(/\n/g,'\n&nbsp;')
    safeValue = Encoder.XSSEncode val
    @_clone.html safeValue

    height = @_clone.height()

    getValue = (rule) => parseInt @_clone.css(rule), 10

    if @$().css('boxSizing') is 'border-box'
      padding = getValue('paddingTop')     + getValue('paddingBottom')
      border  = getValue('borderTopWidth') + getValue('borderBottomWidth')
      height  = height + border + padding

    newHeight = if @initialHeight then Math.max @initialHeight, height else height

    if @previousHeight isnt newHeight
      @setHeight newHeight
      @emit 'InputHeightChanged'

    @previousHeight = newHeight


  enableTabKey:-> @inputTabKeyEnabled = yes

  disableTabKey:-> @inputTabKeyEnabled = no

  change:->

  keyUp:-> yes

  keyDown:(event)->

    @checkTabKey event if @inputTabKeyEnabled
    yes

  focus:->

    @setKeyView()
    yes

  blur:->
    # this messes up things
    # if you switch between inputs on focus next input sets the keyview to itself
    # and this fires right afterwards and reverts it back to blurred one

    # hopefully fixed

    KD.getSingleton("windowController").revertKeyView @
    yes

  mouseDown:->

    @setFocus()
    #WHY NO?
    #NO because if it propagates, other stuff might become keyview
    no

  checkTabKey:(event)->
    tab = "  "
    tabLength = tab.length
    t   = event.target
    ss  = t.selectionStart
    se  = t.selectionEnd

    # // Tab key - insert tab expansion
    if event.which is 9
      event.preventDefault()
      # // Special case of multi line selection
      if ss isnt se and t.value.slice(ss,se).indexOf("n") isnt -1
        # // In case selection was not of entire lines (e.g. selection begins in the middle of a line)
        # // we ought to tab at the beginning as well as at the start of every following line.
        pre     = t.value.slice(0,ss)
        sel     = t.value.slice(ss,se).replace(/n/g,"n"+tab)
        post    = t.value.slice(se,t.value.length)
        t.value = pre.concat(tab).concat(sel).concat(post)

        t.selectionStart = ss + tab.length
        t.selectionEnd   = se + tab.length

      # // "Normal" case (no selection or selection on one line only)
      else
        t.value = t.value.slice(0,ss).concat(tab).concat(t.value.slice(ss,t.value.length))
        if ss is se
          t.selectionStart = t.selectionEnd = ss + tab.length
        else
          t.selectionStart = ss + tab.length
          t.selectionEnd   = se + tab.length

      # // Backspace key - delete preceding tab expansion, if exists
    else if event.which is 8 and t.value.slice(ss - tabLength,ss) is tab
      event.preventDefault()

      t.value = t.value.slice(0,ss - tabLength).concat(t.value.slice(ss,t.value.length))
      t.selectionStart = t.selectionEnd = ss - tab.length

    # // Delete key - delete following tab expansion, if exists
    else if event.which is 46 and t.value.slice(se,se + tabLength) is tab
      event.preventDefault()

      t.value = t.value.slice(0,ss).concat(t.value.slice(ss + tabLength,t.value.length))
      t.selectionStart = t.selectionEnd = ss

    # // Left/right arrow keys - move across the tab in one go
    else if event.which is 37 && t.value.slice(ss - tabLength,ss) is tab
      event.preventDefault()
      t.selectionStart = t.selectionEnd = ss - tabLength

    else if event.which is 39 and t.value.slice(ss,ss + tabLength) is tab
      event.preventDefault()
      t.selectionStart = t.selectionEnd = ss + tabLength
