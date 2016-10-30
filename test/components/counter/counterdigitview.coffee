should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDCounterDigitView = require '../../../lib/components/counter/counterdigitview'


describe 'KDCounterDigitView', ->
  beforeEach ->
    @instance = new KDCounterDigitView

  it 'exists', ->
    KDCounterDigitView.should.exist

  describe 'setValue', ->
    it 'should set a value', ->
      @instance.setValue 666
      @instance.currentValue.should.equal 666
