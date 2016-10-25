[![Build Status](https://img.shields.io/travis/anonrig/kd.svg?style=flat)](https://travis-ci.org/koding/kd) [![Coverage Status](https://img.shields.io/coveralls/anonrig/kd.svg?style=flat)](https://coveralls.io/github/koding/kd?branch=master)

# kd.js

a collection of ui widgets and other nice things.

```
npm i kd.js
```

# usage

```js
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
```

# example

Type `make example` and go to http://localhost:3000/example. This also starts a `watchify` process, so any changes you make in `example/index.js` will be recompiled on the spot.

# development

To watch `lib` and build standalone umd package into `dist` folder upon changes, type: `make development-dist`

If you want to recompile each coffee individually into `build` folder, type: `make development`

Since `package.json` exposes only `build` folder; if you are bundling kd.js with browserify, second method (along with a `npm link`) might be a better option.

# license

mit

