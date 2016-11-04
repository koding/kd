should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDInputRadioGroup = require '../../../lib/components/inputs/inputradiogroup'

describe 'KDInputRadioGroup', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @o =
      radios: [
        callback: (->)
        disabled: false
      ]
    @instance = new KDInputRadioGroup @o, {}

  afterEach ->
    @sinon.restore()

  it 'exists', ->
    KDInputRadioGroup.should.exist

  describe 'constructor', ->
    it 'should instantiate without any errors', ->
      @instance.should.exist
