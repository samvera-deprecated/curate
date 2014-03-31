//= require browse_everything
(function($) {
	var browse_everything_test = function() {
		$('#browse').browseEverything()
			.done(function(data) {
				$('#status').html(data.length.toString() + " item(s) selected")
			})
		};
	if (typeof Turbolinks !== "undefined") {
		$(document).on('page:load', function() {
			browse_everything_test();
		});
	}
	$(document).ready(function() {
		browse_everything_test();
	});
})(jQuery);

