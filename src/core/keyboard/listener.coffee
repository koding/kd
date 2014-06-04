module.exports = class KDKeyboardListener

  constructor: ->
    @maps = {}
    @isListening = no

  addMap: (map, priority) ->
    { isListening } = this
    @reset()  if isListening
    m = @maps[priority ? map.priority ? 0] ?= []
    m.push map
    @listen()  if isListening
    return this

  removeMap: (map) ->
    for own priority, ms of @maps
      @maps[priority] = ms.filter (m) -> m isnt map
    return this

  listen: ->
    KDKeyboardListener.currentListener = this

    cs = {}
    ks = Object.keys @maps
      .sort (a, b) -> b - a # descending priority
      .map (k) => @maps[k]

    ks.forEach (ms) -> ms.forEach (m) ->
      m.eachCombo (combo, options = { global: yes }, listener) ->
        return if combo of cs  # only bind the first combo we find

        cs[combo] = yes
        method = if options.global then 'bindGlobal' else 'bind'

        Mousetrap[method] combo, listener

    @isListening = yes
    return this

  reset: ->
    Mousetrap.reset()
    @isListening = no
    KDKeyboardListener.currentListener = null

  @current = ->
    return @currentListener  if @currentListener

    @currentListener = new this
    @currentListener.listen()
    return @currentListener
