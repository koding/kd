class KDTokenizedInput extends KDContentEditableView
  constructor: (options = {}, data) ->
    options.cssClass   = KD.utils.curry "kdtokenizedinputview", options.cssClass
    options.bind       = KD.utils.curry "keyup", options.bind
    options.rules    or= {}
    options.layer    or= {}
    super options, data

    @tokenViews        = {}

  getValue: (options = {}) ->
    value = ""

    for node in @getEditableElement().childNodes
      switch node.nodeType
        when Node.TEXT_NODE
          value += node.textContent if node.textContent isnt ""
        when Node.ELEMENT_NODE
          if node.tagName.toLowerCase() is "br" then value += "\n"
          else if options.onlyText is yes then continue
          else
            tokenValue = @getTokenView(node.dataset.key)?.encodeValue?()
            value += tokenValue  if tokenValue

    if value is @getOptions().placeholder then return ""
    else return value

  getTokens: ->
    tokens = []

    for node in @getEditableElement().childNodes
      if node.nodeType is Node.ELEMENT_NODE
        view = @getTokenView node.dataset.key
        continue unless view
        {type} = view.getOptions()
        data   = view.getData()
        tokens.push {type, data}

    return tokens

  getTokenView: (key) ->
    return  @tokenViews[key]

  matchPrefix: ->
    return  if @tokenInput
    range = @utils.getSelectionRange()
    node  = range.commonAncestorContainer

    if node.children?.length is 1
      return  node.textContent is node.children[0].textContent

    start = range.startOffset - 1
    char  = node.textContent[start]
    for name, rule of @getOptions().rules
      if char is rule.prefix
        @activeRule             = rule
        @tokenInput             = document.createElement "span"
        @tokenInput.textContent = rule.prefix
        @utils.replaceRange node, @tokenInput, start, start + rule.prefix.length
        @utils.selectText @tokenInput, rule.prefix.length

  matchToken: ->
    token = @tokenInput.textContent.substring @activeRule.prefix.length
    if token
      {dataSource} = @activeRule
      dataSource token, @bound "showMenu"

  showMenu:(options, data)->
    @menu?.destroy()
    @blur()

    pos       = @tokenInput.getBoundingClientRect()
    options.x = pos.left
    options.y = pos.top + parseInt window.getComputedStyle(@tokenInput).lineHeight, 10

    @menu = new JContextMenu options, data
    @menu.on "ContextMenuItemReceivedClick", @bound "menuItemClicked"

  hideMenu: ->
    @menu?.destroy()
    @menu       = null
    @activeRule = null
    @tokenInput = null

  menuItemClicked: (item, tokenViewClass = @getOptions().tokenViewClass) ->
    @addToken item.data, tokenViewClass
    @hideMenu()

  addToken: (item, tokenViewClass) ->
    {type, prefix, pistachio} = @activeRule
    tokenView = new tokenViewClass {type, prefix, pistachio}, item

    tokenKey              = "#{tokenView.getId()}-#{tokenView.getKey()}"
    @tokenViews[tokenKey] = tokenView

    tokenView.setAttributes "data-key": tokenKey
    @getEditableElement().insertBefore tokenView.getElement(), @tokenInput
    tokenView.emit "viewAppended"
    @utils.selectText @tokenInput.nextSibling, 1
    @tokenInput.remove()

  keyDown: (event) ->
    super
    switch event.which
      when 9, 13, 27, 38, 40 # enter, tab, escape, up, down
        if @menu
          @menu.treeController.keyEventHappened event
          @utils.stopDOMEvent event

    switch event.which
      when 27 then @cancel() if @tokenInput

  keyUp: (event) ->
    super
    switch event.which
      when 9, 13, 27, 38, 40 # enter, tab, escape, up, down
      else
        if @activeRule then @matchToken()
        else @matchPrefix()

  cancel: ->
    text = document.createTextNode @tokenInput.textContent
    @getEditableElement().insertBefore text, @tokenInput
    @tokenInput.nextSibling.remove()
    @tokenInput.remove()
    @utils.selectEnd text
    @hideMenu()

  reset: ->
    @setPlaceholder()
    @blur()

    for own id, view of @tokenViews
      view.destroy()
      delete @tokenViews[id]

  viewAppended: ->
    super
    @setEditingMode on
