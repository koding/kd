
button = new KDButtonView
  title    : "Hello World!"
  callback : ->
    new KDNotificationView
      title: "Hello World!!"

button.appendToDomBody()