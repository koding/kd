
# KDHitEnterInputView

KDHitEnterInputView is convenience [KDInputView][kdinputview]. It creates a 
simple input view and when the user presses enter, the callback is fired with 
the value.

## Usage

```coffee
view = new KDHitEnterInputView
  type: 'text'
  name: 'enterinput'
  placeholder: 'Type something here, and hit enter!'
  callback: (value) ->
    new KDNotificationView
      content: "You wrote: #{value}"

appView.addSubView view
```

In this example we create an input text view. When the user presses enter in 
your text field, a notification pops up with the string that the user wrote.

## API Index

> class KDHitEnterInputView extends [KDInputView][kdinputview]
> - [constructor](#constructor): (options={}, data) ->
> - [disableEnterKey](#disableenterkey): ->
> - [enableEnterKey](#enableenterkey): ->

## [Class](https://github.com/koding/kd/blob/master/src/components/input/hitenterinputview.coffee#L11)

KDHitEnterInputView extends [KDInputView][kdinputview]. Please see that for 
inherited methods and options.

### [Constructor](https://github.com/koding/kd/blob/master/src/components/input/hitenterinputview.coffee#L13)
> [constructor](#constructor): (options={}, data) ->

1. **options**:
  - Type: object
  - Default: `{}`

  The following keys are supported.

  - **options.type**: The type of this input field. Useful values are 
    `"textarea"` and `"text"`.
    - Type: string
    - Default: `"textarea"`
  - **options.callback**: A function, called when the user presses enter within 
    the input field.
    - Type: function
    - Default: `null`

### [disableEnterKey](https://github.com/koding/kd/blob/master/src/components/input/hitenterinputview.coffee#L42)
> [disableEnterKey](#disableenterkey): ->

Disable the callback on enter key.

### [enableEnterKey](https://github.com/koding/kd/blob/master/src/components/input/hitenterinputview.coffee#L36)
> [enableEnterKey](#enableenterkey): ->

Enable the callback on enter key.




[kdinputview]: ./kdinputview.md
