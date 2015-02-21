
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
