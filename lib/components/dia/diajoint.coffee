debug = require('debug') 'kd:dia:diajoint'
KD = require '../../core/kd'
KDView = require '../../core/view'

module.exports = class KDDiaJoint extends KDView

  types = ['left', 'right', 'top', 'bottom']

  constructor:(options={}, data)->

    options.type   or= 'left'
    unless options.type in types
      debug "unknown joint type '#{options.type}', falling back to 'left'"
      options.type = 'left'

    options.static  ?= no
    options.size    ?= 10
    options.cssClass = \
      KD.utils.curry "kddia-joint #{options.type}", options.cssClass

    super options, data

    @connections = {}
    @type = @getOption 'type'
    @size = @getOption 'size'

  viewAppended:->
    super
    @domElement.attr "dia-id", @getDiaId()

  getDiaId:->
    "dia-#{@parent.getId()}-joint-#{@type}"

  getPos:->
    @parent.getJointPos this

  click:(e)->
    @emit 'DeleteRequested', @parent, @type  if @inDeleteMode()
    @utils.stopDOMEvent e

  mouseDown:(e)->
    return  if @inDeleteMode()
    @utils.stopDOMEvent e
    @parent.emit "JointRequestsLine", this
    return no

  inDeleteMode:->
    @hasClass 'deleteMode'

  showDeleteButton:->
    @setClass 'deleteMode'  unless @isStatic()

  hideDeleteButton:->
    @unsetClass 'deleteMode'

  isStatic:->
    @getOption 'static'