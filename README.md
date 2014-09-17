KD [![Build Status](https://img.shields.io/travis/koding/kd/master.svg?style=flat)](https://travis-ci.org/koding/kd) [![Dependency Status](https://img.shields.io/david/dev/koding/kd.svg?style=flat)](https://david-dm.org/koding/kd#info=devDependencies) [![Dependency Status](https://img.shields.io/david/koding/kd.svg?style=flat)](https://david-dm.org/koding/kd#info=dependencies)
--
_a non-document focused UI Framework for web applications._

Install gulp:

```bash
$ npm install gulp -g
```


Build steps:

```bash
$ npm i
$ gulp
```

Before building make sure you have these installed:

- [node](http://nodejs.org)
- [gulp](http://gulpjs.com/)

#### Build the documentation website or create a playground

Documentation website is under `/docs` folder, it is a great example to check how a site can be put together with KD.

You can build & run it by doing:

```bash
$ gulp --docs
```

or you can create playground to fiddle with the components with this:

```bash
$ gulp --play
```


#### Test Runner

KD uses [karma](http://karma-runner.github.io) for automatically running
tests. To launch karma, run

```bash
$ gulp karma
```

If you're editing test files, you'll also need to run the test watcher
to automatically build the test files:

```bash
$ gulp watch-test
```

There is also an html based test runner, which can be useful for
debugging tests. If you're running the playground server (started by
running `gulp`) the tests are available by going to

[http://localhost:8080/test/index.html](http://localhost:8080/test/index.html)

Alternately, you can view the tests directly in the browser:

```bash
$ open test/index.html
```

#### Running tests on Saucelabs

You can also run tests remotely on [SauceLabs](https://saucelabs.com)
browsers.

First, expose your saucelabs username and access key as environment
variables

```bash
$ export SAUCE_USERNAME=your-username SAUCE_ACCESS_KEY=your-access-key
```

Then fire up the SauceLabs test runner with

```bash
$ gulp sauce
```

The available browser definitions are configured in the
`customLaunchers` key in `karma.conf.js` and then
selected in the 'sauce' task in `gulpfile.coffe`.


------------------------

#### Disclaimer

__The framework is not well documented yet and the unit tests are in very early stage, any pull requests in this direction is highly appreciated.__
