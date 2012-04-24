bp.rsi.BarChart = function(domId){
	var margin = [30, 10, 30, 80];
	
	this.width = 1100 - margin[1] - margin[3];
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
	tip.append("rect").attr("transform", "translate(0, -15)").attr("fill", "#9abbec").attr("width", 20).attr("height", 20);	
	tip.append("text").attr("transform", "translate(24, 0)").text("You");
	tip.append("rect").attr("transform", "translate(70, -15)").attr("fill", "#fdcb9a").attr("width", 20).attr("height", 20);
	tip.append("text").attr("transform", "translate(94, 0)").text("Global Average");
};

bp.rsi.BarChart.prototype.draw = function(group, attr, chart){
	var filtered = [];
	
	var add = function(p, v){
		p.count++;
		p.total += (v[attr] == null ? 0 : v[attr]);
		return p;
	}
	var remove = function(p, v){
		p.count--
		p.total -= (v[attr] == null ? 0 : v[attr]);
		return p;
	}
	var initial = function(p, v){
		return {count: 0, total: 0};
	}
	
	var raw = group.reduce(add, remove, initial).all();
	raw = raw.map(function(d){
		return {key: d.key, value: (d.value.total / d.value.count)};
	});
	raw = bp.chart.Utils.removeSmallData(raw);
	
	var data = [];
	raw.forEach(function(d){
		if(d.value > 0){
			var item = {key: bp.chart.Utils.trim(d.key), value: d.value};
			data.push(item);	

			var item_avg = {key: bp.chart.Utils.trim(d.key)}
			var avg = chart.global_avg.filter(function(w){return w.category == d.key + ":" + attr}).pop();		
			if(avg != null){item_avg.average = avg.value;}
			data.push(item_avg);
		}				
	});
	
	var format = d3.format(",.0f");
	
	var y = d3.scale.linear().range([this.height, 0]),
		x = d3.scale.ordinal().rangeRoundBands([0, this.width], .1);

	// Set the scale domain.

	x.domain(data.map(function(d) { return d.key; }));
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
			if(d.average == null){
				tx = x(d.key);
				ty = y(d.value);
			}else{
				tx = x(d.key) + x.rangeBand() / 2;
				ty = y(d.average);
			}
			if(isNaN(ty)){ty = 0};
			return "translate(" + tx + "," + ty + ")"; 
		});
    
	bar.append("rect")	   
	   .attr("fill", function(d) {return d.average == null ? "#9abbec" : "#fdcb9a"; })
	   .attr("height", function(d) {var v = y(d.average == null ? d.value : d.average); return height - (isNaN(v) ? height : v); })
	   .attr("width", x.rangeBand() / 2 - 2);

	this.xAxisArea.call(xAxis);
	this.yAxisArea.call(yAxis);
}