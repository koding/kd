should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDButtonBar = require '../../../lib/components/buttons/buttonbar'


describe 'KDButtonBar', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @instance = new KDButtonBar

  afterEach ->
    @sinon.restore()

  describe 'constructor', ->
    it 'should instantiate without error', ->
      @instance.should.exist

  describe 'createButton', ->
    beforeEach ->
      @buttonBar = new KDButtonBar

    it 'should create a new instance of the default button class', ->
      spy = sinon.spy()
      @buttonBar._itemClass = -> spy()
      @buttonBar.createButton()
      spy.should.be.calledOnce

    it 'should create a new instance of a passed button class', ->
      stub = @sinon.stub()
      buttonView = -> stub()
      @buttonBar.createButton itemClass: buttonView
      stub.should.be.calledOnce
