require 'kd-shim-canvas-loader'
KDView = require '../../core/view'

module.exports = class KDLoaderView extends KDView

  constructor:(options, data)->

    o = options or {}
    o.loaderOptions or= {}
    o.size          or= {}
    options =
      tagName       : o.tagName                 or "span"
      bind          : o.bind                    or "mouseenter mouseleave"
      showLoader    : o.showLoader              or no
      size          :
        width       : o.size.width              or 24
        height      : o.size.height             or 24
      loaderOptions :
        color       : o.loaderOptions.color     or "#000000"   # hex color
        shape       : o.loaderOptions.shape     or "rect"      # "spiral", "oval", "square", "rect", "roundRect"
        diameter    : o.loaderOptions.diameter  or 20          # 10 - 200
        density     : o.loaderOptions.density   or 12          # 5 - 160
        range       : o.loaderOptions.range     or 1           # 0.1 - 2
        speed       : o.loaderOptions.speed     or 1           # 1 - 10
        FPS         : o.loaderOptions.FPS       or 24          # 1 - 60

    options.loaderOptions.diameter = options.size.height = options.size.width
    options.cssClass = if o.cssClass then "#{o.cssClass} kdloader" else "kdloader"
    super options, data

  viewAppended:->

    @canvas = new CanvasLoader @getElement(), id : "cl_#{@id}"
    {loaderOptions, showLoader} = @getOptions()
    for own option, value of loaderOptions
      @canvas["set#{option.capitalize()}"] value

    {height} = @getOption 'size'
    @setCss 'line-height', if height then height + 'px' else 'initial'

    @show()  if showLoader

  show:->

    super
    @active = yes
    @canvas.show() if @canvas

  hide:->

    super
    @active = no
    @canvas.hide() if @canvas

  # easter
  # mouseEnter:->

  #   @canvas.setSpeed 2
  #   @canvas.setColor @utils.getRandomHex()

  # mouseLeave:->

  #   @canvas.setColor @getOptions().loaderOptions.color
  #   @canvas.setSpeed @getOptions().loaderOptions.speed
