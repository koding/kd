class KDContentEditableView extends KDView
  constructor: (options = {}, data) ->
    options.cssClass         = KD.utils.curry "kdcontenteditableview", options.cssClass
    options.bind             = KD.utils.curry "click input keydown paste drop", options.bind
    options.type           or= "text"
    options.multiline       ?= off
    options.placeholder    or= ""
    options.tabNavigation   ?= no

    super options, data

    @getDelegate()?.on "EditingModeToggled", (state) => @setEditingMode state

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

    if value is placeholder then "" else value.trim()

  setContent: (content) ->
    {type, textExpansion} = @getOptions()
    if not @editingMode and textExpansion
      content = @utils.applyTextExpansions content, yes

    element = @getEditableElement()
    if content
      switch type
        when "text" then element.textContent = content
        when "html" then element.innerHTML = content
    else if @editingMode and content is "" then @setPlaceholder()

  focus: ->
    @unsetPlaceholder() if @getValue().length is 0
    @getEditableDomElement().trigger "focus" unless @focused

    windowController = KD.getSingleton "windowController"
    windowController.addLayer this

    @once "ReceivedClickElsewhere", @bound 'blur' unless @focused
    @focused = yes
    @getOptions().focus?()

  blur: ->
    @focused = no
    if @getValue("text").length is 0
      @setPlaceholder()
    else
      @setContent @getValue() if @getOptions().type isnt "html"

  click: => @focus() if @editingMode and not @focused

  input: (event) =>
    @emit "ValueChanged", event

  keyDown: (event) =>
    {tabNavigation, multiline, validate} = @getOptions()

    switch event.which
      when 9  then @utils.stopDOMEvent event  if tabNavigation
      when 13 then @utils.stopDOMEvent event

    switch event.which
      when 9 # Tab key
        break  unless tabNavigation
        @blur()
        if event.shiftKey then @emit "PreviousTabStop"
        else @emit "NextTabStop"
      when 13 # Enter key
        if @getOptions().multiline then @appendNewline()
        else @emit "Enter"

    value = @getValue()
    maxLength = @getOptions().validate?.rules?.maxLength or 0

    if event.which is 13 or (maxLength > 0 and value.length == maxLength)
      event.preventDefault()
    else if value.length is 0
      @unsetPlaceholder()
      @focus()  if event.target isnt @getEditableElement()

  paste: (event) ->
    event.preventDefault()
    text = @getClipboardTextNode event.originalEvent.clipboardData
    {commonAncestorContainer, startOffset, endOffset} = @utils.getSelectionRange()
    @utils.replaceRange commonAncestorContainer, text, startOffset, endOffset

  drop: (event) ->
    event.preventDefault()
    text = @getClipboardTextNode event.originalEvent.dataTransfer
    {originalEvent: {clientX, clientY}} = event

    if @getValue() is ""
      startOffset = 0
      @unsetPlaceholder()

    {commonAncestorContainer, startOffset, endOffset} = document.caretRangeFromPoint clientX, clientY
    @utils.replaceRange commonAncestorContainer, text, startOffset

  getClipboardTextNode: (clipboard) ->
    data = clipboard.getData "text/plain"
    return  document.createTextNode data

  setPlaceholder: ->
    @setClass "placeholder"
    placeholder = @getOptions().placeholder
    @setContent placeholder if placeholder

  unsetPlaceholder: ->
    @unsetClass "placeholder"

    content      = ""
    defaultValue = @getOptions().default
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
