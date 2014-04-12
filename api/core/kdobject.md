
# KDObject


## Extends

[KDEventEmitter](./kdeventemitter.md)

## Methods

### constructor:(options = {}, data) ->

### bound: (method) ->

### lazyBound: (method, rest...) ->

### forwardEvent: (target, eventName, prefix="") ->

### forwardEvents: (target, eventNames, prefix="") ->

### ready:(listener) ->

### registerSingleton:KD.registerSingleton

### getSingleton:KD.getSingleton

### getInstance:(instanceId)->

### registerKDObjectInstance: -> KD.registerInstance @

### setData:(@data)->

### getData:-> @data

### setOptions:(@options = {})->

### setOption:(option, value)-> @options[option] = value

### unsetOption:(option)-> delete @options[option] if @options[option]

### getOptions:-> @options

### getOption:(key)-> @options[key] ? null

### changeId:(id)->

### cgetId:->@id

### csetDelegate:(@delegate)->

### cgetDelegate:->@delegate

### cdestroy:->

### cchainNames:(options)->
