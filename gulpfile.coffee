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

STYLES_PATH = require './src/themes/styl.includes.coffee'
ENTRY_PATH  = ['./playground/main.coffee']
COFFEE_PATH = ['./src/components/**/*.coffee','./src/core/**/*.coffee','./src/init.coffee']
LIBS        = require './src/lib.includes.coffee'

buildDir       = argv.outputDir ? 'build'
version        = if argv.buildVersion then "#{argv.buildVersion}." else ''
useLiveReload  = !!argv.liveReload
useUglify      = !!argv.uglify
useMinify      = !!(argv.minify ? yes)


gulp.task 'styles', ->

  stream = gulp.src(STYLES_PATH)
    .pipe(stylus())
    .pipe(concat "kd.css")
    .pipe(gulpif useMinify, minifyCSS())
    .pipe(gulp.dest "playground/css")
    .pipe(rename "kd.#{version}css")
    .pipe(gulp.dest "#{buildDir}/css")

  stream.pipe(livereload())  if useLiveReload


gulp.task 'libs', ->

  stream = gulp.src(LIBS)
    # .pipe(gulpif useUglify, uglify())
    .pipe(uglify())
    .pipe(concat "kd.libs.js")
    .pipe(gulp.dest "playground/js")
    .pipe(rename "kd.libs.#{version}js")
    .pipe(gulp.dest "#{buildDir}/js")

  stream.pipe(livereload())  if useLiveReload


gulp.task 'coffee', ->

  entryPath = './src/entry.coffee'
  exec "cd ./src;sh exporter.sh > entry.coffee; cd ..", (err)->
    # Throw here maybe?
    console.error err  if err?

    stream = gulp.src(entryPath, { read: false })
      .pipe(browserify
        transform   : ['coffeeify']
        extensions  : ['.coffee']
        debug       : yes )
      .pipe(gulpif useUglify, uglify())
      .pipe(concat "kd.js")
      .pipe(gulp.dest "playground/js")
      .pipe(rename "kd.#{version}js")
      .pipe(gulp.dest "#{buildDir}/js")

    stream.pipe(livereload())  if useLiveReload


gulp.task 'watch-coffee', ->

  watcher = gulp.watch COFFEE_PATH, ['coffee']

  watcher.on 'change', (event)->
    gutil.log gutil.colors.yellow "file #{event.path} was #{event.type}"


gulp.task 'watch-libs', ->

  watcher = gulp.watch './libs/*.js', ['libs']

  watcher.on 'change', (event)->
    gutil.log gutil.colors.yellow "file #{event.path} was #{event.type}"


gulp.task 'watch-styles', ->

  watcher = gulp.watch STYLES_PATH, ['styles']

  watcher.on 'change', (event)->
    gutil.log gutil.colors.magenta "file #{event.path} was #{event.type}"


gulp.task 'watch-playground', ->

  watcher = gulp.watch [
    './playground/**/*.coffee'
    './playground/**/*.html'
  ], ['play']

  watcher.on 'change', (event)->
    gutil.log gutil.colors.blue "file #{event.path} was #{event.type}"


gulp.task 'play', ->

  stream = gulp.src(ENTRY_PATH, { read: false })
    .pipe(browserify
      transform   : ['coffeeify']
      extensions  : ['.coffee']
      debug       : yes )
    .pipe(concat "main.js")
    .pipe(gulp.dest "playground/js")

  stream.pipe(livereload())  if useLiveReload

  if useLiveReload
    gulp.src('./playground/index.html').pipe(livereload())

gulp.task 'live', ->

  useLiveReload = yes


gulp.task 'compile', ['styles', 'libs', 'coffee']

gulp.task 'default', ['live', 'compile', 'play', 'watch-styles',  \
                      'watch-coffee', 'watch-libs', 'watch-playground'] , ->

  http.createServer(ecstatic {root: "#{__dirname}/playground"}).listen(8080)
  gutil.log gutil.colors.blue 'HTTP server ready localhost:8080'
