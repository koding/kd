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

  options.browsers = ['PhantomJS']
  if process.env.TRAVIS
    options.browsers = [ 'Chrome_travis_ci', 'Firefox' , 'PhantomJS' ]

  server(options, done).start()


gulp.task 'test-watch', (done) ->

  options.singleRun = false
  options.browsers = ['PhantomJS']

  server(options, ->
    done()  if not doneBefore
    doneBefore = yes
  ).start()
