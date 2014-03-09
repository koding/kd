# KD Framework Init Script
KD                 = require './core/kd.coffee'
KDWindowController = require './core/windowcontroller.coffee'

KD.registerSingleton "windowController", new KDWindowController
console.timeEnd "Framework loaded"