should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDView = require '../../lib/core/view'


describe 'KDView', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @events = {
      preventDefault: sinon.spy
      stopPropagation: sinon.spy
    }
    @view = new KDView

  afterEach ->
    @sinon.restore()

  describe 'scroll', ->
    it 'should return true', ->
      @view.scroll().should.equal yes

  describe 'load', ->
    it 'should return true', ->
      @view.load().should.equal yes

  describe 'error', ->
    it 'should return true', ->
      @view.error().should.equal yes

  describe 'keyUp', ->
    it 'should return true', ->
      @view.keyUp().should.equal yes

  describe 'keyDown', ->
    it 'should return true', ->
      @view.keyDown().should.equal yes

  describe 'keyPress', ->
    it 'should return true', ->
      @view.keyPress().should.equal yes

  describe 'dblClick', ->
    it 'should return true', ->
      @view.dblClick().should.equal yes

  describe 'click', ->
    it 'should return true', ->
      @view.click().should.equal yes

  describe 'contextMenu', ->
    it 'should return true', ->
      @view.contextMenu().should.equal yes

  describe 'mouseMove', ->
    it 'should return true', ->
      @view.mouseMove().should.equal yes

  describe 'mouseEnter', ->
    it 'should return true', ->
      @view.mouseEnter().should.equal yes

  describe 'mouseLeave', ->
    it 'should return true', ->
      @view.mouseLeave().should.equal yes

  describe 'mouseUp', ->
    it 'should return true', ->
      @view.mouseUp().should.equal yes

  describe 'mouseOver', ->
    it 'should return true', ->
      @view.mouseOver().should.equal yes

  describe 'mouseWheel', ->
    it 'should return true', ->
      @view.mouseWheel().should.equal yes

  describe 'mouseDown', ->
    it 'should return true', ->
      @view.unsetKeyView = @sinon.stub()
      @view.mouseDown().should.equal yes
      @view.unsetKeyView.should.be.calledOnce

  describe 'paste', ->
    it 'should return true', ->
      @view.paste().should.equal yes

  describe 'dragEnter', ->
    it 'should stop event', ->
      @view.dragEnter(@events)
      @events.stopPropagation.should.be.calledOnce
      @events.preventDefault.should.be.calledOnce

  describe 'dragOver', ->
    it 'should stop event', ->
      @view.dragOver(@events)
      @events.stopPropagation.should.be.calledOnce
      @events.preventDefault.should.be.calledOnce

  describe 'dragLeave', ->
    it 'should stop event', ->
      @view.dragLeave(@events)
      @events.stopPropagation.should.be.calledOnce
      @events.preventDefault.should.be.calledOnce

  describe 'dragEnd', ->
    it 'should stop event', ->
      @view.dragEnd(@events)
      @events.stopPropagation.should.be.calledOnce
      @events.preventDefault.should.be.calledOnce

  describe 'drop', ->
    it 'should stop event', ->
      @view.drop(@events)
      @events.stopPropagation.should.be.calledOnce
      @events.preventDefault.should.be.calledOnce

  describe 'submit', ->
    it 'should return false', ->
      @view.submit().should.equal no
