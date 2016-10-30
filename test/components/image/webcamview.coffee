should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDWebcamView = require '../../../lib/components/image/webcamview'


describe 'KDWebcamView', ->
  beforeEach ->
    @instance = new KDWebcamView

  it 'exists', ->
    KDWebcamView.should.exist

  describe 'countDown', ->
    it 'should count down', ->
      @instance.countDown().should.exist

  describe 'getUserMediaVendor', ->
    it 'should get user media vendor', ->
      KDWebcamView.getUserMediaVendor().should.deepEqual (navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia)

  describe 'getURLVendor', ->
    it 'should get url vendor', ->
      KDWebcamView.getURLVendor().should.deepEqual (window.URL || window.webkitURL || window.mozURL)
