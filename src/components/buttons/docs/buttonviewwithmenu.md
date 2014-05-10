
# KDButtonViewWithMenu

This view is a Button, with a dropdown menu.

## Usage

```coffee
view = new KDButtonViewWithMenu
  title: 'Button Title'
  menu:
    'Menu Item 1':
      callback: ->
        new KDNotificationView
          content: 'Item 1 Callback'
    
    'Menu Item 2':
      callback: ->
        new KDNotificationView
          content: 'Item 2 Callback'

  callback: ->
    new KDNotificationView
      content: 'Button Callback'

appView.addSubView view
```

Welcome to callback city! This can be broken down into two main parts.

First up, lets look at the button itself. Just like a normal 
[KDButtonView][kdbuttonview], KDButtonViewWithMenu has a `title` and `callback` 
option. The do exactly the same thing; set the name of the button and the 
callback when the button is pressed.

Next, we have a `menu` object. Each key in this object is the name of a menu 
item. Each object within, supports a callback keyword.

## API Index

> class KDButtonViewWithMenu extends [KDButtonView][kdbuttonview]
> - [constructor](#constructor): (options={}, data) ->

## [Class](https://github.com/koding/kd/blob/master/src/components/buttons/buttonviewwithmenu.coffee#L3)

KDButtonViewWithMenu extends [KDButtonView][kdbuttonview], please see that for 
inherited methods.

### [Constructor](https://github.com/koding/kd/blob/master/src/components/buttons/buttonviewwithmenu.coffee#L3)

1. **options**:
  - Type: object
  - Default: `{}`

  The following keys are supported.

  - **options.title**: The title of this button
    - Type: string
    - Default: `""`
  - **options.callback**: The callback function called when the button is 
    pressed.
    - Type: function
    - Default: `function(){}`
  - **options.menu**: An object containing menu items and callbacks. Each key 
    is the menu item name, and the value of the key is an object with a 
callback key/value pair.
    - Type: object
    - Example: `{"Menu Item Name":{callback: ->}}`




[kdbuttonview]: ./kdbuttonview.md
