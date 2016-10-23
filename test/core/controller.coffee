should = require 'should'
KDController = require '../../lib/core/controller'


describe 'KDController', ->
  it 'exists', ->
    KDController.should.exist

  describe 'constructor', ->
    it 'should instantiate without error', ->
      controller = new KDController
      controller.should.exist
