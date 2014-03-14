
container = new KDView

container.addSubView new KDHeaderView
  type  : 'big'
  title : 'KD Framework Playground'

container.addSubView new KDCustomHTMLView
  partial : "Of brilliant syntheses not a sunrise but a galaxyrise. Drake Equation, decipherment radio telescope culture. Citizens of distant epochs. Bits of moving fluff venture dispassionate extraterrestrial observer, hundreds of thousands. Star stuff harvesting star light a very small stage in a vast cosmic arena, a billion trillion a still more glorious dawn awaits, hundreds of thousands the only home we've ever known colonies kindling the energy hidden in matter radio telescope, preserve and cherish that pale blue dot network of wormholes. Kindling the energy hidden in matter Jean-François Champollion Drake Equation star stuff harvesting star light birth star stuff harvesting star light a very small stage in a vast cosmic arena the sky calls to us, of brilliant syntheses. Shores of the cosmic ocean the only home we've ever known consciousness? Rig Veda the sky calls to us are creatures of the cosmos shores of the cosmic ocean tesseract gathered by gravity a mote of dust suspended in a sunbeam!"

container.addSubView new KDButtonView
  title     : "Hello World!"
  callback  : ->
    new KDNotificationView
      title : "Hello World!!"

container.appendToDomBody()
