should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDToggleButton = require '../../../lib/components/buttons/togglebutton'


describe 'KDToggleButton', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @instance = new KDToggleButton
      cssClass: 'toggle-button'
      style: 'clean-gray'
      defaultState: 'Show details'
      states: [
        title: 'Show details'
        callback: (->)
      ,
        title: 'Hide details'
        callback: (->)
      ]

  afterEach ->
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
