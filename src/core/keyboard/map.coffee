module.exports = class KDKeyboardMap

  constructor: (options) ->
    @combos = {}

    { combos, @priority } = options  if options?

    if combos?
      @addCombo combo, null, listener  for own combo, listener of combos

  addCombo: (combo, options, listener) ->
    [listener, options] = [options, listener]  unless listener?
    @combos[combo] = { listener, options }
    return this

  removeCombo: (combo) ->
    @combos[combo] = null
    return this

  eachCombo: (fn, thisArg) ->
    for own combo, { options, listener } of @combos
      fn.call thisArg, combo, options, listener
    return
