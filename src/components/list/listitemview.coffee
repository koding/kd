KDView = require './../../core/view.coffee'

###*
 * KDListItemView is primarily a default class, used by KDListView and
 * KDListViewController as the default view to be added.
 *
 * It comes with a method that provides the default partial, meaning that
 * if you choose to inherit from this class you should implement your own
 * `partial` method returning a string you'd like to use.
 *
 * ## Usage
 *
 * ```coffee
 * class CustomListItem extends KDListItemView
 *   partial: -> 'This is my custom list item'
 *
 * view = new KDListView()
 * view.addItemView new CustomListItem()
 *
 * appView.addSubView header
 * ```
 *
 * As you can see, we implemented a class `CustomListView` that extended the
 * `partial` method and returned a string that we wanted to use.
###
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

  getItemDataId:-> @getData().getId?() or @getData().id or @getData()._id
