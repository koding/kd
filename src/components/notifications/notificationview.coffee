KDView       = require './../../core/view.coffee'
KDLoaderView = require './../loader/loaderview.coffee'

###*
 * A simple view for creating notifications for varying styles.
 *
 * ## Usage
 *
 * ```coffee
 * new KDNotificationView
 *   content: "Hello, from the most simple Notification View"
 * ```
 *
 * The first thing you'll likely notice with this example, is that we aren't
 * really *doing* anything with this notification. We just create it.. and that's
 * it. We're not assigning it to a variable, or adding it as a subview. This
 * because unlike many other views, KDNotificationView doesn't *need* to be added
 * to another view.  This is because it pops up over the UI.
 *
 * So, if you run this, you will immediately see a notification popup which will
 * look something like this:
 *
 * ![Notification Image](./docs/img-kdnotification-01.png)
 *
 * This seems a little too easy though, so lets make it a bit more complex.
 *
 * ```coffee
 * new KDNotificationView
 *   type: 'tray'
 *   showTimer: true
 *   duration: 12000
 *   closeManually: true
 *   title: 'Stranger Danger'
 *   content: 'We just met, you are a stranger to me..'
 *   followUps: [
 *     {
 *       title: 'Friendly neighbor'
 *       content: "Okay, we've known each other for 4 seconds.. you're okay."
 *       duration: 3000
 *     }
 *     {
 *       title: 'Overly attached family'
 *       content: "We've known each other for 8 seconds. We're basically family!"
 *       duration: 3000
 *     }
 *   ]
 * ```
 *
 * Well now we're getting somewhere, this is far more complex! We'll go over each
 * option in the constructor method options below, but lets sum up
 * what this notification does.
 *
 * First, we are creating a `tray` notification, that shows the timer. The
 * duration of the notification is `12000` milliseconds, and the user can close
 * the notification manually via the `closeManually` key, which puts a little
 * close button onto our tray.
 *
 * The `title` and `content` of the notification are pretty self explanatory.
 * `followUps` on the other hand, is where it gets fun.
 *
 * `followUps` takes a list of objects. Each object represents a different title
 * and content for this notification. The `duration` of the followUp, represents
 * how long it will be before it is shown.
 *
 * So, when you run this the notification will pop up with the first
 * title/message, `"Stranger danger"`. Then after 3 seconds, the title/message
 * combo will change to `"Friendly neighbor"`. Finally, after another 3 seconds
 * *(a total of 6 seconds)*, the title/message combo will change to `"Overly
 * attached family"`. This final message will last for another 6 seconds, until
 * the total notification time of 12 seconds has elapsed.
