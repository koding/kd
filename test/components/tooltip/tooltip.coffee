should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDTooltip = require '../../../lib/components/tooltip/tooltip'
KDView = require '../../../lib/core/view'


describe 'KDTooltip', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @view = new KDView
      tooltip :
        title : 'hello'

    @o = {}
    placementMap =
      above: "s"
      below: "n"
      left: "e"
      right  : "w"

    @o.title or= ""
    @o.cssClass or= ""
    @o.placement or= "top"
    @o.direction or= "center"
    @o.offset or=
      top: 0
      left: 0
    @o.delayIn or= 0
    @o.delayOut or= 0
    @o.html ?= yes
    @o.animate ?= no
    @o.selector or= null
    @o.gravity or= placementMap[@o.placement]
    @o.fade or= @o.animate
    @o.fallback or= @o.title
    @o.view or= null
    @o.sticky ?= no
    @o.permanent ?= no
    @o.delegate or= @view
    @o.events or= ['mouseenter','mouseleave','mousemove']
    @instance = new KDTooltip @o, {}

  afterEach ->
    @instance.destroy()
    @sinon.restore()

  it 'exists', ->
    KDTooltip.should.exist

  describe 'constructor', ->
    it 'should initialize without any error', ->
      @instance.should.exist
      @instance.options.cssClass.should.equal 'kdtooltip'
      @instance.wrapper.should.instanceof KDView

  describe 'show', ->
    it 'should show the tooltip', ->
      @instance.show()
      @instance.visible.should.equal yes

    it 'should not show if a selector is set', ->
      @o.selector = 'tooltip-selector'
      instance = new KDTooltip @o, {}
      instance.show()
      instance.visible.should.equal no

  describe 'hide', ->
    it 'should hide', ->
      @instance.show()
      @instance.visible.should.equal yes
      @instance.hide()
      @instance.visible.should.equal no

  describe 'update', ->
    it 'should update', ->
      @instance.display = @sinon.spy @instance.display
      @instance.update()
      @instance.display.should.calledOnce()

    it 'should update view', ->
      @instance.setView = @sinon.spy @instance.setView
      @instance.update {}, @view
      @instance.setView.should.calledOnce()

  describe 'setTitle', ->
    it 'should set title', ->
      @instance.setTitle 'Koding', no
      @instance.wrapper.getElement().innerHTML.should.equal 'Koding'

  describe 'destroy', ->
    it 'should destroy', ->
      @instance.destroy()
      should(@instance.parentView.tooltip).should.not.exist

  describe 'getView', ->
    it 'should get view', ->
      view = @instance.getView()
      should(view).equal undefined
