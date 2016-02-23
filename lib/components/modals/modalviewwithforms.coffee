debug = require('debug') 'kd:modals:modalviewwithforms'
KDModalView        = require './modalview'
KDTabViewWithForms = require '../tabs/tabviewwithforms'

module.exports = class KDModalViewWithForms extends KDModalView

  constructor: (options, data) ->

    @modalButtons = []

    super options, data

    @addSubView @modalTabs = new KDTabViewWithForms options.tabs


  aggregateFormData: ->

    data = for own formName, form of @modalTabs.forms
      name: formName
      data: form.getData()

    data.reduce (acc, form) ->
      for own key, val of form.data
        debug "overriding #{key}"  if key of acc
        acc[key] = val
      return acc
    , {}


# new KDModalViewWithForms
#     title     : "with tabs and forms"
#     content   : ""
#     overlay   : yes
#     width     : 500
#     height    : "auto"
#     cssClass  : "new-kdmodal"
#     tabs                    :
#       navigable          : yes
#       callback              : (formOutput)-> log formOutput,"All Forms ::::::"
#       forms                 :
#         "My first form"     :
#           buttons           :
#             Next            :
#               title         : "Next"
#               style         : "solid light-gray medium"
#               type          : "submit"
#           # callback          : (formOutput)-> log formOutput,"Form 1 ::::::"
#           fields            :
#             Hiko            :
#               label         : "Title:"
#               type          : "text"
#               name          : "hiko"
#               placeholder   : "give a name to your topic..."
#               validate      :
#                 rules       :
#                   required  : yes
#                 messages    :
#                   required  : "topic name is required!"
#             Zikko           :
#               label         : "Zikkko"
#               type          : "textarea"
#               name          : "zikko"
#               placeholder   : "give something else to your topic..."
#               nextElement   :
#                 lulu        :
#                   type        : "text"
#                   name        : "lulu"
#                   placeholder : "lulu..."
#         "My Second Form"    :
#           buttons           :
#             Submit          :
#               title         : "Submit"
#               style         : "solid light-gray medium"
#               type          : "submit"
#             Reset           :
#               title         : "Reset"
#               style         : "solid red medium"
#               type          : "reset"
#           # callback          : (formOutput)-> log formOutput,"Form 2 ::::::"
#           fields            :
#             Hoho            :
#               label         : "Hoho:"
#               type          : "text"
#               name          : "title"
#               placeholder   : "give a gogo..."
#               validate      :
#                 rules       :
#                   required  : yes
#                 messages    :
#                   required  : "topic name is required!"