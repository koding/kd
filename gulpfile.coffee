gulp = require 'gulp'
karma = require 'karma'
path = require 'path'

server = (singleRun, browsers, done) ->
  new karma.Server({
    configFile: path.join __dirname, 'karma.conf.js'
    singleRun
    browsers
  }, done)

gulp.task 'test', (done) ->
  server(no, ['Chrome'], done).start()

gulp.task 'travis-test', (done) ->
  server(yes, ['Chrome_travis_ci'], done).start()
