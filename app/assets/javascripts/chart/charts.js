if (typeof bp === 'undefined') {
	var bp = {};
}
bp.rsi = {};
bp.chart = {};
bp.chart.Utils = {};

function drawChart(){	
	var chart = {
		days: 1,
		url: "http://192.168.96.175:3000/rsi/charts/data",
		dataByTime: null,
		dataByApp: null,
		color: {},
		colors: d3.scale.category20(),
		
		getColor: function(app){
			return this.color[app] == null ? (this.color[app] = this.colors(bp.chart.Utils.hashLength(this.color))) : this.color[app];
		}
	}
	
	var timeChart = new bp.rsi.TimeChart("#time-chart");
	timeChart.draw(chart);
	
	var zoomChart = new bp.rsi.ZoomChart("#zoom-line");

	var pieChart = new bp.rsi.PieChart("#pie-chart");
	pieChart.mousedown = function(d){
		$('#app-detail').text("Detail of " + d.key);
		
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
			group = chart.dataByTime.filterAll().top(Infinity)
		}
		
		group = crossfilter(group).dimension(function(d) { return d.v; }).group();
		
		var pieData = group.reduceSum(function(d) { return parseFloat(d.d); }).all();
		pieData.forEach(function(d){
			d.color = chart.getColor(d.key);
		})
		pieChart.draw(pieData, true);
	
		keysBarChart.draw(group.reduceSum(function(d){return d.keys; }).all());
	    msclksBarChart.draw(group.reduceSum(function(d){return d.msclks; }).all());
	    dstBarChart.draw(group.reduceSum(function(d){return d.dst; }).all());		
	};
	
	lineChart.draw();
}

