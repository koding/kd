debug = require('debug') 'kd:list:listviewcontroller'
KD = require '../../core/kd'
KDView             = require '../../core/view'
KDViewController   = require '../../core/viewcontroller'
KDCustomHTMLView   = require '../../core/customhtmlview'
KDScrollView       = require '../scrollview/scrollview'
KDCustomScrollView = require '../scrollview/customscrollview'
KDListView         = require '../list/listview'
KDLoaderView       = require '../loader/loaderview'

module.exports = class KDListViewController extends KDViewController

  constructor:(options = {}, data)->

    options.wrapper                ?= yes
    options.scrollView             ?= yes
    options.keyNav                 ?= no
    options.multipleSelection      ?= no
    options.selection              ?= no
    options.startWithLazyLoader    ?= no
    options.itemChildClass        or= null
    options.itemChildOptions      or= {}
    options.useCustomScrollView    ?= no
    # rename these options
    options.noItemFoundWidget     or= null
    options.noMoreItemFoundWidget or= null
    options.lastToFirst            ?= no

    Object.defineProperty this, "itemsOrdered", get : =>
      debug 'itemsOrdered is deprecated'
      @getListItems()

    @itemsIndexed                 = {}
    @selectedItems                = []
    @lazyLoader                   = null

    if options.view
      @setListView listView = options.view
    else
      viewOptions                    = options.viewOptions or {}
      viewOptions.lastToFirst      or= options.lastToFirst
      viewOptions.itemClass        or= options.itemClass
      viewOptions.itemOptions      or= options.itemOptions
      viewOptions.itemChildClass   or= options.itemChildClass
      viewOptions.itemChildOptions or= options.itemChildOptions
      viewOptions.boxed             ?= options.boxed
      viewOptions.itemsPerBox       ?= options.itemsPerBox

      @setListView listView = new KDListView viewOptions

    if options.scrollView
      if options.useCustomScrollView
        @customScrollView = new KDCustomScrollView
          lazyLoadThreshold : options.lazyLoadThreshold
        @scrollView = @customScrollView.wrapper
      else
        @scrollView = new KDScrollView
          lazyLoadThreshold : options.lazyLoadThreshold

    options.view = if options.wrapper
    then new KDView cssClass : "listview-wrapper"
    else listView

    super options, data

    {noItemFoundWidget} = @getOptions()

    listView.on 'ItemWasAdded', (view, index) =>

      @registerItem view, index
      @hideNoItemWidget()  if noItemFoundWidget


    listView.on 'ItemWasRemoved', (view, index) =>

      @unregisterItem view, index
      @showNoItemWidget()  if noItemFoundWidget

    if options.keyNav
      listView.on 'KeyDownOnList', (event) => @keyDownPerformed listView, event


  loadView: (mainView) ->

    { scrollView
      startWithLazyLoader
      noItemFoundWidget
    } = @getOptions()

    windowController = KD.getSingleton 'windowController'

    if scrollView
      mainView.addSubView @customScrollView or @scrollView
      @scrollView.addSubView @getListView()
      @scrollView.on 'LazyLoadThresholdReached', @bound "showLazyLoader"

    @showLazyLoader no  if startWithLazyLoader
    @putNoItemView()    if noItemFoundWidget

    @instantiateListItems @getData()?.items or []

    windowController.on "ReceivedMouseUpElsewhere", @bound 'mouseUpHappened'


  instantiateListItems: (items) ->

    newItems = (@addItem itemData for itemData in items)

    @emit 'AllItemsAddedToList'

    return newItems

  ###
  HELPERS
  ###

  # get the index depending on the
  # conditions. e.g `options.lastToFirst`
  # This method can be overriden by subclasses
  # to change the item order and get necessary index.
  getIndex: (index) ->
    return if @getOptions().lastToFirst
    then @getItemCount() - index - 1
    else index

  itemForId: (id) -> @itemsIndexed[id]

  getItemsOrdered: -> @itemsOrdered

  getListItems: -> @getListView().items

  getItemCount: -> @getListItems().length

  setListView: (listView) -> @listView = listView

  getListView: -> @listView

  forEachItemByIndex: (ids, callback) ->
    [callback, ids] = [ids, callback]  unless callback
    ids = [ids]  unless Array.isArray ids
    ids.forEach (id)=>
      item = @itemsIndexed[id]
      callback item  if item?

  putNoItemView:->
    {noItemFoundWidget} = @getOptions()
    @getListView().addSubView @noItemView = noItemFoundWidget

  showNoItemWidget:->
    if @getListItems().length is 0
      @emit 'ListIsEmptied'
      @noItemView?.show()

  hideNoItemWidget:->
    @noItemView?.hide()
    @emit 'ListIsNoMoreEmpty'

  # regressed, will put back whenever i'm here again. - SY
  showNoMoreItemWidget:->
    {noMoreItemFoundWidget} = @getOptions()
    @scrollView.addSubView noMoreItemFoundWidget  if noMoreItemFoundWidget


  ###
  ITEM OPERATIONS
  ###

  addItem: (itemData, index) ->

    return unless itemData or index?

    @getListView().addItem itemData, index


  removeItem: (itemInstance, itemData, index) ->
    return unless itemInstance or itemData or index?

    @getListView().removeItem itemInstance, itemData, index


  registerItem: (itemInstance, index) ->

    if itemInstance.getItemDataId()?
      id = itemInstance.getItemDataId()
      @itemsIndexed[id] = itemInstance

    {selection, keyNav, multipleSelection} = @getOptions()

    if selection
      itemInstance.on 'click', (event)=> @selectItem itemInstance, event

    if keyNav or multipleSelection
      itemInstance.on 'mousedown',  (event) => @mouseDownHappenedOnItem itemInstance, event
      itemInstance.on 'mouseenter', (event) => @mouseEnterHappenedOnItem itemInstance, event

  unregisterItem: (itemInstance, index) ->

    @emit 'UnregisteringItem', itemInstance, index

    if itemInstance.getData()?
      delete @itemsIndexed[itemInstance.getItemDataId()]

  replaceAllItems: (items) ->

    @removeAllItems()
    @instantiateListItems items

  removeAllItems: ->
    @itemsIndexed = {}

    listView = @getListView()
    listView.empty() if listView.items.length

    return @getListItems()

  moveItemToIndex: (item, newIndex) ->

    newIndex = Math.max(0, Math.min(@getListItems().length-1, newIndex))
    @getListView().moveItemToIndex(item, newIndex).slice()

  ###
  HANDLING MOUSE EVENTS
  ###

  mouseDownHappenedOnItem: (item, event) ->
    KD.getSingleton("windowController").setKeyView @getListView() if @getOptions().keyNav

    @lastEvent = event
    unless item in @selectedItems
      @mouseDown = yes
      @mouseDownTempItem = item
      @mouseDownTimer = setTimeout =>
        @mouseDown = no
        @mouseDownTempItem = null
        @selectItem item, event
      , 300

    else
      @mouseDown = no
      @mouseDownTempItem = null

  mouseUpHappened: (event) ->

    clearTimeout @mouseDownTimer
    @mouseDown = no
    @mouseDownTempItem = null

  mouseEnterHappenedOnItem: (item, event) ->

    clearTimeout @mouseDownTimer
    if @mouseDown
      @deselectAllItems() unless event.metaKey or event.ctrlKey or event.shiftKey
      @selectItemsByRange @mouseDownTempItem,item
    else
      @emit "MouseEnterHappenedOnItem", item

  ###
  HANDLING KEY EVENTS
  ###

  keyDownPerformed: (mainView, event) ->

    switch event.which
      when 40, 38
        @selectItemBelowOrAbove event
        @emit "KeyDownOnListHandled", @selectedItems

  ###
  ITEM SELECTION
  ###

  # bad naming because of backwards compatibility i didn't
  # change the method name during refactoring - Sinan 10 May 2012
  selectItem: (item, event = {}) ->

    return unless item?

    @lastEvent = event

    {selectable}                 = item.getOptions()
    {multipleSelection}          = @getOptions()
    {metaKey, ctrlKey, shiftKey} = event

    # we lost two developers on these two lines below do not CHANGE
    # or ask one of those two, namely Gokmen or Sinan
    @deselectAllItems()  if not multipleSelection
    @deselectAllItems()  if selectable and not(metaKey or ctrlKey or shiftKey)

    if event.shiftKey and @selectedItems.length > 0
      @selectItemsByRange @selectedItems[0], item
    else
      unless item in @selectedItems
        @selectSingleItem item
      else
        @deselectSingleItem item

    return @selectedItems

  selectItemBelowOrAbove: (event) ->

    direction         = if event.which is 40 then "down" else "up"
    addend            = if event.which is 40 then 1 else -1

    items = @getListItems()

    selectedIndex     = items.indexOf @selectedItems[0]
    lastSelectedIndex = items.indexOf @selectedItems[@selectedItems.length - 1]

    if items[selectedIndex + addend]
      unless event.metaKey or event.ctrlKey or event.shiftKey
        # navigate normally if meta key is NOT pressed
        @selectItem items[selectedIndex + addend]
      else
        # take extra actions if meta key is pressed
        if @selectedItems.indexOf(items[lastSelectedIndex + addend]) isnt -1
          # to be deselected item is in @selectedItems
          if items[lastSelectedIndex]
            @deselectSingleItem items[lastSelectedIndex]
        else
          # to be deselected item is NOT in @selectedItems
          if items[lastSelectedIndex + addend ]
            @selectSingleItem items[lastSelectedIndex + addend ]

  selectNextItem:(item, event)->

    items = @getListItems()

    [item] = @selectedItems unless item
    selectedIndex = items.indexOf item
    @selectItem items[selectedIndex + 1]

  selectPrevItem:(item, event)->

    items = @getListItems()

    [item] = @selectedItems unless item
    selectedIndex = items.indexOf item
    @selectItem items[selectedIndex + -1]


  deselectAllItems:->
    for selectedItem in @selectedItems
      selectedItem.removeHighlight()
      deselectedItems = @selectedItems.concat []
      @selectedItems = []
      @getListView().unsetClass "last-item-selected"
      @itemDeselectionPerformed deselectedItems

  deselectSingleItem:(item)->
    item.removeHighlight()

    items = @getListItems()

    @selectedItems.splice @selectedItems.indexOf(item), 1
    if item is items[items.length-1]
      @getListView().unsetClass "last-item-selected"
    @itemDeselectionPerformed [item]

  selectSingleItem:(item)->

    items = @getListItems()

    if item.getOption("selectable") and !(item in @selectedItems)
      item.highlight()
      @selectedItems.push item
      if item is items[items.length-1]
        @getListView().setClass "last-item-selected"
      @itemSelectionPerformed()

  selectAllItems:->

    @selectSingleItem item for item in @getListItems()


  selectItemsByRange:(item1, item2)->

    items = @getListItems()

    indicesToBeSliced = [items.indexOf(item1), items.indexOf(item2)]
    indicesToBeSliced.sort (a, b)-> a - b
    itemsToBeSelected = items.slice indicesToBeSliced[0], indicesToBeSliced[1] + 1
    @selectSingleItem item for item in itemsToBeSelected
    @itemSelectionPerformed()

  itemSelectionPerformed:->

    @emit "ItemSelectionPerformed", @, (event : @lastEvent, items : @selectedItems)

  itemDeselectionPerformed:(deselectedItems)->

    @emit "ItemDeselectionPerformed", @, (event : @lastEvent, items : deselectedItems)

  ###
  LAZY LOADER
  ###

  createLazyLoader: ->

    {lazyLoaderOptions} = @getOptions()

    lazyLoaderOptions                or= {}
    lazyLoaderOptions.itemClass      or= KDCustomHTMLView
    lazyLoaderOptions.partial         ?= ''
    lazyLoaderOptions.cssClass         = KD.utils.curry 'lazy-loader', lazyLoaderOptions.cssClass
    lazyLoaderOptions.spinnerOptions or= size : width : 32
    {itemClass, spinnerOptions}        = lazyLoaderOptions
    delete lazyLoaderOptions.itemClass

    wrapper = @scrollView or @getView()
    wrapper.addSubView @lazyLoader = new itemClass lazyLoaderOptions
    @lazyLoader.addSubView @lazyLoader.spinner = new KDLoaderView spinnerOptions


  showLazyLoader:(emitWhenReached = yes)->

    @hideNoItemWidget()  if @noItemView and @getOptions().noItemFoundWidget

    @createLazyLoader()  unless @lazyLoader

    @lazyLoader.show()
    @lazyLoader.spinner.show()
    @emit 'LazyLoadThresholdReached'  if emitWhenReached


  hideLazyLoader:->

    return  unless @lazyLoader

    @showNoItemWidget() if @noItemView and @getOptions().noItemFoundWidget

    @lazyLoader.spinner.hide()
    @lazyLoader.hide()
