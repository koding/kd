KD               = require '../../core/kd'
KDInputView      = require './inputview'
KDCustomHTMLView = require './../../core/customhtmlview'


module.exports = class KDCustomCheckBox extends KDCustomHTMLView


  constructor: (options = {}, data) ->

    options.cssClass = KD.utils.curry 'kdcustomcheckbox', options.cssClass

    super options, data

    @addSubView @input = new KDInputView
      type  : 'checkbox'
      domId : @getId()

    @addSubView @label = new KDCustomHTMLView
      tagName    : 'label'
      attributes : for: @getId()


  getValue: -> return @input.getValue()
  setValue: (value) -> @input.setValue value
