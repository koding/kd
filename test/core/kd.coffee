should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KD = require '../../lib/core/kd'


describe 'kd', ->
  beforeEach ->
    KD.deleteSingletons()
    KD.deleteInstances()

  it 'exists', ->
    KD.should.exist

  describe 'extend', ->
    it 'should extend', ->
      KD.extend({id: 'key'}).should.deepEqual ['key']

    it 'should throw error if key is registered', ->
      @faulty = ->
        KD.extend {'instances': []}

      @faulty.should.throw /is already registered/

  describe 'registerSingleton', ->
    it 'should register a singleton', ->
      KD.registerSingleton 'koding', {}
      KD.registerSingleton 'koding', {key: 'value'}
      KD.getSingleton('koding').should.deepEqual {}

    it 'should override a singleton', ->
      singleton = {
        key: 'value'
        destroy: (->)
      }
      spy = sinon.spy singleton.destroy

      KD.registerSingleton 'koding', {}
      KD.registerSingleton 'koding', {key: 'value'}, yes
      spy.should.be.calledOnce

  describe 'getSingleton', ->
    it 'should return null if it doesnt exist', ->
      should.not.exist KD.getSingleton 'koding'

    it 'should return singleton', ->
      KD.registerSingleton 'koding', {}

      KD.getSingleton('koding').should.deepEqual {}

  describe 'registerInstance', ->
    it 'should register an instance', ->
      KD.registerInstance( { id: 'key' })
      KD.getAllKDInstances().key.should.exist


  describe 'unregisterInstance', ->
    it 'should unregister an instance', ->
      KD.registerInstance { id: 'key' }
      KD.unregisterInstance 'key'
      should.not.exist KD.getAllKDInstances().key

  describe 'deleteInstance', ->
    it 'should delete an instance', ->
      KD.registerInstance { id: 'key' }
      KD.deleteInstance 'key'
      should.not.exist KD.getAllKDInstances().key
