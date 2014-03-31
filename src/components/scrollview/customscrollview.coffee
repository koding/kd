require('jquery-mousewheel') $

JView                     = require './../../core/jview'
KDCustomHTMLView          = require './../../core/customhtmlview'
KDScrollTrack             = require './scrolltrack'
KDCustomScrollViewWrapper = require './customscrollviewinner'

module.exports = class KDCustomScrollView extends KDCustomHTMLView

  constructor:(options = {}, data)->

    options.naturalScroll   ?= yes
    options.cssClass         = KD.utils.curry 'kdcustomscrollview', options.cssClass
    options.mouseWheelSpeed ?= 3

    super options, data

    {mouseWheelSpeed} = @getOptions()

    @wrapper = new KDCustomScrollViewWrapper {
      tagName  : 'main'
      mouseWheelSpeed
    }

    @verticalTrack   = new KDScrollTrack delegate : @wrapper
    @horizontalTrack = new KDScrollTrack delegate : @wrapper, type : 'horizontal'
    @wrapper.verticalThumb   = @verticalTrack.thumb
    @wrapper.horizontalThumb = @horizontalTrack.thumb

    @wrapper.on 'ScrollTrackShown',  (type)=> @setClass   "has-#{type}"
    @wrapper.on 'ScrollTrackHidden', (type)=> @unsetClass "has-#{type}"

  viewAppended:->

    @addSubView @wrapper
    @addSubView @verticalTrack
    @addSubView @horizontalTrack

    @wrapper.observeMutations()

    @wrapper.on 'MutationHappened', @verticalTrack.thumb.bound 'handleMutation'
    @wrapper.on 'MutationHappened', @horizontalTrack.thumb.bound 'handleMutation'
