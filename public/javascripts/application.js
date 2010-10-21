jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$(document).ready(function() {
	$('#complete_items p.tags').hide();
	//
	// Show/hide new task form  
	//-------------------------
	$('#new_task').hide(); 
	$('#add').click(function() {
		$('#new_task').show();
		$(this).hide();
		return false;		  		
	});
	$('#cancel').click(function() {
  		$('#new_task').hide();
  		$('#add').show();
  		return false;		  		
	});
	
	//
	// Fix checkbox states after page reload..
	//-----------------------------------------
	$('#incomplete_items input:checkbox').each(function(index) {
    	if ($(this).is(':checked')) { $(this).attr('checked', false); }
  	});
	$('#complete_items input:checkbox').each(function(index) {
    	if ($(this).not(':checked')) { $(this).attr('checked', true); }
  	});
  	
	//
	// Ajax task status checkbox state 
	//---------------------------------
	$('#complete_items input:checkbox').live('click', function() {
		$.post($(this).parent().attr("action"), $(this).parent().serialize(), null, "script");
		$(this).parent().parent().remove();
		return false; // ?
	});
	$('#incomplete_items input:checkbox').live('click', function() {
		$.post($(this).parent().attr("action"), $(this).parent().serialize(), null, "script");
		$(this).parent().parent().remove();
		return false; // ?
	});	
	
	//
	// Tasklist item sorting
	//------------------------
	
	var ajax_sort_update_running = false;
	$("#incomplete_items").sortable({
		handle : '.handle',
		
		axis : 'y',
		
		update : function (event, ui) {
			var sort_data = ""
			var sorted = $(this).sortable('toArray');
			for (i in sorted) { sort_data += "&list[order][]=" + i + "_" + sorted[i].split('_')[1]; } 
			var _token = $(ui.item).children().children().children('input[name=authenticity_token]').attr('value');
			$("ul#incomplete_items").addClass("animation");
			$("#incomplete_items").sortable("disable");
			$.post("tasks/"+$(ui.item).attr("id").split('_')[1], "_method=put&authenticity_token="+_token+sort_data, null, "script");
    	}
	});
});