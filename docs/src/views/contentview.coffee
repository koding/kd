module.exports = class ContentView extends KDView
  constructor : (options = {}) ->
    options.tagName  = 'section'
    options.cssClass = 'content-section'

    super options

  getExampleTabView: ->
    exampleTabs = new KDTabView
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

    return exampleTabs

  viewAppended : JView::viewAppended

  pistachio : ->
    """
      <article>
        <section>
          <h3>KD Framework Guidelines</h3>
          <p>
          Welcome to the KD guides! This documentation will take you from
          total beginner to KD expert. It is designed to start from the basics,
          and slowly increase to more sophisticated concepts until you know
          everything there is to know about building awesome web applications.
          </p>

          <p>
          To help you get started, we've also made a 30-minute screencast that
          will guide you through building a full-featured KD
          application:Welcome to the KD guides! This documentation will
          take you from total beginner to KD expert. It is designed to start
          from the basics, and slowly increase to more sophisticated concepts
          until you know everything there is to know about building awesome web
          applications.
          </p>

          <p>
          To help you get started, we've also made a 30-minute screencast that
          will guide you through building
          </p>
        </section>

        <section>
          <h3>So how should I, how could I. Would I?</h3>
          <p>
          Welcome to the KD guides! This documentation will take you from
          total beginner to KD expert. It is designed to start from the
          basics, and slowly increase to applications.
          </p>

          {{> this.getExampleTabView() }}
        </section>

        <section>
          <h3>So how should I, how could I. Would I?</h3>
          <p>
          Welcome to the KD guides! This documentation will take you from
          total beginner to KD expert. It is designed to start from the
          basics, and slowly increase to applications.
          </p>

          {{> this.getExampleTabView() }}
        </section>

      </article>
    """
