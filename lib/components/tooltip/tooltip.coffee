KD = require '../../core/kd'
###

  KDTooltip

  A tooltip has a position and a direction, relative to the delegate
  element it is attached to.

  Valid positioning types are 'top','bottom','left' and 'right'
  Valid direction types are 'top','bottom','left','right' and 'center'

  Should a tooltip move off-screen, it will be relocated to be fully
  visible.

###

KDView  = require '../../core/view'
Encoder = require 'htmlencode'

module.exports = class KDTooltip extends KDView

  constructor:(options,data)->

    options.bind    or= 'mouseenter mouseleave'
    options.sticky   ?= no
    options.cssClass  = KD.utils.curry 'kdtooltip', options.cssClass

    super options, data

    @visible    = no
    @parentView = @getDelegate()
    @wrapper    = new KDView cssClass : 'wrapper'

    if @getOptions().animate then @setClass 'out' else @hide()

    @addListeners()
    
    windowController = KD.getSingleton 'windowController'
    windowController.on 'ScrollHappened', @bound "hide"

    @once 'viewAppended', =>

      {view, title, html} = @getOptions()

      if view?
        @setView view
      else
        @setClass 'just-text'
        @setTitle title, html

      @parentView.emit 'TooltipReady'

      @addSubView @wrapper
      @visible = yes

  show:(event)->

    {selector} = @getOptions()

    return if selector

    @display()

    super

    @visible = yes

  hide: (event)->
    return unless @visible
    {permanent} = @getOptions()
    super
    @getDomElement().remove()
    windowController = KD.getSingleton 'windowController'
    windowController.removeLayer this  unless permanent
    @visible = no

  update: (o = @getOptions(), view) ->

    unless view
      o.selector or= null
      o.title    or= ""
      @setTitle o.title, o.html
      @display()
    else
      @setView view

    @visible = yes

  addListeners:->
    {events, sticky, permanent} = @getOptions()

    _show = @bound 'show'
    _hide = @bound 'hide'

    @parentView.bindEvent name for name in events
    @parentView.on 'mouseenter', _show
    @parentView.on 'mouseleave', _hide  unless sticky

    @on 'ReceivedClickElsewhere', _hide  unless permanent

    @once 'KDObjectWillBeDestroyed', =>
      @parentView.off 'mouseenter',  _show
      @parentView.off 'mouseleave',  _hide  unless sticky

  setView: (childView) ->
    return unless childView

    @wrapper.view.destroy() if @wrapper.view?

    if childView.constructorName
      {options, data, constructorName} = childView
      @childView = new constructorName options, data
    else
      @wrapper.addSubView childView

  getView:-> @childView

  destroy:->

    @parentView.tooltip = null
    delete @parentView.tooltip
    super

  translateCompassDirections:(o)->

    {placement,gravity} = o
    o.placement = placementMap[placement]
    o.direction = directionMap(o.placement, gravity)

    return o

  display: ->

    o = @getOptions()
    {permanent, gravity, animate} = @getOptions()

    # converts NESW-Values to topbottomleftright and retains them in @getOptions
    @appendToDomBody()
    
    windowController = KD.getSingleton 'windowController'
    windowController.addLayer this  unless permanent
    
    o = @translateCompassDirections o  if gravity
    o.gravity = null

    @setClass 'in'  if animate
    KD.utils.defer => @setPositions o

    @visible = yes


  getCorrectPositionCoordinates:(o={},positionValues,callback=KD.noop)->
    # values that can/will be used in all the submethods
    container       = @$()
    selector        = @parentView.$(o.selector)
    d = # dimensions
      container :
        height  : container.height()
        width   : container.width()
      selector  :
        offset  : selector.offset()
        height  : selector.height()
        width   : selector.width()

    {placement,direction} = positionValues

    # check the default values for overlapping boundaries, then
    # recalculate if there are overlaps

    {forcePosition} = @getOptions()

    violations = getBoundaryViolations getCoordsFromPlacement(d, placement, direction),\
    d.container.width, d.container.height

    if !forcePosition and Object.keys(violations).length > 0 # check for possible alternatives
      variants = [
        ['top','right']
        ['right','top']
        ['right','bottom']
        ['bottom','right']
        ['top','left']
        ['top','center']
        ['right','center']
        ['bottom','center']
        ['bottom','left']
        ['left','bottom']
        ['left','center']
        ['left','top']
      ]

      for variant in variants
        if Object.keys(getBoundaryViolations(getCoordsFromPlacement(d,variant[0],variant[1]),\
        d.container.width, d.container.height)).length is 0
          [placement,direction] = variant
          break

    correctValues =
      coords : getCoordsFromPlacement d, placement, direction
      placement : placement
      direction : direction

    callback correctValues
    return correctValues

  setPositions:(o = @getOptions(),animate = no)->

    @setClass 'animate-movement' if animate

    placement = o.placement or 'top'
    direction = o.direction or 'right'

    offset =
      if Number is typeof o.offset
        top   : o.offset
        left  : 0
      else
        o.offset

    # Correct impossible combinations
    direction =
      if placement in ['top','bottom'] and direction in ['top','bottom']
        'center'
      else if placement in ['left','right'] and direction in ['left','right']
         'center'
        else direction

    # fetch corrected placement and coordinated for positioning
    {coords,placement,direction} = @getCorrectPositionCoordinates o,{placement,direction}

    # css classes for arrow positioning

    for placement_ in ['top','bottom','left','right']
      if placement is placement_
        @setClass 'placement-'+placement_
      else
        @unsetClass 'placement-'+placement_

    for direction_ in ['top','bottom','left','right','center']
      if direction is direction_
        @setClass 'direction-'+direction_
      else
        @unsetClass 'direction-'+direction_

    @$().css
      left : coords.left + offset.left
      top  : coords.top + offset.top

    @utils.wait 500, => @unsetClass 'animate-movement'


  setTitle: (title, isHTML) ->

    title = Encoder.htmlEncode title  unless isHTML
    @wrapper.updatePartial title


  directionMap = (placement, gravity)->
    if placement in ["top", "bottom"]
      if /e/.test gravity then "left"
      else if /w/.test gravity then "right"
      else "center"
    else if placement in ["left", "right"]
      if /n/.test gravity then "top"
      else if /s/.test gravity then "bottom"
      else placement

  placementMap =
    top     : "top"
    above   : "top"
    below   : "bottom"
    bottom  : "bottom"
    left    : "left"
    right   : "right"

  # will return an object with the amount of clipped pixels
  getBoundaryViolations = (coordinates,width,height)=>
    violations = {}
    if coordinates.left < 0
      violations.left   = -(coordinates.left)
    if coordinates.top  < 0
      violations.top    = -(coordinates.top)
    if coordinates.left+width > window.innerWidth
      violations.right  = coordinates.left+width-window.innerWidth
    if coordinates.top+height > window.innerHeight
      violations.bottom = coordinates.top+height-window.innerHeight
    violations

  getCoordsDiff = (dimensions,type,center=no)->
    diff = dimensions.selector[type]-dimensions.container[type]
    if center then diff/2 else diff

  getCoordsFromPlacement = (dimensions,placement,direction)->
    coordinates =
      top  : dimensions.selector.offset.top
      left : dimensions.selector.offset.left

    [staticAxis,dynamicAxis,staticC,dynamicC,exclusion] =
      if /o/.test placement then ['height','width','top','left','right']
      else ['width','height','left','top','bottom']

    coordinates[staticC]+= unless placement.length<5
        (dimensions.selector[staticAxis]+10)
      else -(dimensions.container[staticAxis]+10)

    unless direction is exclusion
      coordinates[dynamicC]+=getCoordsDiff(dimensions,dynamicAxis,direction is 'center')
    return coordinates
