class KDBlockingModalView extends KDModalView

  constructor: (options = {}, data) ->

    super options, data

    $(window).off "keydown.modal" # to unbind ESC key

  putOverlay:->
    @overlay = new KDOverlayView
      isRemovable: no

    @overlay.on "click", =>
      @doBlockingAnimation()

  doBlockingAnimation:->
    @setClass "blocking-animation"

    KD.utils.wait 200, =>
      @unsetClass "blocking-animation"

  setDomElement:(cssClass)->
    @domElement = $ """
        <div class='kdmodal #{cssClass}'>
          <div class='kdmodal-shadow'>
            <div class='kdmodal-inner'>
              <div class='kdmodal-title'></div>
              <div class='kdmodal-content'></div>
            </div>
          </div>
        </div>
      """

  click:(e)->