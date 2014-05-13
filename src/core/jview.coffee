KDView = require './view.coffee'

module.exports = class JView extends KDView

  viewAppended:->
    template = @getOptions().pistachio or @pistachio
    params   = @getOptions().pistachioParams or @pistachioParams
    template = template.call this  if 'function' is typeof template
    params   = params.call this    if 'function' is typeof params

    if template?
      @setTemplate template, params
      @template.update()


  pistachio:-> ""
