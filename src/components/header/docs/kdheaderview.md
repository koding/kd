
# KDHeaderView

KDHeaderView is a basic [KDView][kdview] to implement the 
`<h1>`/`<h2>`/`<h3>`/etc DOM elements.

## Usage

```coffee
header = new KDHeaderView
  title: 'Header title!'
  type: 'big'

appView.addSubView header
```

## API Index

> class KDHeaderView extends [KDView][kdview]
> - [constructor](#constructor): (options={}, data) ->
> - [updateTitle](#updatetitle): (newTitle) ->

## [Class](https://github.com/koding/kd/blob/master/src/components/header/headerview.coffee#L3)

KDHeaderView extends [KDView][kdview]. Please see that for inherited methods.

### [Constructor](https://github.com/koding/kd/blob/master/src/components/header/headerview.coffee#L4)
> [constructor](#constructor): (options={}, data) ->

#### Args

1. **options**:
  - Type: object
  - Default: `{}`

  The following keys are supported.
  
  - **options.title**: The contents for your header view.
    - Type: string
    - Default: `undefined`
  - **options.type**: The level of your `H` element, represented in three 
    options: `"big"`, `"medium"`, `"small"` which translates to `"h1"`, `"h2"`, 
`"h3"`,
    respectively.
    - Type: string
    - Default: `"default"`
    - Example: `{type: "big"}`

### [updateTitle](https://github.com/koding/kd/blob/master/src/components/header/headerview.coffee#L14)
> [updateTitle](#updatetitle): (newTitle) ->

Update the title for this header option. This can be used after you have 
already set the title, to change it to another title.

#### Args

1. **title**: The title you want to update your header to.
  - Type: string
  - Default: `undefined`




[kdview]: ./kdview.md
