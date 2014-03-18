gulp       = require 'gulp'
gulpif     = require 'gulp-if'
gutil      = require 'gulp-util'
browserify = require 'gulp-browserify'
rename     = require 'gulp-rename'
uglify     = require 'gulp-uglify'
stylus     = require 'gulp-stylus'
livereload = require 'gulp-livereload'
concat     = require 'gulp-concat'
minifyCSS  = require 'gulp-minify-css'
fs         = require 'fs'
http       = require 'http'
coffee     = require 'coffee-script'
argv       = require('minimist') process.argv
source     = require 'vinyl-source-stream'
ecstatic   = require 'ecstatic'
readdir    = require 'recursive-readdir'
{exec}     = require 'child_process'

pistachioCompiler = require 'gulp-pistachio-compiler'

STYLES_PATH = require './src/themes/styl.includes.coffee'
COFFEE_PATH = ['./src/components/**/*.coffee','./src/core/**/*.coffee','./src/init.coffee']
LIBS_PATH   = ['./libs/*.js']
TEST_PATH   = ['./test/**/*.coffee']
LIBS        = require './src/lib.includes.coffee'

buildDir       = argv.outputDir ? 'build'
version        = if argv.buildVersion then "#{argv.buildVersion}." else ''
useLiveReload  = !!argv.liveReload
useUglify      = !!argv.uglify
useMinify      = !!(argv.minify ? yes)

# Build Tasks

gulp.task 'styles', ->

  stream = gulp.src STYLES_PATH
    .pipe stylus()
    .pipe concat "kd.css"
    .pipe gulpif useMinify, minifyCSS()
    .pipe gulp.dest "playground/css"
    .pipe rename "kd.#{version}css"
    .pipe gulp.dest "#{buildDir}/css"

  stream.pipe livereload()  if useLiveReload


gulp.task 'libs', ->

  stream = gulp.src LIBS
    # .pipe gulpif useUglify, uglify()
    .pipe uglify()
    .pipe concat "kd.libs.js"
    .pipe gulp.dest "playground/js"
    .pipe gulp.dest "test"
    .pipe rename "kd.libs.#{version}js"
    .pipe gulp.dest "#{buildDir}/js"

  stream.pipe livereload()  if useLiveReload


gulp.task 'coffee', ->

  entryPath = './src/entry.coffee'
  exec "cd ./src;sh exporter.sh > entry.coffee; cd ..", (err)->
    # Throw here maybe?
    console.error err  if err?

    stream = gulp.src entryPath, { read: false }
      .pipe browserify
        transform   : ['coffeeify']
        extensions  : ['.coffee']
        debug       : yes
      .pipe gulpif useUglify, uglify()
      .pipe pistachioCompiler()
      .pipe concat "kd.js"
      .pipe gulp.dest "playground/js"
      .pipe rename "kd.#{version}js"
      .pipe gulp.dest "#{buildDir}/js"

    stream.pipe livereload()  if useLiveReload


gulp.task 'test', ->

  stream = gulp.src './test/test.coffee', { read: false }
    .pipe browserify
      transform  : ['coffeeify']
      extensions : ['.coffee']
      debug      : yes
    .pipe concat "kd.test.js"
    .pipe gulp.dest 'test'

  if useLiveReload
    stream.pipe livereload()
    gulp.src './test/index.html'
      .pipe livereload()


gulp.task 'play', ->

  stream = gulp.src "./playground/main.coffee", { read: false }
    .pipe browserify
      transform   : ['coffeeify']
      extensions  : ['.coffee']
      debug       : yes
    .pipe concat "main.js"
    .pipe gulp.dest "playground/js"

  if useLiveReload
    stream.pipe livereload()
    gulp.src './playground/index.html'
      .pipe livereload()


gulp.task 'live', -> useLiveReload = yes

# Watch Tasks

watchLogger = (color, watcher) ->
  watcher.on 'change', (event) ->
    gutil.log gutil.colors[color] "file #{event.path} was #{event.type}"


gulp.task 'watch-test', ->
  watcher = gulp.watch TEST_PATH, ['test']
  watchLogger 'cyan', watcher


gulp.task 'watch-coffee', ->
  watcher = gulp.watch COFFEE_PATH, ['coffee']
  watchLogger 'yellow', watcher


gulp.task 'watch-libs', ->
  watcher = gulp.watch LIBS_PATH, ['libs']
  watchLogger 'yellow', watcher


gulp.task 'watch-styles', ->
  watcher = gulp.watch STYLES_PATH, ['styles']
  watchLogger 'yellow', watcher


gulp.task 'watch-playground', ->
  watcher = gulp.watch [
    './playground/**/*.coffee'
    './playground/**/*.styl'
    './playground/**/*.html'
  ], ['play']

  watchLogger 'blue', watcher


# Aggregate Tasks

gulp.task 'compile', ['styles', 'libs', 'coffee', 'test']

defaultTasks = [
  'live', 'compile', 'play',
  'watch-styles', 'watch-coffee', 'watch-libs',
  'watch-playground', 'watch-test'
]

gulp.task 'default', defaultTasks , ->

  http.createServer ecstatic root : "#{__dirname}/playground"
    .listen(8080)
  gutil.log gutil.colors.blue 'HTTP server ready localhost:8080'
