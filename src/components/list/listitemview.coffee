KDView = require './../../core/view.coffee'
###*
* # KDListItemView
*
* KDListItemView is primarily a default class, used by 
* [KDListView](./kdlistview.md) and 
* [KDListViewController](./kdlistviewcontroller.md) as the default view to be 
* added.
*
* It comes with a method that provides the default partial, meaning that if you 
* choose to inherit from this class you should implement your own `partial` 
* method returning a string you'd like to use.
*
* ## Usage
*
* ```coffee
* class CustomListItem extends KDListItemView
*  partial: -> 'This is my custom list item'
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
  ###*
  *   The following keys are supported.
  *
  * - **options.childClass**: The that all subview will be changed to
  *   - Type: object
  *   - Default: `null`
  * - **options.childOptions**: Options passed to all subviews
  *   - Type: object
  *   - Default: `{}`
  * - **options.selectable**: Whether this object can be selected or not
  *   - Type: boolean
  *   - Default: `true`
  ###
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
  ###*
  * Dims the view by setting the CSS class `"dimmed"`
  ###
  dim:->

    @setClass "dimmed"
  ###*
  * Undims the view by unseting the CSS class `"dimmed"`
  ###
  undim:->

    @unsetClass "dimmed"
  ###*
  * Highlights the view by setting the CSS `"selected"`. If the view was dimmed it will be undimmed
  ###
  highlight:->

    @undim()
    @setClass "selected"
  ###*
  * Removes the highlight of the view by unsetting the CSS class `"selected"`. If the view was dimmed it will be undimmed
  ###
  removeHighlight:->

    @undim()
    @unsetClass "selected"
  ###*
  * Returns the data id
  ###
  getItemDataId: ->
    data = @getData()

    id = if data.getId?() then data.getId()
    else if data.id?      then data.id
    else if data._id?     then data._id

