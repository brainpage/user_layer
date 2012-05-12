var initFilterFields = function(){
	$('#from').datetimepicker({dateFormat: 'yy-mm-dd'}); 
	$('#to').datetimepicker({dateFormat: 'yy-mm-dd'}); 
	$("#fl").multiselect({selectedText: "# of # selected"});
	$("#fl").multiselect("checkAll");
	
	var t = new Date();
	t.setHours(t.getHours() - 1);
	$('#from').val(bp.chart.Utils.fullTime(t), false);
	$('#to').val(bp.chart.Utils.fullTime(new Date()), false);
	setFeaturesValue();
};

var setFeaturesValue = function(){
	var v=""; 
	$("#fl").multiselect("getChecked").each(function(){v += this.value + ",";});
	$("#features").val(v);
}

var makeDataRequest = function(uuid, csv){
	var query = {};
	if($("#from").val() != ""){
		query.from = parseDateTime($("#from").val()).getTime()/1000;
	}
	if($("#to").val() != ""){
		query.to = parseDateTime($("#to").val()).getTime()/1000;
	}
	if($("#features").val() != ""){
		query.features = $("#features").val();
	}
	if(csv){
		query.format = "csv";
	}
	$("#data-list").html("<div class='center'><img src='/assets/spinner.gif'></img></div>");
	$.get('/db/sensors/' + uuid, query, function(data){
		
		var header = "<thead><tr><th>Time</th>";
		$.each(data.columns, function(){header += "<th>" + this + "</th>"});
		header += "</tr></thead>"
		
		var tbody = "<tbody>";
		$.each(data.data, function(){
			tbody += "<tr>";
			
			tbody += "<td>" + bp.chart.Utils.fullTime(new Date(this.ts * 1000), true) + "</td>";
			var item = this;
			$.each(data.columns, function(){
				tbody += "<td>" + (item[this] ? item[this] : "") + "</td>";
			})
			tbody += "</tr>";
		});
		tbody += "</tbody>"
		
		$("#data-list").html(header + tbody);
	});
}

var parseDateTime = function(str){
	var a = str.split(" "),
	    time = a[1].split(":");
	var t = $.datepicker.parseDate('yy-mm-dd', a[0]);
	t.setHours(parseInt(time[0]));
	t.setMinutes(parseInt(time[1]));
	return t;
}


