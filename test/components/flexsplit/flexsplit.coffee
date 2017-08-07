should = require 'should'
sinon = require 'sinon'

KD = require '../../../lib/core/kd'
KDView = require '../../../lib/core/view'
KDFlex = require '../../../lib/components/flexsplit/flex'
KDFlexSplit = require '../../../lib/components/flexsplit/flexsplit'
KDFlexSplitResizer = require '../../../lib/components/flexsplit/flexresizer'


describe 'KDFlexSplit', ->

  it 'should exists', ->
    KDFlexSplit.should.exist

  beforeEach ->
    @sinon = sinon.sandbox.create()
    @callback = @sinon.stub()
    @view1 = new KDView { partial: 'top' }
    @view2 = new KDView { partial: 'bottom' }

    @o = {}
    @o.views = [ @view1, @view2 ]

    @instance = new KDFlexSplit @o, {}

    @instance.appendToDomBody()

  afterEach ->
    for view in [ @view1, @view2, @instance ]
      view.destroy()
    @sinon.restore()

  describe 'constructor', ->

    it 'should instantiate without any error', ->
      (@instance instanceof KDFlexSplit).should.equal true

    it 'should generate a unique name if not provided', ->
      (/flex-/.test @instance.name).should.equal true

    it 'should instantiate with HORIZONTAL type by default', ->
      @instance.type.should.equal KDFlex.HORIZONTAL

    it 'should have a class set with the given type', ->
      @instance.hasClass(KDFlex.HORIZONTAL.name).should.equal true

    it 'should set flex-view class to given views', ->
      for view in [ @view1, @view2 ]
        view.hasClass('flex-view').should.equal true

    it 'should instantiate views with 50%-50% base by default', ->
      for view in [ @view1, @view2 ]
        view.getAttribute('style').should.endWith 'flex-basis: 50%;'

    it 'should create a resizer', ->
      (@instance.resizer instanceof KDFlexSplitResizer).should.equal true

    it 'should support expand events', ->

      @instance.on KDFlex.EVENT_EXPANDED, @callback

      @view1.emit KDFlex.EVENT_EXPAND
      @view1.getAttribute('style').should.endWith "flex-basis: #{KDFlex.MAX}%;"
      @view2.getAttribute('style').should.endWith "flex-basis: #{KDFlex.MIN}%;"

      @callback.calledOnce.should.equal true

    it 'should support collapse events', ->

      @instance.on KDFlex.EVENT_COLLAPSED, @callback

      @view1.emit KDFlex.EVENT_COLLAPSE
      @view1.getAttribute('style').should.endWith 'flex-basis: 50%;'
      @view2.getAttribute('style').should.endWith 'flex-basis: 50%;'

      @callback.calledOnce.should.equal true

    it 'should support custom resizing', ->

      @instance.setFractions [20, 80]
      @view1.getAttribute('style').should.endWith 'flex-basis: 20%;'
      @view2.getAttribute('style').should.endWith 'flex-basis: 80%;'
