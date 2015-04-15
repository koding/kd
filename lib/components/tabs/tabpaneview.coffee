debug = require('debug') 'kd:tabs:tabpaneview'
KD = require '../../core/kd'
KDView = require '../../core/view'

module.exports = class KDTabPaneView extends KDView

  constructor:(options = {},data)->

    options.hiddenHandle  ?= no      # a Boolean
    options.name         or= ""      # a String
    options.detachable    ?= yes
    defaultCssClass        = "kdtabpaneview kdhiddentab #{KD.utils.slugify options.name.toLowerCase()} clearfix"
    options.cssClass       = KD.utils.curry defaultCssClass, options.cssClass

    super options, data

    @name = options.name
    @lastScrollTops =
      parent        : 0
      self          : 0


    @on 'KDTabPaneActive',        @bound 'setMainView'
    @on 'KDTabPaneLazyViewAdded', @bound 'fireLazyCallback'


  show:->

    if @getOption 'detachable'
      @parent?.getElement().appendChild @getElement()

    @unsetClass 'kdhiddentab'
    @setClass 'active'

    @active = yes
    @emit 'KDTabPaneActive'

    @applyScrollTops()


  hide:->

    return  unless @active

    @setScrollTops()
    @emit 'KDTabPaneInactive'

    @unsetClass 'active'
    @setClass 'kdhiddentab'

    if @getOption 'detachable'
      @parent?.getElement().removeChild @getElement()

    @active = no


  setScrollTops: ->

    @lastScrollTops.parent = @parent?.getElement().scrollTop or 0
    @lastScrollTops.self   = @getElement().scrollTop


  applyScrollTops: ->

    KD.utils.defer =>
      @getElement().scrollTop         = @lastScrollTops.self
      @parent?.getElement().scrollTop = @lastScrollTops.parent


  setTitle:(title)->

    @getDelegate().setPaneTitle this, title
    @name = title


  getHandle: -> @getDelegate().getHandleByPane this


  hideTabCloseIcon:-> @getDelegate().hideCloseIcon this


  setMainView:(view)->

    unless view
      {view, viewOptions} = @getOptions()

    return if @mainView
    return unless view or viewOptions

    if view instanceof KDView
      @mainView = @addSubView view
    else if viewOptions
      {viewClass, options, data} = viewOptions
      @mainView = @addSubView new viewClass options, data
    else
      return debug 'invalid view type'

    @emit "KDTabPaneLazyViewAdded", this, @mainView
    return @mainView


  getMainView:-> @mainView


  destroyMainView:->

    @mainView.destroy()
    @mainView = null


  fireLazyCallback:(pane, view)->

    {viewOptions} = @getOptions()
    return  unless viewOptions
    {callback} = viewOptions
    return  unless callback
    callback.call this, pane, view
