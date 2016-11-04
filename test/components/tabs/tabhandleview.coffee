should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDTabHandleView = require '../../../lib/components/tabs/tabhandleview'


describe 'KDTabHandleView', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @o = {}
    @o.title = 'Koding'
    @instance = new KDTabHandleView @o, {}

  afterEach ->
    @sinon.restore()

  it 'exists', ->
    KDTabHandleView.should.exist

  describe 'constructor', ->
    it 'should instantiate without any errors', ->
      @instance.should.exist

  describe 'partial', ->
    it 'should return partial', ->
      @instance.partial().should.equal '<b>Koding</b>'

  describe 'makeActive', ->
    it 'should make it active', ->
      @instance.makeActive()
      @instance.domElement[0].classList.contains('active').should.equal yes


  describe 'makeInactive', ->
    it 'should make it inactive', ->
      @instance.makeActive()
      @instance.makeInactive()
      @instance.domElement[0].classList.contains('active').should.equal no

  describe 'setTitle', ->
    it 'should set a title', ->
      @instance.setTitle 'Koding New'
      @instance.getAttribute('title').should.equal 'Koding New'

  describe 'isHidden', ->
    it 'should return true if hidden', ->
      @instance.isHidden().should.equal @instance.getOptions().hidden

  describe 'getWidth', ->
    it 'should get width', ->
      @instance.getWidth().should.equal @instance.$().outerWidth(false) || 0
