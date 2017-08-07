gulp = require 'gulp'
karma = require 'karma'
path = require 'path'

options = {
  configFile: path.join __dirname, 'karma.conf.js'
  singleRun: true
  coverageReporter: {
    dir: 'coverage/'
    type: 'html'
  }
}
server = (options, done) ->
  new karma.Server(options, done)

gulp.task 'test', (done) ->

  options.coverageReporter.type = 'lcov'

  if process.env.TRAVIS
    options.browsers = [ 'Chrome_travis_ci', 'Firefox' , 'PhantomJS' ]

  server(options, done).start()


gulp.task 'test-watch', (done) ->

  options.singleRun = false
  server(options, ->
    done()  if not doneBefore
    doneBefore = yes
  ).start()
