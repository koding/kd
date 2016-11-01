// Karma configuration
// Generated on Wed Mar 19 2014 12:00:53 GMT-0700 (PDT)

var istanbul = require('browserify-istanbul');

module.exports = function(config) {
  config.set({

    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '',


    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['mocha', 'browserify'],


    // list of files / patterns to load in the browser
    files: [
      'lib/**/*.coffee',
      'test/**/*.coffee'
    ],

    customLaunchers: {
      Chrome_travis_ci: {
        base: 'Chrome',
        flags: ['--no-sandbox']
      }
    },

    // list of files to exclude
    exclude: [
      'lib/index.coffee',

      // full folders
      'lib/components/dia/**/*.coffee',
      'lib/components/upload/**/*.coffee',
      'lib/components/slideshow/**/*.coffee',
      'lib/components/counter/**/*.coffee',
      'lib/components/sliderbar/**/*.coffee',

      // individual files
      'lib/components/inputs/contenteditableview.coffee',
      'lib/components/inputs/multiplechoice.coffee',
      'lib/components/inputs/inputcheckboxgroup.coffee',
      'lib/components/inputs/inputswitch.coffee',
      'lib/components/inputs/wmdinput.coffee',
      'lib/components/inputs/tokenizedinputview.coffee',
      'lib/components/inputs/delimitedinputview.coffee',

      'lib/components/image/webcamview.coffee',

      'lib/components/autocomplete/noautocompleteinputview.coffee',
      'lib/components/autocomplete/noautocompletemultiplelistview.coffee',
      'lib/components/autocomplete/multipleinputlistview.coffee',
      'lib/components/autocomplete/multipleinputview.coffee',
      'lib/components/autocomplete/multiplelistitemview.coffee',
      'lib/components/autocomplete/simpleautocomplete.coffee',
    ],


    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      'lib/**/*.coffee': ['browserify'],
      'test/**/*.coffee': ['browserify']
    },


    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress', 'coverage', 'coveralls'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_ERROR,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['Chrome'],


    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: false,

    plugins : [
      'karma-mocha',
      'karma-coverage',
      'karma-chrome-launcher',
      'karma-browserify',
      'karma-coveralls'
    ],

    coverageReporter: {
      dir : 'coverage/',
      type: 'html'
    },

    browserify: {
      transform: [
        'coffeeify',
        istanbul({
          instrumenterConfig: { embedSource: true }
        })
      ],
      extensions: ['.coffee']
    },

    concurrency: 1
  });
};
