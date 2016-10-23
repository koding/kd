should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
MultipleListItemView = require '../../../lib/components/autocomplete/multiplelistitemview'


describe 'MultipleListItemView', ->
  beforeEach ->
    @itemView = new MultipleListItemView
    @el = document.createElement 'div'
    @el.classList = 'removeIcon'

  it 'exists', ->
    MultipleListItemView.should.exist

  it 'should return partial', ->
    @itemView.partial().should.be.an.instanceOf String
