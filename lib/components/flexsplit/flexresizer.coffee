KDFlex = require './flex'
KDView = require '../../core/view'


module.exports = class KDFlexSplitResizer extends KDView


  constructor: (options = {}, data) ->

    options.type     ?= KDFlex.HORIZONTAL
    options.cssClass  = 'flex-resizer'
    options.draggable = { axis: options.type.axis }

    super options, data

    @views      = []
    @_fractions = []
    { @type, view } = @getOptions()

    @addView view

    @on 'DragFinished', @dragFinished
    @on 'DragStarted',  @dragStarted


  _getViewIndex: (view) ->
    if view is @views[0] then 0 else 1


  addView: (view) ->

    @views.push view

    # This will handle expand request of the view, it will set fraction
    # as KDFlex.MAX for requested view and will do KDFlex.MIN for other view
    # it will also fire the same event which will cause a chain reaction
    # on parent resizers to do same. It will allow us to expand nested
    # views up to the parent one ~ GG
    view.on KDFlex.EVENT_EXPAND, =>

      return  if view.hasClass 'expanded'
      view.setClass 'expanded'

      # This will start chain reaction for expanding parent views
      @emit KDFlex.EVENT_EXPAND

      @_updateViewSizes()
      @_updateFractions 0, set = no

      fractions = []
      viewIndex = @_getViewIndex view
      for i in [0..1]
        fractions.push if i is viewIndex then KDFlex.MAX else KDFlex.MIN
        @_setViewFraction @views[i], fractions[i]

      @emit KDFlex.EVENT_EXPANDED, fractions
      view._windowDidResize?()

    # This will handle collapse request of the view, it will set fraction
    # as KDFlex.MIN for requested view and will do KDFlex.MAX for other view
    # it will also fire the same event which will cause a chain reaction
    # on parent resizers to do same. It will allow us to collapse nested
    # views up to the parent one ~ GG
    view.on KDFlex.EVENT_COLLAPSE, =>

      # This will start chain reaction for collapsing parent views
      @emit KDFlex.EVENT_COLLAPSE

      fractions = []
      viewIndex = @_getViewIndex view
      for i in [0..1]
        fractions.push @_fractions[i] ? 50
        @_setViewFraction @views[i], fractions[i]
        @views[i].unsetClass 'expanded'

      @emit KDFlex.EVENT_COLLAPSED, fractions
      view._windowDidResize?()


    view.on KDFlex.EVENT_HIDE, =>

      fractions = [KDFlex.MAX, KDFlex.MAX]
      viewIndex = @_getViewIndex view
      fractions[viewIndex] = KDFlex.MIN

      for i in [0..1]
        @_setViewFraction @views[i], fractions[i]

      @emit KDFlex.EVENT_HIDDEN, fractions
      view._windowDidResize?()

    # Custom Resize events for programatically resize the view based on the
    # given percentage, the other side will be resized to KDFlex.MAX -
    # Triggering storage is optional and disabled by default ~ GG
    view.on KDFlex.EVENT_RESIZE, (options) =>

      { percentage = KDFlex.MIN, store = no } = options

      leftOver  = KDFlex.MAX - percentage
      fractions = [leftOver, leftOver]
      viewIndex = @_getViewIndex view
      fractions[viewIndex] = percentage

      for i in [0..1]
        @_setViewFraction @views[i], fractions[i]

      if store
        @emit KDFlex.EVENT_RESIZED, fractions

      view._windowDidResize?()


  _updateViewSizes: ->
    # This will get height or width of given views. This height or width
    # depends on the type of this KDFlexSplitResizer. For example; if we've
    # a horizontal resizer then getter will be `getHeight` look constants.
    @sizes = [
      @views[0][@type.getter]()
      @views[1][@type.getter]()
    ]

    # We need to know totalSize of the view including resizer's width or height
    # Since we are not defining resizer handle size in code but in style we
    # need to calculate that size dynamically as well
    #
    # This totalSize will become total width or total height of the KDFlexSplit
    @totalSize = @sizes[0] + @sizes[1] + @[@type.getter]()


  limited = (num) ->
    Math.min KDFlex.MAX, Math.max KDFlex.MIN, num


  _updateFractions: (change = 0, set = yes) ->
    # This will calculate fractions for each view and will leave enough space
    # for the resizer itself as well. For example on a 100px wide KDFlexSplit
    # if you have a 4px wide resizer 96px will be distributed on the views.
    # If they splitted even on the screen then their fractions will become
    # 48% and 48%, remaining 4% is used by the resizer itself. ~ GG
    for i in [0..1]
      change = -change  if i is 1
      @_fractions[i] = limited ((change + @sizes[i]) / @totalSize) * KDFlex.MAX
      @_setViewFraction @views[i], @_fractions[i]  if set


  drag: (event, delta) ->
    # on drag we are getting the delta based on the axis of this type
    # of resizer x for VERTICAL, y for HORIZONTAL ptl. constants.
    @_updateFractions delta[@type.axis]


  dragFinished: (event, dragState) ->

    @unsetClass 'ondrag'
    @emit KDFlex.EVENT_RESIZED, @_fractions
    for view in @views
      view.unsetClass 'ondrag'
      view._windowDidResize?()


  dragStarted: (event, dragState) ->

    for view in @views
      view.unsetClass 'expanded'
      view.setClass 'ondrag'

    @setClass 'ondrag'

    @_updateViewSizes()


  setFractions: (fractions, options = {}) ->

    { updateViews = yes, initialFractions = [50, 50] } = options

    @_fractions = initialFractions
    return  unless updateViews

    for index in [0..1]
      @_setViewFraction @views[index], fractions[index]
      if fractions[index] is KDFlex.MAX
        @views[index].setClass 'expanded'


  _setViewFraction: (view, fraction) ->
    view.setCss 'flex-basis', "#{fraction}%"
    view._windowDidResize?()
