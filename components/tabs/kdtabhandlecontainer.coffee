class KDTabHandleContainer extends KDView

  constructor:(options={}, data)->
    super

    @tabs = new KDView cssClass:'kdtabhandle-tabs'

  viewAppended:->
    @addSubView @tabs