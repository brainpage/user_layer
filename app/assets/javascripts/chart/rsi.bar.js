bp.rsi.BarChart = function(domId){
	var margin = [30, 10, 30, 80];
	
	this.width = 680 - margin[1] - margin[3];
	this.height = 250 - margin[0] - margin[2];

	this.svg = d3.select(domId).append("svg")
	    .attr("width", this.width + margin[1] + margin[3])
	    .attr("height", this.height + margin[0] + margin[2])
	  	.append("g")
	    .attr("transform", "translate(" + margin[3] + "," + margin[0] + ")");
	
	this.xAxisArea = this.svg.append("g").attr("class", "x axis")
		.attr("transform", "translate(0," + (this.height + 1) + ")");
	
	this.yAxisArea = this.svg.append("g").attr("class", "y axis")
		.attr("transform", "translate(0,1)");
		
	var tip = this.svg.append("g").attr("class", "tip")
		.attr("transform", "translate(" + (this.width / 3) + ",-10)");	
	tip.append("rect").attr("transform", "translate(0, -15)").attr("fill", "steelblue").attr("width", 20).attr("height", 20);	
	tip.append("text").attr("transform", "translate(24, 0)").text("You");
	tip.append("rect").attr("transform", "translate(70, -15)").attr("fill", "#003399").attr("width", 20).attr("height", 20);
	tip.append("text").attr("transform", "translate(94, 0)").text("Global Average");
};

bp.rsi.BarChart.prototype.draw = function(data){
	var format = d3.format(",.0f");
	
	var y = d3.scale.linear().range([this.height, 0]),
		x = d3.scale.ordinal().rangeRoundBands([0, this.width], .1);

	// Set the scale domain.
	x.domain(data.map(function(d) { return d.name; }));
	y.domain([0, d3.max(data, function(d) { return d.value; })]);
	
	var xAxis = d3.svg.axis().scale(x).orient("bottom").tickSize(0);
	var yAxis = d3.svg.axis().scale(y).orient("left");

	this.svg.selectAll("g.bar").data([]).exit().remove();

	var height = this.height;
	var bar = this.svg.selectAll("g.bar").data(data)
	   .enter().append("g")
	   .attr("class", "bar")
	   .attr("transform", function(d) {
			var tx, ty;
			if(d.total == null){
				tx = x(d.name);
				ty = y(d.value);
			}else{
				tx = x(d.name) + x.rangeBand() / 2;
				ty = y(d.total);
			}
			return "translate(" + tx + "," + ty + ")"; 
		});
    
	bar.append("rect")	   
	   .attr("fill", function(d) {return d.total == null ? "steelblue" : "#003399"; })
	   .attr("height", function(d) { return height - y(d.total == null ? d.value : d.total); })
	   .attr("width", x.rangeBand() / 2 - 2);

    
   // bar.append("text")
   //    .attr("class", "value")
   //    .attr("y", -10)
   //    .attr("x", x.rangeBand() / 2)
   //    .attr("dx", -6)
   //    .attr("dy", ".35em")
   //    .attr("text-anchor", "middle")
   //    .text(function(d) { return format(d.value); });

	this.xAxisArea.call(xAxis);
	this.yAxisArea.call(yAxis);
}