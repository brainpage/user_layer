if (typeof bp === 'undefined') {
	var bp = {};
}
bp.rsi = {};
bp.chart = {};
bp.chart.Utils = {};

function drawChart(){	
	var chart = {
		days: 3,
		url: "http://192.168.96.175:3000/rsi/charts/data",
		dataByTime: null,
		dataByApp: null,
		color: {}
	}
	
	var zoomChart = new bp.rsi.ZoomChart("#zoom-line");

	var pieChart = new bp.rsi.PieChart("#pie-chart");
	pieChart.mousedown = function(d){
		$('#app-detail').text("Detail of " + d.key + " (click again to restore)");
		
		var data = chart.dataByApp.filter(d.v).top(Infinity);
		zoomChart.draw(data, d);
	}
	
	var keysBarChart = new bp.rsi.BarChart("#keys-bar");
	
	var msclksBarChart = new bp.rsi.BarChart("#msclks-bar");
	var dstBarChart = new bp.rsi.BarChart("#dst-bar");
	
	var lineChart = new bp.rsi.LineChart("#line-chart", chart);
	
	var colors = d3.scale.category20();
	
	lineChart.afterBrush = function(fromTime, toTime){
		
		var group;
		if(fromTime != null){
			group = chart.dataByTime.filter([bp.chart.Utils.secondsOfDay(fromTime), bp.chart.Utils.secondsOfDay(toTime)]).top(Infinity);
		}else{
			group = chart.dataByTime.top(Infinity)
		}
		
		group = crossfilter(group).dimension(function(d) { return d.v; }).group();
		
		var pieData = group.reduceSum(function(d) { return parseFloat(d.d); }).all();
		pieData.forEach(function(d){
			d.color = chart.color[d.key] == null ? (chart.color[d.key] = colors(bp.chart.Utils.hashLength(chart.color))) : chart.color[d.key];
		})
		pieChart.draw(pieData, true);
	
		keysBarChart.draw(group.reduceSum(function(d){return d.keys; }).all());
	    msclksBarChart.draw(group.reduceSum(function(d){return d.msclks; }).all());
	    dstBarChart.draw(group.reduceSum(function(d){return d.dst; }).all());		
	};
	
	lineChart.draw();
}

