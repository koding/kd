should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDFormView = require '../../../lib/components/forms/formview'


describe 'KDFormView', ->
  beforeEach ->
    @instance = new KDFormView

  it 'exists', ->
    KDFormView.should.exist

  describe 'constructor', ->
    it 'should instantiate without error', ->
      @instance.should.exist

    it 'should have proper attributes', ->
      @instance.options.tagName.should.equal 'form'
      @instance.options.cssClass.should.equal 'kdformview'
      @instance.options.bind.should.equal 'submit'

  describe 'addCustomData', ->
    it 'should add custom data', ->
      @instance.addCustomData 'key', 'value'
      @instance.getCustomData().key.should.equal 'value'
      @instance.addCustomData {
        'key2': 'value'
      }
      @instance.getCustomData().key2.should.equal 'value'

  describe 'getCustomData', ->
    it 'should get a custom data', ->
      @instance.addCustomData 'key', 'value'
      data = @instance.getCustomData 'key'
      data.should.equal 'value'

  describe 'removeCustomData', ->
    it 'should remove custom data', ->
      @instance.addCustomData 'key', 'value'
      @instance.getCustomData('key').should.exist
      @instance.getCustomData('key').should.equal 'value'
      @instance.removeCustomData 'key'
      should(@instance.getCustomData('key')).not.exist

  describe 'getData', ->
    it 'should get data', ->
      @instance.addCustomData 'key', 'value'
      @instance.getData().key.should.equal 'value'

  describe 'submit', ->
    it 'should submit', ->
      @instance.addCustomData 'key', 'value'
      @instance.submit()

  describe 'getFormData', ->
    it 'should get form data', ->
      @instance.addCustomData 'key', 'value'
      @instance.getFormData().key.should.equal 'value'
