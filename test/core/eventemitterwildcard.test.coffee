{assert} = require 'chai'
sinon    = require 'sinon'
KDEventEmitterWildcard = require('../../src/core/eventemitterwildcard')

describe 'KDEventEmitterWildcard', ->

  it 'exists', ->
    assert.ok(KDEventEmitterWildcard)

  describe 'constructor', ->

    it 'defaults delimiter option', ->
      emitter = new KDEventEmitterWildcard
      assert.equal emitter._delim, '.'

    it 'gets delim from options', ->
      emitter = new KDEventEmitterWildcard delimiter: '~'
      assert.equal emitter._delim, '~'

  describe 'setMaxListeners', ->

    it 'sets max listeners', ->
      emitter = new KDEventEmitterWildcard
      emitter.setMaxListeners 20
      assert.equal emitter._maxListeners, 20

  describe 'emit', ->

    it "delimits eventName and calls delimited events", ->
      array      = []
      listener   = (num) -> array.push num
      emitter    = new KDEventEmitterWildcard

      emitter._e       =
        namespace      :
          '*'          :
            _listeners : [ listener ]

      emitter.emit 'namespace.first', 'first'
      emitter.emit 'namespace.second', 'second'

      assert.deepEqual array, ['first', 'second']

    it 'returns itself for chaining', ->
      emitter    = new KDEventEmitterWildcard
      emitResult = emitter.emit 'dummy'

      assert.equal emitResult, emitter

  describe 'on', ->

    context 'when listener is not a function', ->

      it 'throws an error', ->
        emitter = new KDEventEmitterWildcard
        assert.throws (-> emitter.on()), /listener is not a function/
        assert.throws (-> emitter.on('a', 'b')), /listener is not a function/
        assert.throws (-> emitter.on('a', 1)), /listener is not a function/
        assert.throws (-> emitter.on('a', {})), /listener is not a function/
        assert.throws (-> emitter.on('a', [])), /listener is not a function/
        assert.throws (-> emitter.on('a', yes)), /listener is not a function/

    it 'emits an event with listener', ->
      listener = -> yes
      emitter  = new KDEventEmitterWildcard

      sinon.spy emitter, 'emit'

      emitter.on 'anEvent', listener

      assert emitter.emit.calledWith 'newListener', 'anEvent', listener

    it 'registers a normal event', ->
      array    = []
      listener = (num) -> array.push num
      emitter  = new KDEventEmitterWildcard

      emitter.on 'regularEvent', listener

      emitter.emit 'regularEvent', 'first'
      emitter.emit 'regularEvent', 'second'

      assert.deepEqual array, ['first', 'second']

    it 'registers a wildcard event', ->
      array    = []
      listener = (num) -> array.push num
      emitter  = new KDEventEmitterWildcard

      emitter.on '*', listener

      emitter.emit 'randomEvent', 'first'
      emitter.emit 'moreRandomEvent', 'second'

      assert.deepEqual array, ['first', 'second']

    it 'registers namespaced wildcard events', ->
      array    = []
      listener = (num) -> array.push num
      emitter  = new KDEventEmitterWildcard delimiter: '/'

      emitter.on 'namespace/*', listener

      emitter.emit 'namespace/randomEvent', 'first'
      emitter.emit 'namespace/moreRandomEvent', 'second'

      assert.deepEqual array, ['first', 'second']

    it 'returns itself for chaining', ->
      emitter = new KDEventEmitterWildcard
      onResult = emitter.on 'dummy', -> yes

      assert.equal onResult, emitter

  describe 'off', ->

    it 'removes listener from regular event', ->
      array    = []
      listener = (num) -> array.push num
      emitter  = new KDEventEmitterWildcard

      emitter.on 'regularEvent', listener
      emitter.emit 'regularEvent', 1

      emitter.off 'regularEvent', listener
      emitter.emit 'regularEvent', 2

      assert.deepEqual array, [1]

    it 'removes wildcard events', ->
      array    = []
      listener = (num) -> array.push num
      emitter  = new KDEventEmitterWildcard delimiter: '/'

      emitter.on 'namespace/*', listener
      emitter.emit 'namespace/randomEvent', 'first'
      emitter.emit 'namespace/mostRandomEvent', 'second'

      emitter.off 'namespace/*', listener
      emitter.emit 'namespace/coolEvent', 'third'

      assert.deepEqual array, ['first', 'second']

    it 'returns itself for chaining', ->
      emitter = new KDEventEmitterWildcard
      offResult = emitter.off '*', -> yes

      assert.equal offResult, emitter


