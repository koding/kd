$ = require 'jquery'
KD = require '../../core/kd'
KDView           = require '../../core/view'
KDOverlayView    = require '../overlay/overlayview'
KDButtonView     = require '../buttons/buttonview'
KDModalViewStack = require './modalviewstack'

module.exports = class KDModalView extends KDView

  constructor: (options = {}, data) ->

    options.overlay       ?= no            # a Boolean
    options.overlayClick  ?= yes           # a Boolean
    options.height       or= "auto"        # a Number for pixel value or a String e.g. "100px" or "20%" or "auto"
    options.width         ?= 600           # a Number for pixel value or a String e.g. "100px" or "20%"
    options.position     or= {}            # an Object holding top and left values
    options.title        or= null          # a String of text or HTML
    options.subtitle     or= null          # a String of text or HTML
    options.content      or= null          # a String of text or HTML
    options.buttons      or= null          # an Object of button options
    options.fx            ?= no            # a Boolean
    options.view         or= null          # a KDView instance
    options.draggable     ?= handle : '.kdmodal-title'
    # TO BE IMPLEMENTED
    options.resizable     ?= no            # a Boolean
    options.appendToDomBody ?= yes

    options.helpContent  or= null
    options.helpTitle    or= "Need help?"
    options.cancelable    ?= yes

    super options, data

    @setClass "initial"
    @putOverlay options.overlay                   if options.overlay
    @setClass "fx"                                if options.fx
    @setTitle options.title                       if options.title
    @setSubtitle options.subtitle                 if options.subtitle
    @setContent options.content                   if options.content
    @addSubView options.view                      if options.view

    @on 'ModalCancelled', options.cancel          if options.cancel

    @on "viewAppended", =>
      @utils.wait 500, => @unsetClass "initial"

    @appendToDomBody()  if @getOptions().appendToDomBody

    @setModalWidth  options.width
    @setModalHeight options.height                if options.height

    if options.buttons
      @buttonHolder = new KDView {cssClass : "kdmodal-buttons clearfix"}
      @addSubView @buttonHolder, ".kdmodal-inner"
      @setButtons options.buttons

      modalButtonsInnerWidth = @$(".kdmodal-inner").width()
      @buttonHolder.setWidth modalButtonsInnerWidth

    # TODO: it is now displayed with setPositions method fix that and make .display work
    @display()
    @_windowDidResize()

    # KD.getSingleton("windowController").setKeyView @ ---------> disabled because KDEnterinputView was not working in KDmodal
    $(window).one "keydown.modal",(e)=>
      @cancel() if e.which is 27

    @on "childAppended", @setPositions.bind this

    @listenWindowResize()


  setDomElement: (cssClass) ->
    {helpContent, helpTitle} = @getOptions()

    if helpContent
      helpButton = "<span class='showHelp'>#{helpTitle}</span>"
    else
      helpButton = ""

    @domElement = $ """
      <div class='kdmodal #{cssClass}'>
        <div class='kdmodal-inner'>
          #{helpButton}
          <span class='close-icon closeModal' title='Close [ESC]'></span>
          <div class='kdmodal-title hidden'></div>
          <div class='kdmodal-content'></div>
        </div>
      </div>
    """


  addSubView: (view, selector = ".kdmodal-content", shouldPrepend = no) ->
    selector = null if @$(selector).length is 0
    super view, selector, shouldPrepend


  setButtons: (buttonDataSet, destroyExists = no) ->
    @buttons or= {}
    @setClass "with-buttons"
    defaultFocusTitle = null
    @destroyButtons()  if destroyExists
    for own buttonTitle, buttonOptions of buttonDataSet
      defaultFocusTitle ?= buttonTitle
      button = @createButton buttonOptions.title or buttonTitle, buttonOptions
      @buttons[buttonTitle] = button
      focused = yes  if buttonOptions.focus

    @buttons[defaultFocusTitle]?.setFocus()  if not focused and defaultFocusTitle


  destroyButtons: ->
    button.destroy()  for own _key, button of @buttons


  click:(e) ->
    @cancel() if $(e.target).is(".closeModal")
    if $(e.target).is(".showHelp")
      {helpContent} = @getOptions()
      if helpContent
        helpContent = KD.utils.applyMarkdown helpContent
        new KDModalView
          # title   : "Help"
          cssClass : "help-dialog"
          overlay  : yes
          content  : "<div class='modalformline'><p>#{helpContent}</p></div>"

    # KD.getSingleton("windowController").setKeyView @ ---------> disabled because KDEnterinputView was not working in KDmodal

  # keyUp:(e)->
  #   @cancel() if e.which is 27


  setTitle: (title) ->
    @$().find(".kdmodal-title").removeClass('hidden').html("<span class='title'>#{title}</span>")
    @modalTitle = title


  setSubtitle: (subtitle) ->
    @$().find(".kdmodal-title").append("<span class='subtitle'>#{subtitle}</span>")
    @modalSubtitle = subtitle


  setModalHeight: (value) ->
    if value is "auto"
      # @$().css "min-height","100px"
      @$().css "height","auto"
      @modalHeight = @getHeight()
    else
      @$().height value
      @modalHeight = value


  setModalWidth: (value) ->
    # if isNaN value
    @modalWidth = value
    @$().width value


  setPositions: ->
    @utils.defer =>
      {top, right, bottom, left} = @getOptions().position
      newRules = {}
      height = $(window).height()
      width  = $(window).width()
      newRules.top  = Math.round(if top?  then top  else height/2 - @getHeight()/2)
      newRules.left = Math.round(if left? then left else width/2  - @modalWidth/2)
      newRules.left = Math.round(width - @modalWidth - right - 20) if right #20 is the padding FIX
      newRules.opacity = 1
      @$().css newRules


  _windowDidResize: ->
    @setPositions()
    {innerHeight} = window
    @$('.kdmodal-content').css maxHeight : innerHeight - 120
    @setY Math.round((innerHeight - @getHeight()) / 2)  unless @getOptions().position.top


  putOverlay: ->

    {overlayOptions, overlayClick} = @getOptions()
    overlayOptions                ?= {}
    overlayOptions.isRemovable    ?= overlayClick

    @overlay = new KDOverlayView overlayOptions

    @overlay.once 'click', @bound 'destroy'  if overlayClick


  createButton: (title, buttonOptions) ->
    buttonOptions.title    = title
    buttonOptions.delegate = this
    itemClass = buttonOptions.itemClass
    delete buttonOptions.itemClass
    @buttonHolder.addSubView button = new (itemClass or KDButtonView) buttonOptions
    button.on 'KDModalShouldClose', => @emit 'KDModalShouldClose'
    button


  setContent: (content) ->
    @modalContent = content
    @getDomElement().find(".kdmodal-content").html content


  display: ->
    if @getOptions().fx
      @utils.defer =>
        @setClass "active"


  cancel: ->
    return unless @getOptions().cancelable
    @emit 'ModalCancelled'
    @destroy()


  destroy: ->
    $(window).off "keydown.modal"
    uber = KDView::destroy.bind this

    if @options.fx
      @unsetClass "active"
      setTimeout uber, 300
    else
      @getDomElement().hide()
      uber()

    @overlay?.destroy()
    @emit 'KDModalViewDestroyed', this


  hide: ->
    @overlay?.hide()
    super


  show: ->
    @overlay?.show()
    super


  ### STACK HELPERS ###

  @createStack: (options) ->
    @stack or= new KDModalViewStack options


  @addToStack: (modal) ->
    @stack.addModal modal


  @destroyStack: ->
    @stack.destroy()
    delete @stack


  @confirm = (options) ->
    noop = -> modal.destroy()

    { ok, cancel, title, content, description } = options
    ok      = callback: ok      if not ok     or 'function' is typeof ok
    cancel  = callback: cancel  if not cancel or 'function' is typeof cancel
    modal   = new this
      title         : title or 'You must confirm this action'
      content       : content or if description
        """
        <div class='modalformline'>
          <p>#{description}</p>
        </div>
        """
      overlay       : yes
      buttons       :
        OK          :
          title     : ok.title
          style     : ok.style or "solid red medium"
          callback  : ok.callback or noop
        cancel      :
          title     : cancel.title
          style     : cancel.style or "solid light-gray medium"
          callback  : cancel.callback or noop
    modal.addSubView options.subView  if options.subView
    modal


