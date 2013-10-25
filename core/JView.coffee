class JView extends KDView

  viewAppended:->
    template = @getOptions().pistachio or @pistachio
    template = template.call this  if 'function' is typeof template

    if template?
      @setTemplate template
      @template.update()

  pistachio:-> ""
