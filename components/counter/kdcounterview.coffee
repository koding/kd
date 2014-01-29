class KDCounterView extends KDView

  constructor : (options = {}, data = {}) ->

    options.style        ?= "dark"
    options.from         ?= 5000
    options.to           ?= 10000
    options.interval     ?= 1000
    options.step         ?= 1
    options.autoStart    ?= yes
    options.direction     = if options.from < options.to then "up" else "down"
    options.digits       ?= if options.direction is "up" then options.to.toString().length else options.from.toString().length
    options.cssClass      = KD.utils.curry "#{options.style} #{options.direction} kd-counter", options.cssClass

    super options, data

    @digitsList   = []
    @currentValue = options.from

    @createCounter()
    @start()  if options.autoStart

  createCounter : ->
    {from, digits} = @getOptions()

    for i in [0...digits]
      @digitsList.push @addSubView new KDCounterDigitView
        initialValue  : from.toString()[i]

  setValue : (value) ->
    return  if value is @currentValue

    @currentValue = value
    value = value.toString()

    for i in [0...value.length]
      @digitsList[i].setValue value[i]

  start : ->
    timer = @getOption "interval"
    @counterInterval = KD.utils.repeat timer, =>
      if @getOption("direction") is "up"
        newValue = @currentValue + @getOption "step"
      else
        newValue = @currentValue - @getOption "step"

      @setValue newValue
      @currentValue = newValue
