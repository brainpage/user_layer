bp.rsi.ChartObject = function(data){
	this.fromDay = data.fromDay;
	this.toDay = data.toDay;
	this.days = data.toDay - data.fromDay + 1;
	this.crossdomain = true;
	this.url = "http://www.brainpage.com/db/query";
	//this.url = "http://localhost:3000/rsi/charts/data";
	this.avg_url = "/rsi/charts/average";
//	this.url = "/db/query";	
	this.dataByTime = null;
	this.dataByApp = null;
	this.color = {};
	this.colors = ["#fbcdc9", "#bcdec4", "#b2e2f0", "#fdcb9a", "#c7c1e0", "#e2d9b8", "#9ad4d2", "#edc2e3", "#9abbec", "#efe9b3", "#cfdf93"];
	
	this.getColor = function(app){
		len = bp.chart.Utils.hashLength(this.color);
		if(len > this.colors.length){
			len = len % this.colors.length;
		}
		return this.color[app] == null ? (this.color[app] = this.colors[len]) : this.color[app];
	}
}
