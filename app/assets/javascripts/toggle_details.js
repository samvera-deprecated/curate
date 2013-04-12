$(function(){
  //NOTE: This function is tightly coupled with the catalog index markup
  $('.show-details').on('click', function(event){
    event.preventDefault();
    $(this)
      .parents('tr')
      .next('tr')
      .toggleClass('hide');
  });
});
