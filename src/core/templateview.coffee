KDCustomHTMLView = require './customhtmlview.coffee'
module.exports   = class KDTemplateView extends KDCustomHTMLView

  constructor : (options = {}, data) ->
    options.tagName   = 'template'
    options.name      =
    options.markup   ?= '<content></content>'
    options.styles   ?= ''

    super options, data

    @setTemplate()
    @appendToDomBody()


  setTemplate : ->
    {markup, styles}   = @getOptions()
    content            = @getElement().content

    parser             = new DOMParser

    stylesEl           = document.createElement 'style'
    stylesEl.innerHTML = styles

    window.markupEl    = parser.parseFromString markup, 'text/html'

    content.appendChild stylesEl

    for child in markupEl.body.children

      element = child.cloneNode true
      content.appendChild element


  getTemplate : -> @getElement().content


  applyTo : (view) ->
    target = view.getElement().createShadowRoot()
    target.appendChild @getTemplate()
