/**
 * client.tpay.webtx.js
 * 상점 제공 연동 함수
 *
 * @version 1.0
 *
 * @date 2012. 7. 23.
 *
 * copyright(c) 2012 www.tpay.co.kr
 *
 * @note
 * 2012.7.23 파일 생성
 * 2012.1.10 displayShow() 함수 추가
 */

/**
 * 결제창 띄우는 함수
 */
$(function() {
	$('.nyroModal').nyroModal({
		closeOnEscape: false,
		closeOnClick: false,
		showCloseButton: false
	});
	var iframeStr=$("<iframe/>");
	iframeStr.css("visibility","hidden");
	iframeStr.on("readystatechange",function(){
		if(this.readyState=="complete" || this.readyState=="interactive"){
			tPayClose();
		}
	});
	var tid;
	tid = setInterval(function(){

	},1000);
	iframeStr.on("load",function(){
		if(tid){
		}
	})

});
function tPayClose(){
	if($("#iframeUrlSendBox").length==false){

	}else{
		$("#iframeUrlSendBox").remove();
	}

	var tpay = $.nmTop();
	if(tpay!=undefined){
		$.nmTop().close();
	}else{
		document.location.reload();
	}
}
function clientIframeUrlSend(urlValue){
	var str = "";
	try{
		$("#iframeUrlSendBox").remove();
		$("#iframeUrlSendFrm").remove();
		str = "";
		str = str + "<iframe id='iframeUrlSendBox' name='iframeUrlSendBox' style='display:none' src='"+urlValue+"' onload='iframeUrlSendCallback(this)'></iframe>";
		str = str + "<form id='iframeUrlSendFrm' name='iframeUrlSendFrm'></form>";

		$(str).appendTo($('body'));
		iframeStr = $(str);

		return true;
	}catch(exception){
		return false;
	}
}
function iframeUrlSendCallback(obj){
	tPayClose();
}

/**
 * 결제창 종료 함수
 */
function payWinClose(){
//	$.nmTop().close();
	var tpay = $.nmTop();
	var pageCloseUrl = document.getElementsByName("pageCloseUrl")[0];
	var pageCancelUrl = document.getElementsByName("pageCancelUrl")[0];
	if(  (pageCloseUrl!=undefined && pageCloseUrl.value!="")
		|| (pageCancelUrl!=undefined && pageCancelUrl.value!="")
	){
		var url = pageCloseUrl.value==""?pageCancelUrl.value:pageCloseUrl.value;
		//close url이 존재하고 결과페이지가 아닐 경우만 iframe send
		if(url!="" && isResult==false){
			clientIframeUrlSend(pageCloseUrl.value);
		}else{
			tPayClose();
		}
	}else{
		tPayClose();
	}
	return false;
}
/**
 * 페이지 로드 종료 후 Display 위해 호출하는 함수
 */
function displayShow(){
	$(".nyroModalCont iframe").css('opacity', '1');
	$(".nyroModalCont iframe").css('filter', '(opacity=1)');
	$(".nyroModalCont iframe").css('-khtml-opacity', '1.0');
	$(".nyroModalCont iframe").css('-moz-opacity', '1.0');
}

function resultConfirm(tid, rslt){
	var resultConfirmIframe = $('<iframe name="resultConfirmIframe" style="display:none" />').appendTo('body');

	var form = document.createElement("form");
	form.setAttribute("method", "post");
	form.setAttribute("target", "resultConfirmIframe");
	form.setAttribute("action", "https://webtx.tpay.co.kr/resultConfirm");

	var tidE = document.createElement("input");
	tidE.setAttribute("type", "hidden");
	tidE.setAttribute("name", "tid");
	tidE.setAttribute("value", tid);
	form.appendChild(tidE);

	var rsltE = document.createElement("input");
	rsltE.setAttribute("type", "hidden");
	rsltE.setAttribute("name", "result");
	rsltE.setAttribute("value", rslt);
	form.appendChild(rsltE);

	document.body.appendChild(form);
	form.submit();
}

