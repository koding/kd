gulp       = require 'gulp'
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
source     = require 'vinyl-source-stream'
ecstatic   = require 'ecstatic'
readdir    = require 'recursive-readdir'

STYLES_PATH = ['./src/themes/**/*.css','./src/themes/default/**/*.styl']
ENTRY_PATH  = ['./src/init.coffee']
COFFEE_PATH = ['./src/components/**/*.coffee','./src/core/**/*.coffee','./src/init.coffee']
LIBS        = require './src/lib.includes.coffee'


gulp.task 'styles', ->

  gulp.src(STYLES_PATH)
    .pipe(stylus())
    .pipe(concat 'app.css')
    .pipe(minifyCSS())
    .pipe(gulp.dest 'build/css')
    .pipe(livereload());


gulp.task 'libs', ->

  gulp.src(LIBS)
    .pipe(uglify())
    .pipe(concat 'libs.js')
    .pipe(gulp.dest 'build/js')
    .pipe(livereload());


gulp.task 'coffee', ->

  readdir './src', (err, files)->
    entryPath = './src/entry.coffee'
    entryFile = ''
    for file in files when /\.coffee$/.test file
      entryFile += "require '#{file.replace 'src/', ''}'\n"

    fs.writeFileSync entryPath, entryFile

    gulp.src(entryPath, { read: false })
      .pipe(browserify
        transform   : ['coffeeify']
        extensions  : ['.coffee']
        debug       : yes
      )
      # .pipe(uglify())
      .pipe(rename 'main.js')
      .pipe(gulp.dest 'build/js')
      .pipe(livereload())


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


gulp.task 'default', ['styles', 'libs', 'coffee', 'watch-styles', 'watch-coffee', 'watch-libs'], ->

  fs.writeFileSync './build/index.html', fs.readFileSync './src/index.html'
  http.createServer(ecstatic {root: "#{__dirname}/build"}).listen(8080)
  gutil.log gutil.colors.blue 'HTTP server ready localhost:8080'
