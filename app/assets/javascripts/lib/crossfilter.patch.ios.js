(function(){
	if (typeof Uint8Array !== "undefined") {	
	  	Uint8Array.prototype.constructor = function (n) { return new Uint8Array(n); }
	  	Uint16Array.prototype.constructor = function (n) { return new Uint16Array(n); }
	  	Uint32Array.prototype.constructor = function (n) { return new Uint32Array(n); }
	}
})(this);

