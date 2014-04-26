class MainView

  instance = null

  class _MainView extends KDView
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

      innerWrapper.addSubView new KDCustomHTMLView
        tagName   : 'figure'
        cssClass  : 'logo'

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
        partial         : 'Unbelieveable huh? Continue and you’ll see your
                           mothers <a href="http://docs.kd.io">private parts and such.</a>'

    createFooter : ->
      @addSubView @footer = new KDCustomHTMLView
        tagName  : 'footer'

      @footer.addSubView innerWrapper = new KDView
        cssClass  : 'inner-wrapper'

      innerWrapper.addSubView new KDCustomHTMLView
        cssClass  : 'about-kd'
        partial   : 'Kd is free, open source and always will be! <br> From Koding with Love'

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


  @getInstance :->
    instance ?= new _MainView

    return instance


mainView = MainView.getInstance()
