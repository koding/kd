{assert} = require 'chai'
KDCustomhtmlview = require '../../src/core/customhtmlview'

describe 'KDCustomhtmlview', ->

  it 'exists', ->
    assert.ok(KDCustomhtmlview)

  describe 'constructor', ->

    it 'should instantiate without error', ->
      router = new KDCustomhtmlview
      assert.ok(router)
