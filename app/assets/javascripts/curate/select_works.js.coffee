$.fn.blacklightAutoComplete = () ->
    return this.each( () ->
      selectedDocs =  $(this).find("option[selected='selected']")
      selectedPids =  $.map(selectedDocs, (el) -> return $(el).attr("value") )
      excludePids =   $(this).data("exclude").split(",")
      targetElement = this
      queryUrl = $(this).data("source")

      $.getJSON( queryUrl, {})
        .done( ( data ) ->
            $(targetElement).empty()
            $.each( data.response.docs, ( i, doc ) ->
                # Skip creating optionElement if pid is in excludePids array
                if (excludePids.indexOf(doc.pid) == -1)
                    optionElement = $( "<option/>" ).attr( "value", doc.pid ).text(doc.title)
                   #  Set "selected" attribute if option was in the original list of selected options.
                    if (selectedPids.indexOf(doc.pid) > -1)
                        optionElement.attr( "selected", "selected" )
                    optionElement.appendTo( targetElement )
            )
            $(targetElement).chosen()
        )
    )

$(".autocomplete").blacklightAutoComplete()