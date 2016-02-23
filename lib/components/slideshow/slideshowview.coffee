KD = require '../../core/kd'
Hammer = require 'hammerjs'
KDView = require '../../core/view'

module.exports = class KDSlideShowView extends KDView

  [X_COORD, Y_COORD] = [1, 2]

  constructor:(options={}, data)->

    options.cssClass      = KD.utils.curry 'kd-slide', options.cssClass
    options.animation    ?= 'move'         # can be move or rotate
    options.direction    ?= 'leftToRight'  # can be leftToRight or topToBottom
    options.touchEnabled ?= yes

    super options, data

    @pages     = []
    @_coordsY  = []
    @_currentX = 0

    {animation, direction, touchEnabled} = @getOptions()

    topToBottom = [["#{animation}FromTop" , "#{animation}FromBottom"],
                   ["#{animation}ToBottom", "#{animation}ToTop"]]
    leftToRight = [["#{animation}FromLeft", "#{animation}FromRight"],
                   ["#{animation}ToRight" , "#{animation}ToLeft"]]

    if direction is 'topToBottom'
      @xcoordAnimations = topToBottom
      @ycoordAnimations = leftToRight
      touchCallbacks    = ['nextSubPage', 'previousSubPage',
                           'nextPage'   , 'previousPage']
    else
      @xcoordAnimations = leftToRight
      @ycoordAnimations = topToBottom
      touchCallbacks    = ['nextPage'   , 'previousPage',
                           'nextSubPage', 'previousSubPage']

    if touchEnabled
      hammer = Hammer @getElement()
      hammer.on "swipeleft",  @bound touchCallbacks[0]
      hammer.on "swiperight", @bound touchCallbacks[1]
      hammer.on "swipeup",    @bound touchCallbacks[2]
      hammer.on "swipedown",  @bound touchCallbacks[3]

      # For touch enabled devices disable bounce scroll o_0
      hammer.on "touchmove", (e)-> e.preventDefault()

  addPage:(page)->
    @addSubView page

    if @pages.length is 0
      page.setClass 'current'
      @currentPage = page

    @pages.push [page]
    @_coordsY.push 0

  addSubPage:(page)->
    @addSubView page
    lastAddedPage = @pages.last
    lastAddedPage.push page

  nextPage:->
    @jump @_currentX + 1, X_COORD
  previousPage:->
    @jump @_currentX - 1, X_COORD

  nextSubPage:->
    @jump @_coordsY[@_currentX] + 1, Y_COORD
  previousSubPage:->
    @jump @_coordsY[@_currentX] - 1, Y_COORD

  jump:(pageIndex, coord = 1, callback = KD.noop)->

    if coord is X_COORD
    then [pages, current] = [@pages, @_currentX]
    else [pages, current] = [@pages[@_currentX], @_coordsY[@_currentX]]

    return if pages.length <= 1

    # Poor man's index limitter, max pages.length - min 0
    index = Math.min pages.length - 1, Math.max 0, pageIndex
    return if current is index

    direction = if index < current then 0 else 1

    if coord is X_COORD
      currentPage = pages[current][@_coordsY[current]]
      newPage     = pages[index][@_coordsY[index]]
      @_currentX  = index
      newPage.move     @xcoordAnimations[0][direction]
      currentPage.move @xcoordAnimations[1][direction]
    else
      currentPage = pages[current]
      newPage     = pages[index]
      @_coordsY[@_currentX] = index
      newPage.move     @ycoordAnimations[0][direction]
      currentPage.move @ycoordAnimations[1][direction]

    @emit 'CurrentPageChanged', x: @_currentX, y:@_coordsY[@_currentX]
    newPage.setClass 'current'
    @currentPage = newPage

    @utils.wait 600, ->
      currentPage.unsetClass 'current'
      callback()
