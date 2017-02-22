should = require 'should'
sinon = require 'sinon'
KDFlex = require '../../../lib/components/flexsplit/flex'

describe 'KDFlex', ->

  it 'should exists', ->
    KDFlex.should.exist

  describe 'constants', ->

    it 'should have instance type exists', ->
      KDFlex.INSTANCE_TYPE.should.exist

    it 'should have action events exists', ->
      KDFlex[e].should.exist  for e in [
        'EVENT_HIDE', 'EVENT_RESIZE', 'EVENT_EXPAND', 'EVENT_COLLAPSE'
      ]

    it 'should have state changed events exists', ->
      KDFlex[e].should.exist  for e in [
        'EVENT_HIDDEN', 'EVENT_RESIZED', 'EVENT_EXPANDED', 'EVENT_COLLAPSED'
      ]

    it 'should have min & max values exists', ->
      KDFlex.MIN.should.exist
      KDFlex.MAX.should.exist

    it 'should have type constants exists', ->
      for e in [ 'HORIZONTAL', 'VERTICAL' ]
        KDFlex[e].should.exist
        KDFlex[e].name.should.exist
        KDFlex[e].axis.should.exist
        KDFlex[e].getter.should.exist
