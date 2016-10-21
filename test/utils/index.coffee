should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
Utils = require '../../lib/utils/index'


describe 'Utils', ->
  beforeEach ->
    @el = document.createElement 'div'

  it 'exists', ->
    Utils.should.exist

  it 'should show an element', ->
    @el.classList = 'hidden'
    Utils.elementShow @el

    @el.classList.contains('hidden').should.be.false


  it 'should hide an element', ->
    Utils.elementHide @el

    @el.classList.contains('hidden').should.be.true

  it 'should check if element has tag', ->
    Utils.elementHasTag(@el, 'div').should.be.true
    Utils.elementHasTag(@el, 'h1').should.be.false

  it 'should get nearest element by tag name', ->
    document.body.appendChild @el
    nearestEl = Utils.getNearestElementByTagName @el, 'body'
    nearestEl.should.exist
    Utils.elementHasTag(nearestEl, 'body').should.be.true

  it 'should check if an element is visible', ->
    @el.innerHTML = 'Hello world'
    document.body.appendChild @el
    Utils.elementIsVisible(@el).should.be.true

  it 'should get selection', ->
    spy = sinon.spy window.getSelection
    Utils.getSelection
    spy.should.be.calledOnce

  it 'should pluralize', ->
    Utils.formatPlural(2, 'car').should.equal '2 cars'
    Utils.formatPlural(1, 'car').should.equal '1 car'
    Utils.formatPlural(3, 'car', no).should.equal 'cars'

  it 'should format indefinite article', ->
    Utils.formatIndefiniteArticle('car').should.equal 'a car'
    Utils.formatIndefiniteArticle('apple').should.equal 'an apple'

  it 'should throw error on missing api key on shorten url', ->
    @faulty = ->
      Utils.shortenUrl 'https://koding.com', (->)

    @faulty().should.throw

  # it 'should create external link', ->
  #   appendChildSpy = sinon.spy document.body.appendChild
  #   removeChildSpy = sinon.spy document.body.removeChild
  #   Utils.createExternalLink 'http://koding.com'
  #   appendChildSpy.should.be.calledOnce
  #   removeChildSpy.should.be.calledOnce

  it 'should check if touch device', ->
    Utils.isTouchDevice().should.equal no
