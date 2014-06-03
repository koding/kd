module.exports = class KDKeyboardListener

  constructor: ->
    @maps = {}

  addMap: (map, priority) ->
    m = @maps[priority ? map.priority ? 0] ?= []
    m.push map
    return this

  removeMap: (map) ->
    for own priority, ms of @maps
      @maps[priority] = ms.filter (m) -> m isnt map
    return this

  listen: ->
    Mousetrap.reset()
    KDKeyboardListener.currentListener = this

    cs = {}
    ks = Object.keys @maps
      .sort (a, b) -> b - a # descending priority
      .map (k) => @maps[k]

    ks.forEach (ms) -> ms.forEach (m) -> m.forEach (combo, fn) ->
      return if combo of cs  # only bind the first combo we find

      cs[combo] = yes
      Mousetrap.bindGlobal combo, fn

    return this

  reset: ->
    Mousetrap.reset()
    KDKeyboardListener.currentListener = null
