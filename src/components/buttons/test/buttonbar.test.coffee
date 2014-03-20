{assert} = require 'chai'
sinon = require 'sinon'
KDButtonBar = require '../buttonbar'

describe 'KDButtonBar', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()

  afterEach ->
    @sinon.restore()

  describe 'contructor', ->
    it 'should instantiate without error', ->
      buttonBar = new KDButtonBar
      assert.ok buttonBar

    it 'should create new buttons supplied as options', ->
      buttonOptions = [{ foo: 'bar' }]

  describe 'createButton', ->
    beforeEach ->
      @buttonBar = new KDButtonBar

    it 'should create a new instance of the default button class', ->
      spy = sinon.spy()
      @buttonBar._itemClass = -> spy()
      @buttonBar.createButton()
      assert.ok spy.called

    it 'should create a new instance of a passed button class', ->
      stub = @sinon.stub()
      buttonView = -> stub()
      @buttonBar.createButton itemClass: buttonView
      assert.ok stub.called

