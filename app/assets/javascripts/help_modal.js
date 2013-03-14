$(function(){
  var $modal = $('#ajax-modal');

  $('.request-help').on('click', function(event){
    event.preventDefault();

    $('body').modalmanager('loading');

    setTimeout(function(){
      $modal.load('/help_requests/new #main', function(){
        $modal.modal();
      });
    }, 1000);
  });
});
