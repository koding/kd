KD = require './kd'
KDView       = require './view'
KDController = require './controller'

module.exports = class KDViewController extends KDController

  constructor:(options = {}, data)->

    options.view or= new KDView

    super options, data

    @setView @getOptions().view  if @getOptions().view

  loadView:(mainView)->

  getView:-> @mainView

  setView:(aViewInstance)->
    @mainView = aViewInstance
    @emit "ControllerHasSetItsView"
    cb = @loadView.bind @, aViewInstance
    if aViewInstance.isViewReady() then do cb
    else
      aViewInstance.once 'viewAppended', cb
      aViewInstance.once 'KDObjectWillBeDestroyed', =>
        KD.utils.defer @bound "destroy"