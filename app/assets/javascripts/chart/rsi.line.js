bp.rsi.LineChart = function(domId, chart){
	this.margin = {top: 10, right: 10, bottom: 10, left: 30};
	this.width = chart.width - this.margin.left - this.margin.right;
	this.height = 90;
	
	this.chart = chart;

	this.svg = d3.select("#line-chart").append("svg").attr("class", "line").attr("width",this.width).attr("height", this.height * chart.days + 50);

	this.x = d3.time.scale().range([0, this.width]);
	this.y = d3.scale.linear().range([this.height, 0]);
	this.y_brush = d3.scale.linear().range([this.svg.attr("height"), 0]);
	
	this.afterBrush = function(fromTime, toTime){};
	this.rawData = [];
}

bp.rsi.LineChart.prototype.draw = function(){
	var line = this;
	
	drawForDay(0);

	function drawForDay(day){
		
		var stage = line.svg.append("g")
	   		.attr("transform", "translate(" + line.margin.left + "," + (line.margin.top + line.height * day) + ")");
	
		function padStr(i) {return (i < 10) ? "0" + i : "" + i;}
		function getDayStr(offset){
			var now = new Date();
			now.setDate(now.getDate() - offset);
			return padStr(now.getFullYear()) + "-" + padStr(1 + now.getMonth()) + "-" + padStr(now.getDate());
		}		
		var timeStr, from, to;
		switch(day){
			case 0:
				timeStr = "today";
				break;
			case 1:
				timeStr = "yesterday";
				break;
			default:
				timeStr = getDayStr(day)
		}
		var now = new Date();
		now.setDate(now.getDate() - day);
		var bod = bp.chart.Utils.beginningOfDay(now), eod = bp.chart.Utils.endOfDay(now);
		from = Math.floor(bod.getTime() / 1000), to = Math.floor(eod.getTime() / 1000);
		
		
		stage.append("text").attr("transform", "translate("+ line.width / 3 + ", " + line.height + ")").attr("class", "center-label").text("Loading data of " + timeStr + "...");

		var app = 'var app=sensor.find("' + line.chart.sensor_uuid + '").by_feature(feature("app").aggregate).with(feature("dst").weighted_sum).with(feature("keys").weighted_sum).with(feature("msclks").weighted_sum).with("point", feature("act").weighted_sum).with(feature("scrll").weighted_sum);sensor.find("' + line.chart.sensor_uuid + '").by_time(60).with("apps", app).with("point", feature("act").weighted_sum).from(' + from + ').to('+ to + ').cache("line-chart")'

		var options = {url:line.chart.url, data: {q: app}, success: doDraw};
		if(line.chart.crossdomain){
			options.dataType = "jsonp";
			options.jsonpCallback = "doDraw";
		}
		$.ajax(options);
		
		function doDraw(data){
			stage.select("text").remove();
			
			if (data != null && data.length > 0){
				var xAxis = d3.svg.axis().scale(line.x).orient("bottom");

			    var area = d3.svg.area()
			       	.interpolate("basis")
			       	.x(function(d) { return line.x(d.t); })
			       	.y0(line.height)
			       	.y1(function(d) { return line.y(d.point); });
	
			    $.each(data, function(index, d) {
			    	d.t = new Date(d.t * 1000);
					
			    	d.point = (isNaN(d.point) ? 0 : +d.point);
			
					if(d.apps != null){
						$.each(d.apps, function(index, w){w.t = d.t; w.seconds = bp.chart.Utils.secondsOfDay(w.t); if(isNaN(w.point)){w.point = 0}})
						line.rawData = line.rawData.concat(d.apps);
					}	
							
			    });
			
			console.log("Data is:");
			console.log(data);
			
				//data = bp.chart.Utils.makeConsecutive(data);

		   		line.x.domain(line.chart.fit ? d3.extent($.map(data, function(d) { return d.t; })) : [bp.chart.Utils.beginningOfDay(data[0].t), bp.chart.Utils.endOfDay(data[0].t)]); 
		   		line.y.domain([0, d3.max($.map(data, function(d) { return d.point; }))]);
		console.log("After:")
		console.log(data);

		   	    stage.append("path").data([data]).attr("d", area);
				
				if(!line.chart.fit){
					stage.append("g")
			   	         .attr("class", "x axis")
			   	         .attr("transform", "translate(0," + (line.height) + ")")
			   	         .call(xAxis);
				}
		   	    
			}
			day < line.chart.days - 1 ? drawForDay(day + 1) : drawBrush();
		}
	
	}

	function drawBrush(){
		var height = line.height * line.chart.days;
		line.svg.append("g")
		     .attr("class", "brush")
		     .call(d3.svg.brush().x(line.x).on("brush", brush))
			.selectAll("rect")
		    .attr("y", line.margin.top)
		    .attr("height", height);

		var records = crossfilter(line.rawData);
		line.chart.dataByTime = records.dimension(function(d) { return d.seconds});
		line.chart.dataByApp = records.dimension(function(d) { return d.v});
		
		line.afterBrush(null, null);
	}	

	function brush() {
		var extent = d3.event.target.extent();	
		if(extent[0].getTime() == extent[1].getTime()){
			extent[0] = null;
			extent[1] = null;
		}
		line.afterBrush(extent[0], extent[1]);
	}
}



