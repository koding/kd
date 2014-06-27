KDView = require './../../core/view.coffee'

###
# # KDHeaderView
#
# KDHeaderView is a basic KDView to implement the
# `<h1>`/`<h2>`/`<h3>`/etc DOM elements.
#
# ## Usage
#
# ```coffee
# header = new KDHeaderView
#   title: 'Header title!'
#   type: 'big'
#
# appView.addSubView header
# ```
###
module.exports = class KDHeaderView extends KDView

  ###
  # Options supports the following keys:
  # - **options.title**: The contents for your header view.
  # - **options.type**: The level of your `H` element, represented in three
  #  options: `"big"`, `"medium"`, `"small"` which translates to `"h1"`,
  #  `"h2"`, ` "h3"` respectively.
  #
  # @param {Object} options
  # @param {Object} data
  ###
  constructor:(options,data)->
    options = options ? {}
    options.type = options.type ? "default"
    super options,data

    if options.title?
      if @lazy
      then @updateTitle options.title
      else @setTitle options.title

  ###
  # Set the title of this heaer element.
  #
  # @param {String} title The title you want to set your header to
  ###
  setTitle:(title)->
    @getDomElement().append "<span>#{title}</span>"

  ###
  # Update the title for this header option. This can be used after you have
  # already set the title, to change it to another title.
  #
  # @param {String} title The title you want to update your header to
  ###
  updateTitle: (title) ->
    @$().find('span').html title

  setDomElement:(cssClass = "")->
    {type} = @getOptions()
    @setOption "tagName", switch type
      when "big"    then "h1"
      when "medium" then "h2"
      when "small"  then "h3"
      else "h4"

    super @utils.curry("kdheaderview", cssClass)
