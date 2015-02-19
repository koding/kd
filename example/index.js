var kd = require('../lib/index');

var main = new kd.View;
main.appendToDomBody();

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
  paneData: [
    {
      title: 'tab1',
      partial: 'that\'s me, tab1'
    },
    {
      title: 'form',
      view: form
    }
  ]
});

main.addSubView(tabs);