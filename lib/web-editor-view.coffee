_ = require 'underscore-plus'
{$, ScrollView} = require 'atom'

# View that renders the image of an {WebEditor}.
module.exports =
class WebEditorView extends ScrollView

  @content: ->
    @iframe class: 'web-view-iframe', name: 'disable-x-frame-options', tabindex: -1, src: ""

  constructor: (@uri) ->
    super

    @.attr('src', @uri)

  @deserialize: ({uri}) ->

  # Gets the title of the page based on the uri
  #
  # Returns a {String}
  getTitle: ->
    @uri || 'Uri-web'

  # Serializes this view
  #
  serialize: ->
    {@uri, deserializer: @constructor.name}

  # Retrieves this view's pane.
  #
  # Returns a {Pane}.
  getPane: ->
    @parents('.pane').view()
