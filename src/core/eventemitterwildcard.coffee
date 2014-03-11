KDEventEmitter = require './eventemitter.coffee'

module.exports = class KDEventEmitter.Wildcard extends KDEventEmitter

  wildcardKey = '*'
  listenerKey = '_listeners'

  constructor: (options = {}) ->
    super
    @_delim = options.delimiter or '.'

  setMaxListeners: (n) -> @_maxListeners = n

  getAllListeners = (node, edges, i = 0) ->

    listeners = []

    straight  = node[listenerKey]  if i is edges.length
    wild      = node[wildcardKey]
    nextNode  = node[edges[i]]

    if straight?
      listeners = listeners.concat straight

    if wild?
      listeners = listeners.concat getAllListeners wild, edges, i + 1

    if nextNode?
      listeners = listeners.concat getAllListeners nextNode, edges, i + 1

    return listeners

  removeAllListeners = (node, edges, it, i = 0) ->
    edge = edges[i]

    nextNode = node[edge]

    if nextNode?
      return removeAllListeners nextNode, edges, it, i + 1

    if it? and (listeners = node[listenerKey])?

      node[listenerKey] = (listener for listener in listeners \
                                    when listener isnt it)

    else node[listenerKey] = []

    return

  emit: (eventName, rest...) ->
    "use strict"

    oldEvent = @event  if @hasOwnProperty 'event'

    @event = eventName

    listeners = getAllListeners @_e, eventName.split @_delim

    listener.apply this, rest  for listener in listeners

    if oldEvent?
    then @event = oldEvent
    else delete @event

    return this

  off: (eventName, listener) ->
    removeAllListeners @_e, ((eventName ? '*').split @_delim), listener
    return this

  on: (eventName, listener) ->
    unless 'function' is typeof listener
      throw new Error 'listener is not a function'

    @emit 'newListener', eventName, listener

    edges = eventName.split '.'

    node = @_e

    node = node[edge] ?= {}  for edge in edges

    listeners = node[listenerKey] ?= []

    listeners.push listener

    return this