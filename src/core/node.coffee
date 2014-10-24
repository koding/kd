KDObject = require './object'

module.exports = class KDNode extends KDObject

  constructor: (options = {}, data) ->

    options.tagName    or= 'div'
    options.domId      or= null
    options.cssClass   or= ''
    options.partial    or= null
    options.delegate   or= null
    options.size       or= null
    options.position   or= null
    options.attributes or= null
    options.key        or= null
    options.nodeType     = 'node'

    super options, data

    @subViews = @subviews = []

  getTagName: -> @options.tagName

  addSubview = (subview) -> @subviews.push subview

  addSubview: -> addSubview.call this

  addSubView: ->
    warn 'KDNode::addSubView is deprecated. Use KDNode::addSubview instead'
    addSubview.call this


