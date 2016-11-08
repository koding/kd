should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDSplitView = require '../../../lib/components/split/splitview'
KDSplitViewPanel = require '../../../lib/components/split/splitpanel'
KDView = require '../../../lib/core/view'


describe 'KDSplitView', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @view = new KDView
      tooltip :
        title : 'hello'
    @o = {}
    @o.type = 'vertical'
    @o.parent = @view
    @splitViewPanel = new KDSplitViewPanel @o, {}
    @instance = new KDSplitView

  afterEach ->
    @instance.destroy()
    @sinon.restore()

  it 'exists', ->
    KDSplitView.should.exist

  describe 'viewAppended', ->
    it 'should exist', ->
      @instance.viewAppended.should.exist
      @instance._calculateSizes = @sinon.spy()
      @instance._createPanels = @sinon.spy()
      @instance._putPanels = @sinon.spy()
      @instance._resizePanels = @sinon.spy()
      @instance._putViews = @sinon.spy()
      @instance.viewAppended()
      @instance._calculateSizes.should.calledOnce
      @instance._createPanels.should.calledOnce
      @instance._putPanels.should.calledOnce
      @instance._resizePanels.should.calledOnce
      @instance._putViews.should.calledOnce

  describe 'isVertical', ->
    it 'should return true if vertical', ->
      @instance.isVertical().should.equal yes

  describe 'getPanelIndex', ->
    it 'should return panel index', ->
      index = @instance.getPanelIndex
        index: 666
      index.should.equal 666

  describe 'hidePanel', ->
    it 'should hide panel', ->
      callback = @sinon.stub()
      @instance.viewAppended()
      @instance.hidePanel 0, callback
      callback.should.calledOnce
      should(@instance.panels[0].size).equal null

  describe 'showPanel', ->
    it 'should show panel', ->
      callback = @sinon.stub()
      @instance.viewAppended()
      @instance.showPanel 0, callback
      callback.should.calledOnce
      callback.should.calledWith
        panel: @instance.panels[0]
        index: 0

  describe 'merge', ->
    it 'should merge views', ->
      @instance.viewAppended()
      @instance.destroy = @sinon.stub()
      @instance.merge()
      @instance.destroy.should.calledOnce

  describe 'setView', ->
    it 'should set sub view of panel', ->
      @instance.viewAppended()
      @instance.setView @view, 0
      @instance.panels[0].subViews[0].should.deepEqual @view

  describe '_panelIsBeingDestroyed', ->
    it 'should set panel attributes to null', ->
      @instance.viewAppended()
      @instance._panelIsBeingDestroyed(@instance.panels[0])

  describe '_getParentSize', ->
    it 'should get parent size', ->
       @instance._getParentSize().should.equal window.innerWidth

    it 'should get parent size for horizontal', ->
      options = {}
      options.type = 'horizontal'
      instance = new KDSplitView options
      instance._getParentSize().should.equal window.innerHeight
