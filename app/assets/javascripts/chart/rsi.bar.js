bp.rsi.BarChart = function(domId){
	var margin = [0, 10, 10, 100];
	
	this.width = 400 - margin[1] - margin[3];
	this.height = 220 - margin[0] - margin[2];

	this.svg = d3.select(domId).append("svg")
	    .attr("width", this.width + margin[1] + margin[3])
	    .attr("height", this.height + margin[0] + margin[2])
	  	.append("g")
	    .attr("transform", "translate(" + margin[3] + "," + margin[0] + ")");
	
	this.yAxisArea =  this.svg.append("g").attr("class", "y axis");
};

bp.rsi.BarChart.prototype.draw = function(data){
	var format = d3.format(",.0f");
	
	var x = d3.scale.linear().range([0, this.width]),
		y = d3.scale.ordinal().rangeRoundBands([0, this.height], .1);

	// Set the scale domain.
	x.domain([0, d3.max(data, function(d) { return d.value; })]);
	y.domain(data.map(function(d) { return d.name; }));
	
	var yAxis = d3.svg.axis().scale(y).orient("left").tickSize(0);

	this.svg.selectAll("g.bar").data([]).exit().remove();

	var bar = this.svg.selectAll("g.bar").data(data)
	   .enter().append("g")
	   .attr("class", "bar")
	   .attr("transform", function(d) { return "translate(0," + y(d.name) + ")"; });
    
	bar.append("rect")	   
	   .attr("fill", function(d) {return d.color; })
	   .attr("width", function(d) { return x(d.value); })
	   .attr("height", y.rangeBand());
    
	bar.append("text")
	   .attr("class", "value")
	   .attr("x", function(d) { return x(d.value) -10; })
	   .attr("y", y.rangeBand() / 2)
	   .attr("dx", -6)
	   .attr("dy", ".35em")
	   .attr("text-anchor", "end")
	   .text(function(d) { return format(d.value); });

	this.yAxisArea.call(yAxis);
}