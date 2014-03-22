gulp       = require 'gulp'
gulpif     = require 'gulp-if'
gutil      = require 'gulp-util'
browserify = require 'browserify'
coffeeify  = require 'coffeeify'
rename     = require 'gulp-rename'
uglify     = require 'gulp-uglify'
stylus     = require 'gulp-stylus'
livereload = require 'gulp-livereload'
concat     = require 'gulp-concat'
minifyCSS  = require 'gulp-minify-css'
karma      = require 'gulp-karma'
fs         = require 'fs'
http       = require 'http'
coffee     = require 'coffee-script'
argv       = require('minimist') process.argv
source     = require 'vinyl-source-stream'
gulpBuffer = require 'gulp-buffer'
ecstatic   = require 'ecstatic'
readdir    = require 'recursive-readdir'
{exec}     = require 'child_process'

pistachioCompiler = require 'gulp-pistachio-compiler'

gulpBrowserify = (options, bundleOptions) ->
  options.extensions or= ['.coffee']
  bundleOptions or= {}
  b = browserify options
  b.transform coffeeify
  b.bundle bundleOptions

STYLES_PATH = require './src/themes/styl.includes.coffee'
ENTRY_PATH  = ['./playground/main.coffee']
COFFEE_PATH = ['./src/components/**/*.coffee','./src/core/**/*.coffee','./src/init.coffee']
LIBS_PATH   = ['./libs/*.js']
TEST_PATH   = ['./src/**/*.test.coffee']
LIBS        = require './src/lib.includes.coffee'

buildDir       = argv.outputDir ? 'build'
version        = if argv.buildVersion then "#{argv.buildVersion}." else ''
useLiveReload  = !!argv.liveReload
useUglify      = !!argv.uglify
useMinify      = !!(argv.minify ? yes)
karmaAction    = 'watch'


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

    stream = gulpBrowserify
        entries : entryPath
      .pipe source entryPath
      .pipe gulpBuffer()
      .pipe pistachioCompiler()
      .pipe gulpif useUglify, uglify()
      .pipe rename "kd.#{version}js"
      .pipe gulp.dest "playground/js"
      .pipe gulp.dest "#{buildDir}/js"

    stream.pipe livereload()  if useLiveReload


gulp.task 'coffee-test', ->
  stream = gulpBrowserify
      entries : './test/test.coffee'
    .pipe source "kd.test.js"
    .pipe gulp.dest 'test'


gulp.task 'karma', ['coffee-test'], ->
  gulp.src ['./test/kd.*']
    .pipe karma
      configFile : 'karma.conf.js'
      action     : karmaAction


gulp.task 'play', ->

  stream = gulpBrowserify
      entries : ENTRY_PATH
    .pipe source "main.js"
    .pipe gulp.dest "playground/js"

  if useLiveReload
    stream.pipe livereload()
    gulp.src './playground/index.html'
      .pipe livereload()

gulp.task 'sauce', ->
  gulp.src ['./test/kd.*']
    .pipe karma
      browsers   : [
        'sl_firefox_windows'
        'sl_chrome_windows'
        'sl_ie_9'
        'sl_ie_10'
      ]
      configFile : 'karma.conf.js'
      action     : 'run'



gulp.task 'live', -> useLiveReload = yes

gulp.task 'run', -> karmaAction = 'run'

# Watch Tasks

watchLogger = (color, watcher) ->
  watcher.on 'change', (event) ->
    gutil.log gutil.colors[color] "file #{event.path} was #{event.type}"


gulp.task 'watch-test', ->
  watcher = gulp.watch TEST_PATH, ['coffee-test']
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
    './playground/**/*.html'
  ], ['play']

  watchLogger 'blue', watcher


# Aggregate Tasks

gulp.task 'compile', ['styles', 'libs', 'coffee']

defaultTasks = [
  'live', 'compile', 'play',
  'watch-styles', 'watch-coffee',
  'watch-libs', 'watch-playground'
]

gulp.task 'default', defaultTasks , ->

  http.createServer ecstatic root : "#{__dirname}/playground"
    .listen(8080)
  gutil.log gutil.colors.blue 'HTTP server ready localhost:8080'


process.on 'uncaughtException', (e)->
  gutil.log gutil.colors.red "An error has occured: #{e.name}"
  console.error e
