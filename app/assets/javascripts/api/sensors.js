var initFilterFields = function(){
	$('#from').datetimepicker({dateFormat: 'yy-mm-dd'}); 
	$('#to').datetimepicker({dateFormat: 'yy-mm-dd'}); 
	$("#fl").multiselect({selectedText: "# of # selected"});
	$("#fl").multiselect("checkAll");
};

var setFeaturesValue = function(){
	var v=""; 
	$("#fl").multiselect("getChecked").each(function(){v += this.value + ",";});
	$("#features").val(v);
}

var makeDataRequest = function(){
console.log($.datepicker.parseDate('yy-mm-dd', '2007-01-26'))
	$.get('/api/sensors/test_data', {}, function(data){
		console.log(data);
	});
}


