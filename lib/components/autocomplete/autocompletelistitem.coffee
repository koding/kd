KD = require '../../core/kd'
KDListItemView = require '../list/listitemview'

module.exports = class KDAutoCompleteListItemView extends KDListItemView

  constructor:(options = {}, data)->

    options.cssClass = KD.utils.curry "kdautocompletelistitem", options.cssClass
    options.bind     = "mouseenter mouseleave"

    super options,data

    @active = no

  viewAppended:-> @updatePartial @partial @data

  mouseEnter:-> @makeItemActive()

  mouseLeave:-> @makeItemInactive()

  makeItemActive:->
    item.makeItemInactive() for item in @getDelegate().items
    @active = yes
    @setClass "active"

  makeItemInactive:->
    @active = no
    @unsetClass "active"

  click: (event)->
    list = @getDelegate()
    list.emit 'KDAutoCompleteSubmit', this, @data
    return KD.utils.stopDOMEvent event

  partial:-> "<div class='autocomplete-item clearfix'>Default item</div>"
