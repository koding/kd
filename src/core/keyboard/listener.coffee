module.exports = class KDKeyboardListener

  constructor: ->
    @maps = {}
    @isListening = no

  makeUpdater = (fn) -> ->
    { isListening } = this
    @reset()  if isListening
    retVal = fn.apply this, arguments
    @listen()  if isListening
    return retVal

  addComboMap: makeUpdater (comboMap, priority) ->
    m = @maps[priority ? comboMap.priority ? 0] ?= []
    m.push comboMap
    return this

  removeComboMap: makeUpdater (comboMap) ->
    for own priority, ms of @maps
      @maps[priority] = ms.filter (m) -> m isnt comboMap
    return this

  listen: ->
    return this  if @isListening

    Mousetrap.reset()
    KDKeyboardListener.currentListener = this

    seen = {}
    @triageComboMaps().forEach (m) ->
      m.eachCombo (combo, options = { global: yes }, listener) ->
        return  if seen[combo]
        seen[combo] = yes
        method = if options.global then 'bindGlobal' else 'bind'
        Mousetrap[method] combo, listener
    @isListening = yes
    return this

  reset: ->
    return this  unless @isListening

    Mousetrap.reset()
    @isListening = no
    KDKeyboardListener.currentListener = null
    return this

  triageComboMaps: ->
    Object.keys @maps
      # prioritize by key:
      .sort (a, b) -> b - a # descending priority
      # map back to value:
      .map (k) => @maps[k]
      # flatten:
      .reduce (a, b) ->
        a.concat b
      , []

  @current = ->
    return @currentListener  if @currentListener?

    @currentListener = new this
    @currentListener.listen()
    return @currentListener
