should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDEventEmitterWildcard = require '../../lib/core/eventemitterwildcard'


describe 'KDEventEmitterWildcard', ->
  beforeEach ->
    @instance = new KDEventEmitterWildcard
    emitSpy = sinon.spy @instance.emit

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

  describe 'off', ->
    it 'should remove all listeners', ->
      emitter = new KDEventEmitterWildcard
      spy = sinon.spy emitter.removeAllListeners
      emitter.off
      spy.should.be.calledOnce

    it 'should return itself', ->
      @instance.off().should.deepEqual @instance

  describe 'on', ->
    it 'should return itself', ->
      @instance.on('koding', (->)).should.be.an.instanceOf(KDEventEmitterWildcard)
