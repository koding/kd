{assert} = require 'chai'
KDScrollview = require '../scrollview'

describe 'KDScrollview', ->

  it 'exists', ->
    assert.ok(KDScrollview)

  describe 'constructor', ->

    it 'should instantiate without error', ->
      router = new KDScrollview
      assert.ok(router)

