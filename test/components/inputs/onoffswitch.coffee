should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDOnOffSwitch = require '../../../lib/components/inputs/onoffswitch'

describe 'KDOnOffSwitch', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @o =
      callback: @sinon.stub()
      title: 'Koding'
    @instance = new KDOnOffSwitch @o, {}

  afterEach ->
    @instance.destroy()
    @sinon.restore()

  it 'exists', ->
    KDOnOffSwitch.should.exist

  describe 'constructor', ->
    it 'should instantiate without any errors', ->
      @instance.should.exist

  describe 'switchStateChanged', ->
    it 'should event proper events', ->
      @instance.emit = @sinon.stub()
      @instance.switchStateChanged()
      @instance.emit.should.calledOnce
      @instance.emit.should.calledWith 'SwitchStateChanged', @instance.getValue()
      @instance.options.callback.should.calledOnce

  describe 'setOn', ->
    it 'should set on', ->
      @instance.setOn()
      @instance.$('input').attr('checked').should.equal 'checked'
