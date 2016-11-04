should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDTabViewWithForms = require '../../../lib/components/tabs/tabviewwithforms'


describe 'KDTabViewWithForms', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @o = {}
    @o.forms = []
    @instance = new KDTabViewWithForms @o, {}

  afterEach ->
    @sinon.restore()

  it 'exists', ->
    KDTabViewWithForms.should.exist

  describe 'constructor', ->
    it 'should instantiate without any errors', ->
      @instance.should.exist
