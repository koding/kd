KDView = require './../../core/view.coffee'

module.exports = class KDSlidePageView extends KDView

  constructor:(options={}, data)->
    options.cssClass = KD.utils.curry 'kd-page', options.cssClass
    super options, data
    @_currentCssClass = null

  move:(cssClass)->
    return  unless cssClass

    @unsetClass @_currentCssClass
    @_currentCssClass = cssClass
    @setClass cssClass
