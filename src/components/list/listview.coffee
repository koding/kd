KDView        = require './../../core/view'
KDListViewBox = require './listviewbox'

module.exports = class KDListView extends KDView

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


  empty: ->

    item.destroy()  for item, i in @items when item

    @items = []


  keyDown: (event) ->

    KD.utils.stopDOMEvent event
    @emit "KeyDownOnList", event


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


  removeItemByData: (itemData) -> @removeItem null, itemData


  removeItemByIndex: (index) -> @removeItem null, null, index


  destroy: ->

    item.destroy() for item in @items

    super


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


  appendItem: (itemInstance) -> @insertItemAtIndex itemInstance


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




  getItemIndex: (targetItem) -> @items.indexOf item


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


  doIHaveToScroll: ->

    if @getOptions().autoScroll
      scrollView = @$().closest(".kdscrollview")[0]
      if scrollView.length and scrollView.scrollHeight > scrollView.outerHeight()
      then yes
      else @isScrollAtBottom scrollView
    else no

  isScrollAtBottom: (scrollView) ->

    slidingView       = scrollView.find('> .kdview')[0]

    scrollTop         = scrollView.scrollTop
    slidingHeight     = slidingView.clientHeight
    scrollViewheight  = scrollView.clientHeight

    return slidingHeight - scrollViewheight is scrollTop

