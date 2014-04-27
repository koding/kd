HeaderView = require './headerview'
FooterView = require './footerview'

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

  viewAppended : ->

    JView::viewAppended.call this

    @createExamples()

    KD.singletons.windowController.on 'ScrollHappened', @bound 'handleScroll'


  showPage: ->


  pistachio: ->

    """
    {{> this.header}}
    <section class='features home-section'>
      <div class='inner-wrapper'>
        <article class='feature'>
          <figure class='chrome'></figure>
          <h3>FROM KODING</h3>
          <p>
            That's the shizzle metus my shizz, luctizzle et, tristique izzle,
            dope at, nulla. Donec pharetra, nisi shut the shizzle up facilisizzle
            malesuada, neque justo its fo rizzle dope, mollizzle sheezy
            tellivizzle erat izzle phat.
          </p>
        </article>

        <article class='feature'>
          <figure class='king'></figure>
          <h3>LIKE A FKIN BOSS</h3>
          <p>
            That's the shizzle metus my shizz, luctizzle et, tristique izzle,
            dope at, nulla. Donec pharetra, nisi shut the shizzle up facilisizzle
            malesuada, neque justo its fo rizzle dope, mollizzle sheezy
            tellivizzle erat izzle phat.
          </p>
        </article>

        <article class='feature'>
          <figure class='box'></figure>
          <h3>OUT OF THE BOX</h3>
          <p>
            That's the shizzle metus my shizz, luctizzle et, tristique izzle,
            dope at, nulla. Donec pharetra, nisi shut the shizzle up facilisizzle
            malesuada, neque justo its fo rizzle dope, mollizzle sheezy
            tellivizzle erat izzle phat.
          </p>
        </article>
      </div>
    </section>
    {{> this.examples}}
    {{> this.footer}}
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
      name    : 'avatar.js'
      tagName : 'pre'
      view    : new KDView
        tagName : 'code'
        partial :
          """
          @addSubView @examplesSection = new KDView
            cssClass    : 'examples home-section'
            tagName     : 'section'

          @examplesSection.addSubView innerWrapper = new KDView
            cssClass  : 'inner-wrapper'

          innerWrapper.addSubView new KDHeaderView
            type      : 'medium'
            title     : 'Let’s talk about the reality'

          innerWrapper.addSubView new KDHeaderView
            type      : 'small'
            title     : 'What you can do, what you can not do, samples baby'
          """

    exampleTabs.addPane (new KDTabPaneView
      name    : 'blob.js'
      tagName : 'pre'
      view    : new KDView
        tagName : 'code'
        partial :
          """
          @addSubView @examplesSection = new KDView
            cssClass    : 'examples home-section'
            tagName     : 'section'

          @examplesSection.addSubView innerWrapper = new KDView
            cssClass  : 'inner-wrapper'

          innerWrapper.addSubView new KDHeaderView
            type      : 'medium'
            title     : 'Let’s talk about the reality'

          innerWrapper.addSubView new KDHeaderView
            type      : 'small'
            title     : 'What you can do, what you can not do, samples baby'
          """
    ), false

    exampleTabs.addPane (new KDTabPaneView
      name    : 'hjob.js'
      tagName : 'pre'
      view    : new KDView
        tagName : 'code'
        partial :
          """
          @addSubView @examplesSection = new KDView
            cssClass    : 'examples home-section'
            tagName     : 'section'

          @examplesSection.addSubView innerWrapper = new KDView
            cssClass  : 'inner-wrapper'

          innerWrapper.addSubView new KDHeaderView
            type      : 'medium'
            title     : 'Let’s talk about the reality'

          innerWrapper.addSubView new KDHeaderView
            type      : 'small'
            title     : 'What you can do, what you can not do, samples baby'
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