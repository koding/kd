HeaderView     = require './HeaderView'
SideNavigation = require './sidenavigation'
ContentView    = require './contentview'

module.exports = class PageView extends KDView

  constructor: (options = {}) ->

    options.cssClass = 'page-view'
    options.tagName  = 'main'
    options.partial  = '<div class=\'inner-wrapper guide-page clearfix\'></div>'

    super options

    @topNav  = new HeaderView
    @sideNav = new SideNavigation
    @content = new ContentView


  viewAppended: ->

    @addSubView @topNav, null, yes
    @addSubView @sideNav
    @addSubView @content
