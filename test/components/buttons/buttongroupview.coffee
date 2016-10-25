should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDButtonGroupView = require '../../../lib/components/buttons/buttongroupview'
KDButtonView = require '../../../lib/components/buttons/buttonview'


describe 'KDButtonGroupView', ->
  beforeEach ->
    ButtonsList = [
      new KDButtonView
        title: 'Click me!'
        cssClass: 'cupid-green'
        callback: ->
          alert 'I got clicked!'
    ]
    @view = new KDButtonGroupView
      cssClass: 'group-buttons'
      buttons: ButtonsList

  describe 'constructor', ->
    it 'should instantiate without an error', ->
      @view.should.exist

    it 'should instantiate without any options', ->
      view = new KDButtonGroupView(null)
      view.should.exist
