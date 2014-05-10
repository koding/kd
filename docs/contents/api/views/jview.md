
# JView

JView implements a basic [KDView](./kdview.md) with [Pistachio][0] as the 
default template language.

## Usage

If you're creating your own class and extending JView, you'll want to define a 
`pistachio` method.

```coffee
class Example extends JView
  pistachio: ->
    """
    <p>
      This is a JView!
    </p>
    """

example = new Example()
appView.addSubView example
```

If you're looking to create a pistachio view *without* inheriting it, you can 
define a `pistachio` property on the JView option.

```coffee
view = new JView
  pistachio: """
  <p>
    This is a JView!
  </p>
  """

appView.addSubView view
```

These two are approximately the same. The differences lie in your 
implementation needs.

## API Index

> class JView extends [KDView][kdview]
> - [constructor](#constructor): (options={}, data) ->
> - [pistachio](#pistachio): -> "some pistachio"

## [Class](https://github.com/koding/kd/blob/master/src/core/jview.coffee#L3)

JView extends [KDView](./kdview.md). Please see that for inherited methods.

### [Constructor](https://github.com/koding/kd/blob/master/src/core/jview.coffee#L3)
> [constructor](#constructor): (options={}, data) ->

Source for JView constructor is inherited entirely from [KDView][kdview].  The 
only difference is the `pistachio` option.

#### Args

1. **options**:
  - Type: object
  - Default: `{}`

    The following keys are supported.

  - **options.pistachio**: A pistachio string. This is an alternative to the 
    `@pistachio` method, and is checked **first** when pistachio is rendered.
    - Type: string
    - Default: `undefined`

### [pistachio](https://github.com/koding/kd/blob/master/src/core/jview.coffee#L14)
> [pistachio](#pistachio): -> "some pistachio"

The `@pistachio` method is intended for you to implement in your class which is 
extending JView. It's sole purpose is to return a string is pistachio 
templating. 

#### Returns

A string is [Pistachio][0].

Example:

```pistachio
<p>
  This is being returned by your class, which inherited JView!
</p>
```




[0]: https://github.com/phidelta/pistachio
[kdview]: ./kdview.md