function submitParametersToNextPage(param, url){
	//document.charset = charset;

	var form = document.createElement("form");
	form.setAttribute("method", "post");
	form.setAttribute("target", "_self");
	form.setAttribute("action", url);
	document.body.appendChild(form);

	for(var i=0;i<param.length;i++){
		var params = param[i].split('#SEPERATE#');
		if(params.length == 2){
			if(params[0] == 'statusCl') continue;
			if(params[0] == 'svcCdList') continue;
			$('<input type="hidden" name='+params[0]+' value="" />').attr("value", params[1]).appendTo(form);
		}
	}

	form.submit();
}

function changeAmt(){
	frm = document.transMgr;
	frm.action = "";
	frm.target = "_self";
	$('#transMgr').removeClass("nyroModal");
	frm.submit();
}

function getInternetExplorerVersion() {
	 var rv = -1; // Return value assumes failure.
	 if (navigator.appName == 'Microsoft Internet Explorer') {
		 var ua = navigator.userAgent;
		 var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
		 if (re.exec(ua) != null)
			 rv = parseFloat(RegExp.$1);
	 }else{
		 rv = 10;
	 }
	 return rv;
}

function receiveMsg(e){
	var data;

	if(getInternetExplorerVersion() <= 9){
		data = e.data.split(",");
	}else{
		data = e.data;
	}
	var statusCl = data[0];
	var resultStr = data[1];
	var url = data[2];

	if(statusCl=='0'){
		displayShow();
	}else if(statusCl=='1'){
		payWinClose();
	}else if(statusCl=='2'){
		resultResponseIframe(data);
	}else if(statusCl=='-1'){
		alert(resultStr);
		payWinClose();
	}else if(statusCl=='3'){
		resultResponseIframeUrl(data, url);
	}
};

var isResult = false;
function resultResponseIframe(param){
	isResult = true;
	payWinClose();
	submitParametersToNextPage(param, resultUrl);
}

function resultResponseIframeUrl(param, url){
	payWinClose();
	submitParametersToNextPage(param, url);
}

var charset;

$(function() {
	var Browser = {
		   chk : navigator.userAgent.toLowerCase()
	}

	Browser = {
		ie : Browser.chk.indexOf('msie') != -1,
		ie6 : Browser.chk.indexOf('msie 6') != -1,
		ie7 : Browser.chk.indexOf('msie 7') != -1,
		ie8 : Browser.chk.indexOf('msie 8') != -1,
		ie9 : Browser.chk.indexOf('msie 9') != -1,
		ie10 : Browser.chk.indexOf('msie 10') != -1,
		opera : !!window.opera,
		safari : Browser.chk.indexOf('safari') != -1,
		safari3 : Browser.chk.indexOf('applewebkir/5') != -1,
		mac : Browser.chk.indexOf('mac') != -1,
		chrome : Browser.chk.indexOf('chrome') != -1,
		firefox : Browser.chk.indexOf('firefox') != -1
	}

	if(window.addEventListener){
		window.addEventListener('message', receiveMsg, false);
	}else{
		if(window.attachEvent){
			window.attachEvent('onmessage', receiveMsg);
		}else if(document.attachEvent){
			document.attachEvent('onmessage', receiveMsg);
		}
	}

	$('#submitBtn').click(function() {
		if($('input[name=transType]:checked').val()=='1' && $('#payMethod').val()!='CARD' && $('#payMethod').val()!='BANK' && $('#payMethod').val()!='VBANK' ){
			alert("에스크로에서 지원하지 않는 결제수단입니다.");
			return;
		}

		charset = document.charset;

		try{
			document.transMgr.acceptCharset = 'utf-8';
		}catch(e){}
        try{
        	if(document.all)document.charset = 'utf-8';
        }catch(e){}

		$('#transMgr').submit();

		if(Browser.ie6==true || Browser.ie7==true || Browser.ie8==true){

		}else{
			document.charset = charset;
		}
	});
});

