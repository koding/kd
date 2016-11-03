should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDSplitComboView = require '../../../lib/components/split/splitcomboview'
KDView = require '../../../lib/core/view'


describe 'KDSplitComboView', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @view = new KDView
      tooltip :
        title : 'hello'

    @o = {}
    @o.views = [@view, @view]
    @instance = new KDSplitComboView @o, {}

  afterEach ->
    @sinon.restore()

  it 'exists', ->
    KDSplitComboView.should.exist

  describe 'constructor', ->
    it 'should instantiate without any error', ->
      @instance.should.exist
      @instance.options.views.length.should.equal 2
