{assert} = require('chai')
KDEventEmitter = require('../../src/core/eventemitter')

describe 'KDEventEmitter', ->

  it 'exists', ->
    assert.ok(KDEventEmitter)
