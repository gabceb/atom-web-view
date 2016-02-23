Point = require 'atom'

module.exports =
class WebEditorAddress
    initialize: ->
    constructor: (serializedState) ->
        @element = document.createElement('atom-text-editor')
        @element.setAttribute('mini', '')

    getElement: ->
        @element
