KDObject = require './object'

module.exports = class KDTextNode extends KDObject

  constructor: (options = {}, data) ->

    options.nodeType = 'text'
    options.key    or= null

    super options, data

    @text = options.text or data.text or ''

