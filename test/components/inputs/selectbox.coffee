should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDSelectBox = require '../../../lib/components/inputs/selectbox'

describe 'KDSelectBox', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @instance = new KDSelectBox

  afterEach ->
    @sinon.restore()

  it 'exists', ->
    KDSelectBox.should.exist

  describe 'constructor', ->
    it 'should instantiate without any errors', ->
      @instance.should.exist

  describe 'setDefaultValue', ->
    it 'should set a default value', ->
      @instance.setDefaultValue 'Koding'
      @instance.getDefaultValue().should.equal 'Koding'

  describe 'makeDisabled', ->
    it 'should make disabled', ->
      @instance.makeDisabled()
      @instance._$select.attr('disabled').should.equal 'disabled'

  describe 'makeEnabled', ->
    it 'should make enabled', ->
      @instance.makeEnabled()
      should(@instance._$select.attr('disabled')).equal undefined

  describe 'focus', ->
    it 'should focus', ->
      @instance.focus()
      @instance.domElement[0].classList.contains('focus').should.equal yes

  describe 'blur', ->
    it 'should blur', ->
      @instance.focus()
      @instance.blur()
      @instance.domElement[0].classList.contains('focus').should.equal no
