KDAutocompleteUnselecteableItem = require './autocompleteunselecteableitem.coffee'

module.exports = class KDAutoCompleteFetchingItem extends KDAutocompleteUnselecteableItem

  constructor:(options = {}, data)->
    options.cssClass = @utils.curry "kdautocompletelistitem fetching", options.cssClass
    super

  partial:-> "Fetching in process..."
