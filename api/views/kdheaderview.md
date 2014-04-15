
# KDHeaderView

KDHeaderView is a basic [KDView](./kdview.md) to implement the 
`<h1>`/`<h2>`/`<h3>`/etc DOM elements.

## Usage

```coffee
header = new KDHeaderView
  title: 'Header title!'
  type: 'big'

appView.addSubView header
```

## API

KDHeaderView extends [KDView](./kdview.md). Please see that for inherited 
methods.

### Constructor

[Source](https://github.com/koding/kd/blob/master/src/components/header/headerview.coffee#L2)

#### Args

1. **options**:
  - Type: object
  - **title**: The contents for your header view.
    - Type: string
    - Default: `undefined`
  - **type**: The level of your `H` element, represented in three options: 
    `"big"`, `"medium"`, `"small"` which translates to `"h1"`, `"h2"`, `"h3"`,
    respectively.
    - Type: string
    - Default: `"default"`
    - Example: `{type: "big"}`

### updateTitle

[Source](https://github.com/koding/kd/blob/master/src/components/header/headerview.coffee#L14)

Update the title for this header option. This can be used after you have 
already set the title, to change it to another title.

#### Args

1. **title**: The title you want to update your header to.
  - Type: string
  - Default: `undefined`

