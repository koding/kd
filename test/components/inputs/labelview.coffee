should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDLabelView = require '../../../lib/components/inputs/labelview'

describe 'KDLabelView', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @o =
      title: 'Koding'
    @instance = new KDLabelView @o, {}

  afterEach ->
    @sinon.restore()

  it 'exists', ->
    KDLabelView.should.exist

  describe 'constructor', ->
    it 'should instantiate without any errors', ->
      @instance.should.exist

  describe 'getTitle', ->
    it 'should get title', ->
      @instance.getTitle().should.equal 'Koding'

  describe 'updateTitle', ->
    it 'should update title', ->
      @instance.updateTitle 'New title'
      @instance.getTitle().should.equal 'New title'
