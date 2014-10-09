window.MutationSummary = require '../../../libs/mutation-summary.js'
KDCustomHTMLView       = require '../../core/customhtmlview'

module.exports = class KDListViewBox extends KDCustomHTMLView

  constructor: (options = {}) ->

    options.tagName = 'section'

    super options

    @observeMutations()
    @on 'MutationHappened', @bound 'updateProps'


  getItems: -> @subViews.filter (item)-> item instanceof KDListItemView


  updateProps: ->

    @emit 'BoxIsEmptied', @getId()  if @subViews.length is 0
    @emit 'HeightChanged', @getElement().clientHeight
