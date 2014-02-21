//= require browse_everything
(function($) {
	var browse_everything_test = function() {
		$('#browse').browseEverything()
			.done(function(data) {
				console.log("DONE!!!!")
					var jsonData=JSON.stringify(data, null, 2)
					var urls= new Array();
					$.each($.parseJSON(jsonData), function(idx, obj) {
						console.log(obj.url);
						urls.push(obj.url);
					});

				$('.cloud_resource').val(urls.join('|'))
				$('#status').html(data.length.toString() + " item(s) selected")
			})
			.cancel(function()   { window.alert('Canceled!') });
		};

	$(document).ready(function() {
		browse_everything_test();
	});
})(jQuery);

