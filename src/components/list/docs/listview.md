
# KDListView

KDListView is a View that implements a List. By default, this List is not a 
`<ul>` or `<ol>`, but rather a series of nested `<divs>`. KDListView takes care 
of the ordering and arrangement.

## Usage

Like any other view, we create the instance and add it to another view. In this 
case, `appView`. The key here is that after adding our ListView, we have to add 
items to our list. We do this with the [addItemView](#additemview) method. Lets 
see what that looks like.

```coffee
view = new KDListView()

view.addItemView new KDView partial: 'Item 1'
view.addItemView (new KDView partial: 'Item 0'), 0

appView.addSubView header
```

Pretty simple eh? We just called the `addItemView` method and gave it an 
instance of a [KDView][kdview].

Additionally, to demonstrate the index adding, we added the `"Item 0"` view 
second, with an index of `0`.

## API Index

> class KDListView extends [KDView][kdview]
> - [constructor](#constructor): (options={}, data) ->

## [Class](https://github.com/koding/kd/blob/master/src/components/list/listview.coffee#L3)

KDListView extends [KDView][kdview]. Please see that for inherited methods.





[kdview]: ./kdview.md
