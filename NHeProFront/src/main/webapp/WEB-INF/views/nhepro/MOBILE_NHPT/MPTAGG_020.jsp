<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String CP_CD = PropertiesManager.getString("kcb.company.id");
%>
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
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>

<script>
    var regExpEMAIL = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
    var regExpTEL_NUM = /^\d{2,3}\d{3,4}\d{4}$/;
    var regExpCELL_NUM = /^\d{3,4}$/;

    var changeIdFlag = true; // 아이디 변경 여부
    var emailChangeFlag = false; // 이메일 변경 여부
    var emailValidFlag = false;

    var certifiedFlag = true; // 인증시간 초과여부
    /*2022.10.31 인증번호 전송여부 = true로 잠시 변경*/
    var certifiedSendFlag = false; // 인증번호전송 여부
    var certifiedConfirmFlag = false; // 인증성공여부

    var signFlag;

    var interval;

    var kcbData;

    /*function onkeypressEvent(type) {

        if( type == 'cell2') {
            if($('#CELL_NUM2').val().length == 3) {
                $('#CELL_NUM3').focus();
            }
        }
    }*/

    function onChangeMonth() {
        var url = "/nhepro/MOBILE_NHPT/getDay.so";
        var param = {
            YEAR: $('#BIRTH_DATE1').val(),
            MONTH: $('#BIRTH_DATE2').val()
        };

        $.post(url, param, function (data) {

            var birth_date3 = "";
            for (var i = 1; i <= Number(data.DAY); i++) {
                if(i < 10) {
                    birth_date3 += "<option value='0" + i + "'>" + i + "일</option>";
                } else {
                    birth_date3 += "<option value='" + i + "'>" + i + "일</option>";
                }

            }

            $('#BIRTH_DATE3').html(birth_date3)
        }, "json");
    }

    function setZipCode(zipcd) {
        if (zipcd.ZIP_CD != "") {
            $('#ZIP_CD').val(zipcd.ZIP_CD_5 == '' ? zipcd.ZIP_CD : zipcd.ZIP_CD_5);
            $('#ADDR').val(zipcd.ADDR1);
            $('#ADDR_ETC').val(zipcd.ADDR2);
            $('#ADDR_ETC').focus();
        }
    }
    
    // 2021.05.17 사용자 ID 입력 시 금지어 체크
    function checkUserId(){
    	
    	var str = $('#USER_ID').val();
    	
    	var map = everString.Injection(str);
        
		if(!map.success) {
			changeIdFlag = true;
			$('#USER_ID').val('');
           	$('#USER_ID').focus();
           	
        	return alert(map.msg);
        }
    }
	
   //2021.05.17 이메일 입력 시 금지어 체크 추가
    function validTelCellEmail(e, type) {
        var id = e.id;
        var value = $('#' + id).val();

        if (type == 'C') {
            if (!value.match(regExpCELL_NUM)) {
                alert("전화번호 앞자리 3~4 자리를 입력하여 주시기 바랍니다."); // 전화번호 앞자리 3~4 자리를 입력하여 주시기 바랍니다.
                $('#' + id).val('');
                $('#' + id).focus();
                return;
            }
        } else if (type == 'T') {
            if (!value.match(regExpTEL_NUM)) {
                alert("형식이 일치하지 않습니다. ex) 02-0000-0000"); // 형식이 일치하지 않습니다. ex) 02-0000-0000
                $('#' + id).focus();
                return;
            }
        } else if (type == 'E') {
            if (!value.match(regExpEMAIL)) {
                $('#' + id).val('');
                $('#' + id).focus();
                emailValidFlag = false;

                return alert("이메일 형식이 일치하지 않습니다."); // 이메일 형식이 일치하지 않습니다.
            } else {
                emailValidFlag = true;
            }
            
            var map = everString.Injection(value);
            
            if(!map.success) {
            	$('#' + id).val('');
                $('#' + id).focus();
                emailValidFlag = false;
                
            	return alert(map.msg); 
            }
        }
    }

    function ppddCheck() {
        if($('#PASSWORD').val() != $('#PASSWORD_CFN').val()) {
            $('#PASSWORD').val('');
            $('#PASSWORD_CFN').val('');
            $('#PASSWORD').focus();

            alert('비밀번호가 일치하지 않습니다.'); // 비밀번호가 일치하지 않습니다.
            return;
        }
    }
	
  	//2021.03.17 비밀번호 입력시 '%' 특수문자 입력 불가하도록 체크 추가
  	//2021.05.17 비밀번호 입력 시 금지어 체크
    function checkCall(){
        var str = $('#PASSWORD').val();
		
        var pass = everString.getCheckPassWord(str);
		
        if(pass.success) {
        } else {
        	$('#PASSWORD').val('');
            $('#PASSWORD_CFN').val('');
            $('#PASSWORD').focus();
            alert(pass.msg);
            return;
        }
        
        var map = everString.getChkPwd(str);
        
        if(map.success) {
        } else {
        	$('#PASSWORD').val('');
            $('#PASSWORD_CFN').val('');
            $('#PASSWORD').focus();
            alert(map.msg);
            return;
        }
        
        var inject = everString.Injection(str);
        
        if(inject.success) {
        } else {
        	$('#PASSWORD').val('');
            $('#PASSWORD_CFN').val('');
            $('#PASSWORD').focus();
            alert(inject.msg);
            return;
        }
    }
	
    //2021.03.02 비밀번호 입력시 check방식 변경
    /*function checkCall(){
        var str = $('#PASSWORD').val();

        if(!chkPwd(str)){
            $('#PASSWORD').val('');
            $('#PASSWORD_CFN').val('');
            $('#PASSWORD').focus();
        }
    }
    
    function chkPwd(str){
        var SamePass_1 = 0;
        var SamePass_2 = 0;

        var reg_pwd = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
        var reg_pwd2 = /^.*(?=.{10,20})(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
        var reg_pwd3 = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[!@#$%^&+=]).*$/;
        var reg_pwd4 = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
        
        if(reg_pwd.test(str) || reg_pwd2.test(str)|| reg_pwd3.test(str)|| reg_pwd4.test(str)){

        }else{
            alert("비밀번호는 영문, 숫자, 특수문자의 조합으로 8~20자리\n또는 두가지 조합으로 10~20자리 입력해주세요."); // 비밀번호는 영문, 숫자, 특수문자의 조합으로 8~20자리\n또는 두가지 조합으로 10~20자리 입력해주세요.
            return false;
        }
        
        if(str.length > 20){
            alert("비밀번호는 영문, 숫자, 특수문자의 조합으로 8~20자리\n또는 두가지 조합으로 10~20자리 입력해주세요.");
            return false;
        }

        for(var i=0; i < str.length; i++) {
            var chr_pass_0 = str.charAt(i);
            var chr_pass_1 = str.charAt(i+1);
            
            var SamePass_0 = 0;
			for(var j = i; j < str.length; j++) {
				if(chr_pass_0 == str.charAt(j)) {
					SamePass_0 = SamePass_0 + 1
				}
			}
			if(SamePass_0 > 2) {
				return EVF.alert("동일문자를 3번 이상 사용할 수 없습니다.");
			}
			
            var chr_pass_2 = str.charAt(i+2);
            if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1) {
                SamePass_1 = SamePass_1 + 1
            }

            if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1) {
                SamePass_2 = SamePass_2 + 1
            }
        }
        if(SamePass_1 > 1 || SamePass_2 > 1) {
            return alert("연속된 문자열(123 또는 321, abc, cba 등)을 3자 이상 사용 할 수 없습니다."); // 연속된 문자열(123 또는 321, abc, cba 등)을 3자 이상 사용 할 수 없습니다.
        }
        return true;
    } */

    function perUser() {
        var url = '/nhepro/MOBILE_NHPT/MPTAGG_030/view.so';
        var param = {
            callBackFunction: "setPerUser",
            modalYn: false
        };
        everPopup.openWindowPopup(url, 700, 600, param, 'perUser');
    }

    function setPerUser(data) {
        $('#SITE_USER_ID').val(data.USER_ID);
        $('#SITE_USER_NM').val(data.USER_NM);
    }
	
    function kcbCallbackFunction(data) {
        kcbData = data;

        if (data.RSLT_MSG == "본인인증 완료" && data.RSLT_NAME == $("#USER_NM").val() && data.TEL_NO == cell_num ) {
            // 인증번호전송여부 체크
            certifiedSendFlag = true;
        } else {
        	alert("본인인증 정보가 일치하지 않습니다.\n 이름 및 핸드폰번호가 휴대폰본인인증 정보와 동일한지 확인하세요.");
            certifiedSendFlag = false;
        }
    }
	
    /*******************************************************************************
     * 저장
     *******************************************************************************/
    function doSave() {
        $('#USER_ID').val($('#USER_ID').val().trim());
        // Validation 체크
        /*
        var returnFlag = false;
        $('input').each(function(k, v) {
            if (v.type == 'text' && v.id != "EMAIL") {
                if(v.value == '') {
                    formUtil.animate(v.id, 'form');
                    returnFlag = true;
                }
            }
            if (v.type == 'password') {
                if(v.value == '') {
                    formUtil.animate(v.id, 'form');
                    returnFlag = true;
                }
            }
            if (v.type == 'radio') {
                if(!$('input[name=GENDER]').is(':checked')) {
                    formUtil.animate(v.id, 'form');
                    returnFlag = true;
                }
            }
        });
        
        if(returnFlag) {
            return alert("필수 값을 입력하여 주시기 바랍니다."); // 필수 값을 입력하여 주시기 바랍니다.
        }

        if(changeIdFlag) {
            return alert("사용자 ID 중복확인 하여 주시기 바랍니다."); // 사용자 ID 중복확인 하여 주시기 바랍니다.
        }
        
        if($('#EMAIL').val()!='' && emailChangeFlag) {
            return alert("이메일을 중복확인 하여 주시기 바랍니다."); // 이메일을 중복확인 하여 주시기 바랍니다.
        }

        if(!certifiedSendFlag) {
            return alert("본인인증을하여 주시기 바랍니다.");
        }

        if(kcbData.RSLT_NAME != $("#USER_NM").val()) {
            return alert("인증 사용자와 일치하지 않습니다.\n다시 인증하여 주시기 바랍니다.");
        }
        */
        var url = "/nhepro/MOBILE_NHPT/doSave.so";
        $.post(url, $('#form').serialize(), function (data) {
            if(data.responseCode == 'success') {
                location.href = "/nhepro/MOBILE_NHPT/MPTAGG_040/view.so";
            } else {
                return alert(data.responseMsg);
            }
        }, "json");
    }
