should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDButtonView = require '../../../lib/components/buttons/buttonview'


describe 'KDButtonView', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @callback = @sinon.spy (->)
    @view = new KDButtonView
      title: 'button'
      iconClass: 'cupid-green'
      cssClass: 'cupid-green'
      callback: @callback

  afterEach ->
    @sinon.restore()

  describe 'constructor', ->
    it 'should instantiate without error', ->
      @view.should.exist

    it 'should instantiate without options', ->
      view = new KDButtonView

  describe 'setDomElement', ->
    it 'should set a dom element', ->
      @view.setDomElement('cupid-green').should.exist
      @view.domElement[0].classList.length.should.equal 2

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
      @view.domElement[0].querySelector('span.icon').className.should.not.equal 'icon cupid-green hidden'

  describe 'hideIcon', ->
    it 'should hide icon', ->
      @view.hideIcon()
      @view.domElement[0].querySelector('span.icon').className.should.equal 'icon cupid-green hidden'

  describe 'setIconOnly', ->
    it 'should set icon only', ->
      @view.setIconOnly()

  describe 'setLoader', ->
    it 'should set a loader', ->
      @view.setLoader()
      @view.loader.should.exist

  describe 'showLoader', ->
    it 'should show a loader', ->
      @view.setLoader()
      @view.showLoader();
      @view.domElement[0].className.should.equal 'kdbutton cupid-green w-loader loading'

  describe 'hideLoader', ->
    it 'should hide a loader', ->
      @view.setLoader()
      @view.showLoader()
      @view.hideLoader()
      @view.domElement[0].className.should.equal 'kdbutton cupid-green w-loader'

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
      @view.domElement[0].disabled.should.be.true

  describe 'enable', ->
    it 'should enable', ->
      @view.enable()
      @view.domElement[0].disabled.should.be.false
