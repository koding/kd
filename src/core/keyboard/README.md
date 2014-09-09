# keyboard

## class KDKeyboardListener

The keyboard listener is responsible for listening to keyboard combinations, and dispatching the appropriate behavior. It represents a prioritized grouping of keyboard maps (see below). It has some interesting attributes.

* Only one keyboard listener can be active at a given time. When you call listen on an instance, that implies that whatever instance is currently listening will be reset.
* It has numerical levels of priority that are more or less arbitrary: you can use these to organize key combos in whatever way you want. Perhaps you have global key combos, contextual key combos, and user defined key combos. Your application can decide the semantics, but the rule is, only the matching combination of the highest priority will be called.
* You can add and remove keyboard mappings to any listener, active or not, at any time.

## api

### new KDKeyboardListener

Instantiate a new KDKeyboardListener instance. There are no parameters.

### l.addComboMap(comboMap[, priority])

Add a combo map to the triage at a given priority. If you don't provide a priority, it will default to either the value of the priority property of the keyboard map itself, if any, or zero.

### l.removeComboMap(comboMap)

Remove a combo map from the triage.

### l.listen()

Start listening to keyboard events. This action implictly unseats the current listener, if any, which will have its reset method called.

### l.reset()

Stops listening to keyboard events, but does not clear any currently registered listeners.

### l.getCombos()

Returns an array of all currently listening keyboard maps, ordered by priority and flattened.

### l.combos(callback)

Iterates over `getCombos()` with the supplied callback of the signature:

'callback(combo, options, listener)`

Where:

`combo` - the combo that was invoked.

`options` - the options that were passed; can be `null`.

`listener` - the behavior function that is mapped to the combo.

### l.isActive()

Is the keyboard listener active?

### KDKeyboardListener.current()

Returns the current keyboard listener, if any, otherwise returns a temporary one.

## class KDKeyboardMap

This class represents a map of keyboard combinations to behaviors.  The combinations are represented using a simple DSL, and the behaviors are just functions.

## api

### new KDKeyboardMap(options)

Instantiate a new KDKeyboardMap instance.  Options are:

`map` - a simple dictionary mapping combos to their behaviors.

`priority` — a number representing the relative priority for this map.  This is arbitrary.  Higher priority is better.

### m.addCombo(combo[, options], behavior)

Adds a combo to the map.  It will overwrite any preexisting same combo.  Options are:

`global` - Default true.  When false, key combinations will not be listened to while an input element is selected.

### m.removeCombo(combo)

Removes a combo from the map.

### m.eachCombo(callback)

Iterates over the map, supplying the given callback with the following signature:

`callback(combo, options, listener)`

Where:

`combo` - the combo that was invoked.

`options` - the options that were passed; can be `null`.

`listener` - the behavior function that is mapped to the combo.
