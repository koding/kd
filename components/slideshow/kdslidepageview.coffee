class KDSlidePageView extends JView

  constructor:(options={}, data)->
    options.cssClass = KD.utils.curry 'kd-page', options.cssClass
    super options, data

  move:(css)->
    @unsetClass @_currentCss  if @_currentCss
    @_currentCss = css
    @setClass css
