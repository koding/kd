{ assert } = require 'chai'
utils      = require '../../src/core/utils'

describe 'KDUtils', ->

  it 'exists', ->
    assert.ok(utils)

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


  describe 'extend', ->

    it 'combines objects together', ->
      target = {}
      firstSource = { a: 1, b: 2 }
      secondSource = { c: 3, d: 4 }

      extended = utils.extend target, firstSource, secondSource

      expected = { a: 1, b: 2, c: 3, d: 4 }

      assert.deepEqual extended, expected


  describe 'dict', ->

    it 'looks like a regular object', ->
      assert.deepEqual utils.dict(), {}


    it "doesn't reassign the prototype chain", ->
      dict = utils.dict()
      dict.__proto__ = Array.prototype

      assert.notOk dict instanceof Array


  describe 'elementHasTag', ->

    it 'checks tagname', ->
      source = { tagName: 'DIV' }
      assert.ok utils.elementHasTag(source, 'div')

    it "returns false if element doesn't have a tag", ->
      assert.notOk utils.elementHasTag {}, 'div'


  describe 'getNearestElementByTagName', ->

    it 'finds nearest element', ->
      grandParent = document.createElement 'article'
      parent      = document.createElement 'span'
      child       = document.createElement 'div'
      parent.appendChild child
      grandParent.appendChild parent

      nearestSpan    = utils.getNearestElementByTagName child, 'span'
      nearestArticle = utils.getNearestElementByTagName child, 'article'

      assert.deepEqual [nearestSpan, nearestArticle], [parent, grandParent]

    it 'returns itself when there is no parent', ->
      element = document.createElement 'span'
      nearest = utils.getNearestElementByTagName element, 'span'
      assert.equal nearest, element


  describe 'elementShow', ->

    it 'returns undefined if there is no element provided', ->
      assert.isUndefined utils.elementShow()

    it 'shows element', ->
      element = document.createElement 'div'
      element.classList.add 'hidden'
      element.classList.add 'dummy'

      utils.elementShow element

      arrayified = Array.prototype.slice.call element.classList
      assert.deepEqual arrayified, ['dummy']


  describe 'elementHide', ->

    it 'returns undefined if there is no element provided', ->
      assert.isUndefined utils.elementHide()

    it 'hides element', ->
      element = document.createElement 'div'
      element.classList.add 'dummy'

      utils.elementHide element

      arrayified = Array.prototype.slice.call element.classList
      assert.deepEqual arrayified, ['dummy', 'hidden']


  describe 'elementIsVisible', ->

    it 'returns false if no offset', ->
      element = document.createElement 'div'
      expected = utils.elementIsVisible element

      assert.notOk expected


  describe 'formatPlural', ->

    it "doesn't pluralize if the count is 1", ->
      formatted = utils.formatPlural 1, 'egg'
      assert.equal formatted, '1 egg'

    it "pluralizes the word", ->
      formatted = utils.formatPlural 10, 'egg'
      assert.equal formatted, '10 eggs'

    it "doesn't show counts", ->
      showCount = no
      formatted = utils.formatPlural 10, 'egg', showCount
      assert.equal formatted, 'eggs'


  describe 'formatIndefiniteArticle', ->

    it 'adds `an` if noun starts with vowel', ->
      expected = utils.formatIndefiniteArticle 'apple'
      assert.equal expected, 'an apple'
      expected = utils.formatIndefiniteArticle 'egg'
      assert.equal expected, 'an egg'
      expected = utils.formatIndefiniteArticle 'info'
      assert.equal expected, 'an info'

    it 'adds `a` if noun starts with consonant', ->
      expected = utils.formatIndefiniteArticle 'door'
      assert.equal expected, 'a door'
      expected = utils.formatIndefiniteArticle 'bank'
      assert.equal expected, 'a bank'
      expected = utils.formatIndefiniteArticle 'computer'
      assert.equal expected, 'a computer'


  describe 'getSelection', ->

    it 'is equal to window.getSelection', ->
      assert.deepEqual utils.getSelection(), window.getSelection()


  describe 'getSelectionRange', ->


    it 'returns selection range', ->
      element = selectDummyElement 'awesome'
      range   = utils.getSelectionRange()

      assert.equal range.toString(), 'awesome'


  describe 'getCursorNode', ->

    it "returns selected text's element", ->
      element = selectDummyElement()
      node    = utils.getCursorNode()

      assert.isObject node
      assert.equal node.textContent, 'dummy data'


  describe 'addRange', ->

    it "adds range", ->
      element = selectDummyElement().firstChild

      range = document.createRange()
      range.setStart element, 1
      range.setEnd   element, 5

      utils.addRange range

      expected = window.getSelection().toString()
      assert.equal expected, 'ummy'


  describe 'selectText', ->

    it 'selects text', ->
      element = selectDummyElement().firstChild

      utils.selectText element, 2, 5

      expected = window.getSelection().toString()
      assert.equal expected, 'mmy'


