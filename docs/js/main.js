(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var MainView;

MainView = require('./views/mainview');

(function() {
  var handleRoute, mainView, router, _ref;
  KD.registerSingleton('router', new KDRouter);
  KD.registerSingleton('mainView', new MainView);
  _ref = KD.singletons, router = _ref.router, mainView = _ref.mainView;
  handleRoute = function(_arg) {
    var page, query, section, _ref1;
    (_ref1 = _arg.params, page = _ref1.page, section = _ref1.section), query = _arg.query;
    return mainView.showPage(page, section);
  };
  router.addRoutes({
    '/:page?': handleRoute,
    '/:page/:section': handleRoute
  });
  return router.listen();
})();


},{"./views/mainview":6}],2:[function(require,module,exports){
var HeaderView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = HeaderView = (function(_super) {
  __extends(HeaderView, _super);

  function HeaderView(options) {
    if (options == null) {
      options = {};
    }
    options.cssClass = 'main-header';
    options.tagName = 'header';
    options.partial = "<div class='inner-wrapper'>\n  <figure class='logo small'></figure>\n  <nav>\n    <a class='hidden' href='/About'>ABOUT</a>\n    <a class='hidden' href='/Guide/Getting+started'>GUIDE</a>\n    <a class='hidden' href='/API'>API</a>\n    <a class='hidden' href='https://koding.com'>COMMUNITY</a>\n    <a class='hidden' href='/Build'>BUILD</a>\n    <a href='http://github.com/koding/kd' id='fork-us' title='Fork us on Github' target='_blank'>FORK US ON GITHUB</a>\n  </nav>\n</div>";
    HeaderView.__super__.constructor.call(this, options);
    this.download = new KDCustomHTMLView({
      tagName: 'a',
      cssClass: 'download-button',
      attributes: {
        href: '#',
        title: 'Download'
      }
    });
    this.once('viewAppended', (function(_this) {
      return function() {
        return _this.addSubView(_this.download, 'nav');
      };
    })(this));
  }

  return HeaderView;

})(KDView);


},{}],3:[function(require,module,exports){
var ContentView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = ContentView = (function(_super) {
  __extends(ContentView, _super);

  function ContentView(options) {
    if (options == null) {
      options = {};
    }
    options.tagName = 'section';
    options.cssClass = 'content-section';
    ContentView.__super__.constructor.call(this, options);
  }

  ContentView.prototype.pistachio = function() {
    return "<article>\n  <section>\n    <h3>KD Framework Guidelines</h3>\n    <p>\n    Welcome to the KD guides! This documentation will take you from\n    total beginner to KD expert. It is designed to start from the basics,\n    and slowly increase to more sophisticated concepts until you know\n    everything there is to know about building awesome web applications.\n    </p>\n\n    <p>\n    To help you get started, we've also made a 30-minute screencast that\n    will guide you through building a full-featured KD\n    application:Welcome to the KD guides! This documentation will\n    take you from total beginner to KD expert. It is designed to start\n    from the basics, and slowly increase to more sophisticated concepts\n    until you know everything there is to know about building awesome web\n    applications.\n    </p>\n\n    <p>\n    To help you get started, we've also made a 30-minute screencast that\n    will guide you through building\n    </p>\n  </section>\n\n  <section>\n    <h3>So how should I, how could I. Would I?</h3>\n    <p>\n    Welcome to the KD guides! This documentation will take you from\n    total beginner to KD expert. It is designed to start from the\n    basics, and slowly increase to applications.\n    </p>\n\n  </section>\n\n  <section>\n    <h3>So how should I, how could I. Would I?</h3>\n    <p>\n    Welcome to the KD guides! This documentation will take you from\n    total beginner to KD expert. It is designed to start from the\n    basics, and slowly increase to applications.\n    </p>\n\n  </section>\n\n</article>";
  };

  return ContentView;

})(KDView);


},{}],4:[function(require,module,exports){
var FooterView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = FooterView = (function(_super) {
  __extends(FooterView, _super);

  function FooterView(options) {
    if (options == null) {
      options = {};
    }
    options.tagName = 'footer';
    FooterView.__super__.constructor.call(this, options);
  }

  FooterView.prototype.viewAppended = function() {
    return this.setPartial(this.partial());
  };

  FooterView.prototype.partial = function() {
    return "<div class='inner-wrapper'>\n  <p class='about-kd'>KD is free and open-source! <br> by Koding with <i><3</i></p>\n  <nav>\n    <a href='#'>Terms</a>\n    <a href='#'>Legal</a>\n    <a href='#'>Blog</a>\n    <a href='#'>Contact</a>\n  </nav>\n</div>";
  };

  return FooterView;

})(KDView);


},{}],5:[function(require,module,exports){
var HeaderView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = HeaderView = (function(_super) {
  __extends(HeaderView, _super);

  function HeaderView(options) {
    if (options == null) {
      options = {};
    }
    options.cssClass = 'main-header';
    options.tagName = 'header';
    options.partial = "<div class='inner-wrapper'>\n  <figure class='logo small'></figure>\n  <nav>\n    <a class='hidden' href='/About'>ABOUT</a>\n    <a class='hidden' href='/Guide/Getting+started'>GUIDE</a>\n    <a class='hidden' href='/API'>API</a>\n    <a class='hidden' href='https://koding.com'>COMMUNITY</a>\n    <a class='hidden' href='/Build'>BUILD</a>\n    <a href='http://github.com/koding/kd' id='fork-us' title='Fork us on Github' target='_blank'>FORK US ON GITHUB</a>\n  </nav>\n</div>";
    HeaderView.__super__.constructor.call(this, options);
    this.download = new KDCustomHTMLView({
      tagName: 'a',
      cssClass: 'download-button',
      attributes: {
        href: '#',
        title: 'Download'
      }
    });
    this.once('viewAppended', (function(_this) {
      return function() {
        return _this.addSubView(_this.download, 'nav');
      };
    })(this));
  }

  return HeaderView;

})(KDView);


},{}],6:[function(require,module,exports){
var FooterView, HeaderView, MainView, PageView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

HeaderView = require('./headerview');

FooterView = require('./footerview');

PageView = require('./pageview');

module.exports = MainView = (function(_super) {
  __extends(MainView, _super);

  function MainView(options) {
    if (options == null) {
      options = {};
    }
    options.cssClass = 'main-view';
    options.tagName = 'main';
    MainView.__super__.constructor.call(this, options);
    this.appendToDomBody();
    this.header = new HeaderView;
    this.examples = new KDView({
      cssClass: 'examples home-section',
      tagName: 'section'
    });
    this.footer = new FooterView;
    this.download = new KDCustomHTMLView({
      tagName: 'a',
      partial: 'DOWNLOAD THE THING',
      cssClass: 'download-button',
      attributes: {
        href: 'http://github.com/koding/kd'
      }
    });
  }

  MainView.prototype.showPage = function() {
    var page;
    this.hide();
    page = new PageView;
    return page.appendToDomBody();
  };

  MainView.prototype.viewAppended = function() {
    this.addSubView(this.header);
    this.setPartial(this.partial());
    this.createExamples();
    return KD.singletons.windowController.on('ScrollHappened', this.bound('handleScroll'));
  };

  MainView.prototype.partial = function() {
    return "<section class='intro home-section'>\n  <div class='inner-wrapper'>\n    <figure class='logo'></figure>\n    <h2><span>A UI framework for the modern web, soon to be here.</span></h2>\n  </div>\n</section>\n\n<section class='features home-section hidden'>\n  <div class='inner-wrapper'>\n    <article class='feature'>\n      <figure class='chrome'></figure>\n      <h3>FROM KODING</h3>\n      <p>\n        coming soon...\n      </p>\n    </article>\n\n    <article class='feature'>\n      <figure class='king'></figure>\n      <h3>LIKE A FKIN BOSS</h3>\n      <p>\n        coming soon...\n      </p>\n    </article>\n\n    <article class='feature'>\n      <figure class='box'></figure>\n      <h3>OUT OF THE BOX</h3>\n      <p>\n        coming soon...\n      </p>\n    </article>\n  </div>\n</section>";
  };

  MainView.prototype.createExamples = function() {
    var exampleTabs, innerWrapper;
    this.examples.addSubView(innerWrapper = new KDView({
      cssClass: 'inner-wrapper'
    }));
    innerWrapper.addSubView(new KDHeaderView({
      type: 'medium',
      title: 'Let’s talk about the reality'
    }));
    innerWrapper.addSubView(new KDHeaderView({
      type: 'small',
      title: 'What you can do, what you can not do, samples baby'
    }));
    innerWrapper.addSubView(exampleTabs = new KDTabView({
      hideHandleCloseIcons: true
    }));
    exampleTabs.addPane(new KDTabPaneView({
      name: 'soon-1',
      tagName: 'pre',
      view: new KDView({
        tagName: 'code',
        partial: "@addSubView @comingSoonView = new KDView\n  cssClass : 'coming-soon'\n  tagName  : 'section'\n  click    : ->\n    new KDNotificationView\n      title : 'Coming soon...'\n      type  : 'tray'"
      })
    }));
    exampleTabs.addPane(new KDTabPaneView({
      name: 'soon-2',
      tagName: 'pre',
      view: new KDView({
        tagName: 'code',
        partial: "@comingSoonView = new KDView\n  cssClass : 'coming-soon'\n  tagName  : 'section'\n  click    : ->\n\n@comingSoonView.appendToDomBody()\n\n@comingSoonView.on 'click', ->\n  new KDNotificationView\n    title : 'Coming soon...'\n    type  : 'tray'"
      })
    }), false);
    exampleTabs.addPane(new KDTabPaneView({
      name: 'soon-3',
      tagName: 'pre',
      view: new KDView({
        tagName: 'code',
        partial: "@comingSoonController = new KDController\n\n@comingSoonController.fetchSomeData (err, data)->\n\n  return console.log err  if err\n\n  new KDNotificationView\n    title : 'Some data is fetched, but this is still coming soon...'\n    type  : 'tray'"
      })
    }), false);
    hljs.configure({
      languages: ['coffeescript']
    });
    hljs.highlightBlock(exampleTabs.getActivePane().mainView.getDomElement()[0]);
    exampleTabs.on('PaneDidShow', function(pane) {
      return hljs.highlightBlock(pane.mainView.getDomElement()[0]);
    });
    return innerWrapper.addSubView(new KDCustomHTMLView({
      cssClass: 'go-to-doc',
      partial: 'Unbelieveable huh? Continue and you’ll see the other <a href="http://docs.kd.io">parts and such.</a>'
    }));
  };

  MainView.prototype.handleScroll = function() {
    var scrollPosition;
    scrollPosition = window.scrollY;
    if ((scrollPosition >= 520) && !this.headerCollapsed) {
      this.setClass('collapse-header');
      return this.headerCollapsed = true;
    } else if ((scrollPosition <= 520) && this.headerCollapsed) {
      this.unsetClass('collapse-header');
      return this.headerCollapsed = false;
    }
  };

  return MainView;

})(KDView);


},{"./footerview":4,"./headerview":5,"./pageview":7}],7:[function(require,module,exports){
var ContentView, HeaderView, PageView, SideNavigation,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

HeaderView = require('./HeaderView');

SideNavigation = require('./sidenavigation');

ContentView = require('./contentview');

module.exports = PageView = (function(_super) {
  __extends(PageView, _super);

  function PageView(options) {
    if (options == null) {
      options = {};
    }
    options.cssClass = 'page-view';
    options.tagName = 'main';
    options.partial = '<div class=\'inner-wrapper guide-page clearfix\'></div>';
    PageView.__super__.constructor.call(this, options);
    this.topNav = new HeaderView;
    this.sideNav = new SideNavigation;
    this.content = new ContentView;
  }

  PageView.prototype.viewAppended = function() {
    this.addSubView(this.topNav, null, true);
    this.addSubView(this.sideNav);
    return this.addSubView(this.content);
  };

  return PageView;

})(KDView);


},{"./HeaderView":2,"./contentview":3,"./sidenavigation":8}],8:[function(require,module,exports){
var SideNavigation,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = SideNavigation = (function(_super) {
  __extends(SideNavigation, _super);

  function SideNavigation(options) {
    if (options == null) {
      options = {};
    }
    options.tagName = 'aside';
    options.cssClass = 'main-sidebar';
    SideNavigation.__super__.constructor.call(this, options);
    this.menu = new JTreeViewController({
      cssClass: 'side-menu'
    }, [
      {
        title: 'GETTING STARTED',
        id: 1
      }, {
        title: "So like let's do it",
        parentId: 1
      }, {
        title: "How to be cool like u guys?",
        parentId: 1
      }, {
        title: "Fight fire with fire maybe",
        parentId: 1
      }, {
        title: 'GETTING KD',
        id: 2
      }, {
        title: "So like let's do it",
        parentId: 2
      }, {
        title: "How to be cool like u guys?",
        parentId: 2
      }, {
        title: "Fight fire with fire maybe",
        parentId: 2
      }, {
        title: 'CONCEPTS',
        id: 3
      }, {
        title: 'GETTING KD',
        id: 3
      }, {
        title: "So like let's do it",
        parentId: 3
      }, {
        title: "How to be cool like u guys?",
        parentId: 3
      }, {
        title: "Fight fire with fire maybe",
        parentId: 3
      }
    ]);
  }

  SideNavigation.prototype.viewAppended = function() {
    return this.addSubView(this.menu.getView());
  };

  return SideNavigation;

})(KDView);


},{}]},{},[1])