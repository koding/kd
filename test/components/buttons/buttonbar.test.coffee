{assert} = require 'chai'
sinon = require 'sinon'
KDButtonBar = require '../../../src/components/buttons/buttonbar.coffee'

describe 'KDButtonBar', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()

  afterEach ->
    @sinon.restore()

  describe 'constructor', ->
    it 'should instantiate without error', ->
      buttonBar = new KDButtonBar
      assert.ok buttonBar

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

