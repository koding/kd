should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDCheckBox = require '../../../lib/components/inputs/checkbox'

describe 'KDCheckBox', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @instance = new KDCheckBox

  afterEach ->
    @instance.destroy()
    @sinon.restore()

  it 'exists', ->
    KDCheckBox.should.exist

  describe 'constructor', ->
    it 'should instantiate without any errors', ->
      @instance.should.exist
      @instance.options.type.should.equal 'checkbox'
