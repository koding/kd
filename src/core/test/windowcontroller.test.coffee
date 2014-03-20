{assert} = require 'chai'
KDWindowController = require '../windowcontroller'

describe 'KDWindowController', ->

  it 'exists', ->
    assert.ok(KDWindowController)

  describe 'constructor', ->

    it 'should instantiate without error', ->
      router = new KDWindowController
      assert.ok(router)
