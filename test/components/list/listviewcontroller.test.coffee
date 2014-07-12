{assert, expect} = require 'chai'
sinon = require 'sinon'
KDListViewController = require '../../../src/components/list/listviewcontroller.coffee'
KDListView = require '../../../src/components/list/listview.coffee'

describe 'KDListViewController', ->
  beforeEach -> @sinon = sinon.sandbox.create()
  afterEach  -> @sinon.restore()

  describe 'constructor', ->
    it 'should instantiate without error', ->
      viewController = new KDListViewController
      expect(viewController).to.be.ok

    it 'should set listview if listview has been passed as an option', ->
      listViewStub = sinon.createStubInstance KDListView
      viewController = new KDListViewController { view: listViewStub }

      expect(viewController.listView).to.be.equal(listViewStub)

    it 'should set listview even if there is no view option passed', ->
      viewController = new KDListViewController
      expect(viewController.listView).to.be.instanceof(KDListView)

    it "shouldn't have scrollView if there is a scrollview option as false", ->
      viewController = new KDListViewController { scrollView: no }
      expect(viewController.scrollView).to.be.not.ok

  describe 'instantiateListItems', ->
    it "should call listview's addItem method", ->
      listViewStub = sinon.createStubInstance KDListView
      viewController = new KDListViewController { view: listViewStub }

      items = [1, 2]
      listViewStub.addItem = (item) -> item * 2
      result = viewController.instantiateListItems items

      expect(result).to.eql [2, 4]

    it "emits 'AllItemsAddedToList' event when it instantiates new items", ->
      listViewStub = sinon.createStubInstance KDListView
      listViewStub.addItem = (item) -> item * 2
      viewController = new KDListViewController { view: listViewStub }
      sinon.spy(viewController, 'emit')

      viewController.instantiateListItems [1, 2]

      assert viewController.emit.called

  describe 'putNoItemView', ->
    it 'should add no item found widget view to subviews', ->
      listViewStub = sinon.createStubInstance KDListView
      widget = sinon.stub()
      viewController = new KDListViewController
        view              : listViewStub
        noItemFoundWidget : widget

      viewController.putNoItemView()

      assert listViewStub.addSubView.withArgs(widget).calledOnce

  describe 'addItem', ->
    beforeEach ->
      @listViewStub = sinon.createStubInstance KDListView
      @viewController = new KDListViewController
        view              : @listViewStub

    it "adds item to its list view", ->
      @viewController.addItem 1, 2

      assert @listViewStub.addItem.withArgs(1, 2).calledOnce

    it "doesn't add item to its list view when args don't exist", ->
      @viewController.addItem

      assert.notOk @listViewStub.addItem.called

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
    it

