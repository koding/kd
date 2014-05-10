
# KDLoaderView

KDLoaderView is a view to display a spinning loading symbol. Built into some 
Views, such as [KDButtonView][kdbuttonview]

## Usage

```coffee
view = new KDLoaderView
  showLoader: true
  loaderOptions:
    color: '#ff0000'
    shape: 'spiral'

appView.addSubView view
```

Creates a red spiral loader, that shows once it's added to another view.


## API Index

> class KDLoaderView extends [KDView][kdview]
> - [constructor](#constructor): (options={}, data) ->
> - [hide](#hide): ->
> - [show](#show): ->

## [Class](https://github.com/koding/kd/blob/master/src/components/loader/loaderview.coffee#L3)

KDLoaderView extends [KDView][kdview]. Please see that for inherited methods.

### [Constructor](https://github.com/koding/kd/blob/master/src/components/loader/loaderview.coffee#L5)
> - [constructor](#constructor): (options={}, data) ->

#### Args

1 **options**:
  - Type: object
  - **tagName**: The type of html element to house this loader spinner.
    - Type: string
    - Default: `"span"`
  - **showLoader**: Whether or not to show the loader.
    - Type: truthy
    - Default: `false`
  - **size**: The dimensions of this loader.
    - Type: object
    - **width**: The width of the loader, in pixels.
      - Type: number
      - Default: `24`
    - **height**: The height of the loader, in pixels.
      - Type: number
      - Default: `24`
  - **loaderOptions**: Options for the loader.
    - Type: object
    - **color**: The color of the loader, in 6 digit hex form.
      - Type: string
      - Default: `"#000000"`
    - **shape**: The shape of this loader.
      - Type: string
      - Options: `"spiral", "oval", "square", "rect", "roundRect"`
      - Default: `"rect"`
    - **diameter**: The diameter of the loader.
      - Type: number
      - Range: `10` through `200`
      - Default: `20`
    - **density**: The number of visual objects within the loader. Such as dots 
      within the spinner.
      - Type: number
      - Range: `5` through `160`
      - Default: `12`
    - **range**: The amount of the loader that the animation covers. Such as 
      the "tail" on the spiral spinner.
      - Type: number
      - Range: `0.1` through `2`
      - Default: `1`
    - **speed**: The speed of the spinner.
      - Type: number
      - Range: `1` through `10`
      - Default: `1`
    - **FPS**: The Frames Per Second of the loading animation.
      - Type: number
      - Range: `1` through `60`
      - Default: 24

### [hide](https://github.com/koding/kd/blob/master/src/components/loader/loaderview.coffee#L45)
> - [hide](#hide): ->

Hide the loader.

### [show](https://github.com/koding/kd/blob/master/src/components/loader/loaderview.coffee#L39)
> - [show](#show): ->

Show the loader.




[kdview]: ./kdview.md
[kdbuttonview]: ./kdbuttonview.md
