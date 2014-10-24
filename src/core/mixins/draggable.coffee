
module.exports = Draggable = ->

  @setEmptyDragState = (moveBacktoInitialPosition = no) ->

    if moveBacktoInitialPosition and @dragState
      el = @$()
      el.css 'left', 0
      el.css 'top' , 0

    nullCoords = { x: null, y: null }
    zeroCoords = { x: 0, y: 0 }

    @dragState =
      containment : null     # a parent KDView
      handle      : null     # a parent KDView or a child selector
      axis        : null     # a String 'x' or 'y' or 'diagonal'
      direction   :
        current   : nullCoords # { x: '<left|right>', '<up|down>' }
        global    : nullCoords # { x: '<left|right>', '<up|down>' }
      position    :
        relative  : zeroCoords # { x: new Number, y: new Number }
        initial   : zeroCoords # { x: new Number, y: new Number }
        global    : zeroCoords # { x: new Number, y: new Number }
      meta        :
        top       : 0        # a Number
        right     : 0        # a Number
        bottom    : 0        # a Number
        left      : 0        # a Number


  @setDraggable = (options = {}) ->

    options = {} if options is yes

    @setEmptyDragState()
    handle = if options.handle instanceof KDView then options.handle else this

    @on "DragFinished", (e) => @beingDragged = no

    handle.on "mousedown", (event)=>
      if "string" is typeof options.handle
        return if $(event.target).closest(options.handle).length is 0

      @dragIsAllowed = yes
      @setEmptyDragState()

      dragState = @dragState

      if options.containment

        dragState.containment = {}
        dragState.containment.m = w: @getWidth(), h: @getHeight()

        {view} = options.containment

        bounds = if 'string' is typeof view
        then @[view].getBounds()
        else if view instanceof KDView
        then view.getBounds()
        else @parent.getBounds()

        dragState.containment.viewBounds = bounds

        padding = top : 0, right : 0, bottom : 0, left : 0

        oPad = options.containment.padding
        if 'number' is typeof oPad
        then v = oPad for own p, v of padding
        else if 'object' is typeof oPad
        then KD.utils.extend padding, oPad

        dragState.containment.padding = padding


      # TODO: should move these lines
      dragState.handle      = options.handle
      dragState.axis        = options.axis

      dragMeta              = dragState.meta
      dragEl                = @getElement()
      dragMeta.top          = parseInt(dragEl.style.top,    10) or 0
      dragMeta.right        = parseInt(dragEl.style.right,  10) or 0
      dragMeta.bottom       = parseInt(dragEl.style.bottom, 10) or 0
      dragMeta.left         = parseInt(dragEl.style.left,   10) or 0

      dragPos = @dragState.position
      dragPos.initial.x     = event.pageX
      dragPos.initial.y     = event.pageY

      KD.getSingleton('windowController').setDragView this
      @emit "DragStarted", event, @dragState
      event.stopPropagation()
      event.preventDefault()
      return no

  drag: (event, delta) =>

    {directionX, directionY, axis, containment} = @dragState

    {x, y}       = delta
    dragPos      = @dragState.position
    dragRelPos   = dragPos.relative
    dragInitPos  = dragPos.initial
    dragGlobPos  = dragPos.global
    dragDir      = @dragState.direction
    dragGlobDir  = dragDir.global
    dragCurDir   = dragDir.current
    {axis}       = @getOptions().draggable

    draggedDistance = if axis
      if axis is "x" then Math.abs x else Math.abs y
    else Math.max Math.abs(x), Math.abs(y)

    @dragIsAllowed = @beingDragged = !(draggedDistance < 20 and not @beingDragged)

    if x > dragRelPos.x
      dragCurDir.x  = 'right'
    else if x < dragRelPos.x
      dragCurDir.x  = 'left'

    if y > dragRelPos.y
      dragCurDir.y  = 'bottom'
    else if y < dragRelPos.y
      dragCurDir.y  = 'top'

    dragGlobPos.x = dragInitPos.x + x
    dragGlobPos.y = dragInitPos.y + y

    dragGlobDir.x = if x > 0 then 'right'  else 'left'
    dragGlobDir.y = if y > 0 then 'bottom' else 'top'

    if @dragIsAllowed
      el = @$()
      dragMeta   = @dragState.meta
      targetPosX = if dragMeta.right  and not dragMeta.left then 'right'  else 'left'
      targetPosY = if dragMeta.bottom and not dragMeta.top  then 'bottom' else 'top'

      newX = if targetPosX is 'left' then dragMeta.left + dragRelPos.x else dragMeta.right  - dragRelPos.x
      newY = if targetPosY is 'top'  then dragMeta.top  + dragRelPos.y else dragMeta.bottom - dragRelPos.y

      if containment
        m  = containment.m                    # My sizes
        p  = containment.viewBounds           # Containment's sizes
        cp = containment.padding              # Containment paddings
        if newX <= cp.left then newX = cp.left
        if newY <= cp.top  then newY = cp.top
        if newX + m.w >= p.w - cp.right  then newX = p.w - m.w - cp.right
        if newY + m.h >= p.h - cp.bottom then newY = p.h - m.h - cp.bottom

      el.css targetPosX, newX unless axis is 'y'
      el.css targetPosY, newY unless axis is 'x'

    dragRelPos.x = x
    dragRelPos.y = y

    @emit "DragInAction", x, y

