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
    log(page, section, query);
    return mainView.showPage(page, section);
  };
  router.addRoutes({
    '/:page?': handleRoute,
    '/:page/:section': handleRoute
  });
  return router.listen();
})();


},{"./views/mainview":4}],2:[function(require,module,exports){
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

  FooterView.prototype.pistachio = function() {
    return "<div class='inner-wrapper'>\n  <p class='about-kd'>KD is free and open-source! <br> by Koding with love <3</p>\n  <nav>\n    <a href='#'>Terms</a>\n    <a href='#'>Legal</a>\n    <a href='#'>Blog</a>\n    <a href='#'>Contact</a>\n  </nav>\n</div>";
  };

  return FooterView;

})(JView);


},{}],3:[function(require,module,exports){
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
    HeaderView.__super__.constructor.call(this, options);
    this.download = new KDCustomHTMLView({
      tagName: 'a',
      cssClass: 'download-button',
      attributes: {
        href: '#',
        title: 'Download'
      }
    });
  }

  HeaderView.prototype.pistachio = function() {
    return "<div class='inner-wrapper'>\n  <figure class='logo small'></figure>\n  <nav>\n    <a href='/About'>ABOUT</a>\n    <a href='/Guide/Getting+started'>GUIDE</a>\n    <a href='/API'>API</a>\n    <a href='https://koding.com'>COMMUNITY</a>\n    <a href='/Build'>BUILD</a>\n    <a href='http://github.com/koding/kd' id='fork-us' title='Fork us on Github' target='_blank'>FORK US ON GITHUB</a>\n    {{> this.download}}\n  </nav>\n</div>";
  };

  return HeaderView;

})(JView);


},{}],4:[function(require,module,exports){
var FooterView, HeaderView, MainView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

HeaderView = require('./headerview');

FooterView = require('./footerview');

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
        href: '#'
      }
    });
  }

  MainView.prototype.viewAppended = function() {
    JView.prototype.viewAppended.call(this);
    this.createExamples();
    return KD.singletons.windowController.on('ScrollHappened', this.bound('handleScroll'));
  };

  MainView.prototype.showPage = function() {};

  MainView.prototype.pistachio = function() {
    return "{{> this.header}}\n\n<section class='intro home-section'>\n  <div class='inner-wrapper'>\n    <figure class='logo'></figure>\n    <h2><span>A framework to change your drinking habits.</span></h2>\n    {{> this.download}}\n  </div>\n</section>\n\n<section class='features home-section'>\n  <div class='inner-wrapper'>\n    <article class='feature'>\n      <figure class='chrome'></figure>\n      <h3>FROM KODING</h3>\n      <p>\n        That's the shizzle metus my shizz, luctizzle et, tristique izzle,\n        dope at, nulla. Donec pharetra, nisi shut the shizzle up facilisizzle\n        malesuada, neque justo its fo rizzle dope, mollizzle sheezy\n        tellivizzle erat izzle phat.\n      </p>\n    </article>\n\n    <article class='feature'>\n      <figure class='king'></figure>\n      <h3>LIKE A FKIN BOSS</h3>\n      <p>\n        That's the shizzle metus my shizz, luctizzle et, tristique izzle,\n        dope at, nulla. Donec pharetra, nisi shut the shizzle up facilisizzle\n        malesuada, neque justo its fo rizzle dope, mollizzle sheezy\n        tellivizzle erat izzle phat.\n      </p>\n    </article>\n\n    <article class='feature'>\n      <figure class='box'></figure>\n      <h3>OUT OF THE BOX</h3>\n      <p>\n        That's the shizzle metus my shizz, luctizzle et, tristique izzle,\n        dope at, nulla. Donec pharetra, nisi shut the shizzle up facilisizzle\n        malesuada, neque justo its fo rizzle dope, mollizzle sheezy\n        tellivizzle erat izzle phat.\n      </p>\n    </article>\n  </div>\n</section>\n{{> this.examples}}\n{{> this.footer}}";
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
      name: 'avatar.js',
      tagName: 'pre',
      view: new KDView({
        tagName: 'code',
        partial: "@addSubView @examplesSection = new KDView\n  cssClass    : 'examples home-section'\n  tagName     : 'section'\n\n@examplesSection.addSubView innerWrapper = new KDView\n  cssClass  : 'inner-wrapper'\n\ninnerWrapper.addSubView new KDHeaderView\n  type      : 'medium'\n  title     : 'Let’s talk about the reality'\n\ninnerWrapper.addSubView new KDHeaderView\n  type      : 'small'\n  title     : 'What you can do, what you can not do, samples baby'"
      })
    }));
    exampleTabs.addPane(new KDTabPaneView({
      name: 'blob.js',
      tagName: 'pre',
      view: new KDView({
        tagName: 'code',
        partial: "@addSubView @examplesSection = new KDView\n  cssClass    : 'examples home-section'\n  tagName     : 'section'\n\n@examplesSection.addSubView innerWrapper = new KDView\n  cssClass  : 'inner-wrapper'\n\ninnerWrapper.addSubView new KDHeaderView\n  type      : 'medium'\n  title     : 'Let’s talk about the reality'\n\ninnerWrapper.addSubView new KDHeaderView\n  type      : 'small'\n  title     : 'What you can do, what you can not do, samples baby'"
      })
    }), false);
    exampleTabs.addPane(new KDTabPaneView({
      name: 'hjob.js',
      tagName: 'pre',
      view: new KDView({
        tagName: 'code',
        partial: "@addSubView @examplesSection = new KDView\n  cssClass    : 'examples home-section'\n  tagName     : 'section'\n\n@examplesSection.addSubView innerWrapper = new KDView\n  cssClass  : 'inner-wrapper'\n\ninnerWrapper.addSubView new KDHeaderView\n  type      : 'medium'\n  title     : 'Let’s talk about the reality'\n\ninnerWrapper.addSubView new KDHeaderView\n  type      : 'small'\n  title     : 'What you can do, what you can not do, samples baby'"
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


},{"./footerview":2,"./headerview":3}]},{},[1])