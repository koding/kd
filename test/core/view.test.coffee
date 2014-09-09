{assert} = require('chai')
KDView = require('../../src/core/view')

describe 'KDView', ->

  it 'exists', ->
    assert.ok(KDView)

  describe 'constructor', ->
    it 'should instantiate without error', ->
      o = new KDView()
      assert.ok(o)
