should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDButtonView = require '../../../lib/components/buttons/buttonview'


describe 'KDButtonView', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @callback = @sinon.stub()
    @view = new KDButtonView
      title: 'button'
      iconClass: 'cupid-green'
      cssClass: 'cupid-green'
      callback: @callback

  afterEach ->
    @view.destroy()
    @sinon.restore()

  describe 'constructor', ->
    it 'should instantiate without error', ->
      @view.should.exist

    it 'should instantiate without options', ->
      view = new KDButtonView
      view.destroy()

  describe 'setDomElement', ->
    it 'should set a dom element', ->
      @view.setDomElement('cupid-green').should.exist
      @view.getElement().classList.length.should.equal 2

  describe 'setTitle', ->
    it 'should set a title', ->
      @view.setTitle 'koding'
      @view.buttonTitle.should.equal 'koding'

  describe 'getTitle', ->
    it 'should get a title', ->
      @view.setTitle 'koding'
      @view.getTitle('koding').should.equal 'koding'

  describe 'getCallback', ->
    it 'should get a callback', ->
      @view.getCallback().should.equal @callback

  describe 'showIcon', ->
    it 'should show icon', ->
      @view.hideIcon()
      @view.showIcon()
      @view.getElement().querySelector('span.icon').className.should.not.equal 'icon cupid-green hidden'

  describe 'hideIcon', ->
    it 'should hide icon', ->
      @view.hideIcon()
      @view.getElement().querySelector('span.icon').className.should.equal 'icon cupid-green hidden'

  describe 'setIconOnly', ->
    it 'should set icon only', ->
      @view.setIconOnly()

  describe 'click', ->
    it 'should call callback function', ->
      @view.click()
      @callback.should.be.calledOnce

  describe 'triggerClick', ->
    it 'should trigger click', ->
      @view.doOnSubmit = @sinon.stub()
      @view.triggerClick()
      @view.doOnSubmit.should.be.calledOnce

  describe 'disable', ->
    it 'should disable', ->
      @view.disable()
      @view.getElement().disabled.should.be.true

  describe 'enable', ->
    it 'should enable', ->
      @view.enable()
      @view.getElement().disabled.should.be.false

  describe 'focus', ->
    it 'should focus', ->
      @view.$().trigger = @sinon.stub()
      @view.focus()
      @view.$().trigger.should.calledOnce
      @view.$().trigger.should.calledWith 'focus'

  describe 'setFocus', ->
    it 'should set focus', ->
      @view.$().trigger = @sinon.stub()
      @view.setFocus()
      @view.$().trigger.should.calledOnce
      @view.$().trigger.should.calledWith 'focus'

  describe 'blur', ->
    it 'should blur', ->
      @view.$().trigger = @sinon.stub()
      @view.blur()
      @view.$().trigger.should.calledOnce
      @view.$().trigger.should.calledWith 'blur'
