var code = `
  var one = new kd.View(
    {
      pistachio: '{{ #(clicked == \`yes\` ? \`Hi user, thanks!\` : \`Click here!\`) }}',
      click: () => one.setData({ clicked: 'yes' }),
    },
    { clicked: 'no' }
  )

  one.appendToDomBody()

`
eval(code)

new kd.CustomHTMLView({
  tagName: 'pre',
  partial: code,
}).appendToDomBody()

code = `
  var two = new kd.View({

    pistachio: '{{ #(clicked < 5 ? \\
      \`Click here to buy me an apple! I need 5 apples.\` : \\
      \`Thanks user!\`) }} {{ #(apples) }} \\
      I have {{ #(apples.length) }} apple{{ #(apples.length != 1 ? \`s\`)}}',

    click: () => {
      let { clicked, apples } = two.getData()
      clicked += 1
      apples.push('🍎')
      if (clicked == 6) {
        apples = []
        clicked = 0
      }
      two.setData({ clicked, apples })
    },

  }, { clicked: 0, apples: [] })  // Initial data

  two.appendToDomBody()

`

eval(code)

new kd.CustomHTMLView({
  tagName: 'pre',
  partial: code,
}).appendToDomBody()
