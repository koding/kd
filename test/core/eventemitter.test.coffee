{ assert } = require('chai')
KDEventEmitter = require('../../src/core/eventemitter')

describe 'KDEventEmitter', ->

  it 'exists', ->
    assert.ok(KDEventEmitter)

  describe 'KDEventEmitter.registerStaticEmitter', ->

    it 'creates events holder', ->

      KDEventEmitter.registerStaticEmitter()
      assert.isDefined KDEventEmitter._e

  describe 'KDEventEmitter.emit', ->

    context "when event holder isn't defined", ->

      beforeEach ->
        # This is suspicious
        # TODO: Talk about it ~Umut
        KDEventEmitter._e = null

      it 'throws an error', ->

        assert.throws (-> KDEventEmitter.emit()), /Static events are not enabled/

    context 'when event holder is defined', ->

      beforeEach ->
        KDEventEmitter.registerStaticEmitter()

      it 'registers an event with the name', ->
        KDEventEmitter.emit 'anEvent'
        assert.isDefined KDEventEmitter._e['anEvent']

      it 'creates event holder if it is not created', ->
        KDEventEmitter.emit 'anEvent'
        assert.isDefined KDEventEmitter._e['anEvent']

      it 'calls all of the listeners', ->
        array = []
        KDEventEmitter._e['anEvent'] = []
        KDEventEmitter._e['anEvent'].push(=> array.push( 1 ))
        KDEventEmitter._e['anEvent'].push(=> array.push( 2 ))

        KDEventEmitter.emit 'anEvent'

        assert.equal array.length, 2

      it 'returns itself for chaining', ->
        ret = KDEventEmitter.emit 'anEvent'
        assert.equal ret, KDEventEmitter

  describe 'KDEventEmitter.on', ->

    context 'when listener is not a function', ->

      it 'throws an error', ->
        assert.throws (-> KDEventEmitter.on()), /listener is not a function/
        assert.throws (-> KDEventEmitter.on('a', 'b')), /listener is not a function/
        assert.throws (-> KDEventEmitter.on('a', 1)), /listener is not a function/
        assert.throws (-> KDEventEmitter.on('a', {})), /listener is not a function/
        assert.throws (-> KDEventEmitter.on('a', [])), /listener is not a function/
        assert.throws (-> KDEventEmitter.on('a', yes)), /listener is not a function/

    context "when event holder isn't defined", ->

      beforeEach ->
        # This is suspicious
        # TODO: Talk about it ~Umut
        KDEventEmitter._e = null

      it 'throws an error', ->
        onFn = -> KDEventEmitter.on 'a', -> 'dummy'
        assert.throws onFn, /Static events are not enabled/

    context "when requirements are ok", ->

      beforeEach ->
        KDEventEmitter.registerStaticEmitter()

      it 'emits an event with listener', ->
        listener = -> yes
        KDEventEmitter.on 'anEvent', listener

        assert.isDefined KDEventEmitter._e['newListener']

      it 'registers an event', ->
        listener = -> yes
        KDEventEmitter.on 'anEvent', listener

        assert.isDefined KDEventEmitter._e['anEvent']
        assert.equal KDEventEmitter._e['anEvent'][0], listener

      it 'registers multiple events', ->
        listener = -> yes
        KDEventEmitter.on ['anEvent', 'otherEvent'], listener

        assert.isDefined KDEventEmitter._e['anEvent']
        assert.equal KDEventEmitter._e['anEvent'][0], listener

        assert.isDefined KDEventEmitter._e['otherEvent']
        assert.equal KDEventEmitter._e['otherEvent'][0], listener

      it 'returns itself for chaining', ->
        listener = -> yes
        onFn = KDEventEmitter.on 'anEvent', listener

        assert.equal onFn, KDEventEmitter


  describe 'KDEventEmitter.off', ->

    beforeEach -> KDEventEmitter.registerStaticEmitter()

    it 'emits an event', ->
      listener = -> yes
      KDEventEmitter.on 'anEvent', listener
      KDEventEmitter.off 'anEvent', listener

      assert.isDefined KDEventEmitter._e['listenerRemoved']

    it 'unregisters an event', ->
      listener = -> yes
      KDEventEmitter.on 'anEvent', listener
      KDEventEmitter.off 'anEvent', listener

      assert.equal KDEventEmitter._e['anEvent'].length, 0

    it "doesn't unregister a listener doesn't exist on that key", ->
      listener = -> yes
      anotherListener = -> no

      KDEventEmitter.on 'anEvent', listener
      KDEventEmitter.off 'anEvent', anotherListener

      assert.deepEqual KDEventEmitter._e['anEvent'], [ listener ]

    it 'unregisters multiple events', ->
      listener = -> yes
      KDEventEmitter.on ['a', 'b'], listener
      KDEventEmitter.off ['a', 'b'], listener

      assert.equal KDEventEmitter._e['a'].length, 0
      assert.equal KDEventEmitter._e['b'].length, 0

    it 'returns itself for chaining', ->
      listener = -> yes
      KDEventEmitter.on 'anEvent', listener
      offFn = KDEventEmitter.off 'anEvent', listener

      assert.equal offFn, KDEventEmitter


  context 'Instance Methods', ->

    describe 'constructor', ->

      it 'creates events holder', ->
        emitter = new KDEventEmitter
        assert.isDefined emitter._e

      it 'defaults maxlisteners to 10', ->
        emitter = new KDEventEmitter
        assert.equal emitter._maxListeners, 10

      it 'sets max listeners to option', ->
        emitter = new KDEventEmitter maxListeners: 30
        assert.equal emitter._maxListeners, 30

      it "doesn't set max listeners to a negative value", ->
        emitter = new KDEventEmitter maxListeners: -1
        assert.equal emitter._maxListeners, 10

    describe 'emit', ->

      it 'creates an event holder', ->
        emitter = new KDEventEmitter
        emitter.emit 'anEvent'

        assert.isDefined emitter._e['anEvent']

      it 'calls listeners', ->
        array = []
        emitter = new KDEventEmitter
        emitter._e = {}
        emitter._e['anEvent'] = []
        emitter._e['anEvent'].push(=> array.push( 1 ))
        emitter._e['anEvent'].push(=> array.push( 2 ))

        emitter.emit 'anEvent'

        assert.deepEqual array, [1, 2]

      it 'returns itself for chaining', ->
        emitter = new KDEventEmitter
        emitResult = emitter.emit 'anEvent'

        assert.equal emitResult, emitter

    describe 'on', ->

      context 'when listener is not a function', ->

        it 'throws an error', ->
          emitter = new KDEventEmitter
          assert.throws (-> emitter.on()), /listener is not a function/
          assert.throws (-> emitter.on('a', 'b')), /listener is not a function/
          assert.throws (-> emitter.on('a', 1)), /listener is not a function/
          assert.throws (-> emitter.on('a', {})), /listener is not a function/
          assert.throws (-> emitter.on('a', [])), /listener is not a function/
          assert.throws (-> emitter.on('a', yes)), /listener is not a function/

      it 'emits an event with listener', ->
        listener = -> yes
        emitter  = new KDEventEmitter

        emitter.on 'anEvent', listener

        assert.isDefined emitter._e['newListener']

      it 'registers an event', ->
        array    = []
        listener = (number) -> array.push number
        emitter  = new KDEventEmitter

        emitter.on 'anEvent', listener

        emitter.emit 'anEvent', 1
        emitter.emit 'anEvent', 2

        assert.deepEqual array, [ 1, 2 ]

      it 'registers multiple events', ->
        listener = -> yes
        emitter  = new KDEventEmitter

        emitter.on ['anEvent', 'otherEvent'], listener

        assert.isDefined emitter._e['anEvent']
        assert.equal emitter._e['anEvent'][0], listener

        assert.isDefined emitter._e['otherEvent']
        assert.equal emitter._e['otherEvent'][0], listener

      it 'returns itself for chaining', ->
        listener = -> yes
        emitter = new KDEventEmitter

        onFn = emitter.on 'anEvent', listener

        assert.equal onFn, emitter

    describe 'off', ->

      it 'emits an event', ->
        listener = -> yes
        emitter = new KDEventEmitter

        emitter.on 'anEvent', listener
        emitter.off 'anEvent', listener

        assert.isDefined emitter._e['listenerRemoved']

      it 'unregisters an event', ->
        listener = -> yes
        emitter = new KDEventEmitter

        emitter.on 'anEvent', listener
        emitter.off 'anEvent', listener

        assert.equal emitter._e['anEvent'].length, 0

      it "doesn't unregister a listener doesn't exist on that key", ->
        emitter         = new KDEventEmitter
        listener        = -> yes
        anotherListener = -> no

        emitter.on 'anEvent', listener
        emitter.off 'anEvent', anotherListener

        assert.deepEqual emitter._e['anEvent'], [ listener ]

      it 'unregisters multiple events', ->
        listener = -> yes
        emitter  = new KDEventEmitter

        emitter.on ['a', 'b'], listener
        emitter.off ['a', 'b'], listener

        assert.equal emitter._e['a'].length, 0
        assert.equal emitter._e['b'].length, 0

      it 'returns itself for chaining', ->
        listener = -> yes
        emitter  = new KDEventEmitter

        emitter.on 'anEvent', listener
        offFn = emitter.off 'anEvent', listener

        assert.equal offFn, emitter

    describe 'once', ->

      it 'registers an event to be called only once', ->
        array    = []
        emitter  = new KDEventEmitter

        emitter.once 'anEvent', (number) -> array.push number

        emitter.emit 'anEvent', 1
        emitter.emit 'anEvent', 2

        assert.deepEqual array, [ 1 ]

      it 'returns itself for chaining', ->
        emitter = new KDEventEmitter
        onceResult = emitter.once 'anEvent', (->)

        assert.equal onceResult, emitter

