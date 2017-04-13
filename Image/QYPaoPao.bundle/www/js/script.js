var hasOwnProperty = Object.prototype.hasOwnProperty;
var propIsEnumerable = Object.prototype.propertyIsEnumerable;

function toObject(val) {
	if (val === null || val === undefined) {
		throw new TypeError('Object.assign cannot be called with null or undefined');
	}

	return Object(val);
}

Object.assign = Object.assign || function (target, source) {
	var from;
	var to = toObject(target);
	var symbols;

	for (var s = 1; s < arguments.length; s++) {
		from = Object(arguments[s]);

		for (var key in from) {
			if (hasOwnProperty.call(from, key)) {
				to[key] = from[key];
			}
		}

		if (Object.getOwnPropertySymbols) {
			symbols = Object.getOwnPropertySymbols(from);
			for (var i = 0; i < symbols.length; i++) {
				if (propIsEnumerable.call(from, symbols[i])) {
					to[symbols[i]] = from[symbols[i]];
				}
			}
		}
	}

	return to;
};

var app = {
    initialize: function() {
        this.onDeviceReady();
    },

    onDeviceReady: function() {
        var obj = {};
        window.argument.split("&").forEach(function(item,index){var arr = item.split("="); obj[arr[0]] = arr[1]});
        $((obj.type == 1 ? ".circle-page" : ".bubble-page")).addClass('shown');
        app.receivedEvent(obj);
    },
    receivedEvent: function(obj) {
		// QRcode
		var getArgument = (function(){
			var argumentObj = Object.assign(obj);
			argumentObj["compress"] = true;
			return function(){
				return argumentObj;
			}
		})();
		var argumentObj = Object.assign(getArgument());
		$(".group-image").attr("src",getArgument()["photo"]||"");
		if(argumentObj.type == 1){
			var fontSize = parseFloat($(".group-title").css("max-width")) / parseFloat(+getArgument()["name"].length+3);
			var currentFontSize = parseFloat($(".group-title").css("font-size"));
			fontSize = fontSize > currentFontSize ? currentFontSize : (fontSize > 12 ? fontSize : 12);
	                var name = getArgument()["name"];
	                if(typeof name  == "string" && name != "")
	                        $(".group-title").css("font-size",fontSize+"px").text(name + "的圈子");
	                else
	                        $(".group-title").css("font-size",fontSize+"px").text("圈子");
			//  append icon to QRcode
			argumentObj["icon"] = argumentObj["photo"];
		}
		$(".group-members").text(getArgument()["name"]||"");
		var showErrorMsg = function(msg) {
                        if (!msg || 0 === msg.length) {
                                return;
                        }
                        $(".qr").on("click",function(e){
                                setTimeout(requestQRCode,100);
                        });
                        $(".qr").removeClass('loading').css("background-image","");
                        $(".qr").text(msg);

                }
                var requestQRCode = function(){
			$.ajax({
				url: 'http://paopao.iqiyi.com/apis/e/qrcode/encode.action',
				type: 'GET',
				cache: false,
				timeout: 5000,
				dataType: 'text',
				data: argumentObj,
				beforeSend: function(xhr,setting){
					$(".qr").text("").addClass('loading').css("background-image","url(img/loading.gif)");
				},
				success: function(data, status, xhr){
                                        data = data.replace(/[\r\n]/g,'');
                                        if (!data || 0 === data.length) {
                                                showErrorMsg("请点击重试");
                                                return;
                                        }
					var dataObj = {
						key: ""+getArgument().type+"_"+(getArgument().paopaoid||getArgument().wallid||""),
						base64: "data:image/gif;base64,"+data
					}
					$(".qr").removeClass('loading').css("background-image","url('" + dataObj.base64 + "')");

					// store data, maximun is 5
					var qrIndex = localStorage.getItem("qrIndex") || '-1';
					var newQrIndex = +qrIndex < count ? +qrIndex + 1 : 0
					localStorage.setItem("qr-"+(newQrIndex),JSON.stringify(dataObj));
					qrcode = true;
					localStorage.setItem("qrIndex",(newQrIndex));
				},
				error: function(xhr, errorType, error){
					// if ajax failed, get the stored item
					// alert(errorType);
					var msg;				
					
					for(var i = 0; i < count; i++){
						var item = localStorage.getItem("qr-"+i);
						if(item){
							try {
								var dataObj = JSON.parse(item);
								if (dataObj.key === ""+getArgument().type+"_"+(getArgument().paopaoid||getArgument().wallid||"")) {
									console.log("load the cached image");
									$(".qr").removeClass('loading').css("background-image","url(" + dataObj.base64 + ")");
									qrcode = true;
									return;				
								};
							}
							catch (e){
								continue;
							}
						}
					}
					if(errorType === "timeout"){
						msg = "请点击重试";
					}else if(errorType === "abort"){
						msg = "请连接网络后重试";
					}else{
						msg = "有错误发生";
					}
					showErrorMsg(msg);
				},
				complete: function(xhr, status){

				}
			})			
		}
		requestQRCode();
    }
};

app.initialize();
