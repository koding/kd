{assert} = require('chai')
KDObject = require('../../src/core/object')

describe 'KDObject', ->

  it 'exists', ->
    assert.ok(KDObject)

  describe 'constructor', ->
    it 'should instantiate without error', ->
      o = new KDObject()
      assert.ok(o)
