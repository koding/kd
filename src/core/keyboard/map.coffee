module.exports = class KDKeyboardMap

  constructor: (options) ->
    { @priority } = options  if options?
    @combos = {}

  addCombo: (combo, fn) ->
    @combos[combo] = fn
    return this

  removeCombo: (combo) ->
    @combos[combo] = null
    return this

  forEach: (fn, thisArg) ->
    fn.call thisArg, combo, listener  for own combo, listener of @combos
    return
