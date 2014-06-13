KDView = require './../../core/view.coffee'

module.exports = class KDListItemView extends KDView

  constructor:(options = {},data)->

    options.type           = options.type ? "default"
    options.cssClass       = "kdlistitemview kdlistitemview-#{options.type} #{options.cssClass ? ''}"
    options.bind         or= "mouseenter mouseleave"
    options.childClass   or= null
    options.childOptions or= {}
    options.selectable    ?= yes

    super options,data

    @content = {}

  viewAppended:->

    {childClass, childOptions} = @getOptions()
    if childClass
      @addSubView @child = new childClass childOptions, @getData()
    else
      @setPartial @partial @data

  partial:->
    "<div class='kdlistitemview-default-content'>
      <p>This is a default partial of <b>KDListItemView</b>,
      you need to override this partial to have your custom content here.</p>
    </div>"

  dim:->

    @setClass "dimmed"

  undim:->

    @unsetClass "dimmed"

  highlight:->

    @undim()
    @setClass "selected"

  removeHighlight:->

    @undim()
    @unsetClass "selected"

  getItemDataId: ->
    data = @getData()

    id = if data.getId?() then data.getId()
    else if data.id?      then data.id
    else if data._id?     then data._id

