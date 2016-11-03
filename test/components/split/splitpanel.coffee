should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDSplitViewPanel = require '../../../lib/components/split/splitpanel'
KDView = require '../../../lib/core/view'


describe 'KDSplitViewPanel', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @view = new KDView
      tooltip :
        title : 'hello'
    @o = {}
    @o.type = 'vertical'
    @o.parent = @view
    @instance = new KDSplitViewPanel @o, {}

  afterEach ->
    @sinon.restore()

  it 'exists', ->
    KDSplitViewPanel.should.exist

  describe 'constructor', ->
    it 'should instantiate without any error', ->
      @instance.should.exist
      @instance.options.type.should.equal 'vertical'
      @instance.options.fixed.should.equal no
      @instance.options.cssClass.should.equal 'kdscrollview'

  describe 'getSize', ->
    it 'should get size', ->
      @instance._getSize().should.equal @instance.getWidth()

    it 'should get height if its horizontal', ->
      @o.type = 'horizontal'
      instance = new KDSplitViewPanel @o, {}
      instance._getSize().should.equal instance.getHeight()

  describe 'getOffSet', ->
    it 'should get offset', ->
      @instance._setOffset 500
      @instance._getOffset().should.equal 500

    it 'should get offset properly if horizontal', ->
      @o.type = 'horizontal'
      instance = new KDSplitViewPanel @o, {}
      instance._setOffset 500
      instance._getOffset().should.equal 500
