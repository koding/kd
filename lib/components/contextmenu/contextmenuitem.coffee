KD = require '../../core/kd'
KDView        = require '../../core/view'
JTreeItemView = require '../tree/treeitemview'

module.exports = class JContextMenuItem extends JTreeItemView

  constructor:(options = {}, data = {})->

    options.type       = "contextitem"
    options.cssClass or= "default #{KD.utils.slugify data.title}"
    data.title        ?= ''

    super options, data

    @unsetClass "jtreeitem"

    if data
      if data.type is "divider" or data.type is "separator"
        @setClass "separator"

      if data.cssClass
        @setClass data.cssClass

      if data.type is "customView"
        @addCustomView data

      if data.disabled
        @setClass "disabled"

  viewAppended:->
    super()  unless @customView

  mouseDown:-> yes

  addCustomView:(data)->

    @setClass "custom-view"
    @unsetClass "default"
    @customView = data.view or new KDView
    delete data.view
    @addSubView @customView
