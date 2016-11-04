should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDHitEnterInputView = require '../../../lib/components/inputs/hitenterinputview'

describe 'KDHitEnterInputView', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @o = {}
    @o =
      button:
        show: @sinon.stub()
        hide: @sinon.stub()
    @instance = new KDHitEnterInputView @o, {}

  afterEach ->
    @sinon.restore()

  it 'exists', ->
    KDHitEnterInputView.should.exist

  describe 'constructor', ->
    it 'should instantiate without any errors', ->
      @instance.should.exist


  describe 'enableEnterKey', ->
    it 'should enable enter key', ->
      @instance.enableEnterKey()
      @instance.button.show.should.calledOnce
      @instance.enterKeyEnabled.should.equal yes

  describe 'disableEnterKey', ->
    it 'should disable enter key', ->
      @instance.enableEnterKey()
      @instance.disableEnterKey()
      @instance.button.hide.should.calledOnce
      @instance.enterKeyEnabled.should.equal no

  describe 'toggleEnterKey', ->
    it 'should toggle enter key', ->
      @instance.disableEnterKey = @sinon.stub()
      @instance.toggleEnterKey()
      @instance.disableEnterKey.should.calledOnce

  describe 'keyDown', ->
    it 'should trigger necessary events for escape', ->
      escapeEvent = {
        which: 27
      }

      @instance.emit = @sinon.stub()
      @instance.keyDown(escapeEvent)
      @instance.emit.should.calledOnce
      @instance.emit.should.calledWith 'EscapePerformed'
    it 'should trigger necessary events for enter', ->
      enterEvent = {
        which: 13
        altKey: false
        preventDefault: @sinon.stub()
      }
      @instance.enterKeyEnabled = yes
      @instance.emit = @sinon.stub()
      @instance.keyDown(enterEvent)
      @instance.emit.should.calledOnce
      @instance.emit.should.calledWith 'EnterPerformed'
