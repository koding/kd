var kd = require('../lib/index');

var main = new kd.View;
main.appendToDomBody();

var flex = new kd.FlexSplit({
  cssClass: 'mainview',
  resizable: true,
  type: kd.Flex.VERTICAL,
  views: [
    new kd.FlexSplit({
      sizes: [ 40, 60 ],
      views: [
        new kd.View({ partial: 'left top' }),
        new kd.View({ partial: 'left bottom' })
      ]
    }),
    new kd.FlexSplit({
      sizes: [ 20, 80 ],
      views: [
        new kd.View({ partial: 'right top' }),
        new kd.View({ partial: 'right bottom' })
      ]
    })
  ]
})

var input = new kd.InputView;
var form = new kd.View;

form.addSubView(input);
form.addSubView(new kd.ButtonView({
  title: 'i\'m a button. type in your name and click on me',
  callback: function () {
    alert('sup ' + input.getValue())
  }
}));

var tabs = new kd.TabView({
  hideHandleCloseIcons: true,
  attributes: {
    style: 'height: 100vh'
  },
  paneData: [
    {
      title: 'tab1',
      partial: 'that\'s me, tab1'
    },
    {
      title: 'form',
      view: form
    },
    {
      title: 'flex split',
      view: flex
    }
  ]
});

main.addSubView(tabs);