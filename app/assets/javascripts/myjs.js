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
			return false;
		}
	});
});

$(function(){
	$(".dropdown").click(function() {
		if ($('.dropdown-menu').is('.selected')){
			$('.dropdown-menu').slideUp('fast');
			$('.dropdown').removeClass('selected-btn-list');
			$('.dropdown-menu').removeClass('selected');
		}
		else {
			$('.dropdown-menu').slideDown('fast');
			$('.dropdown').addClass('selected-btn-list');
			$('.dropdown-menu').addClass('selected');
			return false;
		}
	});
});

$(function(){
	$("#body-container").click(function() {
		if ($('#signin-menu').is('.selected')){
			$('#signin-menu').slideUp('fast');
			$('#signin').removeClass('selected-btn');
			$('#signin-menu').removeClass('selected');
		}
		if ($('.dropdown-menu').is('.selected')){
			$('.dropdown-menu').slideUp('fast');
			$('.dropdown').removeClass('selected-btn-list');
			$('.dropdown-menu').removeClass('selected');
		}
	});
});

$(function(){
	$("#footer").click(function() {
		if ($('#signin-menu').is('.selected')){
			$('#signin-menu').slideUp('fast');
			$('#signin').removeClass('selected-btn');
			$('#signin-menu').removeClass('selected');
		}
		if ($('.dropdown-menu').is('.selected')){
			$('.dropdown-menu').slideUp('fast');
			$('.dropdown').removeClass('selected-btn-list');
			$('.dropdown-menu').removeClass('selected');
		}
	});
});