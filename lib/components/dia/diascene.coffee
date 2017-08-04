debug            = require('debug') 'kd:dia:diascene'
$                = require 'jquery'
KD               = require '../../core/kd'
KDView           = require '../../core/view'
KDCustomHTMLView = require '../../core/customhtmlview'
_                = require 'lodash'

module.exports = class KDDiaScene extends KDView

  constructor: (options = {}, data) ->

    options.cssClass = KD.utils.curry "kddia-scene", options.cssClass
    options.bind     = KD.utils.curry "mousemove",   options.bind

    options.lineCap          or= "round"
    options.lineWidth         ?= 2
    options.lineColor        or= "#ccc"
    options.lineColorActive  or= "orange"
    options.lineDashes        ?= []
    options.fakeLineColor    or= "green"
    options.fakeLineDashes    ?= []
    options.curveDistance     ?= 50
    options.updateEvery       ?= 10
    options.prependCanvas     ?= no

    super

    @containers      = []
    @connections     = []
    @activeDias      = []
    @activeJoints    = []
    @fakeConnections = []

    @_autoUpdate   = null
    @updateEvery   = @getOption 'updateEvery'
    @prependCanvas = @getOption 'prependCanvas'


  diaAdded: (container, diaObj) ->

    diaObj.on "JointRequestsLine",   @bound "handleLineRequest"
    diaObj.on "DragInAction",        => @highlightLines diaObj
    diaObj.on "RemoveMyConnections", => @disconnectAllConnections diaObj


  addContainer: (container, pos = {}) ->

    @createCanvas()  if @prependCanvas

    @addSubView container

    container.on 'NewDiaObjectAdded', @bound 'diaAdded'
    container.on 'DragInAction',      @bound 'updateScene'
    container.on 'UpdateScene',       @bound 'updateScene'
    container.on 'HighlightDia',      @bound 'highlightLines'

    @containers.push container

    padding = (container.getOption 'draggable')?.containment?.padding
    if padding
      pos.x = Math.max padding, pos.x ? 0
      pos.y = Math.max padding, pos.y ? 0

    container.setX pos.x  if pos.x?
    container.setY pos.y  if pos.y?

    @createCanvas()  unless @prependCanvas

    return container


  drawFakeLine: (options = {}) ->

    { sx, sy, ex, ey } = options

    @cleanup @fakeCanvas

    @fakeContext.beginPath()

    # Take canvas position into account to render correctly
    # when scale changed on the view ~ GG
    canvas = { x: @realCanvas.getX(), y: @realCanvas.getY() }

    sx -= canvas.x
    sy -= canvas.y
    ex -= canvas.x
    ey -= canvas.y

    @fakeContext.moveTo sx, sy
    @fakeContext.lineTo ex, ey

    @fakeContext.lineCap     = @getOption "lineCap"
    @fakeContext.lineWidth   = @getOption "lineWidth"
    @fakeContext.strokeStyle = @_trackJoint.parent.getOption('colorTag') or \
                               @getOption "fakeLineColor"
    lineDashes = @getOption "fakeLineDashes"
    @fakeContext.setLineDash lineDashes  if lineDashes.length > 0

    @fakeContext.stroke()


  click: (e) ->

    return if e.target isnt e.currentTarget
    @highlightLines()


  mouseMove: (e) ->

    return  unless @_trackJoint
    {x, y} = @_trackJoint.getPos()
    ex = x + (e.clientX - @_trackJoint.getX())
    ey = y + (e.clientY - @_trackJoint.getY())
    @drawFakeLine {sx:x, sy:y, ex, ey}


  mouseUp: (e) ->

    return  unless @_trackJoint

    targetId = $(e.target).closest(".kddia-object").attr("dia-id")
    sourceId = @_trackJoint.getDiaId()
    delete @_trackJoint

    # Cleanup fake scene
    @cleanup @fakeCanvas

    return  unless targetId

    source = @getDia sourceId
    target = @getDia targetId

    debug 'source - target', { source, target }

    target.joint = @guessJoint target, source  unless target.joint
    @connect source, target  if target.joint


  guessJoint: (target, source) ->

    joints = Object.keys target.dia.joints
    return  if joints.length is 0
    return joints.first  if joints.length is 1

    if source.joint is 'right'
      return 'left'    if target.dia.joints.left
      return 'bottom'  if target.dia.joints.bottom
      return 'top'     if target.dia.joints.top

    if source.joint is 'left'
      return 'right'   if target.dia.joints.right
      return 'bottom'  if target.dia.joints.bottom
      return 'top'     if target.dia.joints.top

    if source.joint is 'bottom'
      return 'top'     if target.dia.joints.top
      return 'bottom'  if target.dia.joints.bottom
      return 'left'    if target.dia.joints.left

    if source.joint is 'top'
      return 'bottom'  if target.dia.joints.bottom
      return 'top'     if target.dia.joints.top
      return 'right'   if target.dia.jointsright


  getDia: (id) ->

    # Find a better way for this
    parts = ( id.match /dia\-((.*)\-joint\-(.*)|(.*))/ ).filter (m) -> !!m
    return null  unless parts
    [objId, joint] = parts.slice(-2)
    joint = null  if objId is joint
    for container in @containers
      break  if dia = container.dias[objId]
    return {dia, joint, container}


  highlightLines: (dia=[], update=yes) ->

    if not Array.isArray dia then dia = [dia]
    @activeDias = dia
    joint.off 'DeleteRequested'      for joint in @activeJoints
    container.emit 'UnhighlightDias' for container in @containers
    @activeJoints = []
    @updateScene()  if update
    return  unless @activeDias.length is 1

    dia = dia.first
    for connection in @connections
      {source, target} = connection
      if (source.dia is dia) or (target.dia is dia)
        [source, target].forEach (conn)=>
          conn.dia.setClass 'highlight'
          unless conn.dia is dia
            joint = conn.dia.joints[conn.joint]
            if joint and joint not in @activeJoints
              joint.showDeleteButton()
              joint.on 'DeleteRequested', @bound 'disconnect'
              @activeJoints.push joint


  handleLineRequest: (joint) ->
    @_trackJoint = joint


  findTargetConnection: (dia, joint) ->

    isEqual = (connection) ->
      (dia is connection.dia) and (joint is connection.joint)

    activeDia = @activeDias.first

    for conn in @connections
      if ((isEqual conn.source) or (isEqual conn.target)) and \
         ((conn.source.dia is activeDia) or (conn.target.dia is activeDia))
        return conn


  deleteConnection: (connectionToDelete) ->

    @connections = @connections.filter (connection) ->
      connection isnt connectionToDelete


  disconnect: (dia, joint) ->

    return  if @activeDias.length isnt 1

    connectionToDelete = @findTargetConnection dia, joint
    @deleteConnection connectionToDelete

    @highlightLines @activeDias


  disconnectAllConnections:(dia)->

    newConnections = []
    for connection in @connections
      {source, target} = connection
      if dia.getDiaId() not in [source.dia.getDiaId(), target.dia.getDiaId()]
        newConnections.push connection
    @connections = newConnections

    @highlightLines()


  allowedToConnect: (source, target) ->

    return no  unless source and target
    return no  if source.dia?.id is target.dia?.id

    for i in [0..1]
      if Object.keys(source.dia.allowedConnections).length > 0
        allowList = source.dia.allowedConnections
        restrictions = allowList[target.dia.constructor.name]
        return no  unless restrictions
        return no  if source.joint in restrictions
      [source, target] = [target, source]

    return yes


  connect: (source, target, update = yes) ->

    return  if not @allowedToConnect source, target

    @emit "ConnectionCreated", source, target
    options = { transfers: [] }
    @connections.push connection = { source, target, options }
    @highlightLines target.dia, update

    return connection


  resetScene: ->

    @fakeConnections = []
    @updateScene()


  updateScene: do (queued = no) -> ->

    return  if @_paused

    return unless @parentIsInDom
      if not queued
        @once 'viewAppended', @bound 'updateScene'
        queued = yes

      return

    needsUpdate = !!@_forceUpdate
    @cleanup @realCanvas

    for connection in @connections

      if connection.options.transfers.length > 0
        needsUpdate = yes
        KD.utils.defer =>
          @_autoUpdate ?= KD.utils.repeat @updateEvery, @bound 'updateScene'

      @drawConnectionLine connection

    for connection in @fakeConnections
      @drawConnectionLine connection

    unless needsUpdate
      @_autoUpdate = KD.utils.killRepeat @_autoUpdate


  pause: ->

    @_paused = yes


  play: ->

    @_paused = no
    @updateScene()


  startAutoUpdate: do (autoKill = null) -> (duration) ->

    @_forceUpdate = yes
    @_autoUpdate ?= KD.utils.repeat @updateEvery, @bound 'updateScene'

    return  unless duration
    KD.utils.killWait autoKill
    autoKill = KD.utils.wait duration, @bound 'stopAutoUpdate'


  stopAutoUpdate: ->

    return  if @hasActiveTransfer()

    @_forceUpdate = no
    @_autoUpdate = KD.utils.killRepeat @_autoUpdate


  hasActiveTransfer: ->

    for connection in @connections
      return yes  if connection.options.transfers.length > 0
    return no


  getBezierCurves = (t, pos) ->

    # Applying Cubic Bézier Curve formula to provided
    # positions to get specific position in given t
    # where t is 0 <= t <= 1.
    #
    # https://en.wikipedia.org/wiki/Bézier_curve

    mt = 1 - t
    b  = [
      mt ** 3          # P0 * (1 - t)^3
      3 * t * mt ** 2  # P1 * 3 * (1 - t)^2 * t
      3 * mt * t ** 2  # P2 * 3 * (1 - t) * t^2
      t ** 3           # P3 * t^3
    ]

    # Above formula will be applied below with following data;
    #
    # Where P0 is s  -> source joint position
    # Where P1 is c1 -> first control point
    # Where P2 is c2 -> second control point
    # Where P3 is t  -> target joint position
    #
    # Then sum of Ps will get the curve point

    { s, t, c1, c2 } = pos

    # Applying for both x and y coordinates to get pin point
    return {
      x: (s.x * b[0]) + (c1.x * b[1]) + (c2.x * b[2]) + (t.x * b[3])
      y: (s.y * b[0]) + (c1.y * b[1]) + (c2.y * b[2]) + (t.y * b[3])
    }


  # TODO: we can implement a cache mechanism for calculated joint positions
  # if we know the changed node/joint. So, in that case we won't need to re
  # calculate all the line positions from scratch for example only one node's
  # position has changed. This requires a bit refactoring here ~ GG
  drawConnectionLine: ({ source, target, options = {} }) ->

    return  unless source or target

    { lineColorActive, lineDashes, transfers = []
      lineColor, lineWidth, curveDistance } = @getOptions()

    @realContext.beginPath()

    activeDia = if source.dia in @activeDias then source \
                else if target.dia in @activeDias then target

    lineColor = options.lineColor ? lineColor
    lineWidth = options.lineWidth ? lineWidth

    if activeDia
      lineColor  = options.lineColor  ? \
                   (activeDia.dia.getOption 'colorTag') ? lineColorActive
      lineDashes = options.lineDashes ? \
                   (activeDia.dia.getOption 'lineDashes') ? lineDashes

    sJoint = source.dia.getJointPos source.joint
    tJoint = target.dia.getJointPos target.joint

    # Take canvas position into account to render correctly
    # when scale changed on the view ~ GG
    canvas = { x: @realCanvas.getX(), y: @realCanvas.getY() }

    s = { x: sJoint.x - canvas.x, y: sJoint.y - canvas.y }
    t = { x: tJoint.x - canvas.x, y: tJoint.y - canvas.y }

    @realContext.strokeStyle = lineColor
    @realContext.setLineDash lineDashes  if lineDashes.length > 0

    @realContext.moveTo s.x, s.y

    cd = curveDistance
    [ sx, sy, tx, ty ] = [ 0, 0, 0, 0 ]
    if source.joint in ["top", "bottom"]
      sy = if source.joint is "top" then -cd else cd
    else if source.joint in ["left", "right"]
      sx = if source.joint is "left" then -cd else cd
    if target.joint in ["top", "bottom"]
      ty = if target.joint is "top" then -cd else cd
    else if target.joint in ["left", "right"]
      tx = if target.joint is "left" then -cd else cd

    c1 = { x: s.x + sx, y: s.y + sy }
    c2 = { x: t.x + tx, y: t.y + ty }

    @realContext.bezierCurveTo c1.x, c1.y, c2.x, c2.y, t.x, t.y
    @realContext.lineWidth = lineWidth

    @realContext.stroke()

    return  if options.transfers.length is 0

    transfers = []
    options.transfers.forEach (transfer) =>

      { step, reverse, size, stepSize, textAlign
        color, text, font, shadowColor, shadowBlur } = transfer

      @realContext.fillStyle = color

      dot = getBezierCurves step, { s, t, c1, c2 }
      if text
        @realContext.font        = font         if font
        @realContext.textAlign   = textAlign    if textAlign
        @realContext.shadowColor = shadowColor  if shadowColor
        @realContext.shadowBlur  = shadowBlur   if shadowBlur
        @realContext.fillText text, dot.x, dot.y
      else
        dot.x -= size / 2
        dot.y -= size / 2
        @realContext.fillRect dot.x, dot.y, size, size

      if 0 < (step += stepSize) < 1
        transfer.step = step
        transfers.push transfer
      else
        KD.utils.defer => @emit "Transfer-#{transfer.id}-Done"

    options.transfers = transfers

    return


  addTransfer: (connection, transfer = {}) ->

    transfer = $.extend
      size        : 3
      reverse     : no
      stepSize    : 0.005
      duration    : 1000
      font        : '12px sans-serif'
      color       : 'black'
      textAlign   : 'center'
      shadowBlur  : 10
    , transfer

    transfer.step = 0

    if transfer.duration
      transfer.stepSize = 1 / (transfer.duration / @updateEvery)

    if transfer.reverse
      transfer.step = 1
      transfer.stepSize = -transfer.stepSize  if transfer.stepSize > 0

    hasTransfer = no

    if transfer.id
      transfers = []
      connection.options.transfers.forEach (_transfer) ->
        if transfer.id is _transfer.id
          transfer.step = _transfer.step
          transfers.push transfer
          hasTransfer = yes
        else
          transfers.push _transfer

      connection.options.transfers = transfers

    unless hasTransfer
      transfer.id = KD.utils.getUniqueId()
      connection.options.transfers.push transfer

    @updateScene()

    return transfer.id


  addFakeConnection: (connection) ->

    @drawConnectionLine connection
    @fakeConnections.push connection


  createCanvas: ->

    return  if @realCanvas

    @addSubView @realCanvas = new KDCustomHTMLView
      tagName    : 'canvas'
      attributes : @getSceneAttributes()
    @realContext = @realCanvas.getElement().getContext '2d'

    # Fallback function for Firefox and Safari
    # which does not support lineDashes correctly ~ GG
    @realContext.setLineDash = KD.noop  unless @realContext.setLineDash?

    @addSubView @fakeCanvas = new KDCustomHTMLView
      tagName    : 'canvas'
      cssClass   : 'fakeCanvas'
      attributes : @getSceneAttributes()
    @fakeContext = @fakeCanvas.getElement().getContext '2d'


  setScale: (scale = 1) ->

    @scale = scale
    container.setScale scale  for container in @containers
    @updateScene()


  cleanup: (canvas) ->

    canvas.setAttributes @getSceneAttributes()


  parentDidResize: ->

    super
    @updateScene()


  getSceneAttributes: -> {
    width  : @getWidth()
    height : @getHeight()
  }


  dumpScene: ->

    containers = {}
    for _, c of @containers
      containers[c.id] = c.dumpContainer()

    connections = []
    for connection in @connections
      { source, target, options: { transfers } } = connection
      connections.push {
        source: source.dia.id
        target: target.dia.id
        transfers
      }

    JSON.stringify { containers, connections }


  reset: (update = yes) ->

    @connections     = []
    @fakeConnections = []
    @updateScene()  if update
