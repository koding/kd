should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDInputValidator = require '../../../lib/components/inputs/inputvalidator'

describe 'KDInputValidator', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @instance = new KDInputValidator

  afterEach ->
    @sinon.restore()

  it 'exists', ->
    KDInputValidator.should.exist

  describe 'ruleRequired', ->
    it 'should validate', ->
      input =
        getValue: ->
          ''
        getOptions: ->
          { validate: yes }

      should(KDInputValidator.ruleRequired(input)).equal 'Field is required'

      input.getValue = ->
        'Koding'
      should(KDInputValidator.ruleRequired(input)).equal null

  describe 'ruleEmail', ->
    it 'should validate', ->
      input =
        getValue: ->
          ''
        getOptions: ->
          { validate: yes }

      should(KDInputValidator.ruleEmail(input)).equal 'Please enter a valid email address'

      input.getValue = ->
        'test@koding.com'
      should(KDInputValidator.ruleEmail(input)).equal null

  describe 'ruleCreditCard', ->
    it 'should validate', ->
      input =
        getValue: ->
          ''
        getOptions: ->
          { validate: yes }
        emit: @sinon.stub()

      should(KDInputValidator.ruleCreditCard(input)).equal 'Please enter a valid credit card number'
      input.emit.should.calledOnce

      input.getValue = ->
        '4000000000000001'
      should(KDInputValidator.ruleCreditCard(input)).equal null

  describe 'ruleJSON', ->
    it 'should validate', ->
      input =
        getValue: ->
          "{foo: 'bar'}"
        getOptions: ->
          { validate: yes }

      should(KDInputValidator.ruleJSON(input)).equal 'a valid JSON is required'

      input.getValue = ->
        '{ "hello": "world"}'
      should(KDInputValidator.ruleJSON(input)).equal null

  describe 'ruleMaxLength', ->
    it 'should validate', ->
      input =
        getValue: ->
          'koding'
        getOptions: ->
          {
            validate:
              rules:
                maxLength: 5
          }

      should(KDInputValidator.ruleMaxLength(input)).equal 'Please enter a value that has 5 characters or less'

      input.getValue = ->
        'code'
      should(KDInputValidator.ruleMaxLength(input)).equal null

  describe 'ruleMinLength', ->
    it 'should validate', ->
      input =
        getValue: ->
          'code'
        getOptions: ->
          {
            validate:
              rules:
                minLength: 5
          }

      should(KDInputValidator.ruleMinLength(input)).equal 'Please enter a value that has 5 characters or more'

      input.getValue = ->
        'koding'
      should(KDInputValidator.ruleMinLength(input)).equal null
