module.exports = class MainView extends KDView

  constructor : (options = {}) ->
    options.cssClass = 'main-view'
    options.tagName  = 'main'

    super options

    @appendToDomBody()

  createIntroSection : ->
    @addSubView @introSection = new KDView
      cssClass  : 'intro home-section'
      tagName   : 'section'

    @introSection.addSubView innerWrapper = new KDView
      cssClass  : 'inner-wrapper'

    innerWrapper.addSubView new KDView
      tagName   : 'nav'
      pistachio :
        """
        <a href='#'>ABOUT</a>
        <a href='#'>GUIDE</a>
        <a href='#'>API</a>
        <a href='#'>COMMUNITY</a>
        <a href='#'>BUILD</a>
        <a href='#' id='fork-us'>FORK US ON GITHUB</a>
        """

    innerWrapper.addSubView @logo = new KDCustomHTMLView
      tagName   : 'figure'
      cssClass  : 'logo'

    innerWrapper.addSubView new KDCustomHTMLView
      tagName   : 'figure'
      cssClass  : 'logo small'

    innerWrapper.addSubView new KDHeaderView
      type      : 'medium'
      title     : 'A framework to change your drinking habits.'

    innerWrapper.addSubView new KDCustomHTMLView
      tagName   : 'a'
      partial   : 'DOWNLOAD THE THING'
      cssClass  : 'download-button'
      attributes:
        href    : '#'


  createFeaturesSection : ->
    @addSubView @featuresSection = new KDView
      cssClass  : 'features home-section'
      tagName   : 'section'
      pistachio :
        """
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
        """

  createExamplesSection : ->
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
      cssClass        : 'go-to-doc'
      partial         : 'Unbelieveable huh? Continue and you’ll see the other <a href="http://docs.kd.io">parts and such.</a>'

  createFooter : ->
    @addSubView @footer = new KDCustomHTMLView
      tagName  : 'footer'

    @footer.addSubView innerWrapper = new KDView
      cssClass  : 'inner-wrapper'

    innerWrapper.addSubView new KDCustomHTMLView
      cssClass  : 'about-kd'
      partial   : 'KD is free and open-source! <br> by Koding with love <3'

    innerWrapper.addSubView new KDCustomHTMLView
      tagName  : 'nav'
      pistachio:
        """
        <a href='#'>Terms</a>
        <a href='#'>Legal</a>
        <a href='#'>Blog</a>
        <a href='#'>Contact</a>
        """

  viewAppended : ->
    @createIntroSection()
    @createFeaturesSection()
    @createExamplesSection()
    @createFooter()


    KD.singletons.windowController.on 'ScrollHappened', @bound '_windowDidResize'


  _windowDidResize: ->
    # # logoAttributes
    # la = [
    #   width  : 188
    #   height : 148
    #   top    : 123
    #   left   : 50
    # ,
    #   width  : 64
    #   height : 50
    #   top    : -4
    #   left   : 0
    # ]

    # animationEndY = 475

    # KD.utils.throttle 50, ->

    # scrollTop = Math.min document.body.scrollTop, animationEndY

    # ratio = scrollTop / animationEndY

    # # log ratio

    # @logo.setStyle

    #   width      : la.first.width  - (la.first.width  - la.last.width)  * ratio
    #   height     : la.first.height - (la.first.height - la.last.height) * ratio
    #   top        : la.first.top    - (la.first.top    - la.last.top)    * ratio
    #   left       : "#{la.first.left - (la.first.left - la.last.left) * ratio}%"
    #   marginLeft : ((la.first.width / 2) - (la.first.width * ratio)) * -1

    scrollPosition = window.scrollY
    if (scrollPosition >= 520) and not @headerCollapsed

      @setClass 'collapse-header'
      @headerCollapsed = yes

    else if (scrollPosition <= 520) and @headerCollapsed

      @unsetClass 'collapse-header'
      @headerCollapsed = no