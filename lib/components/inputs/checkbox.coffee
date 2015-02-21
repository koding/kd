KDInputView = require './inputview'

module.exports = class KDCheckBox extends KDInputView
  constructor:(options = {}, data)->
    options.type   or= "checkbox"       # mandatory
    options.attributes ?= {}
    options.attributes.checked ?= options.defaultValue or no
    super options, data