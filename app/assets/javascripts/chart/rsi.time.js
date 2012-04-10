bp.rsi.TimeChart = function(domId){
	
}

bp.rsi.TimeChart.prototype.draw = function(chart){
	
	d3.json(chart.url + "?type=time", function(data) {
		data = data.sort(function(a, b){return b.t - a.t});
		
		var layers = [];
		var dates = [];
		var map = {};
		
		var layer_index = 0;
		data.forEach(function(d){
			d.app.forEach(function(app){
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
				item.day = d.t;
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
        m = dates.length, // number of samples per layer

        color = d3.interpolateRgb("#aad", "#556");
		data = layers;

    	var p = 20,
        w = 1160,
        h = 200 - .5 - p,
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
        x = function(d) { return d.x * (w -50)/ mx; },
        y0 = function(d) { return h - d.y0 * h / my; },
        y1 = function(d) { return h - (d.y + d.y0) * h / my; },
        y2 = function(d) { return d.y * h / mz; }; // or `my` to not rescale

    
    var vis = d3.select("#time-chart")
      .append("svg")
        .attr("width", w)
        .attr("height", h + p);

   var yAxisArea = vis.append("g").attr("class", "y axis")
   		.attr("transform", "translate(50,1)");

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
        .attr("transform", function(d) { return "translate(" + (x(d) + 50) + ",0)"; });
    
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


		function mouseover(d, i) {
		
			vis.append("g").attr("class", "time-tip")
				.attr("transform", "translate(" + (x(d) + 50) + ","+ y1(d) + ")")
				.append("text")
				.text("hello");
		 	d3.selectAll("." + d.app).attr("fill", "red").attr("stroke", "white").attr("stroke-width", 2);		
		 }
		
		function mouseout(d, i) {
		   d3.selectAll("." + d.app).attr("fill", d.color).attr("stroke", "none");
		}
    
    var labels = vis.selectAll("text.label")
        .data(data[0])
      .enter().append("text")
        .attr("class", "label")
		.attr("transform", function(d) { return "translate(" + 50 + ",0)"; })
        .attr("x", x )
        .attr("y", h + 6)
        .attr("dx", x({x: .9}))
        .attr("dy", ".71em")
        .attr("text-anchor", "middle")
        .text(function(d, i) { var date = new Date(dates[i] * 1000); return (date.getMonth() + 1) + "-" + date.getDate(); });
    
    vis.append("line")
        .attr("x1", 0)
        .attr("x2", w - x({x: .1}))
        .attr("y1", h)
        .attr("y2", h);
	});
}