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
