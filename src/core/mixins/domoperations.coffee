
module.exports = DOMOperations = ->

  @appendToDomBody = ->
    @parentIsInDom = yes
    unless @lazy
      $("body").append @$()
      @utils.defer => @emit "viewAppended"


  @setDomElement = (cssClass='') ->
    {domId, tagName} = @getOptions()

    @lazy = yes

    el = document.getElementById domId  if domId

    @lazy = unless el?
      el    = document.createElement tagName
      el.id = domId  if domId
      no
    else yes

    for klass in "kdview #{cssClass}".split ' ' when klass.length
      el.classList.add klass

    @domElement = $(el)

    @utils.defer => @emit 'viewAppended'  if @lazy


  @setDomId  = (id) -> @domElement.attr "id", id
  @getDomId  = -> @domElement.attr "id"
  @setDataId = -> @domElement.data "data-id", @getId()

  @getAttribute  = (attr) -> @getElement().getAttribute attr
  @setAttribute  = (attr, val) -> @getElement().setAttribute attr, val
  @setAttributes = (attributes) -> @setAttribute attr, val for own attr, val of attributes


  @isInDom = do ->
    findUltimateAncestor = (el) ->
      ancestor = el
      while ancestor.parentNode
        ancestor = ancestor.parentNode
      ancestor
    return -> findUltimateAncestor(@$()[0]).body?


  @getDomElement = -> @domElement
  @getElement    = -> @getDomElement()[0]

  @$ = (selector)->
    if selector
    then @getDomElement().find(selector)
    else @getDomElement()


  @append = (child, selector) ->
    @$(selector).append child.$()
    child.emit 'viewAppended'  if @parentIsInDom
    return this


  @appendTo = (parent, selector) ->
    @$().appendTo parent.$(selector)
    @emit 'viewAppended'  if @parentIsInDom
    return this


  @appendToSelector = (selector) ->
    $(selector).append @$()
    @emit 'viewAppended'
    return this


  @prepend = (child, selector) ->
    @$(selector).prepend child.$()
    child.emit 'viewAppended'  if @parentIsInDom
    return this


  @prependTo = (parent, selector) ->
    @$().prependTo parent.$(selector)
    @emit 'viewAppended'  if @parentIsInDom
    return this


  @prependToSelector = (selector)->
    $(selector).prepend @$()
    @emit 'viewAppended'


  @setPartial = (partial, selector) ->
    warn 'KDView::setPartial is deprecated. Use KDView::addPartial instead'
    @addPartial partial, selector


  @addPartial = (partial, selector) ->
    @$(selector).append partial
    return this

  @updatePartial = (partial, selector) -> @$(selector).html partial

  @clear    = -> @getElement().innerHTML                                                     = ''
  @setCss   = (property, value) -> @$().css property, value
  @setStyle = (properties) -> @$().css property, value for own property, value of properties

  @setClass = (cssClass) ->
    return unless cssClass
    KDView.setElementClass @getElement(), 'add', cssClass
    return this


  @unsetClass = (cssClass) ->
    return unless cssClass
    KDView.setElementClass @getElement(), 'remove', cssClass
    return this


  @toggleClass = (cssClass) ->
    if @hasClass cssClass
    then @unsetClass cssClass
    else @setClass cssClass

    return this


  @hasClass = (cssClass) ->
    return no  unless cssClass
    @getElement().classList.contains cssClass


  @getBounds = ->
    x : @getX()
    y : @getY()
    w : @getWidth()
    h : @getHeight()
    n : @constructor.name


  @hide = (duration) -> @setClass 'hidden'
  @show = (duration) -> @unsetClass 'hidden'


  @setPosition = ->
    positionOptions = @getOptions().position
    positionOptions.position = "absolute"
    @$().css positionOptions


  @setX = (x) -> @$().css left: x
  @setY = (y) -> @$().css top: y
  @getX = -> @getElement().getBoundingClientRect().left
  @getY = -> @getElement().getBoundingClientRect().top
  @getRelativeX = -> @$().position().left
  @getRelativeY = -> @$().position().top

  @getWidth  = -> @$().outerWidth no
  @getHeight = -> @getDomElement().outerHeight no


  @setWidth = (w, unit = "px") ->
    @getElement().style.width = "#{w}#{unit}"
    @emit "ViewResized", {newWidth : w, unit}


  @setHeight = (h, unit = "px") ->
    @getElement().style.height = "#{h}#{unit}"
    @emit "ViewResized", {newHeight : h, unit}



  @attach = (view) ->
    @getElement().appendChild view.getElement()
    view.setParent this
    @subViews.push view


  @detach = ->
    @parent?.getElement().removeChild @getElement()
    @orphanize()
    @unsetParent()


