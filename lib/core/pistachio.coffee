module.exports = class Pistachio

  @createId = do ->
    counter = 0
    (prefix) -> "#{prefix}el-#{counter++}"

  @getAt = (ref, path) ->
    if 'function' is typeof path.split # ^1
      path = path.split '.'
    else
      path = path.slice()
    while ref? and prop = path.shift()
      ref = ref[prop]
    ref

  ###
  example pistachios:

  header:
  {h3{#(title)}}

  date:
  {time.timeago{#(meta.createdAt)}}

  id:
  {h1#siteTitle{#(title)}}

  subview / partial:
  {{> @subView }}

  wrapped subview / partial:
  {div.fixed.widget{> @clock }}

  attribute:
  {a[href="#profile"]{ '@'+#(profile.nickname) }}

  kitchen sink:
  {div#id.class1.class2[title="Example Attribute"]{> @subView }}

  it's important to note that there is a priority.  That is to make the symbol easier for the CPU to parse.

  1 tagName
  2 id, #-prefixed (hash prefixed)
  3 classNames, .-prefixed (dot prefixed)
  4 custom attributes, bracketed squarely, each ([key=val]) # weird stuff is OK for "val"

  #sth is short for [id=sth]
  .sth is short for [class=sth]
  .sth.els is short for [class="sth els"]

  we optimize both.
  ###

  pistachios =
    ///
    \{                  # first { (begins symbol)
      ([\w|-]*)?        # optional custom html tag name
      (\#[\w|-]*)?      # optional id - #-prefixed
      ((?:\.[\w|-]*)*)  # optional class names - .-prefixed
      (\[               # optional [ begins the attributes
        (?:\b[\w|-]*\b) # the name of the attribute
        (?:\=           # optional assignment operator =
                        # TODO: this will tolerate fuzzy quotes for now. "e.g.'
          [\"|\']?      # optional quotes
          .*            # optional value
          [\"|\']?      # optional quotes
        )
      \])*              # optional ] closes the attribute tag(s). there can be many attributes.
      \{                # second { (begins expression)
        ([^{}]*)        # practically anything can go between the braces, except {}
      \}\s*             # closing } (ends expression)
    \}                  # closing } (ends symbol)
    ///g

  constructor: (@view, @template, @options = {}) ->
    { @prefix, @params }  = @options
    @params             or= {}
    @symbols              = {}
    @symbolsByDataPath    = {}
    @symbolsBySubViewName = {}
    @dataPaths            = {}
    @subViewNames         = {}
    @prefix             or= ''
    @html                 = @init()

  createId: @createId

  toString: -> @template

  parseProp = (prop, getter) ->

    if prop and isNaN prop
      if prop[0] is '`' then prop[1...prop.length - 1] else getter prop


  notSupported = 'Not supported operation! Check template!'

  init: do ->

    dataGetter = (prop) ->

      return  unless data = @getData?()
      getter = data.getAt ? (p) -> Pistachio.getAt data, p

      [ p1, rest... ] = prop.match /[^\s`]+|`([^`]*)`/gi

      # If this is only a single prop we will just return it's value
      return getter p1  unless rest.length

      # In the case of prop includes a simple compare code;
      #
      #   {{ #(foo > 5 ? foo else bar) }}
      #
      # This will end up like below;
      #
      #   {{ #(p1 op p2 ? r1 : r2) }}
      #
      #  where;
      #
      #    p1 : first prop or a string in ``
      #    op : operation which can be >,>=,<,<=,== or !=
      #    p2 : second prop or a string in ``
      #    qm : question mark
      #    r1 : first return value or prop
      #    ow : otherwise
      #    r2 : second return value or prop
      #
      # Example above will return;
      #
      #    data.foo if data.foo is greater than 5 othwerise data.bar
      #
      # If needed string values can be used in any place;
      #
      #   {{ #(`foo` == foo ? `cool` : bar )}}
      #
      # which will return;
      #
      #   'cool' string if data.foo equals to 'foo' string otherwise data.bar
      #
      # otherwise part is optional which can be simply ignored;
      #
      #   item{{ #(items.count != 1 ? `s`)}}
      #
      # which will render 'items' when data.items.count != 0
      #
      # also return values can be omitted which causes results to be true or
      # false as string
      #
      #   is foo greater than 5? {{ #(foo > 5)}}
      #
      [ op, p2, qm = '?', r1, ow = ':', r2 = '' ] = rest

      if qm != '?' or ow != ':'
        return notSupported

      p1 = parseProp(p1, getter) ? Number p1
      p2 = parseProp(p2, getter) ? Number p2
      r1 = parseProp(r1, getter) ? r1
      unless r1?
        [ r1, r2 ] = [ !!1, !!0 ]
      else
        r2 = parseProp(r2, getter) ? r2

      # Following can be done with a simple eval like following;
      #
      #   res = if eval("#{p1}#{op}#{p2}") then r1 else r2
      #
      # But it's better to keep the operation limited here. ~ GG
      #
      res = switch op
        when '>'
          if p1 > p2  then r1 else r2
        when '>='
          if p1 >= p2 then r1 else r2
        when '<'
          if p1 < p2  then r1 else r2
        when '<='
          if p1 <= p2 then r1 else r2
        when '=='
          if p1 == p2 then r1 else r2
        when '!='
          if p1 != p2 then r1 else r2
        else
          notSupported

      return res


    getEmbedderFn = (pistachio, view, id, symbol) ->
      (childView) ->
        view.embedChild id, childView, symbol.isCustom
        unless symbol.isCustom
          symbol.id      = childView.id
          symbol.tagName = childView.getTagName?()
          delete pistachio.symbols[id]
          pistachio.symbols[childView.id] = symbol

    init = ->
      { prefix, view, createId } = this
      @template.replace pistachios, (_, tagName, id, classes, attrs, expression) =>

        id = id?.split('#')[1]
        classNames = classes?.split('.').slice(1) or []
        attrs = attrs?.replace(/\]\[/g, ' ').replace(/\[|\]/g, '') or ''

        isCustom = !!(tagName or id or classes.length or attrs.length)

        tagName or= 'span'

        dataPaths = []
        subViewNames = []

        expression = expression
          .replace /#\(([^)]*)\)/g, (_, dataPath) ->
            [ p1, op, p2 ] = dataPath.match /[^\s`]+|`([^`]*)`/gi
            if p2
              dataPaths.push p1  if p1 and p1[0] isnt '`' and isNaN p1
              dataPaths.push p2  if p2 and p2[0] isnt '`' and isNaN p2
            else
              dataPaths.push p1
            "data('#{dataPath}')"
          .replace /^(?:> ?|embedChild )(.+)/, (_, subViewName) ->
            subViewNames.push subViewName.replace /\@\.?|this\./, ''
            "embedChild(#{subViewName})"

        @registerDataPaths dataPaths
        @registerSubViewNames subViewNames

        js = 'return ' + expression

        if 'debug' is tagName
          console.debug js
          tagName = 'span'

        paramKeys     = Object.keys @params
        paramValues   = paramKeys.map (key) => @params[key]

        formalParams = ['data', 'embedChild', paramKeys...]

        try code = Function formalParams..., js

        catch e then throw new Error \
          """
          Pistachio encountered an error: #{e}
          Source: #{js}
          """

        id or= createId prefix

        render = ->
          '' + code.apply view, [
            dataGetter.bind view
            embedChild
            paramValues...
          ]

        symbol = {
          tagName, id, isCustom, js, code, render, dataPaths, subViewNames
        }

        @addSymbolInternal symbol

        embedChild = getEmbedderFn this, view, id, symbol

        dataPathsAttr =
          if dataPaths.length
            " data-#{prefix}paths='#{dataPaths.join ' '}'"
          else ''

        subViewNamesAttr =
          if subViewNames.length
            classNames.push "#{prefix}subview"
            " data-#{prefix}subviews='#{cleanSubviewNames(subViewNames.join ' ')}'"
          else ''

        classAttr =
          if classNames.length then " class='#{classNames.join ' '}'"
          else ''

        "<#{tagName}#{classAttr}#{dataPathsAttr}#{subViewNamesAttr} #{attrs} id='#{id}'></#{tagName}>"


  addSymbolInternal: (symbol) ->
    { dataPaths, subViewNames } = symbol

    @symbols[symbol.id] = symbol

    for dataPath in dataPaths
      @symbolsByDataPath[dataPath] ?= []
      @symbolsByDataPath[dataPath].push symbol

    for subViewName in subViewNames
      @symbolsBySubViewName[subViewName] ?= []
      @symbolsBySubViewName[subViewName].push symbol

    return symbol

  addSymbol: (childView) ->
    @symbols[childView.id] = {
      id      : childView.id
      tagName : childView.getTagName?()
    }

  appendChild: (childView) ->
    @addAdhocSymbol childView

  prependChild: (childView) ->
    @addAdhocSymbol childView

  registerDataPaths: (paths) ->
    @dataPaths[path] = yes for path in paths

  registerSubViewNames: (subViewNames) ->
    @subViewNames[subViewName] = yes for subViewName in subViewNames

  getDataPaths: -> Object.keys @dataPaths

  getSubViewNames: -> Object.keys @subViewNames

  cleanSubviewNames = (name) -> name.replace /(this\["|\"])/g, ''

  symbolKeys =
    subview : 'symbolsBySubViewName'
    path    : 'symbolsByDataPath'

  refreshChildren: (childType, items, forEach = (->)) ->
    unique = {}

    for item in items
      symbols = @[symbolKeys[childType]][item]
      continue  unless symbols?

      for symbol in symbols
        unique[symbol.id] = symbol

    for own id, symbol of unique
      el = @view.getElement().querySelector "##{id}"
      continue  unless el?

      out = symbol?.render()
      forEach.call el, out  if out or out == ''

  embedSubViews: (subviews = @getSubViewNames()) ->
    @refreshChildren 'subview', subviews

  update: (paths = @getDataPaths()) ->
    @refreshChildren 'path', paths, (html) -> @innerHTML = html

  pistachio: (tmpl) ->
    "#{@options.prefix}#{tmpl}#{@options.suffix}"  if tmpl
