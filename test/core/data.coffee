should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDData = require '../../lib/core/data'


describe 'KDData', ->
  it 'exists', ->
    KDData.should.exist

  describe 'constructor', ->
    beforeEach ->
      @instance = new KDData

    it 'should create __proxy__ holder', ->
      @instance.__proxy__.should.exist

  describe 'update', ->

    it 'should emit update on object data change', ->

      instance = new KDData {}

      spy = sinon.spy instance.__proxy__.emit
      listener = -> yes
      instance.__proxy__.on 'update', listener
      instance.foo = 'bar'

      spy.should.be.calledOnce

    it 'should emit update on array data change', ->

      instance = new KDData []

      spy = sinon.spy instance.__proxy__.emit
      listener = -> yes
      instance.__proxy__.on 'update', listener
      instance.push 'bar'

      spy.should.be.calledOnce
