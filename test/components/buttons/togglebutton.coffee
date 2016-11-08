should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDToggleButton = require '../../../lib/components/buttons/togglebutton'


describe 'KDToggleButton', ->
  beforeEach ->
    noop = (->)
    @sinon = sinon.sandbox.create()
    @instance = new KDToggleButton
      cssClass: 'toggle-button'
      style: 'clean-gray'
      defaultState: 'Show details'
      states: [
        title: 'Show details'
        callback: noop
      ,
        title: 'Hide details'
        callback: noop
      ]

  afterEach ->
    @instance.destroy()
    @sinon.restore()

  describe 'constructor', ->
    it 'should instantiate without error', ->
      @instance.should.exist

  describe 'getState', ->
    it 'should get state', ->
      @instance.getState().title.should.equal 'Show details'

  describe 'toggleState', ->
    it 'should toggle state', ->
      @instance.toggleState()
      @instance.getState().title.should.equal 'Hide details'
