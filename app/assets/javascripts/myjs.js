$(document).ready(function(){ 
	$('#signin-menu').hide();
	$('.dropdown-menu').hide();
	$('.search-menu').hide();
	$('.note-submit').hide();
	$('.notavail').hide();
	$('.note-submit').attr('disabled',true);
    $('input:file').change(
        function(){
            if ($(this).val()) { 
            	$('.note-submit').show();
                $('.note-submit').attr('disabled',false);
        	} 
    	}
    );
    if($('#jquery-find').length >0 ){    
        DrawAllLines();
    }
});

jQuery.fn.darken = function() {
  $(this).each(function() {
		var darkenPercent = 15; // darken color by 15 percent
		var rgb = $(this).css('background-color');
		rgb = rgb.replace('rgb(', '').replace(')', '').split(',');
		var red = $.trim(rgb[0]);
		var green = $.trim(rgb[1]);
		var blue = $.trim(rgb[2]);
				
		// darken
		red = parseInt(red * (100 - darkenPercent) / 100);
		green = parseInt(green * (100 - darkenPercent) / 100);
		blue = parseInt(blue * (100 - darkenPercent) / 100);
		// lighten
		/* red = parseInt(red * (100 - darkenPercent) / 100);
		green = parseInt(green * (100 - darkenPercent) / 100);
		blue = parseInt(blue * (100 - darkenPercent) / 100); */
		
		rgb = 'rgb(' + red + ', ' + green + ', ' + blue + ')';
		
		$(this).css('background-color', rgb);
  });
  return this;
}

jQuery.fn.lighten = function() {
  $(this).each(function() {
		var darkenPercent = -17.65; // darken color by 15 percent
		var rgb = $(this).css('background-color');
		rgb = rgb.replace('rgb(', '').replace(')', '').split(',');
		var red = $.trim(rgb[0]);
		var green = $.trim(rgb[1]);
		var blue = $.trim(rgb[2]);
				
		// darken
		red = parseInt(red * (100 - darkenPercent) / 100);
		green = parseInt(green * (100 - darkenPercent) / 100);
		blue = parseInt(blue * (100 - darkenPercent) / 100);
		// lighten
		/* red = parseInt(red * (100 - darkenPercent) / 100);
		green = parseInt(green * (100 - darkenPercent) / 100);
		blue = parseInt(blue * (100 - darkenPercent) / 100); */
		
		rgb = 'rgb(' + red + ', ' + green + ', ' + blue + ')';
		
		$(this).css('background-color', rgb);
  });
  return this;
}


function DrawAllLines(){
	var passed = allpassed.toString().split(',');
	var underunder = underdone.toString().split(',');
	var lines = alllines.toString().split(",");
	var lineslen = lines.length/2;
	for (i = 0; i < lineslen; i++){
		var subsub = lines[(i*2)+1].substring(1);
		if(passed.indexOf(subsub) !== -1){
			DrawLine(lines[i*2], lines[(i*2)+1], "yes");
		} else {
			if(underunder.indexOf(subsub) !== -1){
				DrawLine(lines[i*2], lines[(i*2)+1], "blue");
			} else {
				DrawLine(lines[i*2], lines[(i*2)+1], "no");
			}
		}
	}
}

function DrawLine(thing1, thing2, wordword){
	var x1 = $(thing1).offset().left + 8 +($(thing1).width()/2);
	var y1 = $(thing1).offset().top + 20 + ($(thing1).height()/2);
	var x2 = $(thing2).offset().left + 8 + ($(thing2).width()/2);
	var y2 = $(thing2).offset().top + 20 + ($(thing2).height()/2);
	var what = thing2.substring(1);
	if(wordword == "yes"){
		var yes = "lines_prereq_green";
	}
	else{
		if(wordword == "blue"){
			var yes = "lines_prereq_blue";
		}
		else{
			var yes = "lines_prereq";
		}
	}

    if(y1 < y2){
        var pom = y1;
        y1 = y2;
        y2 = pom;
        pom = x1;
        x1 = x2;
        x2 = pom;
    }

    var a = Math.abs(x1-x2);
    var b = Math.abs(y1-y2);
    var c;
    var sx = (x1+x2)/2 ;
    var sy = (y1+y2)/2 ;
    var width = Math.sqrt(a*a + b*b ) ;
    var x = sx - width/2;
    var y = sy;

    a = width / 2;

    c = Math.abs(sx-x);

    b = Math.sqrt(Math.abs(x1-x)*Math.abs(x1-x)+Math.abs(y1-y)*Math.abs(y1-y) );

    var cosb = (b*b - a*a - c*c) / (2*a*c);
    var rad = Math.acos(cosb);
    var deg = (rad*180)/Math.PI;

    htmlns = "http://www.w3.org/1999/xhtml";
    div = document.createElementNS(htmlns, "div");
    div.setAttribute('style','width:'+width+'px;height:0px;z-index:-10;-moz-transform:rotate('+deg+'deg);-webkit-transform:rotate('+deg+'deg);position:absolute;top:'+y+'px;left:'+x+'px;');   
    div.setAttribute('class', yes);
    document.getElementById("myelement").appendChild(div);
}

$(function(){
	$(".green-test").click(function(e){
		$('.class-select-top').lighten();
		$('.class-select-bottom').lighten();
		$('.class-select').lighten();
		$(".green-test").show();
		$(".all-prereqs").removeClass('class-select-top');
		$(".all-prereqs").removeClass('class-select-bottom');
		$(".green-test").parent().removeClass('class-select');
		$(e.target).hide();
		$(e.target).parent().addClass('class-select');
		$(e.target).parent().darken();
		var alltop1 = alltop;
		var allbottom1 = allbottom;
		var selected_id = parseInt($(this).parent().attr("id"));
		for (i = 0; i < alltop1[selected_id].length; i++){
			var number = '#' + alltop1[selected_id][i].toString();
			$(number).addClass('class-select-top');
			$(number).darken();
		}
		for (i = 0; i < allbottom1[selected_id].length; i++){
			var number = '#' + allbottom1[selected_id][i].toString();
			$(number).addClass('class-select-bottom');
			$(number).darken();
		}
	});
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
		dropmenu("#signin", '#signin-menu', 'selected-btn');
	});
});

$(function(){
	$(".unclickable-file").mouseenter(function(e){
		$('.notavail').show();
	}).mouseleave(function(e) {      
        $('.notavail').hide();
    });
});

$(function(){
	$(".dropdown").click(function(){
		dropmenu(".dropdown", '.dropdown-menu', 'selected-btn-list');
		$('.search-menu').slideUp('fast');
		$('.search-btn').removeClass('selected-btn-list');
		$('.search-menu').removeClass('selected');
	});
});

$(function(){
	$(".search-btn").click(function(){
		dropmenu(".search-btn", '.search-menu', 'selected-btn-list');
		$('.dropdown-menu').slideUp('fast');
		$('.dropdown').removeClass('selected-btn-list');
		$('.dropdown-menu').removeClass('selected');
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

$(function(){
	$('a.add-answer').click(function() {
		if ($('#answer-list li').length < 8){
			$('#answer-list li:first').clone().find('input#question_answers_attributes__name').val('').end().appendTo('#answer-list');
		}
		else
			alert("There's a max of 8 answers.");
	});
});