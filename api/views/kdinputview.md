
# KDInputView

The base input field view. Similar to the classic `<input type="foo">` element, 
but with additional options such as validation.

## Usage

```coffee
view = new KDInputView
  placeholder: 'Type something here for an inspiring message!'

view.on 'keyup', (e) ->
  if e.keyCode is 13 #13==Enter
    new KDNotificationView
      content: "You said #{e.target.value}!"

appView.addSubView view
```

Create a simple text input view, with a placeholder. When the `keyup` event is 
fired, we check what the key is. If the keyCode is `13` *(An Enter key)*, we 
create a notification with the value of the field.

## API Index

> class KDInputView extends [KDView][kdview]
> - [constructor](#constructor): (options={}, data) ->
> - [getValue](#getvalue): ->
> - [makeDisabled](#makedisabled): ->
> - [makeEnabled](#makeenabled): ->
> - [setValue](#setvalue): (value) ->

## [Class](https://github.com/koding/kd/blob/master/src/components/input/inputview.coffee#L4)

KDInputView extends [KDView][kdview]. Please see that for inherited methods and 
options.

### [Constructor](https://github.com/koding/kd/blob/master/src/components/input/inputview.coffee#L6)
> [constructor](#constructor): (options={}, data) ->

1. **options**:
  - Type: object
  - Default: `{}`

  The following keys are supported.

  - **options.type**: The type of this input. All html input types are 
    supported.  It should be noted that `"textarea"` and `"select"` do not 
create `<input>` elements, but rather they create `<textarea>` and `<select>` 
respectively.
    - Type: string
    - Default: `"text"`
    - Options: `"text"`, `"password"`, `"hidden"`, `"checkbox"`, `"range"`, 
      `"textarea"`, `"select"`
  - **options.name**: The `name="foo"` attribute of this `<input>` element.
    - Type: string
    - Default: `""`
  - **options.label**: The label instance for this input field.
    - Type: [KDLabelView][kdlabelview]
    - Default: `null`
  - **options.defaultValue**: The default value for this instance.
    - Type: string
    - Default: `""`
  - **options.placeholder**: The HTML5 placeholder for this input.
    - Type: string
    - Default: `""`
  - **options.disabled**: Whether or not this input is disabled.
    - Type: boolean
    - Default: `false`
  - **options.selectOptions**: If this input is of the type `"select"`, this 
    list populates the select options.
    - Type: list
    - Default: `null`
  - **options.validate**: An object containing validation options, which are 
    passed to the [KDInputValidator][kdinputvalidator] for this input. Note 
that the validator is created internally, you do not need to create it.
    - Type: object
    - Default: `null`
  - **options.autogrow**: If the input type can grow, such as a `textarea`, 
    this will cause the input to grow to the content size, rather than scroll.
    - Type: boolean
    - Default: `false`
  - **options.bind**: A string of event names, separated by a space.
    - Type: string
    - Default: `" blur change focus"`
  - **options.forceCase**: Force either uppercase, or lowercase for this field 
    type. If `null`, case is not enforced.
    - Type: string
    - Default: `null`
    - Options: `"uppercase"`, `"lowercase"`, `null`

### [getValue](https://github.com/koding/kd/blob/master/src/components/input/inputview.coffee#L155)
> [getValue](#getvalue): -> value

Get the value of this input field.

### [makeDisabled](https://github.com/koding/kd/blob/master/src/components/input/inputview.coffee#L149)
> [makeDisabled](#makedisabled): ->

Disable this input field.

### [makeEnabled](https://github.com/koding/kd/blob/master/src/components/input/inputview.coffee#L152)
> [makeEnabled](#makeenabled): ->

Enable this input field.

### [setValue](https://github.com/koding/kd/blob/master/src/components/input/inputview.coffee#L168)
> [setValue](#setvalue): (value) ->

Set the value of this input field.






[kdview]: ./kdview.md
[kdinputvalidator]: ./kdinputvalidator.md
