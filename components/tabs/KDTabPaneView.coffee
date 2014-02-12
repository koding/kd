class KDTabPaneView extends KDView

  constructor:(options = {},data)->

    options.hiddenHandle ?= no      # a Boolean
    options.name        or= ""      # a String
    defaultCssClass       = "kdtabpaneview kdhiddentab #{KD.utils.slugify(options.name.toLowerCase())} clearfix"
    options.cssClass      = KD.utils.curry defaultCssClass, options.cssClass

    super options, data

    @name = options.name
    @lastScrollTops =
      window : 0
      parent : 0
      self   : 0


    @on "KDTabPaneActive",        @bound "setMainView"
    @on "KDTabPaneLazyViewAdded", @bound "fireLazyCallback"


  show:->

    @setClass "active"
    @unsetClass "kdhiddentab"
    @parent.getElement().appendChild @getElement()
    @active = yes
    @emit "KDTabPaneActive"
    KD.utils.defer =>
      document.documentElement.scrollTop = @lastScrollTops.window
      @getElement().scrollTop            = @lastScrollTops.self
      @parent?.getElement?().scrollTop   = @lastScrollTops.parent


  hide:->

    return  unless @active

    @lastScrollTops.window = document.documentElement.scrollTop
    @lastScrollTops.parent = @parent.getElement().scrollTop
    @lastScrollTops.self   = @getElement().scrollTop

    @setClass "kdhiddentab"
    @unsetClass "active"
    @parent.getElement().removeChild @getElement() if @active
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
