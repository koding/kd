var code = `
  // Create a new kd.Data with initial data
  var date = new kd.Data({ now: new Date() })

  // Create a view pistachio and the data created above
  var main = new kd.View({ pistachio: "Now it's {strong{ #(now) }}, bye." }, date)

  // Update the data every second
  kd.utils.repeat(1000, () => date.now = new Date())

  main.appendToDomBody()

`
eval(code)

new kd.CustomHTMLView({
  tagName: 'pre',
  partial: code,
}).appendToDomBody()

code = `
  // Create a new kd.Data with initial data
  var basket = new kd.Data([])

  // Create a view pistachio and the data created above
  var main = new kd.View({
    pistachio: "I'll add an 🍎 into basket every 2 seconds. " +
               "Now I've {strong{ #(length) }} 🍎 in the basket."
  }, basket)

  // Update the data every second
  kd.utils.repeat(2000, () => basket.push('🍎'))

  main.appendToDomBody()

`
eval(code)

new kd.CustomHTMLView({
  tagName: 'pre',
  partial: code,
}).appendToDomBody()
