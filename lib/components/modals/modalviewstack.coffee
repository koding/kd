debug = require('debug') 'kd:modals:modalviewstack'
KD = require '../../core/kd'
KDModalView = require './modalview'
KDObject = require '../../core/object'

module.exports = class KDModalViewStack extends KDObject

  constructor: (options={}, data)->
    options.lastToFirst ?= no
    super options, data

    @modals = []

  addModal: (modal)->

    unless modal instanceof KDModalView
      debug 'modal must be an instanceof kd.ModalView'
      return

    modal.on "KDObjectWillBeDestroyed", => @next()

    {lastToFirst} = @getOptions()

    @modals.push modal

    KD.utils.defer => # deferring to help reposition on hiding
      modal.hide()
      if lastToFirst
        @modals.forEach (modal)-> modal.hide()
        @modals.last.show()
      else
        @modals.first.show()

    return modal

  next: ->
    {lastToFirst} = @getOptions()

    if lastToFirst
      @modals.pop()
      @modals.last?.show()
    else
      @modals.shift()
      @modals.first?.show()

  destroy: ->
    @modals.forEach (modal)-> KD.utils.defer -> modal.destroy()
    @modals = []
    super