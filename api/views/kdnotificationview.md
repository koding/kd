
# KDNotificationView

A simple view for creating notifications for varying styles.

## Usage

```coffee
new KDNotificationView
  content: "Hello, from the most simple Notification View"
```

The first thing you'll likely notice with this example, is that we aren't 
really *doing* anything with this notification. We just create it.. and that's 
it. We're not assigning it to a variable, or adding it as a subview. This 
because unlike many other views, KDNotificationView doesn't *need* to be added 
to another view.  This is because it pops up over the UI.

So, if you run this, you will immediately see a notification popup which will 
look something like this:

![Notification Image](./img-kdnotification-01.png)

This seems a little too easy though, so lets make it a bit more complex.

```coffee
new KDNotificationView
  type: 'tray'
  showTimer: true
  duration: 12000
  closeManually: true
  title: 'Stranger Danger'
  content: 'We just met, you are a stranger to me..'
  followUps: [
    {
      title: 'Friendly neighbor'
      content: "Okay, we've known each other for 4 seconds.. you're okay."
      duration: 3000
    }
    {
      title: 'Overly attached family'
      content: "We've known each other for 8 seconds. We're basically family!"
      duration: 3000
    }
  ]
```

Well now we're getting somewhere, this is far more complex! We'll go over each 
option in the [constructor](#constructor) method options below, but lets sum up 
what this notification does.

First, we are creating a `tray` notification, that shows the timer. The 
duration of the notification is `12000` milliseconds, and the user can close 
the notification manually via the `closeManually` key, which puts a little 
close button onto our tray.

The `title` and `content` of the notification are pretty self explanatory.  
`followUps` on the other hand, is where it gets fun.

`followUps` takes a list of objects. Each object represents a different title 
and content for this notification. The `duration` of the followUp, represents 
how long it will be before it is shown.

So, when you run this the notification will pop up with the first 
title/message, `"Stranger danger"`. Then after 3 seconds, the title/message 
combo will change to `"Friendly neighbor"`. Finally, after another 3 seconds 
*(a total of 6 seconds)*, the title/message combo will change to `"Overly 
attached family"`. This final message will last for another 6 seconds, until 
the total notification time of 12 seconds has elapsed.

## API Index

> class KDNotificationView extends [KDView][kdview]
> - [constructor](#constructor): (options={}, data) ->

## [Class](https://github.com/koding/kd/blob/master/src/components/notifications/notificationview.coffee#L5)

KDNotificationView extends [KDView][kdview]. Please see that for inherited 
methods and options.

### [Constructor](https://github.com/koding/kd/blob/master/src/components/notifications/notificationview.coffee#L5)
> - [constructor](#constructor): (options={}, data) ->

#### Args

1. **options**:
    - Type: object
    - Default: `{}`

    The following keys are supported.

    - **options.type**: The visual appearance type of this notification.
      - Type: string
      - Default: `""` (The fallback option)
      - Options: `"tray"`, `"growl"`, `"mini"`, `"sticky"`, `""`
    - **options.title**: The title of the notification.
      - Type: string
      - Default: `null`
    - **options.content**: The body message of the notification.
      - Type: string
      - Default: `""`
    - **options.duration**: The duration that the timer will be displayed, in 
      milliseconds.
      - Type: number
      - Default: `1500`
    - **options.showTimer**: Whether or not to show the time left, in seconds.
      - Type: boolean
      - Default: `false`
    - **options.closeManually**: Display a close button for the user to close 
      the timer.
      - Type: boolean
      - Default: `false`
    - **options.loader**: An object of options to be passed to a 
      [KDLoaderView][kdloaderview] instance.
      - Type: [KDLoaderView][kdloaderview]
      - Default: `undefined`
    - **options.followUps**: A list of objects containing a `duration`, 
      `title`, and/or `content` values.
      - Type: list
      - Default: `undefined`
      - Example: `[{title: 'Bar', duration: 1000}, {title: 'Baz', duration: 
        1000}]`




[kdview]: ./kdview.md
[kdloaderview]: ./kdloaderview.md
