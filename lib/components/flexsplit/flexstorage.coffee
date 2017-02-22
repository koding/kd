KD       = require '../../core/kd'
KDObject = require '../../core/object'

KDFlex = require './flex'


module.exports = class KDFlexSplitStorage extends KDObject


  constructor: (options = {}, data) ->

    super options, data

    @storage    = {}
    @viewCount  = 0
    @eventCount = 0

    if adapterClass = @getOption 'adapter'
      @adapter = new adapterClass


  addView: (view, identifier, options = {}) ->

    options.restore          ?= yes
    options.keepExpandStatus ?= yes # Experimental

    view.on [ KDFlex.EVENT_RESIZED, KDFlex.EVENT_HIDDEN ], (fractions) =>
      @set identifier, fractions
      @store()

    if options.keepExpandStatus
      view.on [
        KDFlex.EVENT_EXPANDED
        KDFlex.EVENT_COLLAPSED
      ], (fractions) =>

        @eventCount++
        @set identifier, fractions

        if @eventCount is @viewCount - 1
          @eventCount = 0
          @store()

    @viewCount++

    KD.utils.wait 500, =>

      @get identifier, (fractions) =>

        sizes = view.getOption 'sizes'
        fractions ?= sizes

        if options.restore and fractions
          view.setFractions fractions, { initialFractions: sizes }
          @set identifier, fractions


  get: (identifier, callback) ->
    if @adapter
    then @adapter.get identifier, callback
    else callback @storage[identifier]


  set: (identifier, fractions, callback = KD.noop) ->
    @storage[identifier] = fractions
    callback null, @storage


  store: (callback = KD.noop) ->
    if @adapter?.store?
    then @adapter.store @storage, callback
    else callback null
