should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDLoaderView = require '../../../lib/components/loader/loaderview'


describe 'KDLoaderView', ->
  beforeEach ->
    @instance = new KDLoaderView
      size:
        height: 100
        width: 100

  it 'exists', ->
    KDLoaderView.should.exist

  describe 'constructor', ->
    it 'should instantiate without any error', ->
      @instance.options.size.should.exist
      @instance.options.cssClass.should.equal 'kdloader'

  describe 'viewAppended', ->
    it 'should exist', ->
      @instance.viewAppended.should.exist

    it 'should set line height', ->
      @instance.viewAppended()
      @instance.getElement().style['line-height'].should.equal '100px'

  describe 'show', ->
    it 'should show the loader', ->
      @instance.show()
      @instance.active.should.equal yes

  describe 'hide', ->
    it 'should hide the loader', ->
      @instance.hide()
      @instance.active.should.equal no
