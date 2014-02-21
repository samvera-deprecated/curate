$(function() {
  $('#browse-btn').browseEverything("/remote_files/browse").done(function(data) { $('#status').html(data.length.toString() + " items selected") });
});



