var ready = function(){
    $('#no-doi, #mint-doi').click(function(e){
    var $target = $(e.target),
        $field  = $('#publisher')
                       
    if ($target.attr('id') == 'mint-doi') {
      $field.attr('required', 'true');
    } else {
      $field.removeAttr('required');
    }
  });
};
$(document).ready(ready)
$(document).on('page:load', ready)
