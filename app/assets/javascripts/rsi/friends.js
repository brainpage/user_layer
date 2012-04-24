function expandOnHover(cls){
	var origin = 0;
	$('.' + cls + ' div').hover(function(){
		var max = 0;
		var dom = $(this);
		origin = dom.width();
		
		var children = $(this).find('*');
        
		if (children.length) {
		    children.map(function(){
		        max = Math.max(max, $(this).outerWidth(true));
		    });
		}
		if(max > origin){
			dom.width(Math.min(110, max + 28));
		}	
	},
	function(){$(this).width(origin)}
	);
};

function setCellColor(cls){
	var chart = new bp.rsi.ChartObject({});
	$('.' + cls).each(function(index){
		$(this).css("background-color", chart.getColor($(this).attr("id")));
	});
}
