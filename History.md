
1.0.10 / 2015-03-08
==================

 * Merge pull request #8 from tetsuo/bump-up-jspath
 * npm: bump up jspath

1.0.9 / 2015-03-04
==================

 * Merge pull request #6 from alex-ionochkin/82401098-custom-scroll-keyboard-handling
 * customview: fix for incorrect constant name
 * customscroll: document keydown event unbinding, refactoring
 * customscroll: char code constants
 * customscroll: keyboard handling
 * Merge pull request #7 from sinan/get-rid-of-kdfsprite-and-sourcemaps-on-dist
 * styles: get rid of kdfsprite() util
 * dist: css/js w/o sourcemaps

1.0.7 / 2015-02-27
==================

 * windowController: focusChange improved (https://github.com/tetsuo/kd/pull/5)

1.0.6 / 2015-02-27
==================

 * Close dialog on ESC (https://github.com/tetsuo/kd/pull/4)

1.0.3 / 2015-02-19
==================

 * add changelog
 * bump up htmlencode

1.0.2 / 2015-02-19
==================

* `playground` folder is gone. Typing `make example` starts a simple development server and recompiles files upon changes in `example` folder
* added touch support to `scrollview`
* to watch `lib` folder and build a standalone umd package into `dist` folder, you type `make development-dist`
* to compile each file individually into `build` folder upon changes, type `make development`

1.0.1 / 2015-02-9
==================

* browserified and re-listed on npm as `kd.js`
* umd build (`dist/kd.js`) exposes only `kd` to global scope now on
* we are exporting all classes and methods without the `KD` prefix

Example:

```coffeescript
kd = require 'kd'

class X extends kd.View
```

* styl entry file is now being transpiled with `--include-css`
* `test` & `docs` became obsolete and removed
* `KD.EventEmitter.Wildcard` is changed to `kd.EventEmitterWildcard`
* `underscore` is removed
* `jquery-timeago` is changed with `timeago` package on npm
* added `kd.singleton` (alias for `kd.getSingleton`)
* moved `lib/themes` to `styles`
* all `window` calls/assignment are changed to `global` (see: browserify)
* removed `gulpfile`, added `Makefile`
