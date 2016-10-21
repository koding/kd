should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDController = require '../../lib/core/viewcontroller'


describe 'KDViewController', ->
  beforeEach ->
    sinon.spy KDController.emit
    sinon.spy KDController.setView
    @router = new KDController


  it 'exists', ->
    KDController.should.exist

  describe 'constructor', ->
    it 'should instantiate without error', ->
      @router.should.exist

    it 'should call setview', ->
      @router.setView.should.be.calledOnce

  describe 'getView', ->
    it 'should return the main view', ->
      @router.getView().should.deepEqual @router.mainView

  describe 'setView', ->
    it 'should store main view', ->
      @router.mainView.should.exist

    it 'should emit ControllerHasSetItsView', ->
      @router.emit.should.be.calledOnce

    it 'should throw error on invalid view instance', ->
      @faulty = ->
        @router.setView

      @faulty().should.throw
