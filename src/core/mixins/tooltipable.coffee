
module.exports = Tooltip = ->

  @unsetTooltip = ->

    @tooltip?.destroy()
    @tooltip = null


  @setTooltip = (o = {}) ->

    placementMap =
      above      : "s"
      below      : "n"
      left       : "e"
      right      : "w"

    o.title     or= ""
    o.cssClass  or= ""
    o.placement or= "top"
    o.direction or= "center"
    o.offset    or=
      top         : 0
      left        : 0
    o.delayIn   or= 0
    o.delayOut  or= 0
    o.html       ?= yes
    o.animate    ?= no
    o.selector  or= null
    o.gravity   or= placementMap[o.placement]
    o.fade      or= o.animate
    o.fallback  or= o.title
    o.view      or= null
    o.sticky     ?= no
    o.permanent  ?= no
    o.delegate  or= this
    o.events    or= ['mouseenter','mouseleave','mousemove']

    @unsetTooltip()
    KDTooltip = require '../../components/tooltip/tooltip.coffee'
    @tooltip  = new KDTooltip o, {}


  @getTooltip = -> @tooltip


