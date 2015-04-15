debug = require('debug') 'kd:list:listview'
KD = require '../../core/kd'
KDListItemView = require './listitemview'
KDView        = require '../../core/view'
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

    # if @getOptions().boxed
    #   @on 'viewAppended', =>
    #     @parent.on 'scroll', @bound 'handleScroll'


  empty: ->

    item.destroy()  for item, i in @items when item

    @items = []


  keyDown: (event) ->

    KD.utils.stopDOMEvent event
    @emit "KeyDownOnList", event


  sanitizeIndex: (index) ->

    {lastToFirst} = @getOptions()
    {length}      = @items

    if lastToFirst
      index ?= 0
      sanitizedIndex = Math.max 0, length - index - 1
    else
      index ?= length
      sanitizedIndex = Math.min length, index

    return sanitizedIndex


  addItemView: (itemInstance, index) ->

    index = @sanitizeIndex index

    @insertItemAtIndex itemInstance, index

    return itemInstance


  addItem: (itemData, index) ->

    index = @sanitizeIndex index

    {itemOptions, itemClass, itemChildClass, itemChildOptions} = @getOptions()

    itemClass   ?= KDListItemView
    itemOptions ?= {}
    itemOptions  = @customizeItemOptions?(itemOptions, itemData) or itemOptions

    itemOptions.delegate     or= this
    itemOptions.childClass   or= itemChildClass
    itemOptions.childOptions or= itemChildOptions

    itemInstance = new itemClass itemOptions, itemData

    @insertItemAtIndex itemInstance, index

    return itemInstance


  removeItem: (item) ->

    index = @items.indexOf item

    return no if index < 0

    @emit 'ItemWasRemoved', item, index
    item.destroy()
    @items.splice index, 1

    return yes


  destroy: ->

    item.destroy() for item in @items

    super


  insertItemAtIndex: (item, index) ->

    {boxed, lastToFirst} = @getOptions()


    endIndex = @items.length - 1
    isLastIndex  = index > endIndex
    isFirstIndex = index is 0
    isInBetween  = 0 < index <= endIndex

    if isFirstIndex      then @items.unshift item
    else if isLastIndex  then @items.push item
    else @items.splice index, 0, item

    @emit 'ItemWasAdded', item, index

    addNeighborItem = (item, index) =>
      element      = item.getElement()
      neighborIndex = if @items.length - 1 is index then index else index + 1
      neighborItem = @items[neighborIndex].getElement()
      neighborItem.parentNode.insertBefore element, neighborItem
      item.emit 'viewAppended'  if @parentIsInDom

    unless boxed

      if isFirstIndex     then @addSubView item, null, yes
      else if isLastIndex then @addSubView item
      else addNeighborItem item, index

    else

      {itemsPerBox} = @getOptions()

      if @boxes.length is 0

        box = @createBox()
        box.addSubView item

      else if isFirstIndex or isLastIndex

        box   = null
        which = if isFirstIndex then 'first' else 'last'

        if @boxes[which].getItems().length >= itemsPerBox
        then box = @createBox isFirstIndex
        else box = @boxes[which]

        box.addSubView item, null, isFirstIndex

      else if isInBetween

        addNeighborItem item, index

    @scrollDown()  if @doIHaveToScroll()


  packageItem: (itemInstance, prepend) ->

    {itemsPerBox, lastToFirst} = @getOptions()

    newBox = =>
      box = @createBox prepend
      box.addSubView itemInstance

    potentialBox = if prepend then @boxes.first else @boxes.last

    return newBox()  unless potentialBox

    items = potentialBox.getItems()

    if items.length < itemsPerBox
    then potentialBox.addSubView itemInstance, null, lastToFirst
    else newBox()


  createBox: (prepend) ->

    box = new KDListViewBox
    if prepend then @boxes.unshift box else @boxes.push box

    @addSubView box, null, prepend

    box.on 'BoxIsEmptied', (id) =>
      # TODO: use indexOf here
      index = null
      for _box, i in @boxes when _box.getId() is id
        index = i
        break
      @boxes.splice(index, 1)[0].destroy()  if index?

    return box


  # handle vertical and horizontal scrolls separately - SY
  handleScroll:->


  getItemIndex: (item) -> @items.indexOf item


  moveItemToIndex: (item, newIndex) ->

    currentIndex = @getItemIndex item
    if currentIndex < 0
      debug "missing item", item
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

