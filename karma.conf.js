// Karma configuration
// Generated on Wed Mar 19 2014 12:00:53 GMT-0700 (PDT)

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

    sauceLabs: {
      username: process.env.SAUCE_USERNAME,
      accessKey: process.env.SAUCE_ACCESS_KEY,
      startConnect: true,
      testName: 'KD tests'
    },

    // define SauceLabs browsers
    customLaunchers: {

      sl_firefox_windows: {
        base: 'SauceLabs',
        browserName: 'firefox',
        platform: 'Windows 7'
      },

      sl_chrome_windows: {
        base: 'SauceLabs',
        browserName: 'chrome',
        platform: 'Windows 7'
      },

      sl_ie_9: {
        base: 'SauceLabs',
        browserName: 'internet explorer',
        platform: 'Windows 7',
        version: '9'
      },

      sl_ie_10: {
        base: 'SauceLabs',
        browserName: 'internet explorer',
        platform: 'Windows 7',
        version: '10'
      }
    },

    // list of files to exclude
    exclude: [
      'lib/index.coffee'
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
    reporters: ['progress', 'coverage'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


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
      'karma-browserify'
    ],

    coverageReporter: {
      type : 'html',
      dir : 'coverage/'
    },

    browserify: {
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }
  });
};
