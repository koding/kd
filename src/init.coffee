# KD Framework Init Script
KD                 = require './core/kd.coffee'
KDWindowController = require './core/windowcontroller.coffee'
KDCustomHTMLView   = require './core/customhtmlview.coffee'

KD.registerSingleton "windowController", new KDWindowController
console.timeEnd "Framework loaded"

do ->

  # this is the playground

  view = new KDCustomHTMLView
    tagName : 'h1'
    partial : 'I am a KDView!!!'

  view.appendToDomBody()