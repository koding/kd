should = require 'should'
sinon = require 'sinon'
Polyfills = require '../../lib/utils/polyfills'


describe 'Polyfills', ->
  beforeEach ->
    Polyfills

  it 'exists', ->
    Polyfills.should.exist

  it 'should capitalize a string', ->
    'koding'.capitalize().should.exist
    'koding'.capitalize().should.equal 'Koding'

  it 'should trim a string', ->
    ' koding '.trim().should.equal 'koding'

  it 'should get first element of an array', ->
    ['first', 'last'].first.should.equal 'first'

  it 'should get last element of an array', ->
    ['first', 'last'].last.should.equal 'last'

  it 'should throw error on document.write', ->
    faulty = ->
      document.write

    faulty().should.throw

  it 'should throw error on document.writeln', ->
    faulty = ->
      document.writeln

    faulty().should.throw
