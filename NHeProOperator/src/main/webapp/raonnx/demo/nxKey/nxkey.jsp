<%@ page language="java" contentType="text/html; charset=utf-8"%>        
<!DOCTYPE html>
<html>
<head>
<%-- 키보드보안 암호화 라이브러리 적용 시작 --%>
<%@ include file="/raonnx/nxKey/jsp/makeRndValue.jsp" %>
<%-- 키보드보안 암호화 라이브러리 적용 종료 --%>
<%-- 라온시큐어 스크립트 로출 시작 --%>
<script type="text/javascript" src="/raonnx/jquery/jquery-1.6.3.js"></script>
<%@ include file="/raonnx/jsp/raonnx.jsp" %>
<%-- 라온시큐어 스크립트 로출 종료 --%>
<script>
TouchEnNxConfig.installPage.tos = TouchEnNxConfig.installPage.nxkey;
</script>
<title>Insert title here</title>
</head>
<body>
<form name="frm1" id="frm1" method="post" action="result.jsp">
	id : <input type="text" id="txt01" name="txt01" data-enc="on"/>
	pwd : <input type="password" id="pwd01" name="pwd01" data-enc="on"/>
	<input type=button onclick="SubmitData(frm1)" value="전송"/>
	<input type="button" name="btn_ajax1" id="btn_ajax1" value="ajax" onclick="doAjax('01');"/>
</form>
</body>
<script>
function SubmitData(formObj){
	TK_makeEncData(formObj);
	formObj.submit();
}
function doAjax(keyId){
	var hid_key_data = document.getElementsByName("hid_key_data")[0].value;
	var E2E_txtId = "E2E_txt" + keyId;
	var E2E_pwdId = "E2E_pwd" + keyId;
	var E2E_txt = 	document.getElementsByName(E2E_txtId)[0].value;
	var E2E_pwd = document.getElementsByName(E2E_pwdId)[0].value;
	var request = new XMLHttpRequest();
	request.open("POST", "result_ajax.jsp", false);
	request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	request.setRequestHeader("Cache-Control", "no-cache");
	request.send("hid_key_data=" + hid_key_data + "&E2E_txt"+keyId+"=" + E2E_txt + "&E2E_pwd"+keyId+"=" + E2E_pwd + "&keyId=" + keyId);
	alert(request.responseText.replace(/\n/gi, ''));
}

$(function(){
$(".showpassword").each(function(index,input) {
    var $input = $(input);
    $("<p>").append(
        $("<input type='checkbox' class='showpasswordcheckbox' id='showPassword' />").click(function() {
            var change = $(this).is(":checked") ? "text" : "password";
            var rep = $("<input placeholder='Password' type='" + change + "' />")
                .attr("id", $input.attr("id"))
                .attr("name", $input.attr("name"))
                .attr('class', $input.attr('class'))
                .attr('data-enc', $input.attr('data-enc'))
                .val($input.val())
                .insertBefore($input);
            $input.remove();
            $input = rep;
         })
    ).append($("<label for='showPassword'/>").text("Show password")).insertAfter($input.parent());
});

$('#showPassword').click(function(){
	if($("#showPassword").is(":checked")) {
		$('.icon-lock').addClass('icon-unlock');
		$('.icon-unlock').removeClass('icon-lock');
	} else {
		$('.icon-unlock').addClass('icon-lock');
		$('.icon-lock').removeClass('icon-unlock');
	}
	
	TK_Rescan();
	
});
});

</script>

</html>