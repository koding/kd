KDAutocompleteUnselecteableItem = require './autocompleteunselecteableitem.coffee'

module.exports = class KDAutoCompleteFetchingItem extends KDAutocompleteUnselecteableItem

  constructor: (options = {}, data) ->

    options.cssClass = KD.utils.curry 'kdautocompletelistitem fetching', options.cssClass

    super options, data


  partial: -> 'Loading...'
