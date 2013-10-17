class KDSlideShowView extends JView

  [X_COORD, Y_COORD] = [1, 2]

  constructor:(options={}, data)->

    options.cssClass = KD.utils.curry 'kd-slide', options.cssClass

    super options, data

    @pages     = []
    @_coordsY  = []
    @_currentX = 0

  addPage:(page)->
    @addSubView page

    if @pages.length is 0 then page.setClass 'current'

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

  jump:(pageIndex, coord)->

    if coord is X_COORD
    then [pages, current] = [@pages, @_currentX]
    else [pages, current] = [@pages[@_currentX], @_coordsY[@_currentX]]

    return if pages.length <= 1

    # Poor man's index limitter, max pages.length - min 0
    index = Math.min pages.length - 1, Math.max 0, pageIndex
    return if current is index

    direction = index < current
    anim = (@getOption 'animation') or 'move'

    if coord is X_COORD
      currentPage = pages[current][@_coordsY[current]]
      newPage     = pages[index][@_coordsY[index]]
      @_currentX  = index
      newPage.move     if direction then "#{anim}FromLeft" else "#{anim}FromRight"
      currentPage.move if direction then "#{anim}ToRight"  else "#{anim}ToLeft"
    else
      currentPage = pages[current]
      newPage     = pages[index]
      @_coordsY[@_currentX] = index
      newPage.move     if direction then "#{anim}FromTop"  else "#{anim}FromBottom"
      currentPage.move if direction then "#{anim}ToBottom" else "#{anim}ToTop"

    newPage.setClass 'current'
    @utils.wait 600, -> currentPage.unsetClass 'current'
