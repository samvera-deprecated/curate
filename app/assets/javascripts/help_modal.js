$(function(){
  var $modal = $('#ajax-modal');

  $('.request-help').on('click', function(event){
    event.preventDefault();

    $('body').modalmanager('loading');

    setTimeout(function(){
      $modal.load('/help_requests/new #new_help_request', function(){
        $modal.modal();
      });
    }, 1000);
  });
});
