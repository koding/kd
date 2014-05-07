
# KDButtonGroupView

A view that creates buttons in a group.

## Usage

```coffee
view = new KDButtonGroupView
  buttons:
    "Button One!":
      cssClass: "clean-red"
      callback: ->
        new KDNotificationView
          content: "You clicked the red button, we're doomed!"
    "Button Two!"
      cssClass: "cupid-green"
      callback: ->
        new KDNotificationView
          content: "You clicked the green button, we're saved!"

appView.addSubView view
```

In this example we create a `KDButtonGroupView` and pass in a options object.  
This buttons object has a key `"buttons"`, with the value of an object also.

Each key in the buttons object is a button title, and the value for that key is 
the settings for that button. So, in the above example `"Button One!"` is the 
title of a button, and the object within are settings passed directly to the 
button being created.

`KDButtonGroupView` will take these button objects, and create instances of 
[KDButtonView][kdbuttonview] for each one.

## API Index

> class KDButtonGroupView extends [KDView][kdview]
> - [constructor](#constructor): (options={}, data) ->

## [Class](https://github.com/koding/kd/blob/master/src/components/buttons/buttongroupview.coffee#L3)

KDbuttonView inherits from [KDView][kdview]. Please see that for inherited 
methods.

### [Constructor](https://github.com/koding/kd/blob/master/src/components/buttons/buttongroupview.coffee#L5)

1. **options**:
  - Type: object
  - Default: `{}`

  The following keys are supported.

  - **options.buttons**: An object containing settings for the 
    [KDButtonViews][kdbuttonview] that KDButtonGroupView will create. Each key 
is the title of a button to be created, and the value is yet another object 
that will be given as options to the [KDButtonView][kdbuttonview].
    - Type: object




[kdview]: ./kdview.md
[kdbuttonview]: ./kdbuttonview.md
