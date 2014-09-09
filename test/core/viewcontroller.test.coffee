{assert} = require 'chai'
KDViewController = require '../../src/core/viewcontroller'

describe 'KDViewController', ->

  it 'exists', ->
    assert.ok(KDViewController)

  describe 'constructor', ->

    it 'should instantiate without error', ->
      router = new KDViewController
      assert.ok(router)
