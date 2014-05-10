
# Real World KDApp

In our previous example, we took some shortcuts to simplify the application. As 
a result of these shortcuts, our application would be unable to be deployed.  

So, in an effort to actually have our application be useful, lets roll up our 
sleeves and make a deployable application!

## Create it on DevTools

Rather than copy code from this tutorial and paste it into DevTools, we're 
going to simply have it create one for us.

So, open up [DevTools][0] and press the **Create New** button in the center of 
the app. If you already have a file open, you'll have to go to the DevTools 
menu in the upper right and choose **Create a new App**.

Choose whatever name for your app you like, and press Create. In this tutorial, 
the app is named "Example".

## Examine our new App

If we look into our newly created `~/Applications/Example.kdapp` folder, we can 
see that DevTools created a handful of files. Two of which are quite familiar, 
`index.coffee` and `manifest.json`.

We're going to ignore the Manifest file for the moment, but we'll cover that 
soon. Lets take a look at our friendly `index.coffee` file.

```coffee
class ExampleMainView extends KDView

  constructor:(options = {}, data)->
    options.cssClass = 'example main-view'
    super options, data

  viewAppended:->
    @addSubView new KDView
      partial  : "Welcome to Example app!"
      cssClass : "welcome-view"

class ExampleController extends AppController

  constructor:(options = {}, data)->
    options.view    = new ExampleMainView
    options.appInfo =
      name : "Example"
      type : "application"

    super options, data

do ->

  # In live mode you can add your App view to window's appView
  if appView?

    view = new ExampleMainView
    appView.addSubView view

  else

    KD.registerAppClass ExampleController,
      name     : "Example"
      routes   :
        "/:name?/Example" : null
        "/:name?/leeolayvar/Apps/Example" : null
      dockPath : "/leeolayvar/Apps/Example"
      behavior : "application"
```

Whoa! This one is quite a bit longer, but we can still see some familiar spots.  
Lets break it down, piece by piece.

### ExampleMainView

First up, our friendly neighborhood `ExampleMainView`.

```coffee
class ExampleMainView extends KDView

  constructor:(options = {}, data)->
    options.cssClass = 'example main-view'
    super options, data

  viewAppended:->
    @addSubView new KDView
      partial  : "Welcome to Example app!"
      cssClass : "welcome-view"
```

Just like our `HelloWorld` view from the last tutorial, this is a Koding View.  
However, unlike our `HelloWorld` this view extends `KDView` directly.

This means that it does not have a `JView.prototype.pistachio` method, and to 
actually render views to the DOM we need to do it another way, via the 
`KDView.prototype.viewAppended` method.

When our View is added to another view, such as `appView`, our `viewAppended()` 
method is called. This event is a good place to add our views with the 
`KDView.prototype.addSubView` method.

The KDView itself will be rendered to a generic `div` element, with the partial 
*(contents)* of `"Welcome to Example app!"`, and a cssClass of `welcome-view`.

### ExampleController

```coffee
class ExampleController extends AppController

  constructor:(options = {}, data)->
    options.view    = new ExampleMainView
    options.appInfo =
      name : "Example"
      type : "application"

    super options, data
```

### appView and KD.registerAppClass

```coffee
if appView?

  view = new ExampleMainView
  appView.addSubView view

else

  KD.registerAppClass ExampleController,
    name     : "Example"
    routes   :
      "/:name?/Example" : null
      "/:name?/leeolayvar/Apps/Example" : null
    dockPath : "/leeolayvar/Apps/Example"
    behavior : "application"
```


 

[0]: https://koding.com/DevTools
