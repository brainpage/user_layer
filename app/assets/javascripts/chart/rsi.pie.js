bp.rsi.PieChart = function(domId){
	var w = 450, h = 300,  ir = 45;
	this.r = r = 120;
	this.textOffset = 14;
	this.tweenDuration = 300;

	this.lines = [];
	this.valueLabels = [];
	this.keyLabels = [];
	this.pieData = [];    
	this.oldPieData = [];
	this.filteredPieData = [];

	this.donut = d3.layout.pie().value(function(d){return d.value;});

	this.mousedown = function(d){};

	this.arc = d3.svg.arc()
	  .startAngle(function(d){ return d.startAngle; })
	  .endAngle(function(d){ return d.endAngle; })
	  .innerRadius(ir)
	  .outerRadius(this.r);

	this.vis = d3.select(domId).append("svg:svg").attr("width", w).attr("height", h);
	
	this.centerLabel = this.vis.append("svg:g")	  
	  .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")")
	  .append("svg:text")
	  .attr("dy", 5)
	  .attr("class", "center-label")
	  .attr("text-anchor", "middle") 
	  .text("Loading Apps...");

	this.arc_group = this.vis.append("svg:g")
	  .attr("class", "arc")
	  .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")");

	this.label_group = this.vis.append("svg:g")
	  .attr("class", "label_group")
	  .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")");
};

bp.rsi.PieChart.prototype.draw = function(data, fresh) {
	if(fresh){
		this.originData = data;
	}

	var pieObject = this;
	
	this.oldPieData = this.filteredPieData;
	this.pieData = this.donut(data);
	
	var r = this.r;
	var textOffset = this.textOffset;
	var oldPieData = this.oldPieData;
	var arc = this.arc;
	
	this.filteredPieData = this.pieData.filter(filterData);
	function filterData(element, index, array) {
		element.origin_key = data[index].key;
		element.key = bp.chart.Utils.trim(data[index].key);
		element.value = data[index].value;
		element.color = data[index].color;
		return (element.value > 0);
	}
	
	function calcArc(d){
		return Math.cos(((d.startAngle+d.endAngle - Math.PI)/2)) * (r+textOffset) + "," + Math.sin((d.startAngle+d.endAngle - Math.PI)/2) * (r+textOffset);
	}
	
	function calcPos(d){
		return (d.startAngle+d.endAngle)/2 < Math.PI ? "beginning" : "end";
	}
	
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
	
	//var color = d3.scale.category20();

	if(this.filteredPieData.length > 0 ){
		this.filteredPieData = bp.chart.Utils.removeSmallData(this.filteredPieData);
		
		this.centerLabel.text("Apps");		
		
		//DRAW ARC PATHS
		var paths = this.arc_group.selectAll("path").data(this.filteredPieData);
		paths.enter().append("svg:path")
			.attr("stroke", "white")
			.attr("stroke-width", 0.5)
			.attr("class", function(d){return "pie-item "+d.key})
			.attr("fill", function(d) {return d.color; })
			.on("mousedown", function(d) {									 			   			
				pieObject.mousedown(d);  
			})
			.transition()
		    .duration(this.tweenDuration)
		    .attrTween("d", pieTween);
		
		paths
			.transition()
		    .duration(this.tweenDuration)
		    .attrTween("d", pieTween);
		
		paths.exit()
			.transition()
		    .duration(this.tweenDuration)
		    .attrTween("d", removePieTween)
			.remove();
		
		//DRAW TICK MARK LINES FOR LABELS
		this.lines = this.label_group.selectAll("line").data(this.filteredPieData);
		this.lines.enter().append("svg:line")
			.attr("x1", 0)
			.attr("x2", 0)
			.attr("y1", -r-3)
			.attr("y2", -r-8)
			.attr("stroke", "white")
			.attr("transform", function(d) {
				return "rotate(" + (d.startAngle+d.endAngle)/2 * (180/Math.PI) + ")";
			});
		this.lines.transition()
			.duration(this.tweenDuration)
			.attr("transform", function(d) {
				return "rotate(" + (d.startAngle+d.endAngle)/2 * (180/Math.PI) + ")";
			});
		this.lines.exit().remove();
		
		//DRAW LABELS WITH PERCENTAGE VALUES
		this.valueLabels = this.label_group.selectAll("text.value").data(this.filteredPieData);
		
		this.valueLabels.enter().append("svg:text")
			.attr("class", "value")
			.attr("transform", function(d) {return "translate(" + calcArc(d) + ")";});
		
		this.valueLabels.transition().duration(this.tweenDuration).attrTween("transform", textTween);
		this.valueLabels.exit().remove();
		
		//DRAW LABELS WITH ENTITY NAMES
		this.keyLabels = this.label_group.selectAll("text.units")
			.data(this.filteredPieData)
			.attr("dy", 5)
			.attr("text-anchor", calcPos)
			.text(function(d){return d.key;});
		
		this.keyLabels.enter().append("svg:text")
			.attr("class", "units")
			.attr("transform", function(d) {return "translate(" + calcArc(d) + ")";})
			.attr("dy", 5)
			.attr("text-anchor", calcPos)
			.text(function(d){return d.key;});
		
		this.keyLabels.transition().duration(this.tweenDuration).attrTween("transform", textTween);
		this.keyLabels.exit().remove();	
	}  
}

