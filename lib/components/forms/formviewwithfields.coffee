KD = require '../../core/kd'
KDInputView = require '../inputs/inputview'
KDView           = require '../../core/view'
KDCustomHTMLView = require '../../core/customhtmlview'
KDFormView       = require './formview'
KDButtonBar      = require '../buttons/buttonbar'
KDLabelView      = require '../inputs/labelview'

module.exports = class KDFormViewWithFields extends KDFormView

  constructor:->

    super

    @setClass "with-fields"

    @inputs  = {}
    @fields  = {}

    {fields,buttons} = @getOptions()

    @createFields KDFormView.sanitizeFormOptions fields  if fields

    if buttons
      @createButtons buttons
      { @buttons } = @buttonField

  createFields:(fields)->
    @addSubView @createField fieldData for fieldData in fields

  createButtons:(buttons)->
    @addSubView @buttonField = new KDButtonBar { buttons }

  createField:(fieldData, field, isNextElement = no)->
    {itemClass, title} = fieldData
    itemClass          or= KDInputView
    fieldData.cssClass or= ""
    fieldData.name     or= title
    field or= new KDView cssClass : "formline #{KD.utils.slugify fieldData.name} #{fieldData.cssClass}"
    field.addSubView label = fieldData.label = @createLabel(fieldData) if fieldData.label

    unless isNextElement
      field.addSubView inputWrapper = new KDCustomHTMLView cssClass : "input-wrapper"
      inputWrapper.addSubView input = @createInput itemClass, fieldData
    else
      field.addSubView input = @createInput itemClass, fieldData

    if fieldData.hint
      inputWrapper.addSubView hint  = new KDCustomHTMLView
        partial  : fieldData.hint
        tagName  : "cite"
        cssClass : "hint"
    @fields[title] = field
    if fieldData.nextElement
      for key, next of fieldData.nextElement
        next.title or= key
        @createField next, (inputWrapper or field), yes

    if fieldData.nextElementFlat
      for own key, next of fieldData.nextElementFlat
        next.title or= key
        @createField next, field


    return field

  createLabel:(data)->
    return new KDLabelView
      title    : data.label
      cssClass : @utils.slugify data.label

  createInput:(itemClass, options)->
    {data} = options
    delete options.data  if data
    @inputs[options.title] = input = new itemClass options, data
    return input


# new KDFormViewWithFields
#   title               : "My Form Title"
#   buttons             :
#     Add               :
#       title           : "Add"
#       style           : "solid light-gray medium"
#       type            : "submit"
#     Delete            :
#       title           : "Delete"
#       style           : "solid red medium"
#       callback        : -> log "delete"
#     Reset             :
#       title           : "Reset"
#       style           : "solid red medium"
#       type            : "reset"
#   callback            : (formOutput)->
#     log formOutput,"  ::::::"
#   fields              :
#     Title             :
#       label           : "Title:"
#       type            : "text"
#       name            : "title"
#       placeholder     : "give a name to your topic..."
#       validate        :
#         rules         :
#           required    : yes
#         messages      :
#           required    : "topic name is required!"
#     Zikkko            :
#       label           : "Zikkko"
#       type            : "textarea"
#       name            : "zikko"
#       placeholder     : "give something else to your topic..."
#       nextElement     :
#         lulu          :
#           type        : "text"
#           name        : "lulu"
#           placeholder : "lulu..."
