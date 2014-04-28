HeaderView     = require './HeaderView'
SideNavigation = require './sidenavigation'
ContentView    = require './contentview'

module.exports = class PageView extends JView

  constructor: (options = {}) ->

    options.cssClass = 'page-view'
    options.tagName  = 'main'

    super options

    @topNav  = new HeaderView
    @sideNav = new SideNavigation
    @content = new ContentView


  pistachio: ->

    """
    {{> this.topNav}}
    <div class='inner-wrapper guide-page clearfix'>
      {{> this.sideNav}}
      {{> this.content}}
    </div>
    """
