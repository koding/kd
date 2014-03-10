KDView = require './../../core/view.coffee'

module.exports = class KDAutoCompletedItem extends KDView

  constructor:(options = {}, data)->
    options.cssClass = @utils.curry "kdautocompletedlistitem", options.cssClass
    super

  click:(event)->
    @getDelegate().removeFromSubmitQueue @ if $(event.target).is('span.close-icon')
    @getDelegate().getView().$input().trigger "focus"

  viewAppended:->
    @setPartial @partial()

  partial:(data)->
    @getDelegate().getOptions().itemClass::partial @getData()
