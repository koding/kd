$ = require 'jquery'
KD = require '../../core/kd'
KDInputValidator = require './inputvalidator'
KDView             = require '../../core/view'
KDNotificationView = require '../notifications/notificationview'
Encoder            = require 'htmlencode'

module.exports = class KDContentEditableView extends KDView

  constructor: (options = {}, data) ->
    options.cssClass         = KD.utils.curry "kdcontenteditableview", options.cssClass
    options.bind             = KD.utils.curry "click input paste drop focus blur", options.bind
    options.type           or= "text"
    options.multiline       ?= off
    options.placeholder    or= ""
    options.tabNavigation   ?= no

    super options, data

    @getDelegate()?.on "EditingModeToggled", (state) => @setEditingMode state

    # we shouldn't do per instance
    # quick hack unf - SY
    document.addEventListener 'focus', (event)=>
      @focus()  if event.target is @editableElement
    , yes

    document.addEventListener 'blur', (event)=>
      @blur()  if event.target is @editableElement
    , yes

    @validationNotifications = {}

  viewAppended: ->
    @setEditingMode off
    super

  getEditableElement: ->
    unless @editableElement
      if @getData()
        @editableElement = @getElement().children[0]
      else
        @editableElement = document.createElement "div"
        @getDomElement().append @editableElement

    return  @editableElement

  getEditableDomElement: ->
    @editableDomElement = $ @getEditableElement() unless @editableDomElement
    return  @editableDomElement

  setEditingMode: (state) ->
    @editingMode = state
    @getEditableElement().setAttribute "contenteditable", state

    if @getValue() is ""
      if @editingMode and @getOptions().placeholder then @setPlaceholder()
      else @unsetPlaceholder()

  getValue: (forceType) ->
    {type, placeholder} = @getOptions()
    element             = @getEditableElement()
    type                = forceType if forceType

    switch type
      when "text" then value = element.textContent
      when "html" then value = element.innerHTML

    if value is Encoder.htmlDecode(placeholder) then "" else value.trim()

  setContent: (content) ->
    {type} = @getOptions()

    element = @getEditableElement()
    if content
      switch type
        when "text" then element.textContent = content
        when "html" then element.innerHTML = content
    else if @editingMode and content is "" then @setPlaceholder()

  focus: ->
    @unsetPlaceholder() if @getValue().length is 0
    @getEditableDomElement().trigger 'focus'

    windowController = KD.getSingleton 'windowController'
    windowController.addLayer this
    @setKeyView()

    @once "ReceivedClickElsewhere", @bound 'blur' unless @focused
    @focused = yes
    @getOptions().focus?()

  blur: ->
    @focused = no

    windowController = KD.getSingleton 'windowController'
    windowController.removeLayer this
    @unsetKeyView()

    if @getValue('text').length is 0
      @setPlaceholder()
    else
      @setContent @getValue() if @getOptions().type isnt 'html'

    @emit 'BlurHappened'

  click: => @focus() if @editingMode and not @focused

  input: (event) =>
    @emit "ValueChanged", event

  keyDown: (event) =>
    {tabNavigation, multiline, validate} = @getOptions()

    switch event.which
      when 9  then KD.utils.stopDOMEvent event  if tabNavigation
      when 13 then KD.utils.stopDOMEvent event

    switch event.which
      when 9 # Tab key
        break  unless tabNavigation
        @blur()
        if event.shiftKey then @emit "PreviousTabStop"
        else @emit "NextTabStop"
      when 13 # Enter key
        if @getOptions().multiline then @appendNewline()
        else @emit "EnterPressed"

    value = @getValue()
    maxLength = @getOptions().validate?.rules?.maxLength or 0

    if event.which is 13 or (maxLength > 0 and value.length == maxLength)
      event.preventDefault()
    else if value.length is 0
      @unsetPlaceholder()
      @focus()  if event.target isnt @getEditableElement()

  paste: (event) ->
    event.preventDefault()
    text = event.originalEvent.clipboardData.getData "text/plain"
    document.execCommand "insertText", no, text

  drop: (event) ->
    event.preventDefault()
    text = event.originalEvent.dataTransfer.getData "text/plain"
    {originalEvent: {clientX, clientY}} = event

    if @getValue() is ""
      startOffset = 0
      @unsetPlaceholder()

    {commonAncestorContainer, startOffset, endOffset} = document.caretRangeFromPoint clientX, clientY
    @utils.replaceRange commonAncestorContainer, text, startOffset

  setPlaceholder: ->
    @setClass "placeholder"
    placeholder = @getOptions().placeholder
    @setContent placeholder if placeholder

  unsetPlaceholder: ->
    @unsetClass "placeholder"

    content      = ""
    defaultValue = @getOptions().defaultValue
    value        = @getValue()

    if @editingMode then content = value or ""
    else content = value or defaultValue or ""

    element = @getEditableDomElement()
    element.text ""
    element.append document.createTextNode content

  validate: (event) ->
    valid = yes
    for own name, rule of @getOptions().validate?.rules or {}
      validator = KDInputValidator["rule#{name.capitalize()}"]
      if validator and message = validator @, event
        valid = no
        @notify message,
          title    : message
          type     : "mini"
          cssClass : "error"
          duration : 2500
        break
    return  valid

  notify: (message, options) ->
    @validationNotifications[message] = notice = new KDNotificationView options
    notice.on "KDObjectWillBeDestroyed", =>
      message = notice.getOptions().title
      delete @validationNotifications[message]

  appendNewline: ->
    selection = window.getSelection()
    count     = if selection.baseNode.length is selection.focusOffset then 1 else 0
    range     = selection.getRangeAt 0
    range.insertNode newline = document.createElement "br" for i in [0..count]
    @utils.selectEnd newline

  viewAppended: ->
    super
    @unsetPlaceholder() if not @editingMode and @getValue().length is 0
