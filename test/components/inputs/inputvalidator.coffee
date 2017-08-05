should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDInputValidator = require '../../../lib/components/inputs/inputvalidator'
KDInputView = require '../../../lib/components/inputs/inputview'

describe 'KDInputValidator', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @instance = new KDInputValidator
    @input = new KDInputView
      placeholder: 'Testable input view'
    @input.emit = @sinon.stub()

  afterEach ->
    @input.destroy()
    @sinon.restore()

  it 'exists', ->
    KDInputValidator.should.exist

  describe 'ruleRequired', ->
    it 'should validate', ->
      @input.setValue ''
      @input.setOptions { validate: yes }

      should(KDInputValidator.ruleRequired(@input)).equal 'Field is required'

      @input.setValue 'Koding'

      should(KDInputValidator.ruleRequired(@input)).equal null

  describe 'ruleEmail', ->
    it 'should validate', ->
      @input.setValue ''
      @input.setOptions { validate: yes }

      should(KDInputValidator.ruleEmail(@input)).equal 'Please enter a valid email address'

      @input.setValue 'test@koding.com'

      should(KDInputValidator.ruleEmail(@input)).equal null

  describe 'ruleCreditCard', ->
    it 'should validate', ->
      @input.setValue ''
      @input.setOptions { validate: yes }

      should(KDInputValidator.ruleCreditCard(@input)).equal 'Please enter a valid credit card number'

      @input.setValue '4000000000000001'
      should(KDInputValidator.ruleCreditCard(@input)).equal null
      @input.emit.should.calledOnce()

  describe 'ruleJSON', ->
    it 'should validate', ->
      @input.setValue "{foo: 'bar'}"
      @input.setOptions { validate: yes }

      should(KDInputValidator.ruleJSON(@input)).equal 'a valid JSON is required'

      @input.setValue '{ "hello": "world"}'

      should(KDInputValidator.ruleJSON(@input)).equal null

  describe 'ruleMaxLength', ->
    it 'should validate', ->
      @input.setValue 'koding'
      @input.setOptions
        validate:
          rules:
            maxLength: 5

      should(KDInputValidator.ruleMaxLength(@input)).equal 'Please enter a value that has 5 characters or less'

      @input.setValue 'code'

      should(KDInputValidator.ruleMaxLength(@input)).equal null

  describe 'ruleMinLength', ->
    it 'should validate', ->
      @input.setValue 'code'
      @input.setOptions
        validate:
          rules:
            minLength: 5
      should(KDInputValidator.ruleMinLength(@input)).equal 'Please enter a value that has 5 characters or more'

      @input.setValue 'koding'

      should(KDInputValidator.ruleMinLength(@input)).equal null
