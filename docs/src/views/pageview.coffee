TopNavigation  = require './topnavigation'
SideNavigation = require './sidenavigation'
ContentView    = require './contentview'

module.exports = class PageView extends JView

  constructor: (options = {}) ->

    options.cssClass = 'page-view'
    options.tagName  = 'main'

    super options

    @topNav  = new TopNavigation
    @sideNav = new SideNavigation
    @content = new ContentView


  pistachio: ->

    """
    {{> @topNav}}
    {{> @sideNav}}
    {{> @content}}
    """
