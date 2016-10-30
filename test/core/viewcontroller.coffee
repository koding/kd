should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDController = require '../../lib/core/viewcontroller'


describe 'KDViewController', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @sinon.spy KDController.emit
    @sinon.spy KDController.setView
    @controller = new KDController

  afterEach ->
    @sinon.restore()
    
  it 'exists', ->
    KDController.should.exist

  describe 'constructor', ->
    it 'should instantiate without error', ->
      @controller.should.exist

    it 'should call setview', ->
      @controller.setView.should.be.calledOnce

  describe 'getView', ->
    it 'should return the main view', ->
      @controller.getView().should.deepEqual @controller.mainView

  describe 'setView', ->
    it 'should store main view', ->
      @controller.mainView.should.exist

    it 'should emit ControllerHasSetItsView', ->
      @controller.emit.should.be.calledOnce

    it 'should throw error on invalid view instance', ->
      @faulty = ->
        @controller.setView

      @faulty().should.throw
