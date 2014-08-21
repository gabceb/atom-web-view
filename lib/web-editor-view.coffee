_ = require 'underscore-plus'
{$, ScrollView} = require 'atom'

# View that renders the image of an {WebEditor}.
module.exports =
class WebEditorView extends ScrollView

  @content: ->
    @div class: 'web-view-area', =>
      @div class: 'web-view-toolbar', =>
        @button outlet: 'reladPage', class: 'icon icon-sync', 'Reload',
      @iframe class: 'web-view-iframe', tabindex: -1, src: ""

  constructor: (@uri) ->
    super

    @reloadPage(@uri)

  initialize: (@pack, @packageManager) ->
    @handleButtonEvents()

  handleButtonEvents: ->
    @reladPage.on 'click', =>
      @reloadPage(@uri)
      false

  reloadPage: (@uri) ->
    @.find('iframe.web-view-iframe').attr('src', @uri)

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
