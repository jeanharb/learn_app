$(document).ready(function(){
	$('#signin-menu').hide();
	$('.dropdown-menu').hide();
	$('.search-menu').hide();
	$('.note-submit').hide();
	$('.note-submit').attr('disabled',true);
	DrawAllLines();
    $('input:file').change(
        function(){
            if ($(this).val()) { 
            	$('.note-submit').show();
                $('.note-submit').attr('disabled',false);
        	} 
    	}
    );
});

function DrawAllLines(){
	var lines = alllines.toString().split(",")
	var lineslen = lines.length/2
	for (i = 0; i <= lineslen; i++){
		DrawLine(lines[i*2], lines[(i*2)+1]);
	}
}

function DrawLine(thing1, thing2){
	var x1 = $(thing1).offset().left + 10 +($(thing1).width()/2);
	var y1 = $(thing1).offset().top + 25 + ($(thing1).height()/2);
	var x2 = $(thing2).offset().left + 10 + ($(thing2).width()/2);
	var y2 = $(thing2).offset().top + 25 + ($(thing2).height()/2);

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
    var deg = (rad*180)/Math.PI

    htmlns = "http://www.w3.org/1999/xhtml";
    div = document.createElementNS(htmlns, "div");
    div.setAttribute('style','width:'+width+'px;height:0px;z-index:-10;-moz-transform:rotate('+deg+'deg);-webkit-transform:rotate('+deg+'deg);position:absolute;top:'+y+'px;left:'+x+'px;');   
    div.setAttribute('class',"lines_prereq");
    document.getElementById("myelement").appendChild(div);

}

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