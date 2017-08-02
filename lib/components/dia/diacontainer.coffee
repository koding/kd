KD = require '../../core/kd'
KDDiaObject = require './diaobject'
KDView = require '../../core/view'

module.exports = class KDDiaContainer extends KDView

  constructor: (options = {}, data) ->

    options.cssClass = KD.utils.curry 'kddia-container', options.cssClass

    if options.draggable
      options.draggable = {}  unless 'object' is typeof options.draggable

    options.itemClass ?= KDDiaObject
    super options, data

    @scale = 1
    @dias = {}


  mouseDown: ->

    super
    @emit "HighlightDia", (dia for key, dia of @dias)


  addDia: (diaObj, pos = {}) ->

    @addSubView diaObj

    diaObj.on 'DiaObjectClicked',    => @emit 'HighlightDia', diaObj
    diaObj.on 'RemoveMyConnections', => delete @dias[diaObj.getId()]

    @dias[diaObj.getId()] = diaObj
    @emit 'NewDiaObjectAdded', this, diaObj

    diaObj.setX pos.x  if pos.x?
    diaObj.setY pos.y  if pos.y?

    return diaObj


  addItem: (data, options = {}) ->

    itemClass = @getOption 'itemClass'
    @addDia new itemClass options, data


  removeAllItems: ->
    dia.destroy?() for _key, dia of @dias


  setScale: (scale = 1) ->

    return  if scale is @scale

    props = ['webkitTransform', 'MozTransform', 'transform']
    css   = {}
    css[prop] = "scale(#{scale})"  for prop in props
    @setStyle css
    @scale = scale


  dumpContainer: ->

    dias = {}
    for _, d of @dias
      dEl = d.getElement()
      dias[d.id] = {
        data         : d.getData()
        joints       : Object.keys d.joints
        staticJoints : [d.options.staticJoints...]
        partial      : d.options.partial
        cssClass     : "#{dEl.className}"
        position     : d.getBounds()
      }

    data     = @getData()
    cssClass = @getElement().className
    partial  = @getOption 'partial'
    position = @getBounds()

    return { dias, data, cssClass, partial, position }
