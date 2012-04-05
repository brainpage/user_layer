bp.chart.Utils.removeSmallData = function(data){
	var total = 0;
	data.map(function(d){total += d.value});
	if(total > 0){
		data = data.filter(function(d){return d.value / total > 0.01})
	}
	return data;
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
	
	data.sort(function(a, b) { return a.time - b.time; });			
	data.forEach(function(d) {
	    if(pre != null && ((dst = Math.round((d.time - pre) / (1000 * interval), 0)) > 1)){
	    
			for(var i = 1; i < dst; i++){
				tmpTime = new Date(pre);
				tmpTime.setSeconds(pre.getSeconds() + interval * i)
			
	    		zeroAdded.push({time: tmpTime, point: 0, apps: []});
	    	}
	    }
		zeroAdded.push(d);
	    pre = d.time;
	});
	
	return zeroAdded;
}
