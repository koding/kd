# KDView

KDView is the base class for all GUI components. 


## Usage

```coffee
view = new KDView
  partial:    "I'm a view!"
  cssClass:  'foo'

appView.addSubView view
```

When rendered, this will display approximately:

```html
<div class="foo">I'm a view!</div>
```


## API Index

> class KDView extends [KDObject][kdobject]
> - [constructor](#constructor): (options={}, data) ->
> - [addSubView](#addsubview): ([subView][kdview]) -> [subView][kdview]
> - [getBounds](#getbounds): -> boundsObject
> - [hide](#hide): -> this
> - [show](#show): -> this
> - [toggleClass](#toggleclass): -> this

## [Class](https://github.com/koding/kd/blob/master/src/core/view.coffee#L3)

KDView inherits from [KDObject][kdobject]. Please see that for additional 
inherited methods.

### [Constructor](https://github.com/koding/kd/blob/master/src/core/view.coffee#L72)
> [constructor](#constructor): (options={}, data) ->

#### Args

1. **options**:
  - Type: object
  - Default: `{}`

  The following keys are supported.

  - **options.tagName**: The name of the html tag.
    - Type: string
    - Default: `"div"`
  - **options.domId**: The HTML ID of the element.
    - Type:   string
    - Default: `null`
  - **options.cssClass**: The class string for the html element.  
    - Type: string
    - Default: `""`
  - **options.parent**: The parent view for this view.
    - Type: [KDView][kdview]
    - Default: `null`
  - **options.partial**: The contents of this HTML element, such as `"Hello"` 
    or `"<h1>Hello!"`.
    - Type: string
    - Default: `null`
  - **options.pistachio**: A string of pistachio to add to the contents of this 
    HTML element.
    - Type: string
    - Default: `null`
  - **options.size**: An object with `width` and `height` properties 
    representing the size of this view, in pixels.
    - Type: object
    - Default: `null` 
    - Example: `{width: 10, height: 10}`
  - **options.position**: An object with top/right/bottom/left properties 
    representing the css top/right/bottom/left offset properties.
    - Type: object
    - Default: `null`
    - Example: `{top: 5, left: 5}`
  - **options.attributes**: The HTML attributes for this view. These can be 
    custom, or standard attributes such as `href` or `src`.
    - Type: object
    - Default: `null`
    - Example: `{href:"https://koding.com"}`
  - **options.tooltip**: Options that will be passed to the 
    [KDTooltip](./kdtooltip.md), which is internally created if options are 
specified.
    - Type: object
    - Default: `null`

### [addSubView](https://github.com/koding/kd/blob/master/src/core/view.coffee#L439)
> [addSubView](#addsubview): ([subView][kdview]) -> [subView][kdview]

`addSubView` adds another [KDView](./kdview.md) to this KDView instance.

#### Args

1. **subView**: The [KDView](./kdview.md) to add to this instance.
  - Required
  - Type: [KDView](./kdview.md)
2. **selector**: TODO
3. **shouldPrepend**: Should the view being added be prepended, or appended, to 
  this view's list of children.
  - Type: truthy
  - Default: false

### [getBounds](https://github.com/koding/kd/blob/master/src/core/view.coffee#L325)
> [getBounds](#getbounds): -> boundsObject

Get the bounds of this view.

#### Returns

An object containing the x, y, width, height, and name of the view.

Example:

```coffee
{
  x: 10
  y: 10
  w: 50
  h: 50
  n: "HelloWorldView"
}
```

### [hide](https://github.com/koding/kd/blob/master/src/core/view.coffee#L336)
> [hide](#hide): -> this

Hide this view by applying the `hidden` css class to it.

### [show](https://github.com/koding/kd/blob/master/src/core/view.coffee#L341)
> [show](#show): -> this

If this class is hidden, show this view by removing the `hidden` css class from 
it.

### [toggleClass](https://github.com/koding/kd/blob/master/src/core/view.coffee#L318)
> [toggleClass](#toggleclass): -> this

Toggle the css class on the element.




[kdobject]: ../core/kdobject.md
[kdview]: ./
