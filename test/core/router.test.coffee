{assert} = require 'chai'
KDRouter = require '../../src/core/router'

describe 'KDRouter', ->

  it 'exists', ->
    assert.ok(KDRouter)

  describe 'constructor', ->

    it 'should instantiate without error', ->
      router = new KDRouter
      assert.ok(router)
