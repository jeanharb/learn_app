$(document).ready(function(){
	$('#signin-menu').hide();
	$('.dropdown-menu').hide();
});

$(function(){
	$("#signin").click(function() {
		if ($('#signin-menu').is('.selected')){
			$('#signin-menu').slideUp('fast');
			$('#signin').removeClass('selected-btn');
			$('#signin-menu').removeClass('selected');
		}
		else {
			$('#signin-menu').slideDown('fast');
			$('#signin').addClass('selected-btn');
			$('#signin-menu').addClass('selected');
		}
	});
});

$(function(){
	$(".dropdown").click(function() {
		if ($('.dropdown-menu').is('.selected')){
			$('.dropdown-menu').slideUp('fast');
			$('.dropdown').removeClass('selected-btn');
			$('.dropdown-menu').removeClass('selected');
		}
		else {
			$('.dropdown-menu').slideDown('fast');
			$('.dropdown').addClass('selected-btn');
			$('.dropdown-menu').addClass('selected');
		}
	});
});

$(function(){
	$("#body-signin").click(function() {
		if ($('#signin-menu').is('.selected')){
			$('#signin-menu').slideUp('fast');
			$('#signin').removeClass('selected-btn');
			$('#signin-menu').removeClass('selected');
		}
		if ($('.dropdown-menu').is('.selected')){
			$('.dropdown-menu').slideUp('fast');
			$('.dropdown').removeClass('selected-btn');
			$('.dropdown-menu').removeClass('selected');
		}
	});
});