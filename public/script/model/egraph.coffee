app = app || {}
define ["backbone", "jquery", "cytoscape"], (Backbone, jQuery, cytoscape) ->
  class app.egraph extends Backbone.Model
    graph: null # graph
    root_url: '' # where to load the root of the graph

    constructor: ->
      # TODO
      # get JSON

    data: (cb) ->
      console.log @.get('root_url')
      #$.getJSON @.get('root_url')
