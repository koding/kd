
# KDToggleButton

A [KDButtonView][kdbuttonview] that has a state of on or off, which can be 
toggled.

## Usage

```coffee
view = new KDToggleButton
  defaultState: 'foo'
  states: [
    {title: 'foo', callback: -> @toggleState()}
    {title: 'bar', callback: -> @toggleState()}
  ]

appView.addSubView view
```

In this example we are creating a button with two states, `"foo"` and `"bar"`.  
Each state in the `states` list is an object with varying properties, two of 
which *(`title` and `callback`)* are required.

In this example, when a user clicks out ToggleButton, we use the method 
[toggleState](#togglestate) to cycle through the states of the view.

## API Index

> class KDToggleButton extends [KDButtonView][kdbuttonview]
> - [constructor](#constructor): (options={}, data) ->
> - [setState](#setstate): (name) ->
> - [toggleState](#toggleState): ->

## [Class](https://github.com/koding/kd/blob/master/src/components/buttons/togglebutton.coffee#L3)

KDToggleButton extends [KDButtonView][kdbuttonview], please see that for 
inherited methods.

### [Constructor](https://github.com/koding/kd/blob/master/src/components/buttons/togglebutton.coffee#L5)

#### Args

1. **options**:
  - Type: object
  - **defaultState**: The title of the default state that this button will use 
    when rendered.
    - Type: string
    - Required
  - **states**: A list of state objects, containing a `title` and `callback` 
    key.
    - Type: object
    - Required
    - Example: `[{title: 'State 1', callback: ->}, {title: 'State 2', callback: 
      ->}]`

### [setState](https://github.com/koding/kd/blob/master/src/components/buttons/togglebutton.coffee#L40)
> - [setState](#setstate): (name) ->

Set the active state for this button.

#### Args

1. **name**: The name of the state to set to.
  - Type: string

### [toggleState](https://github.com/koding/kd/blob/master/src/components/buttons/togglebutton.coffee#L49)
> - [toggleState](#toggleState): ->

Cycle through the states of this button. Note that this supports any number of 
states, not just two as the name implies.

#### Args

1. **err**: An error object. If present, a warning with the error details will 
be raised.
  - Type: error
  - Default: undefined





[kdbuttonview]: ./kdbuttonview.md
