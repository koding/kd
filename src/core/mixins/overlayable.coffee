
module.exports = Overlayable = ->

  @putOverlay = (options = {}) ->
    options.delegate = this

    KDOverlayView = require '../../components/overlay/overlayview.coffee'
    @overlay = new KDOverlayView options


  @removeOverlay = -> @overlay?.destroy()


