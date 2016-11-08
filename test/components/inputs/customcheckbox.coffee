should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDCustomCheckBox = require '../../../lib/components/inputs/customcheckbox'

describe 'KDCustomCheckBox', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @instance = new KDCustomCheckBox

  afterEach ->
    @instance.destroy()
    @sinon.restore()

  it 'exists', ->
    KDCustomCheckBox.should.exist

  describe 'constructor', ->
    it 'should instantiate without any errors', ->
      @instance.should.exist

  describe 'setValue', ->
    it 'should set a value', ->
      @instance.setValue 'Koding'
      @instance.getValue().should.equal yes
