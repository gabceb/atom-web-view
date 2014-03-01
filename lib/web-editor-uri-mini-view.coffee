validator = require('validator')
{$, EditorView, Point, View} = require 'atom'

module.exports =
class WebEditorUriMiniView extends View
  @content: ->
    @div class: 'overlay from-top mini', =>
      @subview 'miniEditor', new EditorView(mini: true)
      @div class: 'message', outlet: 'message'

  detaching: false

  initialize: ->
    @miniEditor.hiddenInput.on 'focusout', => @detach() unless @detaching
    @on 'core:confirm', => @confirm()
    @on 'core:cancel', => @detach()

  # Toggles the view to be shown or not
  #
  toggle: ->
    if @hasParent()
      @detach()
    else
      @attach()

  detach: ->
    return unless @hasParent()

    @detaching = true
    miniEditorFocused = @miniEditor.isFocused
    @miniEditor.setText('')

    super

    @restoreFocus() if miniEditorFocused
    @detaching = false

  # Event that gets fired when the user presses Enter on the mini view
  #
  confirm: ->
    url = @miniEditor.getText()
    editorView = atom.workspaceView.getActiveView()

    # Add a the protocol if not present
    url = "http://#{url}" unless /^(http)\S+/.test(url)

    if validator.isURL(url, protocols: ['http','https'], require_tld: true, require_protocol: true)
      atom.workspace.open("web-view:#{url}", split: 'right', searchAllPanes: true)

      @detach()
    else
      console.log("URL passed is not valid. Ignoring..")

  storeFocusedElement: ->
    @previouslyFocusedElement = $(':focus')

  # Restores focus on the element
  restoreFocus: ->
    if @previouslyFocusedElement?.isOnDom()
      @previouslyFocusedElement.focus()
    else
      atom.workspaceView.focus()

  # Shows the mini view on the active editor
  attach: ->
    if editor = atom.workspace.getActiveEditor()
      @storeFocusedElement()
      atom.workspaceView.append(this)
      @message.text("Enter a URL")
      @miniEditor.focus()
