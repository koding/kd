should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDEventEmitter = require '../../lib/core/eventemitter'


describe 'KDEventEmitter', ->
  it 'exists', ->
    KDEventEmitter.should.exist

  describe 'constructor', ->
    beforeEach ->
      @instance = new KDEventEmitter

    it 'should create events holder', ->
      @instance._e.should.exist

    it 'should default max listeners to 10', ->
      @instance._maxListeners.should.equal 10

    it 'should override default max listeners on demand', ->
      emitter = new KDEventEmitter maxListeners: 30
      emitter._maxListeners.should.equal 30

    it 'should not allow negative value for max listeners', ->
      emitter = new KDEventEmitter maxListeners: -1
      emitter._maxListeners.should.equal 10

  describe 'registerStaticEmitter', ->
    it 'should create events holder', ->
      KDEventEmitter.registerStaticEmitter()
      KDEventEmitter._e.should.exist
      KDEventEmitter._e.should.deepEqual {}

  describe 'emit', ->
    it 'should throw error on not registered static emitter', ->
      KDEventEmitter._e = null

      @faulty = ->
        KDEventEmitter.emit

      @faulty().should.throw

    it 'should work seamlessly', ->
      KDEventEmitter.registerStaticEmitter()
      KDEventEmitter.emit 'anEvent'
      KDEventEmitter._e['anEvent'].should.exist

    it 'should return itself', ->
      KDEventEmitter.registerStaticEmitter()
      emitter = KDEventEmitter.emit 'anEvent'
      emitter.should.deepEqual(KDEventEmitter)

  describe 'on', ->
    it 'should throw error on non function listener', ->
      (-> KDEventEmitter.on('anEvent', '')).should.throw
      (-> KDEventEmitter.on('anEvent', {})).should.throw
      (-> KDEventEmitter.on('anEvent', [])).should.throw
      (-> KDEventEmitter.on('anEvent', 1)).should.throw
      (-> KDEventEmitter.on('anEvent', yes)).should.throw

    it 'should emit newListener', ->
      KDEventEmitter.registerStaticEmitter()
      spy = sinon.spy KDEventEmitter.emit
      listener = -> yes

      KDEventEmitter.on 'anEvent', listener

      spy.should.be.calledOnce

  describe 'once', ->
    it 'should register an event to be called only once', ->
      spy = sinon.spy -> yes

      emitter = new KDEventEmitter

      emitter.once 'anEvent', spy
      emitter.emit 'anEvent', 1
      emitter.emit 'anEvent', 2
      spy.should.be.calledOnce

    it 'should return itself', ->
      emitter = new KDEventEmitter
      onceResult = emitter.once 'anEvent', (->)

      emitter.should.deepEqual onceResult

  describe 'off', ->
    beforeEach ->
      KDEventEmitter.registerStaticEmitter()
      @listener = -> yes

    it 'should emit listenerRemoved', ->
      spy = sinon.spy KDEventEmitter.emit

      KDEventEmitter.on 'anEvent', @listener
      KDEventEmitter.off 'anEvent', @listener
      spy.should.be.calledOnce
      KDEventEmitter._e['listenerRemoved'].should.exist

    it 'should unregister an event', ->
      KDEventEmitter.on 'anEvent', @listener
      KDEventEmitter.off 'anEvent', @listener

      KDEventEmitter._e['anEvent'].length.should.equal 0

    it 'should unregister a non existent event', ->
      anotherListener = -> yes
      KDEventEmitter.on 'anEvent', @listener
      KDEventEmitter.off 'anEvent', anotherListener

      KDEventEmitter._e['anEvent'].should.deepEqual [@listener]

    it 'should unregister multiple events', ->
      KDEventEmitter.on ['a', 'b'], @listener
      KDEventEmitter.off ['a', 'b'], @listener

      KDEventEmitter._e['a'].length.should.equal 0
      KDEventEmitter._e['b'].length.should.equal 0
