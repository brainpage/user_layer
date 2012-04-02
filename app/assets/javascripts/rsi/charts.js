function drawChart(){
	var margin = {top: 10, right: 10, bottom: 10, left: 30},
		width = 1170 - margin.left - margin.right,
		height = 90,
		days = 1,
		all_data = [];

	//var formatDate = d3.time.format("%Y-%m-%d %H:%M:%S");

	var svg = d3.select("#line-chart").append("svg").attr("class", "line").attr("width", width).attr("height", height * days + 50);

	var x = d3.time.scale().range([0, width]),
		y = d3.scale.linear().range([height, 0]),
		y_brush = d3.scale.linear().range([svg.attr("height"), 0]);

	draw(0);

	function draw(day){
		d3.json("http://192.168.96.175:3000/rsi/charts/data?day=" + day, function(data) {
			if (data.length > 0){
				var xAxis = d3.svg.axis().scale(x).orient("bottom");

			    var area = d3.svg.area()
			       	.interpolate("monotone")
			       	.x(function(d) { return x(d.time); })
			       	.y0(height - 10)
			       	.y1(function(d) { return y(d.point); });
				
				all_data = all_data.concat(data);

				var stage = svg.append("g")
			   		.attr("transform", "translate(" + margin.left + "," + (margin.top + height * day) + ")");

		   	   data.forEach(function(d) {
		   	   	//d.timestamp = formatDate.parse(d.timestamp);
			   	   d.time = new Date(d.time * 1000);
		   	       d.point = +d.point;
		   	   });

		   		x.domain([beginningOfDay(data[0].time), endOfDay(data[0].time)]); //d3.extent(data.map(function(d) { return d.timestamp; }))
		   		y.domain([0, d3.max(data.map(function(d) { return d.point; }))]);

		   	    stage.append("path").data([data]).attr("d", area);

		   	    stage.append("g")
		   	         .attr("class", "x axis")
		   	         .attr("transform", "translate(0," + (height - 10) + ")")
		   	         .call(xAxis);
			}
			day < days - 1 ? draw(day + 1) : drawBrush();
	   	});
	}

	function drawBrush(){
		svg.append("g")
		     .attr("class", "brush")
		     .call(d3.svg.brush().x(x).y(y_brush)
		     .on("brush", brush));

		drawPieAndBars(all_data);
	}	

	function brush() {
	  
		var extent = d3.event.target.extent();
		var from = extent[0][0],
			to = extent[1][0];
			
		var data = all_data.filter(function(d){return d.time - from > 0 && d.time - to < 0});
		drawPieAndBars(data);
	}
	
	function drawPieAndBars(data){
		var apps = [];
		data.forEach(function(d) {apps = apps.concat(d.apps) });
		
		apps.sort(function(a, b) { return b.name.localeCompare(a.name); });
		
		drawPie(apps);
		updateKeysBar(apps);
		updateMsclksBar(apps);
		updateDstBar(apps);
	}

	function beginningOfDay(time){
		var begin = new Date(time);
		begin.setHours(0);
		begin.setMinutes(0);
		begin.setSeconds(0);
		return begin;
	}

	function endOfDay(time){
		var end = new Date(time);
		end.setHours(23);
		end.setMinutes(59);
		end.setSeconds(59);
		return end;
	}

	function drawPie(data){
		var nest = d3.nest()
		    .key(function(d) { return d.name; })
		    .entries(data);

		update(nest.map(function(d){
			var total = 0;
			d.values.forEach(function(w) { total += parseFloat(w.dur); });
			return {name: d.key, value: total}
		}));
	}

	function removeSmallData(data){
		var total = 0;
		data.map(function(d){total += d.value});
		if(total > 0){
			data = data.filter(function(d){return d.value / total > 0.01})
		}
		return data;
	}

	var w = 450;
	var h = 300;
	var r = 120;
	var ir = 45;
	var textOffset = 14;
	var tweenDuration = 300;

	var lines, valueLabels, nameLabels;
	var pieData = [];    
	var oldPieData = [];
	var filteredPieData = [];

	var donut = d3.layout.pie().value(function(d){return d.value;});

	var color = d3.scale.category20();

	var arc = d3.svg.arc()
	  .startAngle(function(d){ return d.startAngle; })
	  .endAngle(function(d){ return d.endAngle; })
	  .innerRadius(ir)
	  .outerRadius(r);

	var vis = d3.select("#pie-chart").append("svg:svg").attr("width", w).attr("height", h);
	
	var centerLabel = vis.append("svg:g")	  
	  .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")")
	  .append("svg:text")
	  .attr("dy", 5)
	  .attr("class", "center-label")
	  .attr("text-anchor", "middle") 
	  .text("Loading Apps...");

	var arc_group = vis.append("svg:g")
	  .attr("class", "arc")
	  .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")");

	var label_group = vis.append("svg:g")
	  .attr("class", "label_group")
	  .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")");

	//placeholder
	var paths = arc_group.append("svg:circle")
	    .attr("fill", "transparent")
	    .attr("r", r);

	var mask = false;
	function update(data) {
	  data = removeSmallData(data);

	  oldPieData = filteredPieData;
	  pieData = donut(data);

	  filteredPieData =  pieData.filter(filterData);
	  function filterData(element, index, array) {
	    element.name = data[index].name;
	    element.value = data[index].value;
	    return (element.value > 0);
	  }

	  if(filteredPieData.length > 0 ){

	    //REMOVE PLACEHOLDER CIRCLE
	    arc_group.selectAll("circle").remove();

	    centerLabel.text("Apps");

	    //DRAW ARC PATHS
	    paths = arc_group.selectAll("path").data(filteredPieData);
	    paths.enter().append("svg:path")
	      .attr("stroke", "white")
	      .attr("stroke-width", 0.5)
	      .attr("fill", function(d, i) { return color(i); })
		  .on("mousedown", function(d) {
				if(mask){
					update(data);
					mask = false;
				}else{
					update([d]);
					mask = true;
				}		        
		   })
	      .transition()
	        .duration(tweenDuration)
	        .attrTween("d", pieTween);
	    paths
	      .transition()
	        .duration(tweenDuration)
	        .attrTween("d", pieTween);
	    paths.exit()
	      .transition()
	        .duration(tweenDuration)
	        .attrTween("d", removePieTween)
	      .remove();

	    //DRAW TICK MARK LINES FOR LABELS
	    lines = label_group.selectAll("line").data(filteredPieData);
	    lines.enter().append("svg:line")
	      .attr("x1", 0)
	      .attr("x2", 0)
	      .attr("y1", -r-3)
	      .attr("y2", -r-8)
	      .attr("stroke", "white")
	      .attr("transform", function(d) {
	        return "rotate(" + (d.startAngle+d.endAngle)/2 * (180/Math.PI) + ")";
	      });
	    lines.transition()
	      .duration(tweenDuration)
	      .attr("transform", function(d) {
	        return "rotate(" + (d.startAngle+d.endAngle)/2 * (180/Math.PI) + ")";
	      });
	    lines.exit().remove();

		function calcArc(d){
			return Math.cos(((d.startAngle+d.endAngle - Math.PI)/2)) * (r+textOffset) + "," + Math.sin((d.startAngle+d.endAngle - Math.PI)/2) * (r+textOffset);
		}
		
		function calcPos(d){
			return (d.startAngle+d.endAngle)/2 < Math.PI ? "beginning" : "end";
		}

	    //DRAW LABELS WITH PERCENTAGE VALUES
	    valueLabels = label_group.selectAll("text.value").data(filteredPieData);

	    valueLabels.enter().append("svg:text")
	      .attr("class", "value")
	      .attr("transform", function(d) {return "translate(" + calcArc(d) + ")";});

	    valueLabels.transition().duration(tweenDuration).attrTween("transform", textTween);

	    valueLabels.exit().remove();


	    //DRAW LABELS WITH ENTITY NAMES
	    nameLabels = label_group.selectAll("text.units")
		  .data(filteredPieData)
	      .attr("dy", 5)
	      .attr("text-anchor", calcPos)
	      .text(function(d){return d.name;});

	    nameLabels.enter().append("svg:text")
	      .attr("class", "units")
	      .attr("transform", function(d) {return "translate(" + calcArc(d) + ")";})
	      .attr("dy", 5)
	      .attr("text-anchor", calcPos)
		  .text(function(d){return d.name;});

	    nameLabels.transition().duration(tweenDuration).attrTween("transform", textTween);

	    nameLabels.exit().remove();
	  }  
	}

	// Interpolate the arcs in data space.
	function pieTween(d, i) {
	  var s0;
	  var e0;
	  if(oldPieData[i]){
	    s0 = oldPieData[i].startAngle;
	    e0 = oldPieData[i].endAngle;
	  } else if (!(oldPieData[i]) && oldPieData[i-1]) {
	    s0 = oldPieData[i-1].endAngle;
	    e0 = oldPieData[i-1].endAngle;
	  } else if(!(oldPieData[i-1]) && oldPieData.length > 0){
	    s0 = oldPieData[oldPieData.length-1].endAngle;
	    e0 = oldPieData[oldPieData.length-1].endAngle;
	  } else {
	    s0 = 0;
	    e0 = 0;
	  }
	  var i = d3.interpolate({startAngle: s0, endAngle: e0}, {startAngle: d.startAngle, endAngle: d.endAngle});
	  return function(t) {
	    var b = i(t);
	    return arc(b);
	  };
	}

	function removePieTween(d, i) {
	  s0 = 2 * Math.PI;
	  e0 = 2 * Math.PI;
	  var i = d3.interpolate({startAngle: d.startAngle, endAngle: d.endAngle}, {startAngle: s0, endAngle: e0});
	  return function(t) {
	    var b = i(t);
	    return arc(b);
	  };
	}

	function textTween(d, i) {
	  var a;
	  if(oldPieData[i]){
	    a = (oldPieData[i].startAngle + oldPieData[i].endAngle - Math.PI)/2;
	  } else if (!(oldPieData[i]) && oldPieData[i-1]) {
	    a = (oldPieData[i-1].startAngle + oldPieData[i-1].endAngle - Math.PI)/2;
	  } else if(!(oldPieData[i-1]) && oldPieData.length > 0) {
	    a = (oldPieData[oldPieData.length-1].startAngle + oldPieData[oldPieData.length-1].endAngle - Math.PI)/2;
	  } else {
	    a = 0;
	  }
	  var b = (d.startAngle + d.endAngle - Math.PI)/2;

	  var fn = d3.interpolateNumber(a, b);
	  return function(t) {
	    var val = fn(t);
	    return "translate(" + Math.cos(val) * (r+textOffset) + "," + Math.sin(val) * (r+textOffset) + ")";
	  };
	}
	
	
	// bar chart
	var bar_m = [0, 10, 10, 100],
	    bar_w = 360 - bar_m[1] - bar_m[3],
	    bar_h = 170 - bar_m[0] - bar_m[2];

	var format = d3.format(",.0f");

	var bar_x = d3.scale.linear().range([0, bar_w]),
	    bar_y = d3.scale.ordinal().rangeRoundBands([0, bar_h], .1);

	var bar_yAxis = d3.svg.axis().scale(bar_y).orient("left").tickSize(0);

	var keys_svg = d3.select("#keys-bar").append("svg")
	    .attr("width", bar_w + bar_m[1] + bar_m[3])
	    .attr("height", bar_h + bar_m[0] + bar_m[2])
	  .append("g")
	    .attr("transform", "translate(" + bar_m[3] + "," + bar_m[0] + ")");
	
	var yKeysAxisProc =  keys_svg.append("g")
	      .attr("class", "y axis");
	      
	
	
	function updateKeysBar(data){
		var nest = d3.nest()
		    .key(function(d) { return d.name; })
		    .entries(data);

		data = nest.map(function(d){
			var total = 0;
			d.values.forEach(function(w) { total += +w.keys; });
			return {name: d.key, value: total}
		});
		
		// Parse numbers, and sort by value.
		  //data.forEach(function(d) { d.value = +d.value; });
		  //data.sort(function(a, b) { return b.value - a.value; });

		  // Set the scale domain.
		  bar_x.domain([0, d3.max(data, function(d) { return d.value; })]);
		  bar_y.domain(data.map(function(d) { return d.name; }));

		  keys_svg.selectAll("g.bar").data([]).exit().remove();

		  var bar = keys_svg.selectAll("g.bar")
		      .data(data)
		    .enter().append("g")
		      .attr("class", "bar")
		      .attr("transform", function(d) { return "translate(0," + bar_y(d.name) + ")"; });

		  bar.append("rect")
			  .attr("stroke", "white")
			  .attr("stroke-width", 0.5)
		      .attr("width", function(d) { return bar_x(d.value); })
		      .attr("height", bar_y.rangeBand());

		  bar.append("text")
		      .attr("class", "value")
		      .attr("x", function(d) { return bar_x(d.value) -10; })
		      .attr("y", bar_y.rangeBand() / 2)
		      .attr("dx", -3)
		      .attr("dy", ".35em")
		      .attr("text-anchor", "end")
		      .text(function(d) { return format(d.value); });

		yKeysAxisProc.call(bar_yAxis);
	}


	var msclks_svg = d3.select("#msclks-bar").append("svg")
	    .attr("width", bar_w + bar_m[1] + bar_m[3])
	    .attr("height", bar_h + bar_m[0] + bar_m[2])
	  	.append("g")
	    .attr("transform", "translate(" + bar_m[3] + "," + bar_m[0] + ")");
	
	var yMsclksAxisProc =  msclks_svg.append("g")
	      .attr("class", "y axis");
	      
	
	
	function updateMsclksBar(data){
		var nest = d3.nest()
		    .key(function(d) { return d.name; })
		    .entries(data);

		data = nest.map(function(d){
			var total = 0;
			d.values.forEach(function(w) { total += +w.msclks; });
			return {name: d.key, value: total}
		});
		
		// Parse numbers, and sort by value.
		  //data.forEach(function(d) { d.value = +d.value; });
		  //data.sort(function(a, b) { return b.value - a.value; });

		  // Set the scale domain.
		  bar_x.domain([0, d3.max(data, function(d) { return d.value; })]);
		  bar_y.domain(data.map(function(d) { return d.name; }));

		  msclks_svg.selectAll("g.bar").data([]).exit().remove();

		  var bar = msclks_svg.selectAll("g.bar")
		      .data(data)
		    .enter().append("g")
		      .attr("class", "bar")
		      .attr("transform", function(d) { return "translate(0," + bar_y(d.name) + ")"; });

		  bar.append("rect")
			  .attr("stroke", "white")
			  .attr("stroke-width", 0.5)
		      .attr("width", function(d) { return bar_x(d.value); })
		      .attr("height", bar_y.rangeBand());

		  bar.append("text")
		      .attr("class", "value")
		      .attr("x", function(d) { return bar_x(d.value) -10; })
		      .attr("y", bar_y.rangeBand() / 2)
		      .attr("dx", -3)
		      .attr("dy", ".35em")
		      .attr("text-anchor", "end")
		      .text(function(d) { return format(d.value); });

		yMsclksAxisProc.call(bar_yAxis);
	}
	
	
	var dst_svg = d3.select("#dst-bar").append("svg")
	    .attr("width", bar_w + bar_m[1] + bar_m[3])
	    .attr("height", bar_h + bar_m[0] + bar_m[2])
	  	.append("g")
	    .attr("transform", "translate(" + bar_m[3] + "," + bar_m[0] + ")");
	
	var yDstAxisProc =  dst_svg.append("g")
	      .attr("class", "y axis");
	
	function updateDstBar(data){
		var nest = d3.nest()
		    .key(function(d) { return d.name; })
		    .entries(data);

		data = nest.map(function(d){
			var total = 0;
			d.values.forEach(function(w) { total += +w.dst; });
			return {name: d.key, value: total}
		});
		
		// Parse numbers, and sort by value.
		  //data.forEach(function(d) { d.value = +d.value; });
		  //data.sort(function(a, b) { return b.value - a.value; });

		  // Set the scale domain.
		  bar_x.domain([0, d3.max(data, function(d) { return d.value; })]);
		  bar_y.domain(data.map(function(d) { return d.name; }));

		  dst_svg.selectAll("g.bar").data([]).exit().remove();

		  var bar = dst_svg.selectAll("g.bar")
		      .data(data)
		    .enter().append("g")
		      .attr("class", "bar")
		      .attr("transform", function(d) { return "translate(0," + bar_y(d.name) + ")"; });

		  bar.append("rect")
			  .attr("stroke", "white")
			  .attr("stroke-width", 0.5)
		      .attr("width", function(d) { return bar_x(d.value); })
		      .attr("height", bar_y.rangeBand());

		  bar.append("text")
		      .attr("class", "value")
		      .attr("x", function(d) { return bar_x(d.value) -10; })
		      .attr("y", bar_y.rangeBand() / 2)
		      .attr("dx", -3)
		      .attr("dy", ".35em")
		      .attr("text-anchor", "end")
		      .text(function(d) { return format(d.value); });

		yDstAxisProc.call(bar_yAxis);
	}

}

