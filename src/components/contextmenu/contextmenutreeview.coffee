JTreeView = require './../tree/treeview.coffee'

module.exports = class JContextMenuTreeView extends JTreeView

  constructor:(options = {}, data = {})->

    options.type     or= "contextmenu"
    options.animated  ?= no
    options.cssClass or= "default"

    super options, data

    @unsetClass "jtreeview"
