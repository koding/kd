HeaderView = require './headerview'
FooterView = require './footerview'
PageView   = require './pageview'

module.exports = class MainView extends KDView

  constructor : (options = {}) ->

    options.cssClass = 'main-view'
    options.tagName  = 'main'

    super options

    @appendToDomBody()

    @header = new HeaderView

    @examples = new KDView
      cssClass : 'examples home-section'
      tagName  : 'section'

    @footer = new FooterView

    @download = new KDCustomHTMLView
      tagName    : 'a'
      partial    : 'DOWNLOAD THE THING'
      cssClass   : 'download-button'
      attributes :
        href     : 'http://github.com/koding/kd'


  showPage: ->
    @hide()

    page = new PageView
    page.appendToDomBody()


  viewAppended : ->

    @addSubView @header
    @setPartial @partial()
    # @addSubView @examples
    # @addSubView @footer
    # @addSubView @download, '.intro .inner-wrapper'

    @createExamples()

    KD.singletons.windowController.on 'ScrollHappened', @bound 'handleScroll'


  partial: ->

    """
    <section class='intro home-section'>
      <div class='inner-wrapper'>
        <figure class='logo'></figure>
        <h2><span>A UI framework for the modern web, soon to be here.</span></h2>
      </div>
    </section>

    <section class='features home-section hidden'>
      <div class='inner-wrapper'>
        <article class='feature'>
          <figure class='chrome'></figure>
          <h3>FROM KODING</h3>
          <p>
            coming soon...
          </p>
        </article>

        <article class='feature'>
          <figure class='king'></figure>
          <h3>LIKE A FKIN BOSS</h3>
          <p>
            coming soon...
          </p>
        </article>

        <article class='feature'>
          <figure class='box'></figure>
          <h3>OUT OF THE BOX</h3>
          <p>
            coming soon...
          </p>
        </article>
      </div>
    </section>
    """

  createExamples: ->

    @examples.addSubView innerWrapper = new KDView
      cssClass  : 'inner-wrapper'

    innerWrapper.addSubView new KDHeaderView
      type      : 'medium'
      title     : 'Let’s talk about the reality'

    innerWrapper.addSubView new KDHeaderView
      type      : 'small'
      title     : 'What you can do, what you can not do, samples baby'

    innerWrapper.addSubView exampleTabs = new KDTabView
      hideHandleCloseIcons : yes

    exampleTabs.addPane new KDTabPaneView
      name    : 'soon-1'
      tagName : 'pre'
      view    : new KDView
        tagName : 'code'
        partial :
          """
          @addSubView @comingSoonView = new KDView
            cssClass : 'coming-soon'
            tagName  : 'section'
            click    : ->
              new KDNotificationView
                title : 'Coming soon...'
                type  : 'tray'
          """

    exampleTabs.addPane (new KDTabPaneView
      name    : 'soon-2'
      tagName : 'pre'
      view    : new KDView
        tagName : 'code'
        partial :
          """
          @comingSoonView = new KDView
            cssClass : 'coming-soon'
            tagName  : 'section'
            click    : ->

          @comingSoonView.appendToDomBody()

          @comingSoonView.on 'click', ->
            new KDNotificationView
              title : 'Coming soon...'
              type  : 'tray'
          """
    ), false

    exampleTabs.addPane (new KDTabPaneView
      name    : 'soon-3'
      tagName : 'pre'
      view    : new KDView
        tagName : 'code'
        partial :
          """
          @comingSoonController = new KDController

          @comingSoonController.fetchSomeData (err, data)->

            return console.log err  if err

            new KDNotificationView
              title : 'Some data is fetched, but this is still coming soon...'
              type  : 'tray'
          """
    ), false

    hljs.configure
      languages : ['coffeescript']

    hljs.highlightBlock exampleTabs.getActivePane().mainView.getDomElement()[0]

    exampleTabs.on 'PaneDidShow', (pane) ->
      hljs.highlightBlock pane.mainView.getDomElement()[0]

    innerWrapper.addSubView new KDCustomHTMLView
      cssClass : 'go-to-doc'
      partial  : 'Unbelieveable huh? Continue and you’ll see the other <a href="http://docs.kd.io">parts and such.</a>'


  handleScroll: ->

    scrollPosition = window.scrollY
    if (scrollPosition >= 520) and not @headerCollapsed

      @setClass 'collapse-header'
      @headerCollapsed = yes

    else if (scrollPosition <= 520) and @headerCollapsed

      @unsetClass 'collapse-header'
      @headerCollapsed = no
