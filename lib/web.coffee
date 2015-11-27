# atom clean up work
{CompositeDisposable} = require 'atom'

# included modules
WebEditorGluon = require './web-editor-gluon'
WebEditorAddress = require './web-editor-uri-mini-view'

# universal resource link (parser)
url = require 'url'

module.exports =
    activate: (state) ->
        @disposable =
            new CompositeDisposable()

        # for the iframe..
        pane = atom.workspace.getActivePane()
        paneElement = atom.views.getView(pane)

        # for the address bar...
        textEditor = atom.workspace.getActiveTextEditor()
        textEditorElement = atom.views.getView(textEditor)


        subscription =
            atom.commands.add 'atom-workspace',
            'web-view:toggle': => @toggle()
            'web-view:reload': => @reload()

        @disposable.add atom.workspace.addOpener (uri) ->
            return new WebEditorGluon() if uri is "view://web"

        @disposable.add atom.views.addViewProvider WebEditorGluon, paneElement

        @editor = editor =
            atom.workspace.buildTextEditor()

        element = atom.views.getView(editor)
        element.setAttribute('mini', '')
        self = @

        element.addEventListener 'keydown', (e) ->
            if(e.keyCode == 13) # Enter
                atom.commands.dispatch(editor, 'core:confirm')
                self.hide()
            if(e.keyCode == 27) # Escape
                atom.commands.dispatch(editor, 'core:cancel')
                self.hide()

        @disposable.add atom.commands.add editor,
            'core:confirm': @confirm
            'core:cancel': @cancel

        @panel = atom.workspace.addModalPanel(item: editor, visible: false)

        @disposable.add subscription

    deactivate: ->
        @disposable.dispose()
        @panel.destroy()
        @element.destroy()

    confirm: (event) ->
        pane = atom.workspace.getActivePane()
        text = this.getText()

        if pane.activeItem instanceof WebEditorGluon
            pane.activeItem.relocate text
        else
            atom.notifications.addError "Web View must be the active item."

    reload: (event) ->
        pane = atom.workspace.getActivePane()

        if pane.activeItem instanceof WebEditorGluon
            pane.activeItem.element.contentWindow.location.reload()

    cancel: (event) ->
        atom.workspace.panelForItem(this).hide()

    show: ->
        atom.workspace.open("view://web")

        @panel.show()
        atom.views.getView(@editor).focus()

    hide: ->
        @panel.hide()

    toggle: ->
        if @panel.isVisible()
             @hide()
        else
            @show()
