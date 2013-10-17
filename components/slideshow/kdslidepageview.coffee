class KDSlidePageView extends JView

  constructor:(options={}, data)->
    options.cssClass = KD.utils.curry 'kd-page', options.cssClass
    super options, data

  viewAppended:->
    super

    {content} = @getOptions()

    if content
      @addSubView new KDCustomHTMLView
        partial  : content
        cssClass : 'content'

  move:(css)->
    @unsetClass @_currentCss  if @_currentCss
    @_currentCss = css
    @setClass css
