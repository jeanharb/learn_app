$(document).ready(function(){
	$('#signin-menu').hide();
	$('.dropdown-menu').hide();
	$('.search-menu').hide();
	$('.note-submit').hide();
	$('.note-submit').attr('disabled',true);
    $('input:file').change(
        function(){
            if ($(this).val()) { 
            	$('.note-submit').show();
                $('.note-submit').attr('disabled',false);
        	} 
    	}
    );
});

function dropmenu(word1, word2, word3) {
	if ($(word2).is('.selected')){
		$(word2).slideUp('fast');
		$(word1).removeClass(word3);
		$(word2).removeClass('selected');
	}
	else {
		$(word2).slideDown('fast');
		$(word1).addClass(word3);
		$(word2).addClass('selected');
		return false;
	}
}

$(function(){
	$("#signin").click(function(){
		dropmenu("#signin", '#signin-menu', 'selected-btn')
	});
});

$(function(){
	$(".dropdown").click(function(){
		dropmenu(".dropdown", '.dropdown-menu', 'selected-btn-list')
	});
});

$(function(){
	$(".search-btn").click(function(){
		dropmenu(".search-btn", '.search-menu', 'selected-btn-list')
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
		if ($('.search-menu').is('.selected')){
			$('.search-menu').slideUp('fast');
			$('.search-btn').removeClass('selected-btn-list');
			$('.search-menu').removeClass('selected');
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
		if ($('.search-menu').is('.selected')){
			$('.search-menu').slideUp('fast');
			$('.search-btn').removeClass('selected-btn-list');
			$('.search-menu').removeClass('selected');
		}
	});
});