var main = new kd.View()
main.appendToDomBody()

var scene = new kd.DiaScene({
  cssClass: 'main-scene',
})

scene.addContainer(
  (container1 = new kd.DiaContainer({
    cssClass: 'container-1',
    draggable: true,
    partial: 'drag me',
  })),
  { x: 60, y: 60 }
)

scene.addContainer(
  (container2 = new kd.DiaContainer({
    cssClass: 'container-2',
    draggable: true,
    partial: 'drag me',
  })),
  { x: 500, y: 100 }
)

var circle1 = container1.addDia(
  new kd.DiaObject({
    cssClass: 'circle',
    partial: 'drag me',
  }),
  { x: 20, y: 20 }
)

var circle2 = container2.addDia(
  new kd.DiaObject({
    cssClass: 'circle',
    partial: 'drag me',
  }),
  { x: 20, y: 20 }
)

var square1 = container1.addDia(
  new kd.DiaObject({
    cssClass: 'square',
    partial: 'drag me',
  }),
  { x: 100, y: 100 }
)

var square2 = container2.addDia(
  new kd.DiaObject({
    cssClass: 'square',
    partial: 'drag me',
  }),
  { x: 100, y: 100 }
)

var connection1 = scene.connect(
  { dia: circle1, joint: 'right' },
  { dia: circle2, joint: 'left' }
)

var connection2 = scene.connect(
  { dia: square1, joint: 'right' },
  { dia: square2, joint: 'left' }
)

var transfer1, transfer2

function startTransfer1() {
  transfer1 = scene.addTransfer(connection1, {
    text: 'ping',
    duration: 3000,
    color: 'blue',
  })
  scene.once(`Transfer-${transfer1}-Done`, () => {
    transfer1 = scene.addTransfer(connection1, {
      text: 'pong',
      duration: 3000,
      color: 'green',
      reverse: true,
    })
    scene.once(`Transfer-${transfer1}-Done`, startTransfer1)
  })
}

function startTransfer2() {
  transfer2 = scene.addTransfer(connection2, {
    duration: 1000,
    size: 4,
    color: 'red',
  })
  scene.on(`Transfer-${transfer2}-Done`, () => {
    transfer2 = scene.addTransfer(connection2, {
      size: 4,
      duration: 1000,
      color: 'blue',
      reverse: true,
    })
    scene.once(`Transfer-${transfer2}-Done`, startTransfer2)
  })
}

startTransfer1()
startTransfer2()

main.addSubView(scene)
