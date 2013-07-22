$(document).ready(function(){
	$('#signin-menu').hide();
});

$(function(){
	$("#signin").click(function() {
		if ($('#signin-menu').is('.selected')){
			$('#signin-menu').slideUp('fast');
			$('#signin-menu').removeClass('selected');
		}
		else {
			$('#signin-menu').slideDown('fast');
			$('#signin-menu').addClass('selected');
		}
	});
});