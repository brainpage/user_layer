bp.rsi.ChartObject = function(data){
	this.days = data.days;
	this.crossdomain = false;
	//this.url = "http://www.brainpage.com/db/query";
	this.avg_url = "/rsi/charts/average";
	this.url = "/db/query";	
	this.dataByTime = null;
	this.dataByApp = null;
	this.color = {};
	this.colors = d3.scale.category20();
	
	this.getColor = function(app){
		return this.color[app] == null ? (this.color[app] = this.colors(bp.chart.Utils.hashLength(this.color))) : this.color[app];
	}
}