</script>
</head>

<body>
<div class="header">
    <h1>회원가입</h1>
</div>
<div class="page-wrap">
    <form id="form" name="form">
    <section class="contents sign-up">
        <div class="titbar">
            <h2>회원가입 정보입력</h2>
            <div class="signup-step">
                <span>1</span><em></em><span class="active">2</span><em></em><span>3</span>
            </div>
        </div>
        <section class="fbox sign-up">
            <fieldset class="ins">
                <legend class="v-hidden">회원가입</legend>
               	<form>
                <div class="t-row">
                    <div class="t-cell01"><label for="USER_ID"><i class="title required"></i>사용자 ID</label></div>
                    <div class="t-cell02">
                        <input type="text" name="USER_ID" id="USER_ID" value="" onchange="checkUserId();">
                    </div>
                    <div class="t-cell03">
                        <button type="button" class="btn-check" id="overlap_btn">중복확인</button>
                    </div>
                </div>

                <div class="t-row">
                    <div class="t-cell01"><label for="USER_NM"><i class="title required"></i>이름</label></div>
                    <div class="t-cell02">
                        <input type="text" name="USER_NM" id="USER_NM" value="">
                    </div>
                </div>
                <div class="t-row">
                    <div class="t-cell01"><label for="MALE"><i class="title required"></i>성별</label></div>
                    <div class="t-cell02">
                        <div class="chk-wrap">
                            <input type="radio" name="GENDER" id="MALE" value="M">
                            <label for="MALE">남성</label>
                            <input type="radio" name="GENDER" id="FEMALE" value="F">
                            <label for="FEMALE">여성</label>
                        </div>
                    </div>
                </div>
                

                <div class="t-row">
                    <div class="t-cell01"><label for="PASSWORD"><i class="title required"></i>비밀번호</label></div>
                    <div class="t-cell02">
                        <input type="password" name="PASSWORD" id="PASSWORD" value="" onchange="checkCall();" autocomplete=off>
                        <span class="txt-info">&#40; 영문, 숫자, 특수문자 조합 8자 이상 &#41;</span>
                    </div>
                </div>
                <div class="t-row">
                    <div class="t-cell01"><label for="PASSWORD_CFN"><i class="title required"></i>비밀번호 확인</label></div>
                    <div class="t-cell02">
                        <input type="password" name="PASSWORD_CFN" id="PASSWORD_CFN" value="" onchange="ppddCheck();" autocomplete=off>
                    </div>
                </div>
                <div class="t-row t0">
                    <div class="t-cell01"><label for="CELL_NUM1" class="t10"><i class="title required"></i>휴대전화번호</label></div>
                    <div class="t-cell02">
                        <div class="t-row">
                            <div class="t-cell02" style="flex: none;">
                                <select name="CELL_NUM1" id="CELL_NUM1">
                                    <option value="010">010</option>
                                    <option value="011">011</option>
                                    <option value="016">016</option>
                                    <option value="017">017</option>
                                    <option value="018">018</option>
                                    <option value="019">019</option>
                                    <option value="0130">0130</option>
                                </select>
                            </div>
                            <div class="t-cell02" style="flex: none;">
                                <span>&nbsp;</span>
                            </div>
                            <div class="t-cell02">
                                <input type="text" name="CELL_NUM2" id="CELL_NUM2" maxlength="4" style="text-align: center;" onchange="validTelCellEmail(this, 'C')">
                            </div>
                            <div class="t-cell02" style="flex: none;">
                                <span style="top: 6px; position: relative;">-</span>
                            </div>
                            <div class="t-cell02">
                                <input type="text" name="CELL_NUM3" id="CELL_NUM3" maxlength="4" style="text-align: center;" onchange="validTelCellEmail(this, 'C')">
                            </div>
                            <div class="t-cell03">
                                <%--<button type="button" class="btn-check" id="certified_confirm_btn">인증번호전송</button>--%>
                                <button type="button" class="btn-check" id="certified_send_btn">본인인증</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="t-row">
                    <div class="t-cell01"><label for="EMAIL"><i class="title"></i>E-mail</label></div>
                    <div class="t-cell02" >
                          <input type="text" placeholder = "(선택)이메일이 있는 경우 입력해주세요." name="EMAIL" id="EMAIL" value="" onchange="validTelCellEmail(this, 'E')">
                    </div>
                    <div class="t-cell03">
                        <button type="button" class="btn-check" id="email-btn">중복확인</button>
                    </div>
                </div>

                <div class="t-row">
                    <div class="t-cell01"><label for="ZIP_CD"><i class="title required"></i>우편번호</label></div>
                    <div class="t-cell02">
                        <input type="text" name="ZIP_CD" id="ZIP_CD" value="" readonly style="background-color: #ebebe4;">
                    </div>
                    <div class="t-cell03">
                        <button type="button" class="btn-check" id="zip_search">우편번호검색</button>
                    </div>
                </div>

                <div class="t-row">
                    <div class="t-cell01"><label for="ADDR"><i class="title required"></i>주소</label></div>
                    <div class="t-cell02">
                        <input type="text" name="ADDR" id="ADDR" value="" readonly style="background-color: #ebebe4;">
                    </div>
                </div>
                <div class="t-row">
                    <div class="t-cell01"><label for="ADDR_ETC"><i class="title required"></i>상세주소</label></div>
                    <div class="t-cell02">
                        <input type="text" name="ADDR_ETC" id="ADDR_ETC" placeholder="상세주소를 입력해 주세요.">
                    </div>
                </div>

                <div class="t-row">
                    <div class="t-cell01"><label for="BIRTH_DATE1"><i class="title required"></i>생년월일</label></div>
                    <div class="t-cell02">
                        <select name="BIRTH_DATE1" id="BIRTH_DATE1" title="년도 선택">

                        </select>
                    </div>
                    <div class="t-cell02">
                        <select name="BIRTH_DATE2" id="BIRTH_DATE2" title="월 선택" onchange="javascript:onChangeMonth();">
                            <option value="01" selected>01</option>
                            <option value="02">02</option>
                            <option value="03">03</option>
                            <option value="04">04</option>
                            <option value="05">05</option>
                            <option value="06">06</option>
                            <option value="07">07</option>
                            <option value="08">08</option>
                            <option value="09">09</option>
                            <option value="10">10</option>
                            <option value="11">11</option>
                            <option value="12">12</option>
                        </select>
                    </div>
                    <div class="t-cell02">
                        <select name="BIRTH_DATE3" id="BIRTH_DATE3" title="일 선택">
                            <option value="01" selected>01</option>
                            <option value="02">02</option>
                            <option value="03">03</option>
                            <option value="04">04</option>
                            <option value="05">05</option>
                            <option value="06">06</option>
                            <option value="07">07</option>
                            <option value="08">08</option>
                            <option value="09">09</option>
                            <option value="10">10</option>
                            <option value="11">11</option>
                            <option value="12">12</option>
                            <option value="13">13</option>
                            <option value="14">14</option>
                            <option value="15">15</option>
                            <option value="16">16</option>
                            <option value="17">17</option>
                            <option value="18">18</option>
                            <option value="19">19</option>
                            <option value="20">20</option>
                            <option value="21">21</option>
                            <option value="22">22</option>
                            <option value="23">23</option>
                            <option value="24">24</option>
                            <option value="25">25</option>
                            <option value="26">26</option>
                            <option value="27">27</option>
                            <option value="28">28</option>
                            <option value="29">29</option>
                            <option value="30">30</option>
                            <option value="31">31</option>
                        </select>
                    </div>
                </div>
                <div class="t-row">
                    <div class="t-cell01"><label for="SITE_USER_NM"><i class="title required"></i>현장담당자</label></div>
                    <div class="t-cell02">
                        <input type="text" name="SITE_USER_NM" id="SITE_USER_NM" readonly style="background-color: #ebebe4;" placeholder="담당자를 검색해 주세요.">
                        <input type="hidden" name="SITE_USER_ID" id="SITE_USER_ID">
                    </div>
                    <div class="t-cell03">
                        <a href="javascript:perUser();" class="btn-check" >담당자검색</a>
                    </div>
                </div>
                </form>
            </fieldset>
        </section>
        <div class="btn-area f-none">
            <button type="button" class="btn-basic" onClick="javascript:doSave();">확인</button>
        </div>
    </section>
    </form>
