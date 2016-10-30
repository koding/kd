should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDButtonViewWithMenu = require '../../../lib/components/buttons/buttonviewwithmenu'
_ = require 'lodash'


describe 'KDButtonViewWithMenu', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @addCallback = @sinon.spy (->)
    @editCallback = @sinon.spy (->)
    @deleteCallback = @sinon.spy (->)
    @view = new KDButtonViewWithMenu
      title : 'Settings'
      iconClass : 'settings'
      cssClass : 'settings-menu'
      menu :
        'Add Into' : { callback: => @addCallback() }
        'Edit' : { callback: => @editCallback() }
        'Delete' : { callback: => @deleteCallback() }

  afterEach ->
    @sinon.restore()

  describe 'constructor', ->
    it 'should instantiate without any errors', ->
      @view.should.exist

  describe 'setDomElement', ->
    it 'should set a dom element', ->
      @view.setDomElement(null).should.exist
      @view.setDomElement('koding-view').should.exist

  describe 'click', ->
    it 'should click', ->
      e = document.createEvent('MouseEvent')
      e.target = @view.domElement[0].querySelector('button')
      @view.click(e)

  describe 'setIconOnly', ->
    it 'should set icon only', ->
      @view.setIconOnly()
      @view.domElement[0].querySelector('span').className.should.equal 'icon settings'

  describe 'createContextMenu', ->
    it 'should create context menu', ->
      @view.createContextMenu()
      @view.buttonMenu.should.exist

  describe 'disable', ->
    it 'should disable', ->
      @view.disable()
      @view.domElement[0].querySelector('button').disabled.should.be.true

  describe 'enable', ->
    it 'should enable', ->
      @view.enable()
      @view.domElement[0].querySelector('button').disabled.should.be.false

  describe 'contextMenu', ->
    it 'should create context menu', ->
      @view.createContextMenu = @sinon.stub()
      @view.contextMenu();
      @view.createContextMenu.should.be.calledOnce
