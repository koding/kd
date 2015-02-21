KD = require '../../core/kd'
KDDiaJoint = require './diajoint'
KDView = require '../../core/view'

module.exports = class KDDiaObject extends KDView

  constructor:(options, data)->

    options.cssClass  = KD.utils.curry 'kddia-object', options.cssClass

    unless options.draggable?
      options.draggable = {}  unless 'object' is typeof options.draggable
      options.draggable.containment or= {}
      options.draggable.containment.view or= 'parent'
      options.draggable.containment.padding ?=
        top: 1, right: 1, bottom: 1, left: 1

    options.bind = KD.utils.curry 'mouseleave', options.bind
    options.joints ?= ['left', 'right']
    options.jointItemClass ?= KDDiaJoint
    options.allowedConnections or= {}
    options.staticJoints or= []

    super options, data

    @joints = {}
    @allowedConnections = @getOption 'allowedConnections'
    @domElement.attr "dia-id", "dia-#{@getId()}"
    @wc = KD.getSingleton 'windowController'

    @on "KDObjectWillBeDestroyed", => @emit 'RemoveMyConnections'

    @once 'viewAppended', =>
      @addJoint joint for joint in @getOption 'joints'
      @parent.on 'UnhighlightDias', =>
        @unsetClass 'highlight'
        joint.hideDeleteButton()  for key, joint of @joints

  mouseDown:(e)->
    @emit "DiaObjectClicked"
    @_mouseDown = yes
    @wc.once 'ReceivedMouseUpElsewhere', => @_mouseDown = no
    @utils.stopDOMEvent e  unless @getOption 'draggable'

  mouseLeave:(e)->
    return  unless @_mouseDown

    bounds = @getBounds()
    joint  = null

    bounds.w = bounds.w * @parent.scale
    bounds.h = bounds.h * @parent.scale

    if e.pageX >= bounds.x + bounds.w  # means right joint
      joint = @joints['right']
    if e.pageX <= bounds.x             # means left joint
      joint = @joints['left']
    if e.pageY >= bounds.y + bounds.h  # means bottom joint
      joint = @joints['bottom']
    if e.pageY <= bounds.y             # means top joint
      joint = @joints['top']

    if joint then @emit "JointRequestsLine", joint

  addJoint:(type)->

    if @joints[type]?
      KD.warn "KDDiaObject: Tried to add same joint! Destroying old one. "
      @joints[type].destroy?()

    {jointItemClass, staticJoints} = @getOptions()
    @addSubView joint = new jointItemClass {type, static: type in staticJoints}

    @joints[type] = joint

  getJointPos:(joint)->
    if typeof joint is "string"
      joint = @joints[joint]
    return {x:0, y:0}  unless joint

    [p, s, j]  = [@parent.getElement(), @getElement(), joint.getElement()]
    [ x , y  ] = [p.offsetLeft + s.offsetLeft, p.offsetTop + s.offsetTop]
    [ jx, jy ] = [j.offsetLeft, j.offsetTop]
    [ dx, dy ] = if joint.type in ['left', 'right'] then [10, 4] else [4, 10]

    x:x + jx + dx, y: y + jy + dy

  getDiaId:->
    @domElement.attr "dia-id"
