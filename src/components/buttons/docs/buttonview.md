
# KDButtonView

KDButtonView implements a `<button>` DOM element, with the ability to subscribe 
to click events.

## Usage

```coffee
view = new KDButtonView
  title: 'Click me!'
  cssClass: 'cupid-green'
  callback: ->
    alert 'I got clicked!'

appView.addSubView view
```

This example will render a green button, with the text `"Click me!"`. When the 
button is pressed by the user, an alert will pop up with the message `"I got 
clicked!"`

While this example is fine for an immediate action, what if we wanted our 
button to load a project? For that, we tell the button to use a 
[KDLoaderView](./kdloaderview.md). Lets see how this looks.

```coffee
view = new KDButtonView
  title: 'Take a long time.'
  cssClass: 'clean-red'
  loader: {}
  callback: ->
    longTimeDone = =>
      @hideLoader()
    setTimeout longTimeDone, 2000

appView.addSubView view
```

In this example, a couple things are different. First, we define a loader 
object. This is an object full of options that are passed to a 
[KDLoaderView](./kdloaderview.md) instance. You'll note that we don't actually 
define any options, but the empty object will cause a loader to be used with 
the default options.

Secondly, in our callback we turn the loader off with the 
[hideLoader](#hideloader) method, after a `setTimeout` of 2000.

The end result of these changes is that when our button is clicked, it starts 
the loader *(with the options we define)*. When we want to turn it off, we call 
the `@hideLoader()` method. Easy!

## API Index

> class KDButtonView extends [KDView][kdview]
> - [constructor](#constructor): (options={}, data) ->
> - [hideLoader](#hideloader): ->
> - [showLoader](#showloader): ->

## [Class](https://github.com/koding/kd/blob/master/src/components/buttons/buttonview.coffee#L4)

KDButtonView extends [KDView][kdview], please see that for inherited methods.

### [Constructor](https://github.com/koding/kd/blob/master/src/components/buttons/buttonview.coffee#L6)
> [constructor](#constructor): (options={}, data) ->

1. **options**:
  - Type: object
  - Default: `{}`

  The following keys are supported.

  - **options.title**: The title of the button.
    - Type: string
    - Default: `""`
  - **options.callback**: The function to be called when the button is pressed.
    - Type: function
    - Default: `function(){}`
  - **options.loader**: The options to use for a loader on this button. If 
    false, this button will not use a loader by default. See 
[KDLoaderView](./kdloaderview.md) for the supported options.
    - Type: object
    - Default: `false`

## [hideLoader](https://github.com/koding/kd/blob/master/src/components/buttons/buttonview.coffee#L121)
> [hideLoader](#hideloader): ->

Hide the [KDLoaderView][kdloaderview] on this button, if any.

### [showLoader](https://github.com/koding/kd/blob/master/src/components/buttons/buttonview.coffee#L115)
> [showLoader](#showloader): ->

Show the [KDLoaderView][kdloaderview] on this button, if any. Note that the 
loader is shown by default when the button is clicked.

## Styling

While not complete, the following list is some handy built in css classes to 
style your button with.

- **small-gray**: A small, gray button.
- **small-blue**: A small, blue button.
- **clean-gray**: A clean gray button, the default button style.
- **clean-red**: A clean red button.
- **cupid-green**: A green button.
- **transparent**: And no surprise, a transparent button.




[kdview]: ./kdview.md
[kdloaderview]: ./kdloaderview.md
