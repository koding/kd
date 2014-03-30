KDCustomHTMLView = require '../../core/customhtmlview'

module.exports = class KDListViewBox extends KDCustomHTMLView

  constructor: (options = {}) ->

    options.tagName = 'section'

    super options

    @observeMutations()
    @on 'MutationHappened', @bound 'updateProps'


  updateProps: ->

    @emit 'BoxIsEmptied', @getId()  if @subViews.length is 0
    @emit 'HeightChanged', @getElement().clientHeight
