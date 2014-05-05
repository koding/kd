KDView = require './../../core/view.coffee'

module.exports = class KDTabPaneView extends KDView

  constructor:(options = {},data)->

    options.hiddenHandle  ?= no      # a Boolean
    options.name         or= ""      # a String
    defaultCssClass        = "kdtabpaneview kdhiddentab #{KD.utils.slugify(options.name.toLowerCase())} clearfix"
    options.cssClass       = KD.utils.curry defaultCssClass, options.cssClass

    super options, data

    @name = options.name
    @lastScrollTops =
      window        : 0
      parent        : 0
      self          : 0
      body          : 0


    @on "KDTabPaneActive",        @bound "setMainView"
    @on "KDTabPaneLazyViewAdded", @bound "fireLazyCallback"


  show:->

    @setClass "active"
    @unsetClass "kdhiddentab"

    if @getOption "detachable"
      @parent?.getElement().appendChild @getElement()

    @active = yes
    @emit "KDTabPaneActive"

    KD.utils.defer =>
      @getElement().scrollTop         = @lastScrollTops.self
      @parent?.getElement().scrollTop = @lastScrollTops.parent


  hide:->

    return  unless @active

    @lastScrollTops.parent = @parent?.getElement().scrollTop or 0
    @lastScrollTops.self   = @getElement().scrollTop

    @setClass "kdhiddentab"
    @unsetClass "active"

    if @active and @getOption "detachable"
      @parent?.getElement().removeChild @getElement()

    @active = no
    @emit "KDTabPaneInactive"


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
      return warn "probably you set a weird lazy view!"

    @emit "KDTabPaneLazyViewAdded", this, @mainView
    return @mainView


  getMainView:-> @mainView


  destroyMainView:->

    @mainView.destroy()
    delete @mainView


  fireLazyCallback:(pane, view)->

    {viewOptions} = @getOptions()
    return  unless viewOptions
    {callback} = viewOptions
    return  unless callback
    callback.call this, pane, view
