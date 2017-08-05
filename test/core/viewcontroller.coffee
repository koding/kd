should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDView = require '../../lib/core/view'
KDController = require '../../lib/core/viewcontroller'


describe 'KDViewController', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @controller = new KDController
    @sinon.spy @controller, 'emit'
    @sinon.spy @controller, 'setView'

  afterEach ->
    @controller.destroy()
    @sinon.restore()

  it 'exists', ->
    KDController.should.exist

  describe 'constructor', ->
    it 'should instantiate without error', ->
      @controller.should.exist

    it 'should not call setview when view not passed', ->
      @controller.setView.should.not.be.called()

    it 'should call setview', ->
      @controller.setView new KDView
      @controller.setView.should.be.calledOnce()

  describe 'getView', ->
    it 'should return the main view', ->
      @controller.getView().should.deepEqual @controller.mainView

  describe 'setView', ->
    it 'should store main view', ->
      @controller.mainView.should.exist

    it 'should emit ControllerHasSetItsView', ->
      @controller.setView new KDView
      @controller.emit.should.be.calledOnce()

    it 'should throw error on invalid view instance', ->
      @faulty = ->
        @controller.setView

      @faulty().should.throw
