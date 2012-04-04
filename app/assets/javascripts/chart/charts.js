if (typeof bp === 'undefined') {
	var bp = {};
}
bp.rsi = {};
bp.chart = {};
bp.chart.Utils = {};

function drawChart(){	
	var chart = {
		days: 1,
		url: "http://192.168.96.175:3000/rsi/charts/data?day=",
		data: [],
		color: {}
	}
	
	var zoomChart = new bp.rsi.ZoomChart("#zoom-line");

	var pieChart = new bp.rsi.PieChart("#pie-chart");
	pieChart.mousedown = function(d){
		zoomChart.draw(chart.data, d);
	}
	
	var keysBarChart = new bp.rsi.BarChart("#keys-bar");
	var msclksBarChart = new bp.rsi.BarChart("#msclks-bar");
	var dstBarChart = new bp.rsi.BarChart("#dst-bar");
	
	var lineChart = new bp.rsi.LineChart("#line-chart", chart);
	
	lineChart.afterBrush = function(data){
		var apps = [];
		data.forEach(function(d) {apps = apps.concat(d.apps) });
		
		var colors = d3.scale.category20();
		var nest = d3.nest()
		    .key(function(d) { return d.name; })
		    .entries(apps);

		apps = nest.map(function(d){
			var dur = 0;
				keys = 0;
				msclks = 0;
				dst = 0;
			d.values.forEach(function(w) { 
				dur += parseFloat(w.dur);
				keys += +w.keys;
				msclks += +w.msclks;
				dst += +w.dst;
			});
			
			var color = chart.color[d.key] == null ? (chart.color[d.key] = colors(bp.chart.Utils.hashLength(chart.color))) : chart.color[d.key];
			
			return {name: d.key, color: color, dur: dur, keys: keys, msclks: msclks, dst: dst}
		});
		apps = bp.chart.Utils.removeSmallData(apps);
		apps.sort(function(a, b) { return b.name.localeCompare(a.name); });
		
		pieChart.draw(apps.map(function(d){return {name: d.name, color: d.color, value: d.dur}}), true);
		
		keysBarChart.draw(apps.map(function(d){return {name: d.name, color: d.color, value: d.keys}}));
	    msclksBarChart.draw(apps.map(function(d){return {name: d.name, color: d.color, value: d.msclks}}));
	    dstBarChart.draw(apps.map(function(d){return {name: d.name, color: d.color, value: d.dst}}));
	};
	
	lineChart.draw();
}

