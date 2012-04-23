function showMessageEffect(time, sensor_uuid){	
	var url = "http://brainpage.com/db/query";
	var pUrl = "/rsi/charts/percent"
	var prefix = 'sensor.find("' + sensor_uuid + '").by_time(' + time + ').from_last(' + time + ')';
	var app = prefix + '.by_feature(feature("app").aggregate)';
	var attr = prefix + '.with(feature("dst").weighted_sum).with(feature("keys").weighted_sum).with(feature("msclks").weighted_sum).with(feature("scrll").weighted_sum)';
	
	var appData, attrData;
	
	$.ajax({url: url, data: {q: attr}, dataType: "jsonp", jsonp : "callback", jsonpCallback: "setAttrData", success: setAttrData});	
	
	function setAttrData(data){
		attrData = data;
		$.ajax({url: url, data: {q: app}, dataType: "jsonp", jsonp : "callback", jsonpCallback: "setAppData", success: setAppData});	
	}
	
	function setAppData(data){
		appData = data;
		$.ajax({url: pUrl, data: attrData[0], success: showMessage})
	}
	
	$("#break").fadeIn(2000);

	function showMessage(data){
		var messages = [];
		appData = appData.filter(function(d){return d.d > 180})
						.map(function(d){return {name: bp.chart.Utils.trim(d.v), time: Math.floor(d.d / 60)}})
						
		messages.push("You used " + appData.length + " apps");
	
		messages.push("You typed more than " + data.keys + "% of people");
		messages.push("You clicked the mouse more than " + data.msclks + "% of people");
		messages.push("You moved the mouse farther than " + data.dst + "% of people");
		messages.push("You scrolled farther than " + data.scrll + "% of people");
		appData.forEach(function(d, i){
			messages.push((i==0 ? "You spent " : "") + d.time + " minutes on " + d.name);
		});
		
		messages.push("<a href='/rsi/charts'>Click here to see more statistics</a>");
	
	  	$("#break").fadeOut(2000, function(){

	      $("#past").fadeIn(2000, function(){
	          showAt(0);
	          function showAt(index){
	             if(index < messages.length){
	                var msg = messages[index];
	                $('#content').delay(index == 0 ? 0 : 1000).fadeOut(1000, function(){$('#content').html(msg); $('#content').fadeIn(2000, function(){showAt(index+1)})});  
	             }
	          }
	      });

	  });
	}
}

