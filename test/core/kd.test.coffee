{assert} = require('chai')
sinon = require('sinon')
kd = require('../../src/core/kd')

describe 'KD core', ->

  it 'attaches to the window', ->
    assert.ok(window.KD)

  describe 'KD.create', ->

    beforeEach ->
      @classes = kd.classes

    afterEach ->
      kd.classes = @classes

    it 'should create a new object from a registered KD class', ->
      stub = sinon.stub()

      kd.classes.foo = class Foo
        constructor: stub

      kd.create 'foo'

      assert.ok(stub.called)

