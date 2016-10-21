gulp = require 'gulp'
karma = require 'karma'
path = require 'path'

gulp.task 'test', (done) ->
  new karma.Server({
    configFile: path.join __dirname, 'karma.conf.js'
    singleRun: false
  }, done).start()
