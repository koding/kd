
# KDListItemView

KDListItemView is primarily a default class, used by 
[KDListView](./kdlistview.md) and 
[KDListViewController](./kdlistviewcontroller.md) as the default view to be 
added.

It comes with a method that provides the default partial, meaning that if you 
choose to inherit from this class you should implement your own `partial` 
method returning a string you'd like to use.

## Usage

```coffee
class CustomListItem extends KDListItemView
  partial: -> 'This is my custom list item'

view = new KDListView()
view.addItemView new CustomListItem()

appView.addSubView header
```

As you can see, we implemented a class `CustomListView` that extended the 
`partial` method and returned a string that we wanted to use.

## API Index

> class KDListItemView extends [KDView][kdview]

KDListItemView extends [KDView](./kdview.md). Please see that for inherited 
methods.
