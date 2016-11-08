should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDButtonViewWithMenu = require '../../../lib/components/buttons/buttonviewwithmenu'
_ = require 'lodash'


describe 'KDButtonViewWithMenu', ->
  beforeEach ->
    noop = (->)
    @sinon = sinon.sandbox.create()
    @view = new KDButtonViewWithMenu
      title : 'Settings'
      iconClass : 'settings'
      cssClass : 'settings-menu'
      menu :
        'Add Into': { callback: noop }
        'Edit': { callback: noop }
        'Delete': { callback: noop }

  afterEach ->
    @view.destroy()
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
      e.target = @view.getElement().querySelector('button')
      @view.click(e)

  describe 'setIconOnly', ->
    it 'should set icon only', ->
      @view.setIconOnly()
      @view.getElement().querySelector('span').className.should.equal 'icon settings'

  describe 'createContextMenu', ->
    it 'should create context menu', ->
      @view.createContextMenu()
      @view.buttonMenu.should.exist

  describe 'disable', ->
    it 'should disable', ->
      @view.disable()
      @view.getElement().querySelector('button').disabled.should.be.true

  describe 'enable', ->
    it 'should enable', ->
      @view.enable()
      @view.getElement().querySelector('button').disabled.should.be.false

  describe 'contextMenu', ->
    it 'should create context menu', ->
      @view.createContextMenu = @sinon.stub()
      @view.contextMenu();
      @view.createContextMenu.should.be.calledOnce
