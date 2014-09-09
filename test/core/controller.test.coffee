{assert} = require 'chai'
KDController = require '../../src/core/controller'

describe 'KDController', ->

  it 'exists', ->
    assert.ok(KDController)

  describe 'constructor', ->

    it 'should instantiate without error', ->
      router = new KDController
      assert.ok(router)
