KD     = require '../../core/kd'
KDView = require '../../core/view'

KDFlex = require './flex'
KDFlexSplitResizer = require './flexresizer'


module.exports = class KDFlexSplit extends KDView

  # Keep copy of constants on KDFlexSplit for external uses
  for own key, value of KDFlex
    KDFlexSplit[key] = value

  constructor: (options = {}, data) ->

    options.cssClass   = KD.utils.curry 'flex-split', options.cssClass
    options.sizes     ?= []
    options.type      ?= KDFlex.HORIZONTAL
    options.resizable ?= yes

    super options, data

    @_type = KDFlex.INSTANCE_TYPE

    @resizer = null
    { @type, @name, storage } = @getOptions()
    @setClass @type.name

    @setupViews()

    storage?.addView this, @name


  createResizer: (view, size) ->

    @resizer = @addSubView new KDFlexSplitResizer { @type, view }

    @forwardEvents @resizer, [
      KDFlex.EVENT_EXPANDED
      KDFlex.EVENT_RESIZED
      KDFlex.EVENT_HIDDEN
      KDFlex.EVENT_COLLAPSED
    ]

    @resizer.on KDFlex.EVENT_EXPAND, ->
      if KDFlexSplit.isInstance view.parent
        view.parent.emit KDFlex.EVENT_EXPAND

    @resizer.on KDFlex.EVENT_COLLAPSE, ->
      if KDFlexSplit.isInstance view.parent
        view.parent.emit KDFlex.EVENT_COLLAPSE


  setupViews: ->

    { sizes, views, resizable } = @getOptions()

    views.forEach (view, index) =>

      unless view.hasClass 'flex-split'
        view.setClass 'flex-view'

      if sizes[index]?
        size = sizes[index]
        view.setCss 'flex-basis', "#{size}%"

      @addSubView view

      if resizable
        view.setCss 'flex-basis', '50%'  unless size?
        @resizer?.addView view, size
        if views[index + 1]
          @createResizer view, size


  setFractions: (fractions, options) ->
    @resizer?.setFractions fractions, options


  @isInstance = (instance) ->
    instance?._type is KDFlex.INSTANCE_TYPE
