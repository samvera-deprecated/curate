jQuery ($) ->
  ready = ->
    $("#browse").browseEverything()
      .done (data) ->
        $('#status').html(data.length.toString() + " item(s) selected")

  $(document).ready(ready)
  $(document).on('page:load', ready)