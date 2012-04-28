bp.chart.Utils.removeSmallData = function(data){
	var total = 0, other = 0;
	data.map(function(d){total += d.value});
	
	var main = []
	if(total > 0){		
		data.forEach(function(d){if(d.value / total > 0.02){main.push(d)}});
	}
	return main;
}

bp.chart.Utils.beginningOfDay = function(time){
	var begin = new Date(time);
	begin.setHours(0);
	begin.setMinutes(0);
	begin.setSeconds(0);
	return begin;
}

bp.chart.Utils.endOfDay = function(time){
	var end = new Date(time);
	end.setHours(23);
	end.setMinutes(59);
	end.setSeconds(59);
	return end;
}

bp.chart.Utils.hashLength = function(hash){
	var count = 0;
	for (var i in hash) count++;
	return count;
}

//Add datapoint with 0 point, so that the chart makes sense.
bp.chart.Utils.makeConsecutive = function(data){	
	var zeroAdded = [],
		pre = null,
		interval = 60, //Seconds
		dst = 0,
		tmpTime;
	
	data.sort(function(a, b) { return a.t - b.t; });			
	data.forEach(function(d) {
	    if(pre != null && ((dst = Math.round((d.t - pre) / (1000 * interval), 0)) > 1)){
	    
			for(var i = 1; i < dst; i++){
				tmpTime = new Date(pre);
				tmpTime.setSeconds(pre.getSeconds() + interval * i)
			
	    		zeroAdded.push({t: tmpTime, point: 0, apps: []});
	    	}
	    }
		zeroAdded.push(d);
	    pre = d.t;
	});
	
	return zeroAdded;
}

bp.chart.Utils.trim = function(name){	
	return name == null ? "" : name.split(".").pop();
}

bp.chart.Utils.secondsOfDay = function(date){
	return date.getHours() * 3600 + date.getMinutes() * 60 + date.getSeconds();
}

bp.chart.Utils.shortDate = function(date){
	return (date.getMonth() + 1) + "-" + date.getDate();
}

bp.chart.Utils.formatMinutes = function(minutes){
	var min = Math.round(minutes % 60, 0);
	var hour = Math.round((minutes - min) / 60, 0); 
	if(hour == 0){return min + "m";}
	
	if(min < 10){min = "0" + min};
	return hour + "h:" + min + "m";
}


