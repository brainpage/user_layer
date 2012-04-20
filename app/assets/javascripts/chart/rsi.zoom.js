bp.rsi.ZoomChart = function(domId){
	this.domId = domId;
	
	var margin = {top: 10, right: 10, bottom: 100, left: 40},
	    margin2 = {top: 230, right: 10, bottom: 20, left: 40},
	    width = 1160 - margin.left - margin.right,
	    height = 300 - margin.top - margin.bottom,
	    height2 = 300 - margin2.top - margin2.bottom;

	this.x = d3.time.scale().range([0, width]);
	this.x2 = d3.time.scale().range([0, width]);
	this.y = d3.scale.linear().range([height, 0]);
	this.y2 = d3.scale.linear().range([height2, 0]);
	
	this.height = height;
	this.height2 = height2;
	
	this.xAxis = d3.svg.axis().scale(this.x).orient("bottom");
	this.xAxis2 = d3.svg.axis().scale(this.x2).orient("bottom");
	this.yAxis = d3.svg.axis().scale(this.y).orient("left");
	
	var x = this.x, y = this.y, x2 = this.x2, y2 = this.y2;

	this.area = d3.svg.area()
	    .interpolate("basis")
	    .x(function(d) { return x(d.t); })
	    .y0(height)
	    .y1(function(d) { return y(d.point); });

	this.area2 = d3.svg.area()
	    .interpolate("basis")
	    .x(function(d) { return x2(d.t); })
	    .y0(height2)
	    .y1(function(d) { return y2(d.point); });

	this.svg = d3.select(this.domId).append("svg")
	    .attr("width", width + margin.left + margin.right)
	    .attr("height", height + margin.top + margin.bottom);
	
   	this.svg.append("defs").append("clipPath")
   	    .attr("id", "clip")
   	  	.append("rect")
   	    .attr("width", width)
   	    .attr("height", height);
   	
   	this.focus = this.svg.append("g")
   	    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
   	
   	this.context = this.svg.append("g")
   	    .attr("transform", "translate(" + margin2.left + "," + margin2.top + ")");
};

bp.rsi.ZoomChart.prototype.draw = function(data, app){	
	data = bp.chart.Utils.makeConsecutive(data);

	this.x.domain(d3.extent(data.map(function(d) { return d.t; })));
	this.y.domain([0, d3.max(data.map(function(d) { return d.point; }))]);
	this.x2.domain(this.x.domain());
	this.y2.domain(this.y.domain());
	
	$(this.domId + " svg g").empty();
    
	this.focus.append("path")
	    .data([data])
		.attr("fill", app.color)
	    .attr("clip-path", "url(#clip)")
	    .attr("d", this.area);
    
	this.focus.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + this.height + ")")
	    .call(this.xAxis);
    
	this.focus.append("g")
	    .attr("class", "y axis")
	    .call(this.yAxis);
    
	this.context.append("path")
	    .data([data])
	    .attr("fill", app.color)
	    .attr("d", this.area2);
    
	this.context.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + this.height2 + ")")
	    .call(this.xAxis2);
    
	var brush = d3.svg.brush().x(this.x2).on("brush", brush);
    
	this.context.append("g")
	    .attr("class", "x brush")
	    .call(brush)
	  	.selectAll("rect")
	    .attr("y", -6)
	    .attr("height", this.height2 + 7);
		
	var x = this.x,
	 	x2 = this.x2,
		area = this.area,
		xAxis = this.xAxis,
		focus = this.focus;

	function brush() {
		x.domain(brush.empty() ? x2.domain() : brush.extent());
		focus.select("path").attr("d", area);
		focus.select(".x.axis").call(xAxis);
	}
}