###
module.exports = class KDNotificationView extends KDView
  ###*
   * Options supports the following keys.
   * - **options.type**: The visual appearance type of this notification.
   *   Supports the options `"tray"`, `"growl"`, `"mini"`, `"sticky"`, `""`.
   * - **options.title**: The title of the notification.
   * - **options.content**: The body message of the notification.
   * - **options.duration**: The duration that the timer will be displayed, in 
   *   milliseconds. Defaults to `1500`
   * - **options.showTimer**: Whether or not to show the time left, in seconds.
   *   Defaults to `false`
   * - **options.closeManually**: Display a close button for the user to close 
   *   the timer. Defaults to `false`
   * - **options.loader**: An object of options to be passed to a KDLoaderView
   *   instance.
   * - **options.followUps**: A list of objects containing a `duration`,
   *   `title`, and/or `content` values. Example:
   *   ```
   *   [
   *     {title: 'Bar', duration: 1000},
   *     {title: 'Baz', duration: 1000}
   *   ]
   *   ```
   *
   * @param {Object} options
   * @param {Object} data
  ###
  constructor:(options)->
    super options
    options = @notificationSetDefaults options

    @notificationSetType        options.type
    @notificationSetTitle       options.title         if options.title?
    @notificationSetContent     options.content       if options.content?
    @notificationSetTimer       options.duration      if options.duration?
    @notificationSetOverlay     options.overlay       if options.overlay?
    @notificationSetFollowUps   options.followUps     if options.followUps?
    @notificationShowTimer()                          if options.showTimer?
    @notificationSetCloseHandle options.closeManually

    @once "viewAppended",       @bound "setLoader"    if options.loader

    @notificationDisplay()

  # OVERRIDE KDView
  setDomElement:(cssClass = '')->
    @domElement = $ "<div class='kdnotification #{cssClass}'>
        <a class='kdnotification-close hidden'></a>
        <div class='kdnotification-timer hidden'></div>
        <div class='kdnotification-title'></div>
        <div class='kdnotification-content hidden'></div>
      </div>"

  destroy:->
    @notificationCloseHandle.unbind ".notification"
    @notificationOverlay.remove() if @notificationOverlay?
    super()
    @notificationStopTimer()
    @notificationRepositionOtherNotifications()

  viewAppended:-> @notificationSetPositions()

  # OWN METHODS
  notificationSetDefaults:(options)->
    options.duration      ?= 1500
    if options.duration > 2999 or options.duration is 0
      options.closeManually ?= yes
    return options

  notificationSetTitle:(title)->
    unless title instanceof KDView
      @$().find(".kdnotification-title").html title
    else
      @notificationTitle.destroy() if @notificationTitle and \
                                      @notificationTitle instanceof KDView
      @addSubView title, ".kdnotification-title"
    @notificationTitle = title

  notificationSetType:(type = "main")->
    @notificationType = type

  notificationSetPositions:->
    @setClass @notificationType
    sameTypeNotifications = $("body").find ".kdnotification.#{@notificationType}"

    if @getOptions().container
      winHeight = @getOptions().container.getHeight()
      winWidth  = @getOptions().container.getWidth()
    else
      winWidth  = window.innerWidth
      winHeight = window.innerHeight

    switch @notificationType
      when "tray"
        bottomMargin = 8
        for notification,i in sameTypeNotifications
          bottomMargin += $(notification).outerHeight(no) + 8 if i isnt 0
        styles =
          bottom: bottomMargin
          right : 8
          paddingRight: if @options.content and @options.title then 10 else 25
      when "growl"
        topMargin = 63
        for notification,i in sameTypeNotifications
          topMargin += $(notification).outerHeight(no) + 8 if i isnt 0
        styles =
          top   : topMargin
          right : 8
      when "mini"
        styles =
          top   : 0
          left  : winWidth/2 - @getDomElement().width()/2
      when "sticky"
        styles =
          top   : 0
          left  : winWidth/2 - @getDomElement().width()/2
      else
        styles =
          top   : winHeight/2 - @getDomElement().height()/2
          left  : winWidth/2 - @getDomElement().width()/2

    @getDomElement().css styles

  notificationRepositionOtherNotifications:->

    sameTypeNotifications = $("body").find ".kdnotification.#{@notificationType}"
    heights = ($(elm).outerHeight(no) for elm,i in sameTypeNotifications)

    for elm,i in sameTypeNotifications
      switch @notificationType
        when "tray", "growl"
          newValue = 0
          position = if @notificationType is "tray" then "bottom" else "top"
          for h,j in heights[0..i]
            if j isnt 0 then newValue += h else newValue = 8
          options = {}
          options[position] = newValue + i*8
          $(elm).css options

  notificationSetCloseHandle:(closeManually = no)->
    @notificationCloseHandle = @getDomElement().find ".kdnotification-close"
    if closeManually
      @notificationCloseHandle.removeClass "hidden"

    @notificationCloseHandle.bind "click.notification",(e)=> @destroy()
    $(window).bind "keydown.notification",(e)=> @destroy() if e.which is 27

  notificationSetTimer:(duration)->
    return if duration is 0
    @notificationTimerDiv = @getDomElement().find ".kdnotification-timer"
    @notificationTimerDiv.text Math.floor duration/1000

    @notificationTimeout = setTimeout ()=>
      @getDomElement().fadeOut 200,()=>
        @destroy()
    ,duration

    @notificationInterval = setInterval ()=>
      next = parseInt(@notificationTimerDiv.text(),10) - 1
      @notificationTimerDiv.text next
    ,1000

  notificationSetFollowUps: (followUps)->

    followUps = [followUps]  unless Array.isArray followUps
    chainDuration = 0

    followUps.forEach (followUp)=>

      chainDuration += followUp.duration ? 10000

      @utils.wait chainDuration, =>
        @notificationSetTitle   followUp.title    if followUp.title
        @notificationSetContent followUp.content  if followUp.content
        @notificationSetPositions()

  notificationShowTimer:()->
    @notificationTimerDiv.removeClass "hidden"
    @getDomElement().bind "mouseenter",()=>
      @notificationStopTimer()
    @getDomElement().bind "mouseleave",()=>
      newDuration = parseInt(@notificationTimerDiv.text(),10)*1000
      @notificationSetTimer newDuration

  notificationStopTimer:->
    clearTimeout @notificationTimeout
    clearInterval @notificationInterval

  notificationSetOverlay:(options)->

    options.transparent     ?= yes
    options.destroyOnClick  ?= yes

    @notificationOverlay = $ "<div/>",
      class : "kdoverlay transparent"
    @notificationOverlay.hide()
    @notificationOverlay.removeClass "transparent"  unless options.transparent
    @notificationOverlay.appendTo "body"
    @notificationOverlay.fadeIn 200
    @notificationOverlay.bind "click",()=>
      @destroy()  if options.destroyOnClick
  notificationGetOverlay:()-> @notificationOverlay

  setLoader:->
    @setClass "w-loader"
    {loader} = @getOptions()

    diameters =
      tray    : 25
      growl   : 30
      mini    : 18
      sticky  : 25

    loader.diameter = diameters[@notificationType] or 30

    @loader = new KDLoaderView
      size          :
        width       : loader.diameter
      loaderOptions :
        color       : loader.color    or "#ffffff"
        shape       : loader.shape    or "spiral"
        diameter    : loader.diameter
        density     : loader.density   ? 30
        range       : loader.range     ? 0.4
        speed       : loader.speed     ? 1.5
        FPS         : loader.FPS       ? 24

    @addSubView @loader, null, yes

    @setCss "paddingLeft", loader.diameter * 2
    @loader.setStyle
      position    : "absolute"
      left        : loader.left or Math.floor loader.diameter / 2
      top         : loader.top  or "50%"
      marginTop   : -(loader.diameter/2)

    @loader.show()

  showLoader:->
    @setClass "loading"
    @loader.show()

  hideLoader:->
    @unsetClass "loading"
    @loader.hide()

  notificationSetContent:(content)->
    @notificationContent = content
    @getDomElement().find(".kdnotification-content").removeClass("hidden").html content

  notificationDisplay:->
    if @getOptions().container
      @getOptions().container.addSubView @
    else
      @appendToDomBody()
