$(function() {
  $('#browse-btn').browseEverything(browse_everything_engine.root_path)
    .done(function(data) { $('#status').html(data.length.toString() + " items selected") })
    .cancel(function() { window.alert('Canceled!') });
});


