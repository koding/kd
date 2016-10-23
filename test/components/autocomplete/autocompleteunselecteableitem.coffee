should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDAutocompleteUnselecteableItem = require '../../../lib/components/autocomplete/autocompleteunselecteableitem'


describe 'KDAutocompleteUnselecteableItem', ->
  beforeEach ->
    @item = new KDAutocompleteUnselecteableItem

  it 'exists', ->
    KDAutocompleteUnselecteableItem.should.exist

  describe 'click', ->
    it 'should return false', ->
      @item.click().should.equal no

  describe 'keyUp', ->
    it 'should return false', ->
      @item.keyUp().should.equal no

  describe 'keyDown', ->
    it 'should return false', ->
      @item.keyDown().should.equal no

  describe 'destroy', ->
    it 'should be destroyed', ->
      @item.destroy().should.equal yes
