class KDDelimitedInputView extends KDInputView
  
  constructor: (options = {}, data) ->

    options.delimiter ?= ','

    options.usePadding ?= yes

    { defaultValue } = options
    options.defaultValue = @join defaultValue, options  if defaultValue?.join?

    super options, data

  change: -> @setValue @getValue()

  getPadding: (options = @getOptions()) ->
    if options.usePadding
    then ' '
    else ''

  split: (value) ->
    @utils.splitTrim value, @getOptions().delimiter

  join: (value, options = @getOptions()) ->
    value.join "#{ options.delimiter }#{ @getPadding options }"

  getValue: -> @split super

  setValue: (value) ->
    super(
      if value.join?
      then @join value
      else value
    )