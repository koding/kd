
# KDView

KDView is the base class for all GUI components. 


## Usage

```coffee
view = new KDView
  partial:    "I'm a view!"
  className:  'foo'

appView.addSubView view
```

When rendered, this will display approximately:

```html
<div class="foo">I'm a view!</div>
```

## API

KDView inherits from [KDObject][0].

### Constructor

[Source](https://github.com/koding/kd/blob/master/src/core/view.coffee#L72)

### Args

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
    - Type: [KDView](./)
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
  - **prefix**: 
    - Type: string
    - Default: `""`
  - **suffix**: 
    - Type: string
    - Default: `""`
  - **tooltip**: 
    - Type: object
    - Default: `null`




####



[0]: ../core/kdobject.md
