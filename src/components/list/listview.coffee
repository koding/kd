KDView        = require './../../core/view'
KDListViewBox = require './listviewbox'
###*
* # KDListView
*
* KDListView is a View that implements a List. By default, this List is not a 
* `<ul>` or `<ol>`, but rather a series of nested `<divs>`. KDListView takes care 
* of the ordering and arrangement.
*
* ## Usage
*
* Like any other view, we create the instance and add it to another view. In this 
* case, `appView`. The key here is that after adding our ListView, we have to add 
* items to our list. We do this with the [addItemView](#additemview) method. Lets 
* see what that looks like.
*
* ```coffee
* view = new KDListView()
*
* view.addItemView new KDView partial: 'Item 1'
* view.addItemView (new KDView partial: 'Item 0'), 0
*
* appView.addSubView header
* ```
*
* Pretty simple eh? We just called the `addItemView` method and gave it an 
* instance of a [KDView][kdview].
*
* Additionally, to demonstrate the index adding, we added the `"Item 0"` view 
* second, with an index of `0`.
*
* ## Boxes
*
* Boxes are a new concept in lists. Boxes allow you to conveniently group elements of the list into groups. By setting a list as `boxed` you will make the it automatically arrange elements into boxes on append or prepend. Let's start by creating a boxed list
*
* ```coffee
* view = new KDListView
*  boxed: true        #Make list boxed
*  itemsPerBox: 3     #The list will automatically create a new box for every 3 elements
* ```
###
module.exports = class KDListView extends KDView
  ###*
  * The following keys are supported.
  *
  * - **options.type**: The type of list.
  *   - Type: string
  *   - Default: `"default"`
  * - **options.lastToFist**: Whether to append elements when added or prepend them
  *   - Type: boolean
  *   - Default: `false`
  * - **options.itemOptions**: Options to be transfered to child views in the list
  *   - Type: object
  *   - Default: `{}`
  * - **options.itemChildClass**: The class which the created child views will be when using [addItem](#addItem) (Must subclass KDView)
  *   - Type: object
  *   - Default: `KDListItemView`
  * - **options.autoScroll**: Whether the list should automatically scroll if overflow is present
  *   - Type: boolean
  *   - Default: `undefined`
  * - **options.boxed**: Whether the list should use boxes for grouping elements
  *   - Type: boolean
  *   - Default: `false`
  * - **options.itemsPerBox**: Amount of items put in each box
  *   - Type: number
  *   - Default: `10`
  * @param {Object} options
  * @param {Object} data
  ###
  constructor: (options = {}, data) ->

    options.type        or= "default"
    options.lastToFirst  ?= no
    options.boxed        ?= no
    options.itemsPerBox  ?= 10
    options.cssClass      = if options.cssClass? then "kdlistview kdlistview-#{options.type} #{options.cssClass}" else "kdlistview kdlistview-#{options.type}"

    super options, data

    @items = []
    @boxes = []

    if @getOptions().boxed
      @on 'viewAppended', =>
        @parent.on 'scroll', @bound 'handleScroll'

  ###*
  * Clears the list of all its content
  ###
  empty: ->

    item.destroy()  for item, i in @items when item

    @items = []

  ###*
  * Function that is called whenever a key is pressed
  * @param {Object} event The object containing data about the event
  ###
  keyDown: (event) ->

    KD.utils.stopDOMEvent event
    @emit "KeyDownOnList", event

  ###*
  * Creates and adds a view based on the itemData passed with the default itemOptions specified. Emits `"ItemWasAdded"` with the created view and the index as parameters
  * @param {Object} itemData Data passed as the `data` parameter to the constructor of the view
  * @param {Number} The index at which the item object should be added. Note that for backwards compatibilty if the parameter is not set to a number it will be used as optinos for the item.
  ###
  addItem: (itemData, index) ->

    {itemChildClass, itemChildOptions} = @getOptions()

    if index? and 'number' isnt typeof index
      itemOptions = index
      index       = null
    else
      {itemOptions} = @getOptions()

    itemOptions = @customizeItemOptions?(itemOptions, itemData) or \
                  itemOptions or {}

    itemOptions.delegate     or= this
    itemOptions.childClass   or= itemChildClass
    itemOptions.childOptions or= itemChildOptions

    itemInstance = new (@getOptions().itemClass ? KDListItemView) itemOptions, itemData
    @addItemView itemInstance, index

    return itemInstance

  ###*
  * First attempts to remove a view by its index. If the index is not found, will attempt to remove the view by its instance and itemData in that order. Emits `"ItemWasRemoved"`
  * @param (Object) itemInstance The instace of the view you are trying to remove from the list
  * @param {Object} itemData The item data by which you are attempting to remove from the list
  * @param {Object} index The index by which you are attempting to remove fromt the list
  ###
  removeItem: (itemInstance, itemData, index) ->
    destroy = (item, i) =>
      @emit 'ItemWasRemoved', item, i
      item.destroy()
      @items.splice i, 1
      return yes

    if index
      return no  unless @items[index]
      return destroy @items[index], index

    {dataPath} = @getOptions()

    for item, i in @items
      if itemInstance
        if itemInstance.getId() is @items[i].getId()
          return destroy @items[i], i
      else if itemData
        if itemData[dataPath] and @items[i].getData()[dataPath] and itemData[dataPath] is @items[i].getData()[dataPath]
          return destroy @items[i], i

  ###*
  * Attempts to remove a view by its `itemData`. Emits `"ItemWasRemoved"`
  * @param {Object} itemData The item data by which you are attempting to remove from the list
  ###
  removeItemByData: (itemData) -> @removeItem null, itemData

  ###*
  * Attempts to remove a view by its index. Emits `"ItemWasRemoved"`
  * @param {Number} index The index by which you are attempting to remove fromt the list
  ###
  removeItemByIndex: (index) -> @removeItem null, null, index

  ###*
  * Destroys the view and all its children
  ###
  destroy: ->

    item.destroy() for item in @items

    super

  ###*
  * Adds an already created view to the list. The default options will not be passed and the class will not be set. Emits `"ItemWasAdded"` with the created view and the index as parameters
  * @param {Object} itemInstance The instance of the view that you would like to add
  * @param {Number} The index at which the item object should be added.
  ###
  addItemView: (itemInstance, index) ->

    {lastToFirst} = @getOptions()

    unless index?
      if lastToFirst
      then @items.unshift itemInstance
      else @items.push itemInstance

      index = if lastToFirst then 0 else @items.length - 1
    else

      @items.splice index, 0, itemInstance


    @emit 'ItemWasAdded', itemInstance, index
    @insertItemAtIndex itemInstance, index

    return itemInstance

  ###*
  * Appends item to the end of the list
  * @param {Object} itemInstance The instance of the view that you would like to append
  ###
  appendItem: (itemInstance) -> @insertItemAtIndex itemInstance

  ###*
  * Insert an already created view at a certain index the list. The default options will not be passed and the class will not be set. Emits `"ItemWasAdded"` with the created view and the index as parameters
  * @param {Object} itemInstance The instance of the view that you would like to insert
  * @param {Object} index The index at which the item object should be inserted
  ###
  insertItemAtIndex: (itemInstance, index) ->

    {boxed, lastToFirst} = @getOptions()

    if index <= 0
      index = if boxed and lastToFirst then undefined else 0

    if index >= @items.length - 1
      index = if boxed and not lastToFirst then undefined else @items.length - 1

    if boxed and not index?
      @packageItem itemInstance
    else
      shouldBeLastItem = index >= @items.length - 1
      item             = itemInstance.getElement()

      unless shouldBeLastItem
        neighborItem = @items[index + 1].getElement()
        neighborItem.parentNode.insertBefore item, neighborItem
        itemInstance.emit 'viewAppended'  if @parentIsInDom
      else
        @addSubView itemInstance, null

    @scrollDown()  if @doIHaveToScroll()

  ###*
  * Packages an item into a suitable box. Will not work if `boxed` is set to `false`
  * @param {Object} itemInstance The instance of the view that you would like to package
  ###
  packageItem: (itemInstance) ->

    {
      lastToFirst
      itemsPerBox
    } = @getOptions()

    operation = if lastToFirst then 'prepend' else 'append'

    newBox = =>
      box = @createBox()
      box.addSubView itemInstance

    if @boxes.last
      items = @boxes.last.subViews.filter (item)-> item instanceof KDListItemView
      if items.length < itemsPerBox
      then @boxes.last.addSubView itemInstance, null, lastToFirst
      else newBox()
    else newBox()

  ###*
  # Creates and returns a new box
  ###
  createBox: ->

    @boxes.push box = new KDListViewBox
    @addSubView box, null, @getOptions().lastToFirst
    box.on 'HeightChanged', (height) => @updateBoxProps box, height
    box.on 'BoxIsEmptied', (id)=>

      index = null
      for b, i in @boxes when b.getId() is id
        index = i
        break
      @boxes.splice(index, 1)[0].destroy()  if index?


    return box


  updateBoxProps: (box, height) ->

    # log @boxes.indexOf(box), height

  # handle vertical and horizontal scrolls separately - SY
  handleScroll:->

    # log box.size for box in @boxes
    # log @parent.fractionOfHeightBelowFold view : @boxes.first

    # log 'scrollaki'
    # log @boxes



  ###*
  * Packages an item into a suitable box. Will not work if `boxed` is set to `false`
  * @param {Object} targetItem The instance of the item that you would like to get the index of
  ###
  getItemIndex: (targetItem) ->
    for item, index in @items
      return index if item is targetItem
    return -1

  ###*
  * Move an item from one index in the list to another
  * @param item The instance of the view that you would like to move
  * @param newIndex The index to which you would like to move to
  ###
  moveItemToIndex: (item, newIndex) ->

    currentIndex = @getItemIndex item
    if currentIndex < 0
      warn "Item doesn't exists", item
      return @items

    newIndex = Math.max(0, Math.min(@items.length-1, newIndex))

    if newIndex >= @items.length-1
      targetItem = @items.last
      targetItem.$().after item.$()
    else
      diff = if newIndex > currentIndex then 1 else 0
      targetItem = @items[newIndex+diff]
      targetItem.$().before item.$()

    @items.splice(currentIndex, 1)
    @items.splice(newIndex, 0, item)

    return @items

  ###*
  * 
  ###
  scrollDown: ->

    clearTimeout @_scrollDownTimeout

    @_scrollDownTimeout = KD.utils.wait 50, =>
      scrollView    = @$().closest(".kdscrollview")
      slidingView   = scrollView.find '> .kdview'
      slidingHeight = slidingView.height()

      scrollView.animate
        scrollTop : slidingHeight
      ,
        duration  : 200
        queue     : no

  ###*
  * Returns a boolean of whether the scrollView containing this list has to scroll to reveal more content. Will always return `false` if autoScroll is set to `false`
  ###
  doIHaveToScroll: ->

    if @getOptions().autoScroll
      scrollView = @$().closest(".kdscrollview")[0]
      if scrollView.length and scrollView.scrollHeight > scrollView.outerHeight()
      then yes
      else @isScrollAtBottom scrollView
    else no
  ###*
  * Returns a boolean of whether the scroll is at the bottom of the list
  ###
  isScrollAtBottom: (scrollView) ->

    slidingView       = scrollView.find('> .kdview')[0]

    scrollTop         = scrollView.scrollTop
    slidingHeight     = slidingView.clientHeight
    scrollViewheight  = scrollView.clientHeight

    return slidingHeight - scrollViewheight is scrollTop

