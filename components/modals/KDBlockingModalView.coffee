class KDBlockingModalView extends KDModalView
  constructor:->
    super
    $(window).off "keydown.modal"

  putOverlay:->
    @$overlay = $ "<div/>",
      class : "kdoverlay"
    @$overlay.hide()
    @$overlay.appendTo "body"
    @$overlay.fadeIn 200
    @$overlay.bind "click", => @doBlockingAnimation()

  doBlockingAnimation:->
    @unsetClass "blocking-animation"
    @setClass   "blocking-animation"

    @$overlay.off "click"

    KD.utils.wait 200, =>
      @unsetClass "blocking-animation"
      @$overlay.bind "click", => @doBlockingAnimation()

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