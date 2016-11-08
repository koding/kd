should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDTabView = require '../../../lib/components/tabs/tabview'
KDTabPaneView = require '../../../lib/components/tabs/tabpaneview'

describe 'KDTabView', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @pane = new KDTabPaneView
      name: 'Koding'
    @instance = new KDTabView

  afterEach ->
    @instance.destroy()
    @sinon.restore()

  it 'exists', ->
    KDTabView.should.exist

  describe 'constructor', ->
    it 'should instantiate without any errors', ->
      @instance.should.exist

  describe 'addPane', ->
    it 'should add a pane view', ->
      @instance.addPane @pane
      @instance.panes.length.should.equal 1

    it 'should not add a non-pane view', ->
      @instance.addPane({}, no).should.equal no
      @instance.panes.length.should.equal 0

  describe 'removePaneByName', ->
    it 'should remove pane by name', ->
      @instance.addPane @pane
      @instance.removePaneByName('Koding').length.should.equal 0

  describe 'getActivePaneIndex', ->
    it 'should get active pane index', ->
      @instance.addPane @pane
      @instance.getActivePaneIndex().should.equal 0

  describe 'showPaneByIndex', ->
    it 'should show pane by index', ->
      @instance.addPane @pane
      @instance.showPane = @sinon.stub()
      @instance.showPaneByIndex 0
      @instance.showPane.should.calledOnce

  describe 'showPaneByName', ->
    it 'should show pane by name', ->
      @instance.addPane @pane
      @instance.showPane = @sinon.stub()
      @instance.showPaneByName 'Koding'
      @instance.showPane.should.calledOnce
