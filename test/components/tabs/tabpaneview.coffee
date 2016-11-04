should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDTabPaneView = require '../../../lib/components/tabs/tabpaneview'


describe 'KDTabPaneView', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @instance = new KDTabPaneView

  afterEach ->
    @sinon.restore()

  it 'exists', ->
    KDTabPaneView.should.exist

  describe 'constructor', ->
    it 'should instantiate without any errors', ->
      @instance.should.exist
