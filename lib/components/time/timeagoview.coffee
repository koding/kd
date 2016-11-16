$ = require 'jquery'
KD = require '../../core/kd'
KDView = require '../../core/view'
timeago = new require 'timeago'

module.exports = class KDTimeAgoView extends KDView

  @registerStaticEmitter()

  KD.utils.repeat 60000, => @emit "OneMinutePassed"

  constructor: (options = {}, data) ->

    options.tagName = "time"

    super options, data

    KDTimeAgoView.on "OneMinutePassed", => @updatePartial timeago.format @getData()

  setData: ->
    super
    @updatePartial timeago.format @getData()  if @parent

  viewAppended: ->
    @setPartial timeago.format @getData()
