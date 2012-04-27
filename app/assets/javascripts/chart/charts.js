if (typeof bp === 'undefined') {
	var bp = {};
}
bp.rsi = {};
bp.chart = {};
bp.chart.Utils = {};

function drawChart(sensor_uuid, fromDay, toDay){	
	$(".chart").empty();
	
	var chart = new bp.rsi.ChartObject({fromDay: fromDay, toDay: toDay});
	chart.width = 1100;
	chart.sensor_uuid = sensor_uuid
	
	getGlobalAverage(chart);
	
	var timeChart = new bp.rsi.TimeChart("#time-chart");
	
	var zoomChart = new bp.rsi.ZoomChart("#zoom-line");

	var pieChart = new bp.rsi.PieChart("#pie-chart");
	pieChart.mousedown = function(d){
		$('#app-detail').text("Detail of " + d.key);
		$("html,body").scrollTop($(document).height());			
		
		d3.selectAll("#pie-chart .pie-item").attr("fill", function(d){return d.color}).attr("stroke-width", 1);
		d3.selectAll("#pie-chart ." + d.key).attr("fill", "#868686").attr("stroke-width", 2);
	
		var data = chart.dataByApp.filter(d.origin_key).top(Infinity);
		zoomChart.draw(data, d);
	}
	
	var keysBarChart = new bp.rsi.BarChart("#keys-bar");
	var msclksBarChart = new bp.rsi.BarChart("#msclks-bar");
	var dstBarChart = new bp.rsi.BarChart("#dst-bar");
	var scrllBarChart = new bp.rsi.BarChart("#scrll-bar");
	
	var lineChart = new bp.rsi.LineChart("#line-chart", chart);
	
	lineChart.afterBrush = function(fromTime, toTime){
		chart.dataByApp.filterAll();
		chart.dataByTime.filterAll();
		
		var group = getGroup(chart, fromTime, toTime);
		pieChart.draw(getPieData(group, chart), true);
	
		keysBarChart.draw(group, "keys", chart);
	    msclksBarChart.draw(group, "msclks", chart);
	    dstBarChart.draw(group, "dst", chart);		
		scrllBarChart.draw(group, "scrll", chart);
	};
	
	timeChart.draw(chart, function(){lineChart.draw();});
}

function getGlobalAverage(chart){
	d3.json(chart.avg_url, function(data){
		chart.global_avg = data;
	});
}

function drawPortalChart(sensor_uuid){	
	var chart = new bp.rsi.ChartObject({fromDay: 0, toDay:0});
	chart.width = 580;
	chart.fit = true;
	chart.sensor_uuid = sensor_uuid;
	
	var pieChart = new bp.rsi.PieChart("#pie-chart");
	
	var lineChart = new bp.rsi.LineChart("#line-chart", chart);
	lineChart.afterBrush = function(fromTime, toTime){
		pieChart.draw(getPieData(getGroup(chart, fromTime, toTime), chart), true);
	};
	
	lineChart.draw();
}

function getGroup(chart, fromTime, toTime){
	var group;
	
	if(fromTime != null){
		group = chart.dataByTime.filter([bp.chart.Utils.secondsOfDay(fromTime), bp.chart.Utils.secondsOfDay(toTime)]).top(Infinity);
	}else{
		group = chart.dataByTime.filterAll().top(Infinity)
	}
	
	return crossfilter(group.filter(function(d){return d.point > 0})).dimension(function(d) { return d.v; }).group();
}

function getPieData(group, chart){	
	var pieData = group.reduceSum(function(d) { return parseFloat(d.d); }).all();
	pieData.forEach(function(d){
		d.color = chart.getColor(bp.chart.Utils.trim(d.key));
		
	})
	
	return pieData;
}