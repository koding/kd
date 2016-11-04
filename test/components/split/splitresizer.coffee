should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDSplitResizer = require '../../../lib/components/split/splitresizer'
KDView = require '../../../lib/core/view'


describe 'KDSplitResizer', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @o = {}
    @o.type = 'vertical'
    @instance = new KDSplitResizer @o, {}

  afterEach ->
    @sinon.restore()

  it 'exists', ->
    KDSplitResizer.should.exist

  describe 'getOffset', ->
    it 'should get offset', ->
      @instance._getOffset().should.equal @instance.getRelativeX()

    it 'should get offset for horizontal', ->
      @o.type = 'horizontal'
      instance = new KDSplitResizer @o, {}
      instance._getOffset().should.equal instance.getRelativeY()

  describe 'setOffset', ->
    it 'should get offset', ->
      @instance._setOffset 500
      @instance.domElement[0].style.left.should.equal 500 - @instance.getOption('handleSize') + 'px'

    it 'should get offset for horizontal', ->
      @o.type = 'horizontal'
      instance = new KDSplitResizer @o, {}
      instance._setOffset -10
      instance.domElement[0].style.top.should.equal 0 - instance.getOption('handleSize') + 'px'
