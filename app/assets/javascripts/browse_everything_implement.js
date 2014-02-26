//= require browse_everything
(function($) {
	var browse_everything_test = function() {
		$('#browse').browseEverything()
			.done(function(data) {
				console.log("DONE!!!!")
				$('#status').html(data.length.toString() + " item(s) selected") }
			)
			.cancel(function()   { window.alert('Canceled!') });
		};

	$(document).ready(function() {
		browse_everything_test();
	});
})(jQuery);
