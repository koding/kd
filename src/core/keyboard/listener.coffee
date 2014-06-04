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

  addComboMap: makeUpdater (map, priority) ->
    m = @maps[priority ? map.priority ? 0] ?= []
    m.push map
    return this

  removeComboMap: makeUpdater (map) ->
    for own priority, ms of @maps
      @maps[priority] = ms.filter (m) -> m isnt map
    return this

  listen: ->
    return if @isListening

    Mousetrap.reset()
    KDKeyboardListener.currentListener = this

    seen = {}

    Object.keys @maps
      .sort (a, b) -> b - a # descending priority
      .map (k) => @maps[k] # values
      .forEach (ms) -> ms.forEach (m) ->
        m.eachCombo (combo, options = { global: yes }, listener) ->
          return if seen[combo] # only bind the first combo we find

          seen[combo] = yes
          method = if options.global then 'bindGlobal' else 'bind'
          Mousetrap[method] combo, listener

    @isListening = yes
    return this

  reset: ->
    return unless @isListening

    Mousetrap.reset()
    @isListening = no
    KDKeyboardListener.currentListener = null
    return this

  @current = ->
    return @currentListener  if @currentListener?

    @currentListener = new this
    @currentListener.listen()
    return @currentListener
