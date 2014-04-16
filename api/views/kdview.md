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

## API

KDView inherits from [KDObject][0].

- [Constructor](#constructor)
- [addSubView](#addsubview)
- [getBounds](#getbounds)
- [hide](#hide)
- [show](#show)
- [toggleClass](#toggleclass)

### Constructor

[Source](https://github.com/koding/kd/blob/master/src/core/view.coffee#L72)

#### Args

1. **options**:
  - Type: object
  - **tagName**: The name of the html tag.
    - Type: string
    - Default: `"div"`
  - **domId**: The HTML ID of the element.
    - Type:   string
    - Default: `null`
  - **cssClass**: The class string for the html element.  
    - Type: string
    - Default: `""`
  - **parent**: The parent view for this view.
    - Type: [KDView](./kdview.md)
    - Default: `null`
  - **partial**: The contents of this HTML element, such as `"Hello"` or 
    `"<h1>Hello!"`.
    - Type: string
    - Default: `null`
  - **pistachio**: A string of pistachio to add to the contents of this HTML 
    element.
    - Type: string
    - Default: `null`
  - **delegate**: TODO
  - **bind**: TODO
  - **draggable**: TODO
  - **droppable**: TODO
  - **size**: An object with `width` and `height` properties representing the 
    size of this view, in pixels.
    - Type: object
    - Default: `null` 
    - Example: `{width: 10, height: 10}`
  - **position**: An object with top/right/bottom/left properties representing 
    the css top/right/bottom/left offset properties.
    - Type: object
    - Default: `null`
    - Example: `{top: 5, left: 5}`
  - **attributes**: The HTML attributes for this view. These can be custom, or 
    standard attributes such as `href` or `src`.
    - Type: object
    - Default: `null`
    - Example: `{href:"https://koding.com"}`
  - **tooltip**: Options that will be passed to the 
    [KDTooltip](./kdtooltip.md), which is internally created if options are 
specified.
    - Type: object
    - Default: `null`

### addSubView

[Source](https://github.com/koding/kd/blob/master/src/core/view.coffee#L439)

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

### getBounds

[Source](https://github.com/koding/kd/blob/master/src/core/view.coffee#L325)

Get the bounds of this object.

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

### hide

[Source](https://github.com/koding/kd/blob/master/src/core/view.coffee#L336)

Hide this view by applying the `hidden` css class to it.

### show

[Source](https://github.com/koding/kd/blob/master/src/core/view.coffee#L341)

If this class is hidden, show this view by removing the `hidden` css class from 
it.

### toggleClass

[Source](https://github.com/koding/kd/blob/master/src/core/view.coffee#L318)

Toggle the css class on the element.




[0]: ../core/kdobject.md
