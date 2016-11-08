should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDTabHandleMoveNav = require '../../../lib/components/tabs/tabhandlemovenav'
KDTabHandleContainer = require '../../../lib/components/tabs/tabhandlecontainer'


describe 'KDTabHandleMoveNav', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @view = new KDTabHandleContainer
      title: 'Koding'

    @o = {}
    @o.delegate = @view
    @instance = new KDTabHandleMoveNav @o, {}

  afterEach ->
    @instance.destroy()
    @sinon.restore()

  it 'exists', ->
    KDTabHandleMoveNav.should.exist

  describe 'viewAppended', ->
    it 'should add 2 subviews', ->
      @instance.viewAppended()
      @instance.left.should.exist
      @instance.right.should.exist
