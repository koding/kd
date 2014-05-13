module.exports = class SideNavigation extends KDView

  constructor : (options = {}) ->

    options.tagName  = 'aside'
    options.cssClass = 'main-sidebar'

    super options

    @menu = new JTreeViewController
      cssClass    : 'side-menu'

    ,
    [
      title             : 'GETTING STARTED'
      id                : 1
    ,
      title             : "So like let's do it"
      parentId          : 1
    ,
      title             : "How to be cool like u guys?"
      parentId          : 1
    ,
      title             : "Fight fire with fire maybe"
      parentId          : 1
    ,
      title             : 'GETTING KD'
      id                : 2
    ,
      title             : "So like let's do it"
      parentId          : 2
    ,
      title             : "How to be cool like u guys?"
      parentId          : 2
    ,
      title             : "Fight fire with fire maybe"
      parentId          : 2
    ,
      title             : 'CONCEPTS'
      id                : 3
    ,
      title             : 'GETTING KD'
      id                : 3
    ,
      title             : "So like let's do it"
      parentId          : 3
    ,
      title             : "How to be cool like u guys?"
      parentId          : 3
    ,
      title             : "Fight fire with fire maybe"
      parentId          : 3
    ]

  viewAppended : ->
    @addSubView @menu.getView()
