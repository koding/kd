gulp = require 'gulp'
karma = require 'karma'
path = require 'path'

options = {
  configFile: path.join __dirname, 'karma.conf.js'
  singleRun: false
  browsers: ['Chrome']
  coverageReporter: {
    dir: 'coverage/'
    type: 'html'
  }
}
server = (options, done) ->
  new karma.Server(options, done)

gulp.task 'test', (done) ->
  server(options, done).start()

gulp.task 'travis-test', (done) ->
  options.singleRun = true
  options.coverageReporter.type = 'lcov'
  options.browsers = ['Chrome_travis_ci']
  server(options, done).start()
