{assert} = require 'chai'
KDRouter = require '../router'

describe 'KDRouter', ->

  it 'exists', ->
    assert.ok(KDRouter)

  describe 'constructor', ->

    it 'should instantiate without error', ->
      router = new KDRouter
      assert.ok(router)
