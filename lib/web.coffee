_ = require 'underscore-plus'
url = require 'url'
_str = require 'underscore.string'
WebEditorView = require './web-editor-view'
WebEditorUriMiniView = require './web-editor-uri-mini-view'

module.exports =
  activate: ->
    atom.workspace.addOpener (uriToOpen) ->

      web_view_protocol = 'web-view:'

      {protocol, pathname} = url.parse(uriToOpen)
      pathname = _str.strRight(uriToOpen, ':')
      return unless protocol is web_view_protocol

      new WebEditorView(pathname)

    atom.workspace.observeTextEditors (editor) ->
      miniView = new WebEditorUriMiniView
      miniView.toggle()

  deactivate: ->
