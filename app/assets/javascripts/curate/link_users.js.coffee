(($, window, document) ->
  $this = undefined
 
  # default settings
  _settings =
    default: 'cool!'
    
  _remover = $("<button class=\"btn btn-danger remove\"><i class=\"icon-white icon-minus\"></i><span>Remove</span></button>")
  _adder   = $("<button class=\"btn btn-success add\"><i class=\"icon-white icon-plus\"></i><span>Add</span></button>")
  
 
  # This is your public API (no leading underscore, see?)
  # All public methods must return $this so your plugin is chainable.
  methods =
    init: (options) ->
      $this = $(@)
      # The settings object is available under its name: _settings. Let's
      # expand it with any custom options the user provided.
      $.extend _settings, (options or {})
      # Do anything that actually inits your plugin, if needed, right now!
      # An important thing to keep in mind, is that jQuery plugins should be
      # built so that one can apply them to more than one element, like so:
      #
      #  $('.matching-elements, #another-one').foobar()
      #
      $this.each (index, el) ->
        $('.autocomplete-users').each (index, el) ->
          _internals.autocompleteUsers(el)

        $('.field-wrapper:not(:last-child) .field-controls', $this).append(_remover)
        $('.field-controls:last', $this).append(_adder)
        $(el).on 'click', 'button.add', (e) ->
          _internals.addToList(this)
        $(el).on 'click', 'button.remove', (e) ->
          _internals.removeFromList(this)

      return $this
 
    # This method is often overlooked.
    destroy: ->
      # Do anything to clean it up (nullify references, unbind events…).
      return $this
 
  _internals =
    addToList: (el) ->
      $activeControls = $(el).closest('.field-controls')
      $listing = $activeControls.closest('.listing')
      $('.add', $activeControls).remove()
      $removeControl = _remover.clone()
      $activeControls.prepend($removeControl)
      _internals.newRow($listing)
      false

    newRow: ($listing) ->
      $listing.append _internals.newListItem($('li', $listing).size())
      _internals.autocompleteUsers($('.autocomplete-users:last', $listing))


    removeFromList: (el) ->
      $currentUser = $(el).closest('li')
      $listing = $currentUser.closest('.listing')
      $currentUser.hide()
      # set the destroy flag
      $('input:not([value])', $currentUser).val('true')
      false

    newListItem: (index) ->
      source   = $("#entry-template").html()
      template = Handlebars.compile(source)
      template({index: index})

    addExistingUser: ($listItem, value, label) ->
      source   = $("#existing-user-template").html()
      template = Handlebars.compile(source)
      $list = $listItem.closest('ul')
      $('input[required]', $list).removeAttr('required')
      $listItem.replaceWith template({index: $('li', $list).index($listItem), value: value, label: label})
      _internals.newRow($list)

    autocompleteUsers: (el) ->
      $targetElement = $(el)
      $targetElement.autocomplete
        source: (request, response) ->
          $targetElement.data('url')
          $.getJSON $targetElement.data('url'), { q: request.term + "*" }, ( data, status, xhr ) ->
            matches = []
            $.each data.response.docs, (idx, val) ->
              matches.push {label: val['desc_metadata__name_tesim'][0], value: val['id']}
            response( matches )
        minLength: 2
        focus: ( event, ui ) ->
          $targetElement.val(ui.item.label)
          event.preventDefault()
        select: ( event, ui ) ->
          _internals.addExistingUser($targetElement.closest('li'), ui.item.value, ui.item.label)
          $targetElement.val('')
          event.preventDefault()

 
  $.fn.linkUsers = (method) ->
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method
      methods.init.apply this, arguments
    else
      $.error "Method " + method + " does not exist on jquery.linkUsers"
) jQuery, window, document
