module.exports =

  INSTANCE_TYPE   : 'KDFlexSplit'

  EVENT_HIDE      : 'KDFlexSplit.HIDE'
  EVENT_RESIZE    : 'KDFlexSplit.RESIZE'
  EVENT_EXPAND    : 'KDFlexSplit.EXPAND'
  EVENT_COLLAPSE  : 'KDFlexSplit.COLLAPSE'

  EVENT_HIDDEN    : 'KDFlexSplit.HIDDEN'
  EVENT_RESIZED   : 'KDFlexSplit.RESIZED'
  EVENT_EXPANDED  : 'KDFlexSplit.EXPANDED'
  EVENT_COLLAPSED : 'KDFlexSplit.COLLAPSED'

  MAX : 100
  MIN : 0.0001

  HORIZONTAL :
    name     : 'horizontal'
    axis     : 'y'
    getter   : 'getHeight'

  VERTICAL   :
    name     : 'vertical'
    axis     : 'x'
    getter   : 'getWidth'
