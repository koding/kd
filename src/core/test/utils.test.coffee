{assert} = require 'chai'
KDUtils = require '../utils'

describe 'KDUtils', ->

  it 'exists', ->
    assert.ok(KDUtils)

  it 'should test each method in utils, auditing usage and deprecating unused methods'
