module.exports =
class WebEditorGluon
    constructor: (serializedState) ->
        console.log serializedState
        
        # Create root element
        @element = document.createElement 'iframe'
        @relocate 'https://atom.io/'
        @element.setAttribute 'name', 'disable-x-frame-options'

        # It is very important to note that this is for development only...
        # Sites like google, yahoo, and tumblr do not work.
        self = this

        @element.addEventListener 'load', (event) ->
            self.title = this.contentDocument.title
            atom.notifications.addSuccess self.title + " has loaded."

    relocate: (source) ->
        # if a document model has been established, use it
        if (@element.contentWindow)
            @element.contentWindow.location.href = source
        else # otherwise use the src attribute.
            @element.setAttribute('src', source)

    # This is the tab Title and it is required.
    getTitle: () ->
        return @title || 'Web View'

    # Returns an object that can be retrieved when package is activated
    serialize: ->
        if @element.contentWindow
            return @element.contentWindow.location.href
        else
            return @element.getAttribute('src')

    # Tear down any state and detach
    destroy: ->
        @element.remove()

    # Also required. (allows pane/panel to access it)
    getElement: ->
        @element
