if (typeof bp === 'undefined') {
	var bp = {};
}
bp.rsi = {};
bp.chart = {};
bp.chart.Utils = {};

var loadedData = {};

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
		$('#app-detail').text(I18n.t("detail_of", {app: d.key}));
		$("html,body").scrollTop($(document).height());			
		
		d3.selectAll("#pie-chart .pie-item").attr("fill", function(d){return d.color}).attr("stroke-width", 1);
		d3.selectAll("#pie-chart ." + d.key).attr("fill", "#868686").attr("stroke-width", 2);
	
		var data = chart.dataByApp.filter(d.origin_key).top(Infinity);
		zoomChart.draw(data, d);
	}
	
	var keysBarChart = new bp.rsi.BarChart("#keys-bar");
	var msclksBarChart = new bp.rsi.BarChart("#msclks-bar", true);
	var dstBarChart = new bp.rsi.BarChart("#dst-bar", true);
	var scrllBarChart = new bp.rsi.BarChart("#scrll-bar", true);
	var kmrBarChart = new bp.rsi.BarChart("#kmr-bar", true);
	
	var lineChart = new bp.rsi.LineChart("#line-chart", chart);
	
	if(fromDay + toDay == 0){
		lineChart.afterDraw = function(){timeChart.draw(chart)};
	}	
	
	lineChart.afterBrush = function(fromTime, toTime){
		chart.dataByApp.filterAll();
		chart.dataByTime.filterAll();
		
		var group = getGroup(chart, fromTime, toTime);
		
		var data = getPieData(group, chart);
		data = bp.chart.Utils.removeSmallData(data);
		pieChart.draw(data, true);
	
		var visible = data.map(function(e){return e.key});
		
		keysBarChart.draw(group, "keys", chart, visible);
	    msclksBarChart.draw(group, "msclks", chart, visible);
	    dstBarChart.draw(group, "dst", chart, visible);		
		scrllBarChart.draw(group, "scrll", chart, visible);
		kmrBarChart.draw(group, "kmr", chart, visible);
	};
	
	lineChart.draw();
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