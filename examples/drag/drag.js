var main = new kd.View({ cssClass: 'lobilo' })
main.appendToDomBody()

var header = new kd.CustomHTMLView({
  partial: 'Drag scaled items',
  tagName: 'h1',
})
var foo = new kd.View({ cssClass: 'foo', draggable: true })
var bar = new kd.View({ cssClass: 'bar', draggable: { containment: true } })
var baz = new kd.View({ cssClass: 'baz', draggable: { containment: true } })

bar.addSubView(baz)
foo.addSubView(bar)

main.addSubView(header)
main.addSubView(foo)
