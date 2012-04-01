function drawChart(){
	var margin = {top: 10, right: 10, bottom: 10, left: 30},
		width = 1170 - margin.left - margin.right,
		height = 80,
		days = 3,
		all_data = [];

	var formatDate = d3.time.format("%Y-%m-%d %H:%M:%S");

	var svg = d3.select("#line-chart").append("svg").attr("class", "line").attr("width", width).attr("height", (height + 10) * days);

	var x = d3.time.scale().range([0, width]),
		y = d3.scale.linear().range([height, 0]),
		y_brush = d3.scale.linear().range([svg.attr("height"), 0]);

	svg.append("defs").append("clipPath")
	         .attr("id", "clip")
	         .append("rect")
	         .attr("width", width)
	         .attr("height", height);

	var w = 300,
	    h = 300,
	    r = Math.min(w, h) / 2,
	    color = d3.scale.category20(),
	    donut = d3.layout.pie(),
	    arc = d3.svg.arc().innerRadius(r * .3).outerRadius(r);

	var vis = null,
		arcs = null;

	draw(0);

	function draw(day){
	   	var xAxis = d3.svg.axis().scale(x).orient("bottom");

	    var area = d3.svg.area()
	       	.interpolate("monotone")
	       	.x(function(d) { return x(d.timestamp); })
	       	.y0(height)
	       	.y1(function(d) { return y(d.point); });

		d3.json("http://192.168.96.175:3000/rsi/charts/data?day=" + day, function(data) {
			if (data.length > 0){
				all_data = all_data.concat(data);

				var stage = svg.append("g")
			   		.attr("transform", "translate(" + margin.left + "," + (margin.top + height * day) + ")");

		   		data.forEach(function(d) {
		   			d.timestamp = formatDate.parse(d.timestamp);
		   	        d.point = +d.point;
		   		});

		   		x.domain([beginningOfDay(data[0].timestamp), endOfDay(data[0].timestamp)]); //d3.extent(data.map(function(d) { return d.timestamp; }))
		   		y.domain([0, d3.max(data.map(function(d) { return d.point; }))]);

		   	    stage.append("path").data([data]).attr("d", area);

		   	    stage.append("g")
		   	         .attr("class", "x axis")
		   	         .attr("transform", "translate(0," + height + ")")
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

		drawPie(all_data);
	}	

	function brush() {
	   console.log(d3.event.target.extent());
		var extent = d3.event.target.extent();
		var from = extent[0][0],
			to = extent[1][0];
			
		drawPie(all_data.filter(function(d){return d.timestamp - from > 0 && d.timestamp - to < 0}));
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
		    .key(function(d) { return d.app; })
		    .entries(data);

		update(nest.map(function(d){return {name: d.key, value: d.values.length}}));
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
}

