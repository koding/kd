should = require 'should'
KDCustomHTMLView = require '../../lib/core/customhtmlview'


describe 'KDCustomHTMLView', ->
  it 'exists', ->
    KDCustomHTMLView.should.exist

  describe 'constructor', ->
    it 'should instantiate without error', ->
      view = new KDCustomHTMLView
      view.should.exist

    it 'should set tag name', ->
      htmlView = new KDCustomHTMLView 'koding'
      htmlView.tagName.should.equal 'koding'

    it 'should set link attributes', ->
      htmlView = new KDCustomHTMLView {
        tagName: 'a'
      }

      htmlView.options.attributes.href.should.equal '#'
