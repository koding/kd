KDView = require './../../core/view.coffee'

###*
 * KDLoaderView is a view to display a spinning loading symbol. Built into
 * some Views, such as KDButtonView.
 *
 * ## Usage
 *
 * ```coffee
 * view = new KDLoaderView
 *   showLoader: true
 *   loaderOptions:
 *     color: '#ff0000'
 *     shape: 'spiral'
 *
 * appView.addSubView view
 * ```
 *
 * Creates a red spiral loader, that shows once it's added to another view.
###
module.exports = class KDLoaderView extends KDView

  ###*
   * Options supports the following keys.
   * - **options.tagName**: The type of html element to house this
   *   loader spinner. tagName defaults to `<span>`.
   * - **options.showLoader**: Whether or not to show the loader. Defaults to
   *   false.
   * - **options.size**: An `Object` with the dimensions of this loader.
   *   Supports the following keys.
   *   - **width**: The width of the loader, in pixels. Default `24`
   *   - **height**: The height of the loader, in pixels. Default `24`
   * - **loaderOptions**: Options for the loader. Supports the following keys.
   *   - **color**: The color of the loader, in 6 digit hex form. Defaults to
   *     `#000000`
   *   - **shape**: The shape of this loader. Supports the following strings
   *     `"spiral", "oval", "square", "rect", "roundRect"`. Defaults to `"rect"`
   *   - **diameter**: The diameter of the loader. Supports a range between
   *     `10` and `200`. Defaults to `20`.
   *   - **density**: The number of visual objects within the loader. Such as dots
   *     within the spinner. Supports a range between `5` and `160`. Defaults to
   *     `12`
   *   - **range**: The amount of the loader that the animation covers. Such as
   *     the "tail" on the spiral spinner. Supports a range between `0.1` and
   *     `2`. Defaults to `1`
   *   - **speed**: The speed of the spinner. Supports a range between `1` and
   *     `10`. Defaults to `1`
   *   - **FPS**: The Frames Per Second of the loading animation. Supports a
   *     range between `1` and `60`. Defaults to `24`
   *
   * @param {Object} options
   * @param {Object} data
  ###
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

    @show()  if showLoader

  ###*
   * Show the loader
  ###
  show:->

    super
    @active = yes
    @canvas.show() if @canvas

  ###*
   * Hide the loader
  ###
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
