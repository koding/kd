should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDEventEmitterWildcard = require '../../lib/core/eventemitterwildcard'


describe 'KDEventEmitterWildcard', ->
  beforeEach ->
    @instance = new KDEventEmitterWildcard

  it 'exists', ->
    KDEventEmitterWildcard.should.exist

  describe 'constructor', ->
    it 'should default delimiter option', ->
      @instance._delim.should.equal '.'

    it 'should change delimiter option', ->
      emitter = new KDEventEmitterWildcard delimiter: '~'
      emitter._delim.should.equal '~'

  describe 'setMaxListeners', ->
    it 'should set max listeners', ->
      @instance.setMaxListeners 20
      @instance._maxListeners.should.equal 20
