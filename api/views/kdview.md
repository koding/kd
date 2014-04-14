
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

### Methods

#### Constructor

[constructor: (options={}, data) 
->](https://github.com/koding/kd/blob/master/src/core/view.coffee#L72)

- **options**: Optional, object. Supports the following values:
  - **tagName**: Optional, string. The name of the html tag. Default `"div"`
  - **domId**: Optional, string. The ID of the html element. Default `null`
  - **cssClass**: Optional, string. The class string for the html element.  
    Default `""`
  - **parent**: Optional, KDView. The parent view for this view. Default `null`
  - **partial**: Optional, string. The contents of this HTML element, such as 
    `"Hello"` or `"<h1>Hello!"`. Default `null`
  - **pistachio**: Optional, string. A string of pistachio to add to the 
    contents of this HTML element. Default 'null'
  - **delegate**: TODO
  - **bind**: TODO
  - **draggable**: TODO
  - **droppable**: TODO
  - **size**: Optional, Object. An object with `width` and `height` properties 
    representing the size of this view, in pixels. Example `{width: 10, height: 
10}`. Default: `null`
  - **position**: Optional, Object. An object with top/right/bottom/left 
    properties representing the css top/right/bottom/left offset properties.  
Example: `{top: 5, left: 5}`. Default `null`
  - **attributes**  
  - **prefix      
  - **suffix      
  - **tooltip     



####



[0]: ../core/kdobject.md
