class KDCounterDigitView extends KDCustomHTMLView

  constructor : (options = {}, data = {}) ->

    options.tagName       = "ul"
    options.initialValue ?= 0

    super options, data

    @currentValue = options.initialValue

    @createDigit()

  createDigit : ->
    @addSubView @digit = new KDCustomHTMLView
      tagName   : "li"
      cssClass  : "real"
      partial   :
        """
          <span class="top">#{@getOption('initialValue')}</span>
          <span class="bottom">#{@getOption('initialValue')}</span>
        """

    @addSubView @fakeDigit = new KDCustomHTMLView
      tagName   : "li"
      cssClass  : "fake"
      partial   :
        """
          <span class="top">#{@getOption('initialValue')}</span>
          <span class="bottom">#{@getOption('initialValue')}</span>
        """

    @setValue @getOption "initialValue"

  setValue : (value) ->
    return  if value is @currentValue

    @currentValue  = value

    @digit.updatePartial """
      <span class="top">#{value}</span>
      <span class="bottom">#{value}</span>
    """

    @setClass "animate"

    KD.utils.wait 500, =>
      @fakeDigit.updatePartial """
        <span class="top">#{value}</span>
        <span class="bottom">#{value}</span>
      """
      @unsetClass "animate"
