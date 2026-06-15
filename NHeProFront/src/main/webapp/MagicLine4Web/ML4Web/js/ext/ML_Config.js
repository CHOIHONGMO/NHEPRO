// 로컬
var cpUrl = location.port != ""?location.hostname+":"+location.port:location.hostname;
var mlMainUrl = location.protocol+"//"+( location.port != ""?location.hostname+":"+location.port:location.hostname );
var mlDirPath = "/MagicLine4Web/ML4Web/";
var childHtml = "Child.html";

$(document).ready(function(){

	$('#dscertContainer').hide();
	
	$.blockUI({
		message:'<div><div><img src="' + mlDirPath + 'UI/images/loader.gif" alt="로딩중입니다."/></div><p style="display:inline-block; padding-top:4px; font-size:11px; color:#333; font-weight:bold;">잠시만 기다려 주세요.</p></div>',
		css:{left:(($(window).width()/2)-75)+'px'}
	});
	
	magicline.uiapi.ML_funProcInitCheck(function(code,data){
		if( code == 0 ){
			magicline.uiapi.completeInit();
			if(typeof(checkCallback) == "function"){
				magicline.uiapi.checkInstall(checkCallback);
			}
		}
	});
	
	magicline.uiapi.ML_checkInit();
	

});

var magicline = {
		uiapi : "",
		initCallback : "",
		is_ML_Sign_Init:false
}
var magiclineApi = function(){
	var callback="";
	var defaultOptions = {
			sign:{signType:"MakeSignData",msg:"",messageType:"",signOpt:{ds_pki_sign:['OPT_USE_CONTNET_INFO'], ds_pki_rsa:'rsa15', ds_pki_hash:'sha256',ds_msg_decode:"false",ds_pki_sign_type:"signeddata"}},
			signPdfOpt:{ds_pki_sign:['OPT_USE_CONTNET_INFO','OPT_USE_PKCS7','OPT_NO_CONTENT','OPT_HASHED_CONTENT'], ds_pki_rsa:'rsa15', ds_pki_hash:'sha256',ds_msg_decode:"true"},
			encOpt:{ds_pki_rsa:'rsa15'},
			signedenvOpt:{ds_pki_sign:['OPT_USE_CONTNET_INFO'], ds_pki_rsa:'rsa15', ds_pki_algo:'SEED-CBC'},
			// 추가
			idn : "",
			vidType : "",
			certOidfilter : "",
			certExpirefilter : true, //false:만료 인증서 보여주기, true:보여주지 않기
			//mrs2 옵션 설정
			saveStorageList : ["web","hdd"],
			exportStorageList : ["web", "hdd"],
			exportStorageSelect : "web",
			browser_notice_show	: false,
			//특허청 전자서명 옵션
			kipoSignOpt:{signType:"MakeSignData",msg:"",messageType:"",signOpt:{ds_pki_sign:['OPT_USE_CONTNET_INFO', 'OPT_HASHED_CONTENT'], ds_pki_rsa:'rsa15', ds_pki_hash:'sha256',ds_msg_decode:"hash",ds_pki_sign_type:"signeddata"}},
	}
	
	function CommonResopnseProcess( json ){
		
		var response = JSON.parse( json );
		var close = response.close;

		if( response.close  == 'closeDialog'){
			$('#dscertContainer').hide();
		}
	}
	
	/**
	 * send 할 메시지를 생성
	 */
	function MakeRequestJsonMessage( functionName, functionParameter, option ){
		var temp = 
			{
				"funcName" : functionName,
				"funcParam" : functionParameter
			}
		return JSON.stringify( temp );
	}

	/**
	 * SignedData
	 */
	function MakeSignData( msg , signOpt, callback, pCertOidfilter ){

		defaultOptions.certOidfilter = pCertOidfilter;
		magiclineApi.callback = callback;
		var param = defaultOptions.sign;
		param.signType = "MakeSignData";

		// Param Mapping
		if( msg!=null && typeof(msg)!='undefined' && msg!='' ){
			param.msg = msg;
		}
		
		// 본인확인 (IDN) 입력시 서명 원문 맵핑
//		if(msg instanceof HTMLFormElement){
		if(typeof(msg) == 'object' && typeof(msg.signData) != "undefined"){
			//param.msg = msg.signData.value;
			
			if(typeof(msg.signData.length) != "undefined"){
				param.msg = new Array();
				for(var i = 0; i < msg.signData.length; i++){
					param.msg[i] = msg.signData[i].value;
				}
			}else{
				param.msg = msg.signData.value;
			}
		}
		
		if(msg.idn != null && msg.idn != ""){
			param.idn = msg.idn.value;
		}
		
		if(msg.vidType != null && msg.vidType != ""){
			param.vidType = msg.vidType.value;							
		}
		
		param.signOpt.ds_pki_sign_type = "signeddata";
		param.signOpt.cert_filter_expire = defaultOptions.certExpirefilter;
		param.signOpt.cert_filter_oid = defaultOptions.certOidfilter;

		param.certOidfilter = defaultOptions.certOidfilter;
		param.certExpirefilter = defaultOptions.certExpirefilter;
		
		var funcName = param.signType;
		var option = null;
		
		var request = MakeRequestJsonMessage(funcName, param, option );
		
		addEventLisner( callback );
		ML_sendPostMessage( request );
	}
	
	
	/**
	 * MakeMultiSignData
	 */
	function MakeMultiSignData( msg , signOpt, callback, pCertOidfilter , idn, vidType){

		defaultOptions.certOidfilter = pCertOidfilter;
		magiclineApi.callback = callback;
		var param = defaultOptions.sign;
		param.signType = "MakeSignData";

		// Param Mapping
		if( msg!=null && typeof(msg)!='undefined' && msg!='' ){
			
			param.msg = msg;
		}
		
		if( idn!=null && typeof(idn)!='undefined' && idn!='' ){				
			param.idn = idn;
		}
		
		if( vidType!=null && typeof(vidType)!='undefined' && vidType!='' ){				
			param.vidType = vidType;
		}
		
		param.signOpt.ds_pki_sign_type = "signeddata";
		param.signOpt.cert_filter_expire = defaultOptions.certExpirefilter;
		param.signOpt.cert_filter_oid = defaultOptions.certOidfilter;

		param.certOidfilter = defaultOptions.certOidfilter;
		param.certExpirefilter = defaultOptions.certExpirefilter;
		
		var funcName = param.signType;
		var option = null;
		
		var request = MakeRequestJsonMessage(funcName, param, option );
		
		addEventLisner( callback );
		ML_sendPostMessage( request );
	}	
	
	/**
	 * SinatureData
	 */
	function MakeSignatureData( msg , signOpt, callback ){
		magiclineApi.callback = callback;
		
		var param = defaultOptions.sign;		
		param.signType = "MakeSignData";
		
		if( msg!=null && typeof(msg)!='undefined' && msg!='' ){
			param.msg = msg;
		}
		
//		if(msg instanceof HTMLFormElement){
		if(typeof(msg) == 'object'){
			param.msg = magicline.extraceFormToString(msg);
		}
		
		if(msg.signData != null && msg.signData != ""){
			param.signData = msg.signData.value;
		}
		
		if(msg.idn != null && msg.idn != ""){
			param.idn = msg.idn.value;
		}
		
		if(msg.vidType != null && msg.vidType != ""){
			param.vidType = msg.vidType.value;							
		}
		
		param.signOpt.ds_pki_sign_type = "sign";
		param.signOpt.cert_filter_expire = defaultOptions.certExpirefilter;
		param.signOpt.cert_filter_oid = defaultOptions.certOidfilter;

		param.certOidfilter = defaultOptions.certOidfilter;
		param.certExpirefilter = defaultOptions.certExpirefilter;
		
		var funcName = param.signType;
		var option = null;
		
		var request = MakeRequestJsonMessage(funcName, param, option );
		
		addEventLisner( callback );
		ML_sendPostMessage( request );
	}
	/**
	 * MakeAddSignData
	 */
	function MakeAddSignData( msg , signOpt, callback ){
		
		magiclineApi.callback = callback;
		var param = defaultOptions.sign;
		param.signType = "MakeSignData";
		
		// Param Mapping
		if( msg!=null && typeof(msg)!='undefined' && msg!='' ){
			param.msg = msg;
		}
		// 본인확인 (IDN) 입력시 서명 원문 맵핑
//		if(msg instanceof HTMLFormElement){
		if(typeof(msg) == 'object'){
			//param.msg = magicline.extraceFormToString(msg);
			param.msg = msg.signData.value;
		}
		
		if(msg.idn != null && msg.idn != ""){
			param.idn = msg.idn.value;
		}
		
		if(msg.vidType != null && msg.vidType != ""){
			param.vidType = msg.vidType.value;							
		}
		
		param.signOpt.ds_pki_sign_type = "signeddata";
		var funcName = param.signType;
		param.signOpt.ds_pki_signData = param.msg;
		param.signOpt.ds_pki_signdata = param.msg;
		
		param.signOpt.cert_filter_expire = defaultOptions.certExpirefilter;
		param.signOpt.cert_filter_oid = defaultOptions.certOidfilter;

		param.certOidfilter = defaultOptions.certOidfilter;
		param.certExpirefilter = defaultOptions.certExpirefilter;
		
		var option = null;
		
		var request = MakeRequestJsonMessage(funcName, param, option );
		
		addEventLisner( callback );
		ML_sendPostMessage( request );
	}
	
	/**
	 * ntsCertAuth
	 */
	function ntsCertAuth(msg, signOpt, callback){
		
		magiclineApi.callback = callback;
		
		var param = defaultOptions.sign;
		param.signType = "NTSCertAuth";
		
		if( msg!=null && typeof(msg)!='undefined' && msg!='' ){
			param.msg = msg;
		}
		
//		if(msg instanceof HTMLFormElement){
		if(typeof(msg) == 'object'){
			param.msg = magicline.extraceFormToString(msg);
		}
		
		if(msg.signData != null && msg.signData != ""){
			param.signData = msg.signData.value;
		}
		
		if(msg.idn != null && msg.idn != ""){
			param.idn = msg.idn.value;
		}
		
		if(msg.vidType != null && msg.vidType != ""){
			param.vidType = msg.vidType.value;							
		}
		
		param.signOpt.ds_pki_sign_type = "sign";
		
		param.signOpt.cert_filter_expire = defaultOptions.certExpirefilter;
		param.signOpt.cert_filter_oid = defaultOptions.certOidfilter;

		param.certOidfilter = defaultOptions.certOidfilter;
		param.certExpirefilter = defaultOptions.certExpirefilter;
		
		var funcName = param.signType;
		var option = null;
		
		var request = MakeRequestJsonMessage(funcName, param, option );
		
		addEventLisner( callback );
		ML_sendPostMessage( request );
	}
	
	function keyBoardSecurityUse(strKeyboard, callback){
		magiclineApi.callback = callback;
		
		if(magicline.is_ML_Sign_Init){
			
			var param = {};
			param.layer = "UI";
			param.strKeyboard = strKeyboard;
			
			var option = null;			
			var request = MakeRequestJsonMessage("keyBoardSecurityUse", param, option);
			
			ML_sendUtilMessage(request);
			
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
	}
	
	function tranx2PEM(callback){
		magiclineApi.callback = callback;
		
		if(magicline.is_ML_Sign_Init){
			
			var param = {};
			param.layer = "UI";			
			var option = null;
			
			var request = MakeRequestJsonMessage("tranx2PEM", param, option);			
			ML_sendUtilMessage(request);
			
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
		
	}
	
	function getRandomfromPrivateKey(callback){
		magiclineApi.callback = callback;
		
		if(magicline.is_ML_Sign_Init){
		
			var param = {};
			param.layer = "UI";
			var option = null;
			
			var request = MakeRequestJsonMessage("getVIDRandom", param, option);
			ML_sendUtilMessage(request);
			
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
	}
	
	function setSessionID(strSessionID, callback){		
		magiclineApi.callback = callback;
		
		if(magicline.is_ML_Sign_Init){
			
			var param = {};
			param.layer = "UI";
			param.strSessionID = strSessionID;
			var option = null;
			
			var request = MakeRequestJsonMessage("setSessionID", param, option);
			ML_sendUtilMessage(request);
			
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}	
	}
	
	function getSignDN(callback){
		magiclineApi.callback = callback;
		
		if(magicline.is_ML_Sign_Init){
			
			var param = {};
			param.layer = "UI";
			var option = null;
			var request = MakeRequestJsonMessage("getSignDN", param, option);
			
			ML_sendUtilMessage(request);
			
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
	}
	
	function signatureData(dn, callback){
		magiclineApi.callback = callback;
		
		if(magicline.is_ML_Sign_Init){
			
			var param = {};
			param.layer = "UI";
			param.msg = dn;
			var option = null;
			
			var request = MakeRequestJsonMessage("signatureData", param, option);
			
			ML_sendUtilMessage(request);
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
		
	}
	
	/**
	 * 인증서 저장을 위한 함수
	 */
	function saveCertToStorage(certbag, stgArr, callback){
		magiclineApi.callback = callback;
		
		if(magicline.is_ML_Sign_Init){			
			var param = {};						
			param.certbag = certbag;
			param.stgArr  = defaultOptions.saveStorageList;
			
			var option = null;			
			var request = MakeRequestJsonMessage("saveCertToStorage", param, option);			
			addEventLisner( callback );
			ML_sendPostMessage( request );
		}else{
			alert('초기화 중입니다. 잠시 후 다시 시도해 주세요.');
		}	
	}
	
	/**
	 * 인증서 이동을 위한 함수
	 */
	function getSelectCert( msg , signOpt, callback ){
		
		magiclineApi.callback = callback;
		var param = defaultOptions.sign;
		param.signType = "MakeSignData";
		
		// Param Mapping
		if( msg!=null && typeof(msg)!='undefined' && msg!='' ){
			param.msg = msg;
		}
		
		// 본인확인 (IDN) 입력시 서명 원문 맵핑
		if(typeof(msg) == 'object'){
			param.msg = msg.signData.value;
		}
		
		if(msg.idn != null && msg.idn != ""){
			param.idn = msg.idn.value;
		}
		
		if(msg.vidType != null && msg.vidType != ""){
			param.vidType = msg.vidType.value;							
		}
		
		param.signOpt.ds_pki_sign_type = "signeddata";
		param.signOpt.cert_filter_expire = defaultOptions.certExpirefilter;
		param.signOpt.cert_filter_oid = defaultOptions.certOidfilter;

		param.certOidfilter = defaultOptions.certOidfilter;
		param.certExpirefilter = defaultOptions.certExpirefilter;
		
		// 인증서 이동시 인증서를 불러오기 위한 저장매체 설정 - 인증서내보내기
		param.STORAGELIST			= defaultOptions.exportStorageList;
		param.STORAGESELECT			= defaultOptions.exportStorageSelect;
		param.BROWSER_NOTICE_SHOW	= defaultOptions.browser_notice_show;
		
		var funcName = param.signType;
		var option = null;
		
		var request = MakeRequestJsonMessage(funcName, param, option );
		
		addEventLisner( callback );
		ML_sendPostMessage( request );
	}
	
	/**
	 * 특허청 파일 해쉬 전자서명
	 */
	function MakeHashSignData( msg , signOpt, callback ){
		magiclineApi.callback = callback;
		var param = defaultOptions.kipoSignOpt;
		param.signType = "MakeSignData";
		
		// Param Mapping
		if( msg!=null && typeof(msg)!='undefined' && msg!='' ){
			param.msg = msg;
		}
		
		// 본인확인 (IDN) 입력시 서명 원문 맵핑
		if(typeof(msg) == 'object' && typeof(msg.signData) != "undefined"){
			//param.msg = msg.signData.value;
			
			if(typeof(msg.signData.length) != "undefined"){
				param.msg = new Array();
				for(var i = 0; i < msg.signData.length; i++){
					param.msg[i] = msg.signData[i].value;
				}
			}else{
				param.msg = msg.signData.value;
			}
		}
		
		if(msg.idn != null && msg.idn != ""){
			param.idn = msg.idn.value;
		}
		
		if(msg.vidType != null && msg.vidType != ""){
			param.vidType = msg.vidType.value;							
		}
		
		param.signOpt.ds_pki_sign_type = "signeddata";
		param.signOpt.cert_filter_expire = defaultOptions.certExpirefilter;
		param.signOpt.cert_filter_oid = defaultOptions.certOidfilter;

		param.certOidfilter = defaultOptions.certOidfilter;
		param.certExpirefilter = defaultOptions.certExpirefilter;
		
		var funcName = param.signType;
		var option = null;
		
		var request = MakeRequestJsonMessage(funcName, param, option );
		
		addEventLisner( callback );
		ML_sendPostMessage( request );
	}
	
	function closeDialog(event){
		$('#dscertContainer').hide();
		
		var obj = JSON.parse( event.data );
		if( obj.key  == 'closeDialog'){
			$('#dscertContainer').hide();
			/*obj.code = 999;
			magiclineApi.callback( obj.code , obj );*/
		}else if( obj.resultMsg != null && obj.resultMsg !== "" ){
			magiclineApi.callback( obj.code , obj.resultMsg );	
		}else if(obj.opcode != null && obj.opcode !== ""){
			magicmrsApi.callback(obj);
		}else{
			magiclineApi.callback( obj.code , obj );
		}
	}
	
	function addEventLisner( callback ){
		if(window.addEventListener){
			window.addEventListener("message",closeDialog, false);
		}else if(window.attachEvent){
			window.attachEvent("onmessage", closeDialog );
		}
	}
	
	function ML_sendPostMessage ( requestStr ){
		
		var dialogTitle = "전자서명";
		$('#dscertContainer').show();
		var iframeWindow = document.getElementById('dscert').contentWindow;
		
		iframeWindow.postMessage(requestStr, mlMainUrl);
	}
	
	function ML_sendUtilMessage( requestStr ){
		
		var iframeWindow = document.getElementById('dscert').contentWindow;		
		iframeWindow.postMessage(requestStr, mlMainUrl);
	}
	
	function ML_funProcInitCheck (callback){
		magiclineApi.callback = callback;
		var childUrl = mlMainUrl + mlDirPath + childHtml +"?lgUrl="+cpUrl+"&random=" + Math.random() * 99999;
		$('#dscert').attr("src", childUrl);
		addEventLisner( callback );
	}
	
	function completeInit(){
		magicline.is_ML_Sign_Init = true;
		if( typeof magicline.initCallback == "function" ){
			magicline.initCallback(0, 'completeInit');
		}
		$.unblockUI();
	}
	
	function ML_checkInit(){
		setTimeout(function(){
			if( magicline.is_ML_Sign_Init ){
				$.unblockUI();
			}else{
				ML_checkInit();
			}
		},1500);
	}
	
	/*
	 * jquery 충돌로 인해 blockUI를 업무페이지에서 사용하기 위한 함수
	 */
	function blockUI(){
		$.blockUI({
			message:'<div><div><img src="' + mlDirPath + 'UI/images/loader.gif" alt="로딩중입니다."/></div><p style="display:inline-block; padding-top:4px; font-size:11px; color:#333; font-weight:bold;">잠시만 기다려 주세요.</p></div>',
			css:{left:(($(window).width()/2)-75)+'px'}
		});
	}
	
	function checkInstall(callback){
		magiclineApi.callback = callback;
		
		if(magicline.is_ML_Sign_Init){
			var param = null;
			var option = null;
			var request = MakeRequestJsonMessage("checkInstall", param, option);
			ML_sendUtilMessage(request);
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
	}
	
	function genHash(algorithm, msg, callback){
		magiclineApi.callback = callback;
		
		if(magicline.is_ML_Sign_Init){
			var param = {};
			param.algorithm = algorithm;
			param.msg = msg;
			
			var option = null;
			var request = MakeRequestJsonMessage("genHash", param, option);
			ML_sendUtilMessage(request);
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
	}
	
	return {
		MakeSignData:MakeSignData,
		MakeMultiSignData:MakeMultiSignData,		
		MakeSignatureData:MakeSignatureData,
		MakeAddSignData:MakeAddSignData,		
		MakeRequestJsonMessage:MakeRequestJsonMessage,
		ML_sendUtilMessage : ML_sendUtilMessage,
		ML_funProcInitCheck : ML_funProcInitCheck,
		completeInit:completeInit,
		ML_checkInit:ML_checkInit,
		saveCertToStorage:saveCertToStorage,
		getSelectCert:getSelectCert,
		MakeHashSignData:MakeHashSignData,
		/* NTS */
		ntsCertAuth:ntsCertAuth,
		keyBoardSecurityUse:keyBoardSecurityUse,
		tranx2PEM:tranx2PEM,
		getRandomfromPrivateKey:getRandomfromPrivateKey,
		getSignDN:getSignDN,
		signatureData:signatureData,
		setSessionID:setSessionID,		
		blockUI:blockUI,
		checkInstall:checkInstall,
		genHash:genHash
	}
}

magicline.uiapi = new magiclineApi();
var readLength = function(b) {

	  var b2 = b.getByte();
	  if(b2 === 0x80) {
	    return undefined;
	  }

	  // see if the length is "short form" or "long form" (bit 8 set)
	  var length;
	  var longForm = b2 & 0x80;
	  if(!longForm) {
	    // length is just the first byte
	    length = b2;
	  } else {
	    // the number of bytes the length is specified in bits 7 through 1
	    // and each length byte is in big-endian base-256
	    length = b.getInt((b2 & 0x7F) << 3);
	  }
	  return length;
	}


var readValue = function(tag, bytes) {

	if(bytes.length() < 2) {
	    throw new Error('Too few bytes to parse DER.');
	  }

	if (bytes.getByte() != tag) {
	           throw new Error('Invalid format.'); } 
	var length = readLength (bytes); return bytes.getBytes(length); 
}
function getSignedData(sigDataBase64){
	magicjs.init();
	var sigData = sigDataBase64;
	var decoded = magicline.base64Util.decode64(sigData);  // Base64 인코딩되어있는 피노텍 데이터.
	var buff = magicjs.ByteStringBuffer.create(decoded);
	readValue(0x30, buff); // 
	var signedData = decoded.slice(0, buff.read);  // SignedData 획득 부분입니다.
	signedData = magicline.base64Util.encode64(signedData);
	var fileName = magicjs.utf8.decode(readValue(0x0C, buff)); 
	var fileGenTime = dreamsecurity.asn1.utcTimeToDate(readValue(0x17, buff)); 
	var pdfFile = readValue(0x04, buff);
	document.reqForm.signData.value= magicline.base64Util.encode64(pdfFile);
	if(document.getElementById("addSigner").value == null || document.getElementById("addSigner").value == ""){
		document.reqForm.addSigner.value = signedData;
	}
}