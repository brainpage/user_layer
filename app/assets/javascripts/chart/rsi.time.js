bp.rsi.TimeChart = function(domId){
	
}

bp.rsi.TimeChart.prototype.draw = function(chart){
	var query = 'sensor.find("0cc32a1ae063af9b70583bd56f9bcaa6dcbe5873").by_time(day).with(feature("app").aggregate).excluding(feature("dst-avg").at_val(5)).from_last(30*day)';
	
	if(chart.crossdomain){
		$.ajax({url: chart.url, data: {q: query}, dataType: "jsonp", jsonp : "callback", jsonpCallback: "doDraw", success: doDraw});
	}else{
		d3.json(chart.url + "?t=time&q=" + query, doDraw);		
	}
	
	function doDraw(data){
		
		data = data.sort(function(a, b){return a.t - b.t});
		
		var layers = [];
		var dates = [];
		var map = {};
		
		var layer_index = 0;
		data.forEach(function(d){
			d.app.forEach(function(app){
				app.v = bp.chart.Utils.trim(app.v);
				if(map[app.v] == null){
					map[app.v] = layer_index++;
					layers.push([]);
				}
			})
		});
		
		var item;
		data.forEach(function(d, index){
			dates[index] = d.t;
			layers.forEach(function(layer){
				layer[index] = {x: index, y:0, y0: 0}
			})
			
			d.app.forEach(function(app){
				item = layers[map[app.v]][index];
				item.y = Math.round(app.d / 60, 0);	
				item.color = chart.getColor(app.v);
				item.day = bp.chart.Utils.shortDate(new Date(d.t * 1000));
				item.app = app.v;
				item.duration = app.d / 60;	
			})
		});
		
		for(var i=1; i< layers.length; i++){
			for(j=0; j < data.length; j++){
				layers[i][j].y0 = layers[i-1][j].y0 + layers[i-1][j].y;
			}
		}
	
	    var n = layers.length, // number of layers
        m = 30, // dates.length, // number of samples per layer

        color = d3.interpolateRgb("#aad", "#556");
		data = layers;

    	var p = 20,
		margin = {top: 30, left: 10, right: 10, bottom: 20},
		yw = 50, // width of y axis
        w = 1160,
        h = 500 - .5 - p - margin.top - margin.bottom,
        mx = m,
        my = d3.max(data, function(d) {
          return d3.max(d, function(d) {
            return d.y0 + d.y;
          });
        }),
        mz = d3.max(data, function(d) {
          return d3.max(d, function(d) {
            return d.y;
          });
        }),
        x = function(d) { return d.x * (w - yw)/ mx; },
        y0 = function(d) { return h - d.y0 * h / my; },
        y1 = function(d) { return h - (d.y + d.y0) * h / my; },
        y2 = function(d) { return d.y * h / mz; }; // or `my` to not rescale
    
		var vis = d3.select("#time-chart")
      		.append("svg")
        	.attr("width", w)
        	.attr("height", h + p + margin.top + margin.bottom);

		var yAxisArea = vis.append("g").attr("class", "y axis")
			.attr("transform", "translate(" + yw + ", " + margin.top + ")");

		var y = d3.scale.linear().domain([0, my]).range([h, 0]);
		var yAxis = d3.svg.axis().scale(y).orient("left");	
		yAxisArea.call(yAxis);
	
		function getColor(data){
			var color;
			data.forEach(function(d){
				if(d.color){ color = d.color;}
			})
			return color;
		}
		    
		var layers = vis.selectAll("g.layer")
			.data(data)
			.enter().append("g")
			.style("fill", function(d) {return getColor(d);})
			.attr("class", "layer");
    
		var bars = layers.selectAll("g.bar")
			.data(function(d) { return d; })
			.enter().append("g")
			.attr("class", "bar")
			.attr("transform", function(d) { return "translate(" + (x(d) + yw) + "," + margin.top + ")"; });
    
		bars.append("rect")
			.attr("width", x({x: .9}))
			.attr("x", 0)
			.attr("y", h)
			.attr("height", 0)
			.on("mouseover", mouseover)
			.on("mouseout", mouseout)
			.transition()
			.delay(function(d, i) { return i * 10; })
			.attr("y", y1)
			.attr("class", function(d){return d.app;})
			.attr("height", function(d) { return y0(d) - y1(d); });

		var preSelected = null;
		function mouseover(d, i) {
			var tip = vis.append("g").attr("class", "time-tip")
				.attr("transform", "translate(" + (x(d) + 50) + ","+ margin.top + ")");
		
			var right = x(d) + yw > w/2,
				height = 100, width = 280,
				tx, ty;
				
			tip.append("rect")
				.attr("stroke", "white")
				.attr("width", 0)
				.attr("x", right ? 0 : 35)
		        .attr("y", ty = (y0(d) + y1(d))/2 - height / 2 )
		        .attr("height", height)
		      	.transition()
		        .delay(200)
		        .attr("x", tx = right ? -width : 35)
				.attr("width", width);

			var total = 0,
				dayTotal = 0,
			 	days = 0;
			
			data[map[d.app]].forEach(function(d){
				if(d.duration != null){
					total += d.duration;
					days++;
				}
			})
			data.forEach(function(layer){
				if(layer[i].duration != null){
					dayTotal += layer[i].duration;
				}
			})
			
			var f = bp.chart.Utils.formatMinutes;
			tip.append("text").attr("x", tx + 10).attr("y", ty + 30).attr("class", "f11").transition().delay(300).text(d.app);
			tip.append("text").attr("x", tx + 10).attr("y", ty + 60).attr("class", "f10").transition().delay(300)
				.text(f(d.duration) + " of " + f(dayTotal) + " on " + d.day);
			tip.append("text").attr("x", tx + 10).attr("y", ty + 85).attr("class", "f9").transition().delay(300)
				.text(f(total) + " in " + days + " days, avg "+ f(Math.round(total/days, 0)));		 
				
			d3.selectAll("." + d.app).attr("fill", "black").attr("stroke", "white").attr("stroke-width", 2);
			if(preSelected != null && preSelected.app != d.app){
				d3.selectAll("." + preSelected.app).attr("fill", preSelected.color).attr("stroke", "none");
			}
		}
		
		function mouseout(d, i) {
			d3.selectAll(".time-tip").remove();
			preSelected = d;		   
		}
    
		var labels = vis.selectAll("text.label")
        	.data(data[0])
			.enter().append("text")
			.attr("class", "label")
			.attr("transform", function(d) { return "translate(" + yw + ", " + margin.top + ")"; })
			.attr("x", x)
			.attr("y", h + 6)
			.attr("dx", x({x: .5}))
			.attr("dy", ".71em")
			.attr("text-anchor", "middle")
			.text(function(d, i) {return bp.chart.Utils.shortDate(new Date(dates[i] * 1000))});
    
		vis.append("line")
			.attr("x1", 0)
			.attr("x2", w - x({x: .1}))
			.attr("y1", h)
			.attr("y2", h);
	
	}
}