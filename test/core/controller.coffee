should = require 'should'
KDController = require '../../lib/core/controller'


describe 'KDController', ->
  it 'exists', ->
    KDController.should.exist

  describe 'constructor', ->
    it 'should instantiate without error', ->
      router = new KDController
      router.should.exist
