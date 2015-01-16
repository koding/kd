KDView           = require '../../core/view'
KDCustomHTMLView = require '../../core/customhtmlview'

module.exports = class KDFileUploadArea extends KDView
  # isDroppable:->
  #   return @droppingEnabled ? yes
  #
  # dropAccept:(item)=>
  #   yes
  #
  # dropOver:(event,ui)=>
  #   event.preventDefault()
  #   event.stopPropagation()
  #   @setClass "hover"
  #
  # dropOut:(event,ui)=>
  #   event.preventDefault()
  #   event.stopPropagation()
  #   @unsetClass "hover"

  dragEnter:(e)->
    e.preventDefault()
    e.stopPropagation()
    @setClass "hover"

  dragOver:(e)->
    e.preventDefault()
    e.stopPropagation()
    @setClass "hover"

  dragLeave:(e)->
    e.preventDefault()
    e.stopPropagation()
    @unsetClass "hover"

  drop:(jQueryEvent)->
    jQueryEvent.preventDefault()
    jQueryEvent.stopPropagation()
    @unsetClass "hover"

    orgEvent = jQueryEvent.originalEvent

    files = orgEvent.dataTransfer.files

    for file in files
      @getDelegate().fileDropped file
    no

  viewAppended:->
    title = @getOptions().title
    o = @getDelegate().getOptions()
    @setPartial "<span>#{title}</span>"
    @addSubView new KDCustomHTMLView
      cssClass    : "info"
      tagName     : "span"
      tooltip     :
        title     : "Max. File Amount: <b>#{o.limit}</b> files<br/>Max. File Size: <b>#{o.fileMaxSize}</b> kbytes<br/>Max. Total Size: <b>#{o.totalMaxSize}</b> kbytes"
        placement : "above"
        offset    : 0
        delayIn   : 300
        html      : yes
        animate   : yes
        selector  : null
        partial   : "i"