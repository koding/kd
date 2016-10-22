gulp = require 'gulp'
karma = require 'karma'
path = require 'path'

server = (singleRun, done) ->
  new karma.Server({
    configFile: path.join __dirname, 'karma.conf.js'
    singleRun
  }, done)

gulp.task 'test', (done) ->
  server(no, done).start()

gulp.task 'travis-test', (done) ->
  server(yes, done).start()
