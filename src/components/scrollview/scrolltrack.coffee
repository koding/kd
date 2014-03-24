KDView = require './../../core/view.coffee'

module.exports = class KDScrollTrack extends KDView

  show:-> @unsetClass 'invisible'

  hide:-> @setClass 'invisible'

