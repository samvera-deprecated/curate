jQuery ->
  $('.autocomplete').each( (index, el) ->
    $targetElement = $(el)
    $targetElement.tokenInput $targetElement.data("url"), {
      theme: 'facebook'
      prePopulate: $('.autocomplete').data('load')
      jsonContainer: "docs"
      propertyToSearch: "title"
      preventDuplicates: true
      tokenValue: "pid"
      onResult: (results) ->
#        selectedPids = $.map( $targetElement.tokenInput("get") , (el, index) -> return el.pid )
#        pidsToFilter = $targetElement.data('exclude').concat(selectedPids)
        pidsToFilter = $targetElement.data('exclude')
        console.log(results.docs)
        $.each(results.docs, (index, value) ->
          console.log(value)
          # Filter out anything listed in data-exclude.  ie. the current object.
          if (pidsToFilter.indexOf(value.pid) > -1)
            results.docs.splice(index, 1)
        )
        return results;
    }
  )