class Split extends KDSplitView

  constructor:(o={},d)->
    o.panelClass = Panel
    super o, d

class Panel extends KDSplitViewPanel

  counter   = 0

  getNumber = ->
    v = KD.utils.getRandomNumber(2000)
    getNumber()  if v < 500
    return v

  viewAppended: ->

    return if counter > 500

    KD.utils.wait getNumber(), =>
      @parent.splitPanel @index
      counter++

do ->
  r = -> KD.utils.getRandomNumber(100)/100
  view = new KDView
    partial : '<h1>Split Frenzy!!!</h1>'

  view.addSubView new KDButtonView
    title    : 'Click to start'
    cssClass : 'cupid-green'
    callback : ->
      @destroy()
      view.updatePartial ""
      view.addSubView new KDSplitView
        splitClass : Split
        panelClass : Panel
        type       : 'horizontal'
        colored    : yes

# split1 = new KDSplitView
#   type    : 'horizontal'
  # minimums: ['20%']
  # maximums: ['60%']
  # sizes   : ['100%']
  # views   : [
  #   new KDButtonView title : 'My button'
  # ,
  #   new KDInputView placeholder : 'my input'
  #   new KDSplitView
  #     type    : 'horizontal'
  #     views   : [
  #       new KDSplitView
  #         type    : 'horizontal'
  #         sizes   : [r(), 'auto']
  #         colored : yes
  #     ,
  #       new KDSplitView
  #         colored : yes
  #     ]
  # ,
  #   new KDSplitView
  #     sizes   : [r(), 'auto']
  #     views   : [
  #       new KDSplitView
  #         type    : 'horizontal'
  #         colored : yes
  #     ,
  #       new KDSplitView
  #         sizes   : [r(), 'auto']
  #         colored : yes
  #     ]
  # ]

  view.appendToDomBody()