</div>
</body>
</html>
<script>
	var cell_num;
    $(document).ready(function () {
        // 회원정보 셋팅
        // 현재 날짜를 받아서 -100년의 값을 계산하여 BIRTH_DATE1 에 넣어준다.
        var now_year = ${NOW_YEAR};
        var birth_date1 = "";
        for (var i = now_year - 100; i <= now_year; i++) {
            birth_date1 += "<option value='" + i + "'>" + i + "</option>";
        }
        $('#BIRTH_DATE1').html(birth_date1);
        // Default 는 현재 날짜
        $('#BIRTH_DATE1').val(now_year);

        /*******************************************************************************
         * 우편번호 검색
         *******************************************************************************/
        $('#zip_search').on('click', function (e) {
        
        	//테스트용 코드
        	// $('#ZIP_CD').val('11111');        	
        	// $('#ADDR').val('경기도 의왕시 성고개로');
        	       
            var url = '/common/code/BADV_022/view.so';

            var param = {
                callBackFunction : "setZipCode",
                modalYn : false
            };
            

            // everPopup.jusoPop(url, param);
            
            window.open(url + "?" + $.param(param),"pop","scrollbars=yes, resizable=yes");
            
        });

        /*******************************************************************************
         * 인증번호전송
         *******************************************************************************/
        $('#certified_send_btn').on('click', function (e) {
            /*
            if($('#USER_ID').val() == '') {
                return alert("사용자 ID 를 입력하여 주시기 바랍니다."); // 사용자 ID 를 입력하여 주시기 바랍니다.
            }

            if(changeIdFlag) {
                return alert("사용자 ID 중복확인 하여 주시기 바랍니다."); // 사용자 ID 중복확인 하여 주시기 바랍니다.
            }
			*/
			
			
            if($('#USER_NM').val() == '') {
                return alert("이름을 입력하여 주시기 바랍니다."); // 이름을 입력하여 주시기 바랍니다.
            }
			
			var $cell_num1= $('#CELL_NUM1').val();
            var $cell_num2 = $('#CELL_NUM2');
            var $cell_num3 = $('#CELL_NUM3');
            if ($cell_num2.val() == '' || $cell_num2.val().length < 3) {
                $cell_num2.focus();
                return alert("휴대전화번호를 제대로 입력하여 주시기 바랍니다."); // 휴대전화번호를 제대로 입력하여 주시기 바랍니다.
            }

            if ($cell_num3.val() == '' || $cell_num3.val().length < 4) {
                $cell_num3.focus();
                return alert("휴대전화번호를 제대로 입력하여 주시기 바랍니다.");
            }
            
            cell_num= $cell_num1 + $cell_num2.val() + $cell_num3.val();

            // 핸드폰 인증(KCB)
            var url = "/kcb/phone_popup2.jsp";
            var param = {
                CP_CD: "<%=CP_CD%>",
                SITE_NAME: "농협정보시스템"
            };
           
          
           everPopup.openWindowPopup(url, 430, 640, param, 'auth_popup', true);
			
           /* 
            // 인증번호전송을 누르면 인증시간 초기화
            $('#second').text('120');

            // 인증 시간 기록
            var url = "/nhepro/MOBILE_NHPT/certified_update.so";
            var param = {
                CELL_NUM: $('#CELL_NUM1').val() + "-" + $('#CELL_NUM2').val() + "-" + $('#CELL_NUM3').val(),
                USER_ID: $('#USER_ID').val().trim(),
                USER_NM: $('#USER_NM').val()
            };
            $.post(url, param, function (data) {
                alert("인증번호를 발송하였습니다."); // 인증번호를 발송하였습니다.

                // 인증번호전송여부 체크
                certifiedSendFlag = true;
                certifiedFlag = true;

                // 120초간 반복하여 인증시간 갱신
                interval = setInterval(function () {
                    if (Number($('#second').text()) == 0) {
                        // 초기화
                        certifiedFlag = false;
                        clearInterval(interval);
                    } else {
                        $('#second').text(Number($('#second').text()) - 1);
                    }
                }, 1000);
            }, 'json');
            */
        });

        /*******************************************************************************
         * 인증번호확인
         *******************************************************************************/
        /*
        $('#certified_confirm_btn').on('click', function (e) {
            if (!certifiedSendFlag) {
                alert("인증번호전송을 요청하여 주시기 바랍니다."); // 인증번호전송을 요청하여 주시기 바랍니다.
                return;
            }

            if (certifiedConfirmFlag) {
                alert("인증 완료 되었습니다."); // 인증 완료 되었습니다.
            }

            if (certifiedFlag) {
                // 인증 시간 기록
                var url = "/nhepro/MOBILE_NHPT/certified_confirm.so";
                var param = {
                    CELL_NUM: $('#CELL_NUM1').val() + "-" + $('#CELL_NUM2').val() + "-" + $('#CELL_NUM3').val(),
                    CERTIFIED_NUMBER: $('#CERTIFIED_NUMBER').val()
                };
                $.post(url, param, function (data) {
                    if (data.CONFIRM_FLAG == '1') {
                        certifiedConfirmFlag = true;
                        clearInterval(interval);
                        alert("인증 완료 되었습니다."); // 인증 완료 되었습니다.
                    } else {
                        certifiedConfirmFlag = false;
                        alert("인증번호를 다시 확인하여 주시기 바랍니다."); // 인증번호를 다시 확인하여 주시기 바랍니다.
                    }
                }, 'json');
            } else {
                alert("인증시간이 초과하였습니다.\n재인증 요청하여 주시기 바랍니다."); // 인증시간이 초과하였습니다.\n재인증 요청하여 주시기 바랍니다.
            }
        });
        */

        /*******************************************************************************
         * 이메일 중복확인
         *******************************************************************************/
        $('#email-btn').on('click', function (e) {

            if(emailValidFlag) {
                var url = "/nhepro/MOBILE_NHPT/emailCheck.so";
                var param = {
                    USER_ID: $('#USER_ID').val().trim(),
                    EMAIL: $('#EMAIL').val().trim()
                };
                $.post(url, param, function (data) {

                    if(data.USR_EMAIL_CNT == '1') {
                        emailChangeFlag = false;
                        return alert("사용하실 수 있는 이메일 입니다."); // 사용하실 수 있는 이메일 입니다.
                    }

                    if(data.EMAIL_CNT == '1') {
                        $('#EMAIL').focus();
                        emailChangeFlag = true;
                        return alert("사용하실 수 없는 이메일 입니다."); // 사용하실 수 없는 이메일 입니다.
                    } else {
                        emailChangeFlag = false;
                        return alert("사용하실 수 있는 이메일 입니다."); // 사용하실 수 있는 이메일 입니다.
                    }

                }, 'json');
            } else {
                return;
            }
        });

        /*******************************************************************************
         * ID 중복확인
         *******************************************************************************/
        $('#overlap_btn').on('click', function () {
            $('#USER_ID').val($('#USER_ID').val().trim());
            if( $('#USER_ID').val().length < 6 ) {
                $('#USER_ID').focus();
                return alert("아이디는 6자리 이상 입력하여 주시기 바랍니다.}"); // 아이디는 6자리 이상 입력하여 주시기 바랍니다.
            }

            if ($('#USER_ID').val() == '') {
                $('#USER_ID').focus();
                return alert("사용자 ID 를 입력하여 주시기 바랍니다."); // 사용자 ID 를 입력하여 주시기 바랍니다.
            }

            var url = "/nhepro/MOBILE_NHPT/userIdCheck.so";
            var param = {
                USER_ID: $('#USER_ID').val()
            };
            $.post(url, param, function (data) {
                if (data.responseCode == 'fail') {
                    if (data.PROGRESS_CD == 'R') {
                        signFlag = data.PROGRESS_CD;
                        $('input').each(function (k, v) {
                            if (v.type == 'text') {
                                if (data[v.id] == undefined) {
                                    v.value = '';
                                } else {
                                    v.value = data[v.id];
                                }
                            }
                            if (v.type == 'radio') {
                                if (data[v.name] == 'M') {
                                    $('#MALE').attr('checked', true);
                                } else if (data[v.name] == 'F') {
                                    $('#FEMALE').attr('checked', true);
                                }
                            }
                            if(v.type == 'hidden') {
                                if (data[v.id] == undefined) {
                                    v.value = '';
                                } else {
                                    v.value = data[v.id];
                                }
                            }
                        });
                        $('select').each(function(k, v) {
                            if (data[v.id] != undefined) {
                                v.value = data[v.id];
                            }
                        });
                        changeIdFlag = false;
                    } else {
                        alert("이미 등록된 사용자 ID 입니다."); // 이미 등록된 사용자 ID 입니다.
                        $('#USER_ID').val('');
                        $('#USER_ID').focus();
                        changeIdFlag = true;
                    }
                } else {
                    alert("사용하실 수 있는 ID 입니다."); // 사용하실 수 있는 ID 입니다.
                    changeIdFlag = false;
                }
                return;
            }, "json");
        });
    });
</script>