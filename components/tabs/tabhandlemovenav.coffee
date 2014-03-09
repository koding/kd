KDCustomHTMLView = require './components/kdcustomhtmlview.coffee'

module.exports = class KDTabHandleMoveNav extends KDCustomHTMLView

  constructor: (options = {}, data) ->

    options.cssClass = KD.utils.curry 'kdtabhandle-movenav', options.cssClass
    super options, data

    @_current = 0

  viewAppended:->
    @addSubView @left  = new KDCustomHTMLView
      cssClass  : 'leftButton'
      click     : => @move 'right'
    @addSubView @right = new KDCustomHTMLView
      cssClass  : 'rightButton'
      click     : => @move 'left'

    @listenWindowResize()

  _windowDidResize:->

    delegate = @getDelegate()

    unless delegate.getWidth() > delegate._tabsWidth + 50
      @show()
    else
      @move 'initial'
      @hide()

  move:(direction)->

    {tabHandleContainer} = delegate = @getDelegate()
    handleWidth = delegate.getOption 'maxHandleWidth'

    switch direction
      when 'left'
        return  if handleWidth * delegate.handles.length + 100 < \
                   tabHandleContainer.getWidth() - @_current
        @_current -= handleWidth
      when 'right'
        return  if @_current is 0
        @_current += handleWidth
      when 'initial'
        @_current = 0

    tabHandleContainer.tabs.setCss 'marginLeft', "#{@_current}px"
