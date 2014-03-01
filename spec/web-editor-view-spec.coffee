WebEditorView = require '../lib/web-editor-view'

describe "WebEditorView", ->
  uri = "www.atom.io"

  beforeEach ->
    view = new WebEditorView(uri)

  it "displays the image for a path", ->
    expect(view.attr('src')).toBe uri
