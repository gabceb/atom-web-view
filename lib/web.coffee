_ = require 'underscore-plus'
url = require 'url'
_str = require 'underscore.string'
WebEditorView = require './web-editor-view'
WebEditorUriMiniView = require './web-editor-uri-mini-view'

module.exports =
  activate: ->
    atom.workspace.registerOpener (uriToOpen) ->

      web_view_protocol = 'web-view:'

      {protocol, pathname} = url.parse(uriToOpen)
      pathname = _str.strRight(uriToOpen, ':')
      return unless protocol is web_view_protocol

      new WebEditorView(pathname)

    atom.workspaceView.eachPaneView (pane) ->
      pane.command 'web-view:go-to-page', ->
        miniView = new WebEditorUriMiniView
        miniView.toggle()

  deactivate: ->
