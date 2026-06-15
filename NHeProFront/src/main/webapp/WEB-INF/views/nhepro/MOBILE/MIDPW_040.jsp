<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <meta name="robots" content="index,nofollow">
    <meta name="description" content="FIRSTePro 빠르고 투명한 전자구매/계약 서비스">
    <title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
    <link rel="stylesheet" href="/css/nhepro/nhepro-m.css">
    <link rel="shortcut icon" href="/images/favicon.ico"/>
    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/js/ever-formutils.js"></script>
</head>
<script>
    function mobileHome() {
        location.href = '/mobile/index.jsp';
    }

    // 비밀번호 초기화
    function resetPassword() {
        var returnFlag = false;
        $('input').each(function(k, v) {
            if (v.type == 'password') {
                if(v.value == '') {
                    formUtil.animate(v.id, 'form');
                    returnFlag = true;
                }
            }
        });

        if(returnFlag) {
            return alert("${MIDPW_040_0001}"); // 필수 값을 입력하여 주시기 바랍니다.
        }

        var url = "/nhepro/MOBILE/MIDPW_040_resetPassword.so";
        var param = {
            USER_ID: '${USER_ID}',
            PASSWORD: $('#PASSWORD').val()
        };
        $.post(url, param, function (data) {
            if(data.responseCode == 'success') {
                alert("${MIDPW_040_0007}"); // 성공적으로 변경되었습니다.
                mobileHome();
            } else if(data.responseCode == 'fail') {
                return alert("${MIDPW_040_0002}"); // 최근 사용한 동일한 비밀번호는 사용할 수 없습니다.
            }
        }, "json");
    }

    function ppddCheck() {
        if($('#PASSWORD').val() != $('#PASSWORD_CFN').val()) {
            $('#PASSWORD').val('');
            $('#PASSWORD_CFN').val('');
            $('#PASSWORD').focus();

            alert("${MIDPW_040_0003}"); // 비밀번호가 일치하지 않습니다.
            return;
        }
    }

    function checkCall(){
        var str = $('#PASSWORD').val();
		
        if(!CheckPassWord(str)){
        	$('#PASSWORD').val('');
            $('#PASSWORD_CFN').val('');
            $('#PASSWORD').focus();
        }
        
        if(!chkPwd(str)){
            $('#PASSWORD').val('');
            $('#PASSWORD_CFN').val('');
            $('#PASSWORD').focus();
        }
    }
	
  	//2021.03.17 비밀번호 입력시 '%' 특수문자 입력 불가하도록 체크
    function CheckPassWord(str){
    	var reg_pwd = new Array();
    	reg_pwd.push("%");
    	for(var i=0; i < reg_pwd.length; i++){
    		if(str.indexOf(reg_pwd[i])!= -1){
        		EVF.alert("비밀번호 입력 시 % 특수문자는 사용할 수 없습니다.");
        		return false;
    		}
    	}
    	
    	return true;
    }
  
    function chkPwd(str){
        var SamePass_1 = 0;
        var SamePass_2 = 0;

        var reg_pwd = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
        var reg_pwd2 = /^.*(?=.{10,20})(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
        var reg_pwd3 = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[!@#$%^&+=]).*$/;
        var reg_pwd4 = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
        if(reg_pwd.test(str) || reg_pwd2.test(str)|| reg_pwd3.test(str)|| reg_pwd4.test(str)){

        } else {
            alert("${MIDPW_040_0004}"); // 비밀번호는 영문, 숫자, 특수문자의 조합으로 8~20자리\n또는 두가지 조합으로 10~20자리 입력해주세요.
            return false;
        }
        
        if(str.length > 20){
            alert("${MIDPW_040_0004}");
            return false;
        }

        for(var i=0; i < str.length; i++) {
            var chr_pass_0 = str.charAt(i);
            var chr_pass_1 = str.charAt(i+1);
            
            var SamePass_0 = 0; //동일문자 카운트
			for(var j = i; j < str.length; j++) {
				if(chr_pass_0 == str.charAt(j)) {
					SamePass_0 = SamePass_0 + 1
				}
			}
			if(SamePass_0 > 2) {
				return EVF.alert("${MIDPW_040_0005}");
			}
			
            var chr_pass_2 = str.charAt(i+2);
            if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1) {
                SamePass_1 = SamePass_1 + 1
            }

            if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1) {
                SamePass_2 = SamePass_2 + 1
            }
        }
        
        if(SamePass_1 > 1 || SamePass_2 > 1 ) {
            alert("${MIDPW_040_0006}"); // 연속된 문자열(123 또는 321, abc, cba 등)을 3자 이상 사용 할 수 없습니다.
            return false;
        }

        return true;
    }
</script>
<body>
<div class="header">    
     <h1><img src="/resource/images/m-lghnh-logo2.png" alt="FIRSTePro 빠르고 투명한 전자구매/계약 서비스"></h1>
</div>    
<div class="page-wrap">
    
    <section class="contents alert">
        <c:if test="${param.CODE eq 'FAIL_LOGIN_DATE_PASS'}">
            <div class="alert-box">
                <em>비밀번호 변경일이</em><strong> 90일 초과</strong>되었습니다.<br>
                비밀번호를 변경하시기 바랍니다.
            </div>
        </c:if>
        <c:if test="${param.CODE eq 'WRONG_PASSWORD_RESET_FLAG'}">
            <div class="alert-box">
                <em>비밀번호가</em><strong> 초기화 </strong>되었습니다.<br>
                비밀번호를 변경하시기 바랍니다.
            </div>
        </c:if>
        <c:if test="${param.CODE eq 'WRONG_PASSWORD_RESET_DATE'}">
            <div class="alert-box">
                <em>비밀번호 변경일이</em><strong> 90일 </strong>초과 되었습니다.<br>
                비밀번호를 변경하시기 바랍니다.
            </div>
        </c:if>
        <fieldset class="ins">
            <legend class="v-hidden">비밀번호 변경</legend>
            <form>
                <div class="fbox">
                    <div class="i-text">
                        <label for="PASSWORD"><i class="dot"></i>새 비밀번호</label>
                        <input type="password" name="PASSWORD" id="PASSWORD" value="" onchange="javascript:checkCall();" autocomplete=off>
                        <div class="txt-info">(영문,숫자,특수문자 조합 8자 이상)</div> 
                    </div>
                    <div class="i-text">
                        <label for="PASSWORD"><i class="dot"></i>비밀번호 확인</label>
                        <input type="password" name="PASSWORD_CFN" id="PASSWORD_CFN" value="" onchange="javascript:ppddCheck();" autocomplete=off>
                    </div>
                    <div class="btn-area">
                        <%-- 2019.2.19 daguri 무조건 변경하는 것으로....
                        <button type="button" class="btn-darkgray" onclick="javascript:mobileHome();">다음에 변경하기</button>
                        --%>
                        <button type="button" class="btn-basic" onclick="javascript:resetPassword();">비밀번호 변경</button>
                    </div>
                </div>
            </form>
        </fieldset>        
        
    </section>   
</div>

</body>

</html>