should = require 'should'
KDCustomHTMLView = require '../../lib/core/customhtmlview'


describe 'KDCustomHTMLView', ->
  it 'exists', ->
    KDCustomHTMLView.should.exist

  describe 'constructor', ->
    it 'should instantiate without error', ->
      router = new KDCustomHTMLView
      router.should.exist
