{assert, expect}     = require 'chai'
sinon                = require 'sinon'
KDListViewController = require '../../../src/components/list/listviewcontroller.coffee'
KDListView           = require '../../../src/components/list/listview.coffee'
KDListItemView       = require '../../../src/components/list/listitemview.coffee'
KDView               = require '../../../src/core/view.coffee'

describe 'KDListViewController', ->

  beforeEach -> @sinon = sinon.sandbox.create()
  afterEach  -> @sinon.restore()

  describe 'constructor', ->

    it 'should instantiate without error', ->
      viewController = new KDListViewController
      assert.isDefined viewController

    context 'when there is a listview', ->

      it 'should set listview', ->
        listViewStub = sinon.createStubInstance KDListView
        viewController = new KDListViewController { view: listViewStub }

        assert.equal viewController.listView, listViewStub

    context 'when scrollview is off', ->

      it "shouldn't have scrollView if there is a scrollview option as false", ->
        viewController = new KDListViewController { scrollView: off }
        assert.isUndefined viewController.scrollView

    context 'when scrollview is on', ->

      context 'if customScrollView wanted', ->

        it 'has customScrollView', ->
          viewController = new KDListViewController { scrollView: on, useCustomScrollView: on }
          assert.isDefined viewController.customScrollView

      context 'if customScrollView not wanted', ->

        it "it doesn't have customScrollView", ->
          viewController = new KDListViewController { scrollView: on, useCustomScrollView: off }
          assert.isUndefined viewController.customScrollView

    context 'when wrapper is on', ->

      it "has wrapper (= mainView) view as KDView", ->
        viewController = new KDListViewController { wrapper: on }
        assert.instanceOf viewController.mainView, KDView

    context 'when wrapper is off', ->

      it "has a mainview as KDListView", ->
        viewController = new KDListViewController { wrapper: off }
        assert.instanceOf viewController.mainView, KDListView

    context 'when there is keyNav', ->

      it "has a 'KeyDownOnList' listener", ->
        viewController = new KDListViewController { keyNav: yes }
        assert.isDefined viewController._e, 'KeyDownOnList'


  describe 'loadView', ->

    context 'when scrollView wanted', ->

      it 'has a scrollView', ->
        viewController = new KDListViewController { scrollView: on }
        assert.isDefined viewController.scrollView

      context 'when customScrollView wanted', ->

        it 'has a customScrollView', ->
          viewController = new KDListViewController { scrollView: on, useCustomScrollView: yes }
          assert.isDefined viewController.customScrollView

    context "when scrollView doesn't wanted", ->
      viewController = new KDListViewController { scrollView: off }
      assert.isUndefined viewController.scrollView

    context 'when it starts with lazyLoader', ->

      it 'shows lazy loader', ->
        viewController = new KDListViewController
          scrollView          : off
          startWithLazyLoader : yes

        sinon.spy viewController, 'showLazyLoader'

        viewController.loadView()

        assert viewController.showLazyLoader.calledOnce

    context 'when there is noItemFoundWidget', ->

      it 'shows no item view', ->
        viewController = new KDListViewController
          scrollView          : off
          noItemFoundWidget   : new KDView

        sinon.spy viewController, 'putNoItemView'

        viewController.loadView()

        assert viewController.putNoItemView.calledOnce

   it "instantiates list items", ->
      viewController = new KDListViewController
        scrollView          : off
        noItemFoundWidget   : new KDView

      sinon.spy viewController, 'instantiateListItems'

      viewController.loadView()

      assert viewController.instantiateListItems.calledOnce


  describe 'instantiateListItems', ->

    it "should call listview's addItem method", ->
      listViewStub = sinon.createStubInstance KDListView
      viewController = new KDListViewController { view: listViewStub }

      items = [1, 2]
      listViewStub.addItem = (item) -> item * 2
      result = viewController.instantiateListItems items

      assert.deepEqual result, [2, 4]

    context 'when it instantiates new items', ->

      it "emits 'AllItemsAddedToList'", ->
        listViewStub = sinon.createStubInstance KDListView

        viewController = new KDListViewController { view: listViewStub }

        sinon.spy(viewController, 'emit')
        listViewStub.addItem = (item) -> item * 2
        viewController.instantiateListItems [1, 2]

        assert viewController.emit.calledWith 'AllItemsAddedToList'


  describe 'putNoItemView', ->

    it 'adds noItemFoundWidget', ->
      listViewStub = sinon.createStubInstance KDListView
      widget = sinon.stub()
      viewController = new KDListViewController
        view              : listViewStub
        noItemFoundWidget : widget

      viewController.putNoItemView()

      assert listViewStub.addSubView.withArgs(widget).calledOnce

  describe 'addItem', ->

    it "adds item to its list view", ->
      listViewStub = sinon.createStubInstance KDListView
      viewController = new KDListViewController { view: listViewStub }

      viewController.addItem 1, 2

      assert listViewStub.addItem.withArgs(1, 2).calledOnce

    context 'when there is no args', ->

      it "doesn't add item to its list view", ->
        listViewStub = sinon.createStubInstance KDListView
        viewController = new KDListViewController { view: listViewStub }

        viewController.addItem

        assert.notOk listViewStub.addItem.called

  describe 'removeItem', ->
    beforeEach ->
      @listViewStub = sinon.createStubInstance KDListView
      @viewController = new KDListViewController
        view          : @listViewStub

    it "adds item to its list view", ->
      itemInstanceStub = sinon.stub()
      @viewController.removeItem itemInstanceStub, 1, 2

      assert @listViewStub.removeItem.withArgs(itemInstanceStub, 1, 2).calledOnce

    it "doesn't add item to its list view when args don't exist", ->
      @viewController.removeItem
      assert.notOk @listViewStub.removeItem.called

  describe 'registerItem', ->

    context 'when there is an id', ->

      it 'registers itemView with that index', ->
        itemView = new KDListItemView {}, {id: 2}
        viewController = new KDListViewController

        viewController.registerItem itemView

        assert.equal viewController.itemsIndexed[2], itemView

    context 'when there is no id', ->

      it "doesn't register itemView to ordered list", ->
        itemView = new KDListItemView {}, {}
        viewController = new KDListViewController

        viewController.registerItem itemView

        values = _.values viewController.itemsIndexed

        assert.equal values.indexOf(itemView), -1

    context 'when there is selection option', ->

      it 'registers a click event', ->
        itemView = new KDListItemView {}, {id: 1}
        viewController = new KDListViewController { selection: on }

        viewController.registerItem itemView

        assert.isDefined itemView._e['click']

    context 'when there is either keyNav or multipleSelection', ->

      it 'registers a mousedown event', ->
        itemView = new KDListItemView {}, {id: 1}
        viewController = new KDListViewController { keyNav: on }

        viewController.registerItem itemView

        assert.isDefined itemView._e['mousedown']

      it 'registers a mouseenter event', ->
        itemView = new KDListItemView {}, {id: 1}
        viewController = new KDListViewController { multipleSelection: on }

        viewController.registerItem itemView

        assert.isDefined itemView._e['mouseenter']


  describe 'unregisterItem', ->

    context 'when it is starting', ->

      it 'emits event', ->
        itemView = new KDListItemView {}, {id: 1}
        viewController = new KDListViewController { multipleSelection: on }

        viewController.registerItem itemView

        viewController.unregisterItem itemView, 0

        assert.isDefined viewController._e['UnregisteringItem']


    context 'when it is lastToFirst', ->

      it 'removes item from view list', ->

        viewController = new KDListViewController
          itemClass    : KDListItemView
          lastToFirst  : yes

        for i in [0...5]
          viewController.addItem {title: Date.now(), id: i}, i

        item = viewController.getListItems()[1]
        viewController.unregisterItem item, 1

        itemViews = viewController.getListItems().map (item) -> item.data.id
        assert.ok _.isEqual itemViews, [0, 1, 2, 4]

    context 'when it is not lastToFirst', ->

      it 'removes item from view list', ->

        viewController = new KDListViewController
          itemClass    : KDListItemView
          lastToFirst  : no

        for i in [0...5]
          viewController.addItem {title: Date.now(), id: i}, i

        item = viewController.getListItems()[1]
        viewController.unregisterItem item, 1

        itemViews = viewController.getListItems().map (item) -> item.data.id

        assert.deepEqual itemViews, [0, 2, 3, 4]

    context 'if there is data on the instance', ->

      it 'removes item from itemsIndexed', ->
        viewController = new KDListViewController
          itemClass    : KDListItemView

        viewController.addItem {title: Date.now(), id: i}, i for i in [0...5]

        item = viewController.getListItems()[1]
        viewController.unregisterItem item, 1

        assert.isUndefined viewController.itemsIndexed[1]


  describe 'removeAllItems', ->

    beforeEach ->
      @viewController = new KDListViewController
        itemClass    : KDListItemView
        lastToFirst  : no

      for i in [0...5]
        @viewController.addItem {title: Date.now(), id: i}, i

      @viewController.removeAllItems()

    it 'cleans items from controller', ->

      assert.deepEqual @viewController.itemsIndexed, {}

    it "cleans items from itemView", ->

      assert.deepEqual @viewController.getListItems(), []

  describe 'moveItemToIndex', ->

    beforeEach ->
      @viewController = new KDListViewController
        itemClass    : KDListItemView
        lastToFirst  : no

      for i in [0...5]
        @viewController.addItem {title: Date.now(), id: i}, i

    it 'moves item to given index', ->
      item = @viewController.getListItems()[2]

      @viewController.moveItemToIndex item, 3

      assert.equal @viewController.getListItems()[3], item

    it 'appends item if index is greater than length', ->
      item = @viewController.getListItems()[1]

      @viewController.moveItemToIndex item, 1000

      assert.equal @viewController.getListItems()[4], item

    it 'prepends item if index is less than length', ->
      item = @viewController.getListItems()[1]

      @viewController.moveItemToIndex item, -1000

      assert.equal @viewController.getListItems()[0], item

  context 'MOUSE EVENTS', ->
    beforeEach ->
      @viewController = new KDListViewController
        itemClass    : KDListItemView
        lastToFirst  : no

      for i in [0...5]
        @viewController.addItem {title: Date.now(), id: i}, i

    describe 'mouseDownHappenedOnItem', ->

      context 'when the item is selected', ->

        beforeEach ->
          @item = @viewController.getListItems()[2]
          @viewController.selectSingleItem @item
          @viewController.mouseDownHappenedOnItem @item

        it "unsets mouse down", ->
          assert.equal @viewController.mouseDown, no

        it "has a null mousedown temp item", ->
          assert.isNull @viewController.mouseDownTempItem

      context "when the item is not selected", ->
        beforeEach ->
          @item = @viewController.getListItems()[2]
          @viewController.mouseDownHappenedOnItem @item

        it "sets mouse down", ->
          assert.equal @viewController.mouseDown, yes

        it "sets mousedown temp item to itemview", ->
          assert.equal @viewController.mouseDownTempItem, @item

        it "has a mouse down timer", ->
          assert.isDefined @viewController.mouseDownTimer

    describe 'mouseUpHappened', ->

      beforeEach ->
        @item = @viewController.getListItems()[2]
        @viewController.selectSingleItem @item
        @viewController.mouseDownHappenedOnItem @item

      after ->
        window.clearTimeout.restore()

      it 'clears timeout', ->
        sinon.spy window, 'clearTimeout'
        @viewController.mouseUpHappened()

        assert.ok window.clearTimeout.calledWith @viewController.mouseDownTimer

      it 'unsets mouse down', ->
        @viewController.mouseUpHappened()
        assert.equal @viewController.mouseDown, no

      it "has a null mousedown temp item", ->
        @viewController.mouseUpHappened()
        assert.isNull @viewController.mouseDownTempItem

    describe 'mouseEnterHappenedOnItem', ->
      beforeEach ->
        @item = @viewController.getListItems()[2]

      after ->
        window.clearTimeout.restore()

      it 'clears timeout', ->
        sinon.spy window, 'clearTimeout'
        @viewController.mouseEnterHappenedOnItem @item

        assert.ok window.clearTimeout.calledWith @viewController.mouseDownTimer

      context 'when mouse is down', ->
        beforeEach ->
          # simulate mousedown
          @viewController.mouseDown = yes

        it 'deselects all items unless a special key is pressed', ->
          @viewController.selectItem @item

          assert.equal @viewController.selectedItems.length, 1

          @viewController.mouseEnterHappenedOnItem @item, {metaKey: off, shiftKey: off, ctrlKey: off}
          assert.equal @viewController.selectedItems.length, 0

        it "doesn't deselects all items if a special key is pressed", ->
          @viewController.selectItem @item
          assert.equal @viewController.selectedItems.length, 1

          @viewController.mouseDownHappenedOnItem @item, {metaKey: yes}
          assert.equal @viewController.selectedItems.length, 1

        it "selects items between 2 selected items", ->
          otherItem = @viewController.getListItems()[0]

          # simulate mouseDown on first item of the list items
          # so that we can try and see if the mouseEnterHappenedOnItem
          # is delegating to range select method.
          @viewController.mouseDownHappenedOnItem otherItem

          @viewController.mouseEnterHappenedOnItem @item, {metaKey: on}

          assert.equal @viewController.selectedItems.length, 3

       context 'when mouse is not down', ->

         beforeEach -> @viewController.mouseDown = no # simulate anti-mouseDown
         after      -> @viewController.emit.restore()

         it 'emits event', ->
           sinon.spy @viewController, 'emit'

           @viewController.mouseEnterHappenedOnItem @item

           assert.ok @viewController.emit.calledWith('MouseEnterHappenedOnItem', @item)

  context 'KEY EVENTS', ->
    describe 'keyDownPerformed', ->
      beforeEach ->
        @viewController = new KDListViewController

      it 'selects items when event has a special key', ->
        sinon.spy @viewController, 'selectItemBelowOrAbove'

        event = {which: 40}
        @viewController.keyDownPerformed null, event

        assert.ok @viewController.selectItemBelowOrAbove.calledWith event

      it 'emits event', ->
        sinon.spy @viewController, 'emit'

        @viewController.keyDownPerformed null, {which: 38}
        assert.ok @viewController.emit.calledWith "KeyDownOnListHandled", @viewController.selectedItems

  context 'ITEM SELECTION', ->

    beforeEach ->
      @viewController = new KDListViewController
        itemClass         : KDListItemView
        lastToFirst       : no
        # multipleSelection : yes

      for i in [0...5]
        @viewController.addItem { title: Date.now(), id: i }, i

    describe 'selectItem', ->
      beforeEach -> @item = @viewController.getListItems()[0]

      context 'when there is no item', ->

        it 'returns immediately', ->
          assert.isUndefined @viewController.selectItem()

      context 'when multipleSelection is not on', ->

        it 'deselects all items', ->
          otherItem = @viewController.getListItems()[2]
          @viewController.selectedItems.push @item
          @viewController.selectItem otherItem, { shiftKey: on }

          # it shoulda been 2 if multiple selection was enabled
          assert.equal @viewController.selectedItems.length, 1

      context 'when shift key is pressed', ->

        it 'selects range', ->
          @viewController.setOptions { multipleSelection: yes }
          newItem = @viewController.getListItems()[2]

          @viewController.selectItem newItem
          @viewController.selectItem @item, { shiftKey: on }

          secondItem = @viewController.getListItems()[1]

          assert.ok _.contains @viewController.selectedItems, secondItem
          assert.equal @viewController.selectedItems.length, 3

      context 'when metaKey and multipleSelection are on', ->
        beforeEach ->
          @viewController.setOptions { multipleSelection: on }
          @newItem = @viewController.getListItems()[1]

          @viewController.selectedItems.push @item

        it "doesn't deselect", ->
          @viewController.selectItem @newItem, { metaKey: on }

          assert.equal @viewController.selectedItems.length, 2

        it "deselects single item", ->
          @viewController.selectedItems.push @newItem

          @viewController.selectItem @item, { metaKey: on }

          assert.notOk _.contains @viewController.selectedItems, @item
          assert.ok _.contains @viewController.selectedItems, @newItem

    describe 'selectItemBelowOrAbove', ->

      context 'when up key is pressed', ->

        it "selects above", ->
          item = @viewController.getListItems()[2]
          aboveItem = @viewController.getListItems()[1]

          @viewController.selectItem item
          @viewController.selectItemBelowOrAbove { which: 38 }

          { selectedItems } = @viewController

          assert.equal selectedItems.length, 1
          assert.ok _.contains selectedItems, aboveItem

      context 'when down key is pressed', ->

        it "selects below", ->
          item = @viewController.getListItems()[2]
          belowItem = @viewController.getListItems()[3]

          @viewController.selectItem item
          @viewController.selectItemBelowOrAbove { which: 40 }

          { selectedItems } = @viewController

          assert.equal selectedItems.length, 1
          assert.ok _.contains selectedItems, belowItem

      context 'when it is at the beginning of the list', ->

        it "doesn't select above", ->
          item = @viewController.getListItems()[0]
          @viewController.selectItem item

          @viewController.selectItemBelowOrAbove { which: 38 }

          { selectedItems } = @viewController

          assert.equal selectedItems.length, 1
          assert.ok _.contains selectedItems, item

      context 'when it is at the end of the list', ->

        it "doesn't select below", ->
          item = @viewController.getListItems()[4]
          @viewController.selectItem item

          @viewController.selectItemBelowOrAbove { which: 40 }

          { selectedItems } = @viewController

          assert.equal selectedItems.length, 1
          assert.ok _.contains selectedItems, item

      context 'when a special key is pressed', ->

        it "deselects item if it is selected", ->
          item = @viewController.getListItems()[2]
          @viewController.selectItem item

          # go up first
          @viewController.selectItemBelowOrAbove { which: 40, metaKey: on }
          assert.equal @viewController.selectedItems.length, 2

          # then go down
          @viewController.selectItemBelowOrAbove { which: 38, metaKey: on }
          assert.equal @viewController.selectedItems.length, 1

    describe 'selectNextItem', ->

      context 'when item is not given', ->

        it 'selects first item from selectedItems', ->
          item = @viewController.getListItems()[2]
          nextItem = @viewController.getListItems()[3]
          @viewController.selectItem item

          @viewController.selectNextItem()

          { selectedItems } = @viewController
          assert.equal selectedItems.length, 1
          assert.ok _.contains selectedItems, nextItem

      context 'when item is given', ->

        it 'selects next element', ->
          item = @viewController.getListItems()[3]
          nextItem = @viewController.getListItems()[4]

          @viewController.selectNextItem item

          { selectedItems } = @viewController
          assert.equal selectedItems.length, 1
          assert.ok _.contains selectedItems, nextItem

    describe 'selectPrevItem', ->

      context 'when item is not given', ->

        it 'selects first item from selectedItems', ->
          item = @viewController.getListItems()[2]
          prevItem = @viewController.getListItems()[1]
          @viewController.selectItem item

          @viewController.selectPrevItem()

          { selectedItems } = @viewController
          assert.equal selectedItems.length, 1
          assert.ok _.contains selectedItems, prevItem

      context 'when item is given', ->

        it 'selects next element', ->
          item = @viewController.getListItems()[3]
          prevItem = @viewController.getListItems()[2]

          @viewController.selectPrevItem item

          { selectedItems } = @viewController
          assert.equal selectedItems.length, 1
          assert.ok _.contains selectedItems, prevItem

    describe 'deselectAllItems', ->

      it 'deselect all items', ->
        item = @viewController.getListItems()[3]
        @viewController.selectItem item

        @viewController.deselectAllItems()

        assert.equal @viewController.selectedItems, 0
        assert.notOk _.contains @viewController.selectedItems, item

    describe 'deselectSingleItem', ->

      it 'deselects single item', ->
        item = @viewController.getListItems()[3]
        @viewController.selectItem item

        @viewController.deselectSingleItem item

        assert.equal @viewController.selectedItems, 0
        assert.notOk _.contains @viewController.selectedItems, item


      context 'when item is the last element', ->

        it 'unsets listview class', ->
          item = @viewController.getListItems()[4]
          @viewController.selectItem item

          sinon.spy @viewController.listView, 'unsetClass'

          @viewController.deselectSingleItem item

          assert.ok @viewController.listView.unsetClass.calledWith 'last-item-selected'

    describe 'selectSingleItem', ->

      @viewController = new KDListViewController
        selectable    : yes

      it 'selects the item', ->
        item = @viewController.getListItems()[2]
        @viewController.selectSingleItem item

        assert.ok _.contains @viewController.selectedItems, item

      context 'when item is the last element', ->

        it 'sets listview class', ->
          item = @viewController.getListItems()[4]
          sinon.spy @viewController.listView, 'setClass'

          @viewController.selectSingleItem item

          assert.ok @viewController.listView.setClass.calledWith 'last-item-selected'

    describe 'selectAllItems', ->

      it 'selects all items', ->
        item = @viewController.getListItems()[1]
        anotherItem = @viewController.getListItems()[4]

        @viewController.selectAllItems()

        assert.equal @viewController.selectedItems.length, 5
        assert.ok _.contains @viewController.selectedItems, item
        assert.ok _.contains @viewController.selectedItems, anotherItem

    describe 'selectItemsByRange', ->

      it 'selects items by range', ->

        item = @viewController.getListItems()[1]
        anotherItem = @viewController.getListItems()[4]

        @viewController.selectItemsByRange item, anotherItem

        assert.equal @viewController.selectedItems.length, 4
        assert.ok _.contains @viewController.selectedItems, item
        assert.ok _.contains @viewController.selectedItems, anotherItem

  describe 'LAZY LOADER', ->

    describe 'createLazyLoader', ->

      it 'creates lazy loader', ->
        viewController = new KDListViewController
        wrapper = viewController.scrollView or viewController.getView()
        viewController.createLazyLoader()

        assert.ok _.contains wrapper.subViews, viewController.lazyLoader

