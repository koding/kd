should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDButtonMenu = require '../../../lib/components/buttons/buttonmenu'
KDButtonView = require '../../../lib/components/buttons/buttonview'


describe 'KDButtonMenu', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    delegate = new KDButtonView
      title: 'button'
      iconClass: 'cupid-green'
      cssClass: 'cupid-green'
      callback: ->
    @instance = new KDButtonMenu { delegate }

  afterEach ->
    @instance.destroy()
    @sinon.restore()

  describe 'constructor', ->
    it 'should instantiate without error', ->
      @instance.should.exist
      @instance.options.cssClass.should.be.instanceOf String
      @instance.options.cssClass.should.exist

  describe 'viewAppended', ->
    it 'should call set partial', ->
      spy = sinon.spy @instance, 'setPartial'
      @instance.viewAppended()
      spy.should.be.calledOnce()

  describe 'positionContextMenu', ->
    it 'should exist', ->
      @instance.positionContextMenu.should.exist
