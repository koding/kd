should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
Utils = require '../../lib/utils/index'

# Preparation function for simulating
# a text selection.
selectDummyElement = (innerText = 'dummy data') ->
  text             = document.createElement 'div'
  text.innerHTML   = innerText
  selection        = window.getSelection()
  range            = document.createRange()

  document.body.appendChild text

  range.selectNodeContents text
  selection.removeAllRanges()
  selection.addRange range

  return text

describe 'Utils', ->
  beforeEach ->
    @el = document.createElement 'div'

  it 'exists', ->
    Utils.should.exist

  it 'should extend', ->
    target = {}
    firstSource = { a: 1, b: 2 }
    secondSource = { c: 3, d: 4 }

    extended = Utils.extend target, firstSource, secondSource

    expected = { a: 1, b: 2, c: 3, d: 4 }

    extended.should.deepEqual expected

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

  it 'should get selection range', ->
    element = selectDummyElement 'helloworld'
    range = Utils.getSelectionRange()

    range.toString().should.equal 'helloworld'

  it 'should add range', ->
    element = selectDummyElement().firstChild
    range = document.createRange()
    range.setStart element, 1
    range.setEnd element, 5
    Utils.addRange range
    window.getSelection().toString().should.equal 'ummy'

  it 'should select text', ->
    element = selectDummyElement().firstChild
    Utils.selectText element, 2, 5
    window.getSelection().toString().should.equal 'mmy'

  it 'should get selection', ->
    spy = sinon.spy window.getSelection

    Utils.getSelection()
    spy.should.be.calledOnce

  it 'should create a unique id', ->
    prefix = 'kd'
    id = Utils.uniqueId(prefix)
    id.substr(0, 2).should.equal prefix

  it 'should create a unique id without prefix', ->
    Utils.uniqueId().should.equal 1

  it 'should generate a random rgb', ->
    Utils.getRandomRGB().substr(0, 3).should.equal 'rgb'

  it 'should generate a random hex', ->
    hex = Utils.getRandomHex()
    hex.length.should.equal 7
    hex[0].should.equal '#'

  it 'should capitalize and remove periods', ->
    input = 'hello world.'
    Utils.capAndRemovePeriods(input).should.equal 'Hello world'

  it 'should slugify a string', ->
    Utils.slugify('Hello world').should.equal 'hello-world'

  it 'should strip tags from a string', ->
    input = '<div>hello world</div>'
    Utils.stripTags(input).should.equal 'hello world'

  it 'should check if touch device', ->
    Utils.isTouchDevice().should.equal no

  it 'should encode and decode utf8', ->
    Utils.utf8Encode('hello world').should.equal Utils.utf8Decode 'hello world'

  it 'should format bytes to human readable', ->
    Utils.formatBytesToHumanReadable(1024, 1).should.equal '1.0 kB'

  it 'should get cursor node', ->
    spy = sinon.spy Utils.getSelectionRange
    Utils.getCursorNode().should.exist
    spy.should.be.calledOnce
