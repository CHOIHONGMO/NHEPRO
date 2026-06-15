<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<!DOCTYPE html>
<html lang="ko">
<head>

<%
	String CP_CD = PropertiesManager.getString("kcb.company.id");
	// SSL redirect
	String localFlag = PropertiesManager.getString("eversrm.system.localserver");
	String devFlag   = PropertiesManager.getString("eversrm.system.developmentFlag");
	boolean useKcbCheckFlag   = PropertiesManager.getBoolean("kcb.login.flag");
	String url       = request.getRequestURL().toString();
	boolean isProductionAndHttp = (devFlag.equals("false") && localFlag.equals("false") && url.indexOf("192") < 0 && url.indexOf("https") < 0 );
	boolean isPortNotSSl  = url.indexOf("https") >=0 && url.indexOf("10443")<0  && devFlag.equals("false") && localFlag.equals("false");
	boolean isDevelopment = devFlag.equals("true") && localFlag.equals("false") && url.indexOf("https") < 0 ;
	if( isProductionAndHttp || isPortNotSSl)  {
		// oper.properties를 읽음
		//String sslUrl = PropertiesManager.getString("eversrm.urls.maintain.real"); 
		String sslUrl = "https://www.first-epro.com:10443";
		response.sendRedirect(sslUrl);
	}
%>

<c:set var="useKcbCheckFlag" value="<%=useKcbCheckFlag%>" />
<c:set var="localFlag" value="<%=localFlag%>" />
<c:set var="devFlag" value="<%=devFlag%>" />

	<%-- 20.02.02 키보드보안 제거 중앙회 요청 농협정보 최종 결정 --%>
    <%-- 키보드보안 암호화 라이브러리 적용 시작 --%>
    <%--<%@ include file="/raonnx/nxKey/jsp/makeRndValue.jsp" %> --%>
    <%-- 키보드보안 암호화 라이브러리 적용 종료 --%>
    <%-- 라온시큐어 스크립트 로출 시작 --%>
    <%--<%@ include file="/raonnx/jsp/raonnx.jsp" %> --%>
    <%-- 라온시큐어 스크립트 로출 종료 --%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="Referrer" content="origin">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="apple-mobile-web-app-title" content="FIRSTePro" />
    <meta name="robots" content="index,nofollow" />
    <meta name="description" content="FIRSTePro" />
    <meta name="keywords" content="FIRSTePro" />
    <meta name="format-detection" content="telephone=no" />
    <title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
    <link rel="shortcut icon" href="/images/favicon.ico"/>
    <link rel="stylesheet" href="/css/nhepro/fonts/NanumGothic.css">
    <link rel="stylesheet" href="/css/nhepro/bootstrap.min.css">

    <script type="text/javascript" src="/js/nhepro/bundle.js"></script>
    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/js/everuxf/lic/licenseKey.js"></script>
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>

    <script type="text/javascript" src="/js/RSA/rsa.js"></script>
    <script type="text/javascript" src="/js/RSA/jsbn.js"></script>
    <script type="text/javascript" src="/js/RSA/prng4.js"></script>
    <script type="text/javascript" src="/js/RSA/rng.js"></script>

    <script>
    	// 20.02.02 키보드보안 제거 중앙회 요청 농협정보 최종 결정
        // TouchEnNxConfig.installPage.tos = TouchEnNxConfig.installPage.nxkey;
    </script>
	<style>
        .ly_v2 {
            position: absolute;
            z-index: 10;
            display: block;
            zoom: 1;
        }

        .ly_v2 .ly_box {
            font-size: 11px;
            line-height: 14px;
            position: static;
            margin-top: 8px;
            padding: 9px 9px 7px;
            letter-spacing: -1px;
            color: #777;
            border: solid 1px #d8d1aa;
            background: #fffadc;
        }

        .ly_v2 .ly_point {
            position: absolute;
            top: 0;
            left: 8px;
            display: block;
            width: 12px;
            height: 10px;
            background-position: -41px -48px;
        }
    </style>
    <script type="text/javascript">
        var tabID
        	,userNm
        	,userCellNum
        ;
        
	    $(document).ready(function() {
		    if("${param.loginType}" == "S") {
			    $("#userId").val("${param.userId}");
			    $("#password").val("${param.password}");
			    doLogin();
		    }
		    
		    // 2021.02.04 공지사항, 입찰공고 탭 활성화에 따라 더보기 클릭 시 해당화면으로 이동
		    $('#notice-tab').click(function() {
		    	tabID = 'notice'        	
	        });
		    
		    $('#bidding-tab').click(function() {
	        	tabID = 'bidding';
	        });
	    });
		
        function doLogin(param) {
        	
        	// 2021.02.02 추가
        	// 키보드보안 제거, 키보드보안 적용 전 rsa방식 사용 중앙회 요청 농협정보 최종 결정 
            var rsa = new RSAKey();
            rsa.setPublic($('#RSAModulus').val(), $('#RSAExponent').val());
            // TK_makeEncData(document.formData);
			
            var store = new EVF.Store();
            if (document.formData.userId.value != "") {
                //store.setParameter("userId", document.formData.E2E_userId.value);
                store.setParameter("userId", rsa.encrypt($('#userId').val()));
                store.setParameter("checkUserId", $('#userId').val());
            } else {
                alert("아이디를 입력하세요.");
                document.formData.userId.focus();
                return;
            }
			
            if (document.formData.password.value == "") {
                alert("비밀번호를 입력하세요.");
                document.formData.password.focus();
                return;
            } else {
                store.setParameter("password", rsa.encrypt($('#password').val()));
            }
			
         	// 2021.11.25 관리자 모드 로그인 추가
         	// 고객사 관리자 모드로 로그인시 "관리자" 메뉴 오픈 (협력사 제외 : 협력사는 사용자명과 휴대폰번호가 정규화되지 않음)
         	var isManagerFlag = document.formData.isManagerFlag.value;
            store.setParameter("userType", "A");
	        store.setParameter("siteType", "BS");
            if (param != undefined) {
            	if( param.invalidate ) {
                	store.setParameter('invalidate', param.invalidate);
            	}
            	if( param.doAuthKcb ) {
            		store.setParameter('doAuthKcb', param.doAuthKcb);
            	}
            	if( param.doAuthManager ) {
            		store.setParameter('doAuthManager', param.doAuthManager);
            		isManagerFlag = "1";
            	}
            }
            store.setParameter("isManagerFlag", isManagerFlag);
            
         	// 2021.02.02 추가
         	// 키보드보안 제거 중앙회 요청 농협정보 최종 결정 	
            //store.setParameter("hid_key_data", document.formData.hid_key_data.value);
            // 개인정보 이용약관 체크
            store.load('/checkAgree.so', function () {
            	
            	// 개인정보 이용약관 체크 한 사용자
                if (this.getResponseMessage() == '1') {
                	 store.load('/loginP.so', function () {doLoginProcess(this); } , false);
                }
             	// 개인정보 이용약관 미체크 한 사용자
                else if (this.getResponseMessage() == '0') {
                    // 2021.02.16 기존 개인정보동의를 시스템 사용동의로 변경
                    // 선불(비농협) 고객 : 서비스이용약관, 개인정보처리방침
                    // 후불(농협) 고객 : ASP 이용계약
                    alert("ASP 미계약 사업자입니다. ASP 계약 전자 서명 이후 사용해 주세요.\n계약담당자(을)에 대한 사업자 정보가 다를 경우 [031-738-8157]에 문의하여 주시기 바랍니다.\n전자서명 시 범용(기업) 인증서가 필요합니다.");
                    
                    var url = '/systemAgreeCheck.so';
                    var params = {
                        title: '범농협 통합전자구매시스템 이용동의서',
                        USER_ID: $('#userId').val()
                    };
                    everPopup.openWindowPopup(url, 900, 800, params, '범농협 통합전자구매시스템 이용동의서');
                }
                else if (this.getResponseMessage() == '2') {
                    // 2021.02.16 기존 개인정보동의를 시스템 사용동의로 변경
                    // 선불(비농협) 고객 : 서비스이용약관, 개인정보처리방침
                    // 후불(농협) 고객 : 서비스이용약관, 개인정보처리방침
                    alert("서비스 이용약관 및 개인정보 약관 미동의 사용자입니다. 동의 후 사용하여 주세요.\n확인 시 이용약관 및 개인정보 동의 화면으로 전환합니다. ");
                    
                    var url = '/userAgreeCheck.so';
                    var params = {
                        title: '범농협 통합전자구매시스템 이용동의서',
                        USER_ID: $('#userId').val()
                    };
                    everPopup.openWindowPopup(url, 900, 750, params, '개인정보 이용약관');
                }
                else {
                	//2021.04.22 비밀번호 5회 이상 실패 체크
                    if (this.getResponseMessage() == null) {
                    	 store.load('/loginP.so', function (data) { doLoginProcess(this); } , false);
                    }
                }
            }, false);
        }
        
        // 2021.11.25 관리자모드 로그인 추가
        // 관리자 모드 로그인 경우 휴대폰 본인인증 처리
        function doLoginProcess(data){
        	var resMsg = data.getResponseMessage()
        		, isLoginError = resMsg != null && resMsg != ''
        		, isLoginDupl = data.getResponseCode() == "201"
       		;
        	
        	if ( isLoginError ) {
                var resCode = data.getResponseCode()
                	, isNonUser = resCode == "nonUser"
                	, isFirstAccess = resCode== "FIRST_ACCESS" && "${useKcbCheckFlag}" == "true"
                	, isWrongPwdExceededCnt = resCode == 'WRONG_PASSWORD_EXCEEDED_CNT'
                	, isPw180 = resCode == "180"
                	, isNotApproval = resCode == 'NOT_APPROVAL'
                	, isManagerFlag = resCode == 'MANAGER_LOGIN'
                ;
                
                // 휴면계정 
                if ( isNonUser) {
                    if ( confirm(resMsg) ) {
                        store.load('/changeLongTermNonUser.so', function () {
                            alert("계정 전환이 완료되었습니다.\n다시 로그인 하시기 바랍니다.");
                        });
                    }
                }
                
                // 반려된 사용자를 제외하고는 모두 메시지 alert
            	if( !isNotApproval ) {
            		alert(resMsg);
        		}
                
        		// 최초 로그인 유저 및 관리자 모드 로그인 -> kcb 본인인증 진행(관리자모드 휴대폰 인증은 운영에서만 진행함)
                if( isFirstAccess || isManagerFlag ){
                	userNm = data.responseBody.USER_NM;
                	userCellNum = data.responseBody.CELL_NUM;
                	
                	// 최초 로그인시에는 kcb 본인인증으로 관리자 인증을 대신함
                	if( isFirstAccess ) {
                    	doAuthKcb();
                	} // 관리자 모드 로그인 경우 휴대폰 문자인증 처리
                	else {
                		doAuthManager();
                	}
                } // PW 오입력 5회이상
                else if (isWrongPwdExceededCnt ) {
             		location.href="/mainHtml/07_search_id_n_pw/07_search_id_pw.jsp"
                } // pw변경일 180일 경과
                else if ( isPw180 ){
                	location.href = "/home.so";
                }
                else if (isNotApproval ){
                	var confirmReason = data.responseBody.CONFIRM_REASON;
                	// 반려된 사용자
                	if(confirmReason){
                		resMsg += '\n반려사유 : ' + confirmReason;
                	} // 미승인 사용자
                	else{
                		resMsg += '\n가입요청한 고객사담당자(입찰공고 내 입찰사무담당자)에게 승인요청 바랍니다.';
                	}
                	resMsg += '\n가입정보를 수정하시겠습니까?';
                	
                	if(confirm(resMsg)){
                		modifyRegisterInfo( data.responseBody.IRS_NUM) ;
                	}
                }
            } // 중복 로그인
        	else if(isLoginDupl){
            	if (confirm('다른 IP로 이미 로그인된 사용자가 있습니다.\n로그아웃시키고 다시 로그인하시겠습니까?')) {
                    doLogin({
                        invalidate: true
                    });
                }
            } // 정상 로그인 
        	else {
                location.href = "/home.so";
            }
        }
        
        // 가입정보 수정
        function modifyRegisterInfo(IRS_NUM){
        	var url = "/session/viewContents/view.so";
        	var param = {
					IRS_NUM: IRS_NUM,
					USER_TYPE: 'S',
						realUrl : "/nhepro/REGISTER/register_supplier/view.so",
						CONFIRM_FLAG : 'R'
				};
    		
    		everPopup.openWindowPopup(url, 700, 600, param, '_self', true);
        }
        
        // 최초 로그인 유저 및 관리자모드 유저 - 휴대폰(kcb) 본인 인증
		function doAuthKcb(){
			 // 핸드폰 인증(KCB)
            var url = "/kcb/phone_popup2.jsp";
            var param = {
                CP_CD: "<%=CP_CD%>",
                SITE_NAME: "농협정보시스템"
            };
            everPopup.openWindowPopup(url, 430, 640, param, 'auth_popup', true);
        }
        
        // Local 또는 개발서버에서는 문자인증 오류라도 완료도 한다.
        // 휴대폰(kcb) 본인 인증 callback func
		function kcbCallbackFunction(data) {
        	
        	var isAuthSuccess = data.RSLT_MSG == "본인인증 완료" && data.RSLT_NAME == userNm && data.TEL_NO == userCellNum;
           	if( isAuthSuccess || "${devFlag}" == "true" || "${localFlag}" == "true" ) {
               	doLogin({doAuthKcb: true});
			} else {
				alert("본인인증 정보가 일치하지 않습니다.\n아리오피스에 등록한 이름 및 핸드폰번호가 휴대폰본인인증 정보와 동일한지 확인하세요.");
   			}
        }
        
        // 2011.12.13 추가
		// 관리자 로그인시 난수 발생에 의한 관리자 문자인증
		function doAuthManager(){
			var url = "/session/viewContents/view.so";
            var param = {
            		realUrl : "/common/userManagerCheck/view.so",
            		USER_ID : $('#userId').val(),
            		USER_NM : userNm,
	                CELL_NUM: userCellNum
	            };
            everPopup.openWindowPopup(url, 430, 250, param, 'authManager', true);
        }
        
		// Local 또는 개발서버 : 123456
        // 관리자모드 문자 인증 callback func
		function doAuthManagerCallback(data) {
           	if( data == "1" ) {
           		doLogin({doAuthManager: true});
   			}
        }
      	
    	// 20.02.02 키보드보안 제거, 키보드보안 적용 전 rsa방식 사용 중앙회 요청 농협정보 최종 결정 
        function checkLoginY(data) {
            if (data == "Y") {
                var rsa = new RSAKey();
                rsa.setPublic($('#RSAModulus').val(), $('#RSAExponent').val());

                var store = new EVF.Store();
                store.setParameter("userId", rsa.encrypt($('#userId').val()));
                store.setParameter("checkUserId", $('#userId').val());
                store.setParameter("password", rsa.encrypt($('#password').val()));
                store.setParameter("userType", "A");
    	        store.setParameter("siteType", "BS");
				
                store.load('/loginP.so', function () {doLoginProcess(this); } , false);
            }
        }

        $(window).ready(function () {
            $('#userId').keydown(function (e) {
                e.stopPropagation();
                if (e.keyCode === 13) {
                    doLogin();
                }
            });

            $('#password').keydown(function (e) {
                e.stopPropagation();
                if (e.keyCode === 13) {
                    doLogin();
                }
            });

            $('#lbtn').click(function (e) {
                e.stopPropagation();
                doLogin();
            });

            $('#formData').keypress(function (e) {
                if (e.keyCode == 13) return false;
            });

            if ($.cookie('nhSrmUserId') != null) {
                $('#userId').val($.cookie('nhSrmUserId'));
                $('#loginSave').prop('checked', true);
            }

            // 로그인 공지사항 팝업
            <c:forEach var="noticePopup" items="${noticeListPopup}">
            noticeCookieCheck('${noticePopup.NOTICE_NUM }', 'loginPopupNotice');
            </c:forEach>

        });

        // 로그인 공지사항 팝업
        function noticeCookieCheck(noticeNum, loginPopupNotice) {
            //var blnCookie = $.cookie('div_laypopup' + noticeNum); // 공지사항 팝업ID
            //if (!blnCookie) {
                openNotice(noticeNum, loginPopupNotice);
            //}
        }

        // 로그인 공지사항 팝업
        function noticeCookieCheck2(buyer_cd, bid_num, bid_cnt, bid_status, loginPopupNotice) {
            var blnCookie = $.cookie('div_laypopup' + bid_num + bid_cnt); // 공지사항 팝업ID
            if (!blnCookie) {
                openNotice2(buyer_cd, bid_num, bid_cnt, bid_status, loginPopupNotice);
            }
        }

        // 로그인 공지사항 팝업
        function openNotice(noticeNum, loginPopupNotice) {
            var url = "/session/viewContents/view.so";
            var param = {
                realUrl: '/mainHtml/03_customer/03_notice_detail.jsp',
                NOTICE_NUM: noticeNum,
            };
            everPopup.openWindowPopup(url, 855, 695, param, '_self');
        }

        // 로그인 공지사항 팝업
        function openNotice2(buyer_cd, bid_num, bid_cnt, bid_status, loginPopupNotice) {
            var url     = "/session/viewContents/view.so";
            var realUrl = "/nhepro/CBDI/CBDR0012/view.so";
            var height  = 900;
            if(bid_status == '2303' || bid_status == '2330') {
            	realUrl = "/nhepro/CBDI/CBDR0014/view.so";
            	height  = 700;
            }
            
            var param = {
                realUrl: realUrl,
                buyerCd: buyer_cd,
                bidNum: bid_num,
                bidCnt: bid_cnt,
                popupFlag: true,
                detailView: true,
                loginPopupNotice: loginPopupNotice
            };
            everPopup.openWindowPopup(url, 1200, height, param, 'ANN_BID' + bid_num + bid_cnt);
        }

        // 공지사항 팝업 닫기
        function closeWinAt00(winName, expiredays) {
            cookie.setCookie(winName, "done", expiredays);
        }

        function toggleSaveUserId() {
            $.cookie('nhSrmUserId', ($('#loginSave').prop('checked') == true ? $('#userId').val() : null), { expires: 365 });
            console.log($.cookie('nhSrmUserId'));
        }
		
        function setManageMode() {
        	if( $('#AgreeY').prop('checked') ) {
        		document.formData.isManagerFlag.value = "1";
        	} else {
        		document.formData.isManagerFlag.value = "0";
        	}
        }
        
        function resetPassword() {

            var store = new EVF.Store();
            if ($('#userId').val() == '') {
                return alert('아이디를 입력하셔야 합니다.');
            }
			
            store.setParameter("userId", $('#userId').val());
            if (confirm('비밀번호를 초기화하시겠습니까?')) {
                store.load('/resetPassword.so', function () {
                    alert(this.getResponseMessage());
                }, false);
            }
        }

        function changeLayer(fg) {
            var cur = document.getElementById("layer1");
            var old = document.getElementById("layer2");
            if (fg == '1') {
                cur.style.display = 'none';
                old.style.display = 'block';
            }
            else {
                cur.style.display = 'block';
                old.style.display = 'none';
            }
        }

        function capslockevt(e) {
            userStrokes = true;
            var myKeyCode = 0;
            var myShiftKey = false;
            if (window.event) { // IE
                myKeyCode = e.keyCode;
                myShiftKey = e.shiftKey;
            } else if (e.which) { // netscape ff opera
                myKeyCode = e.which; // myShiftKey=( myKeyCode == 16 ) ? true :
                // false;
                myShiftKey = isshift;
            }
            if ((myKeyCode >= 65 && myKeyCode <= 90) && !myShiftKey) {
                is_capslockon=true;
                show('err_capslock');
                setTimeout("hide('err_capslock')",3000);
            } else if ((myKeyCode >= 97 && myKeyCode <= 122) && myShiftKey) {
                is_capslockon=true;
                show('err_capslock');
                setTimeout("hide('err_capslock')",3000);
            } else {
                is_capslockon=false;
                setTimeout("hide('err_capslock')",1500);
            }
        }

        var isshift = false;
        var userStrokes = false;
        function checkShiftUp(e) {
            if (e.which && e.which == 16) {
                isshift = false;
            }
        }
        function checkShiftDown(e) {
            var down_keyCode=0;
            if (e.which && e.which == 16) {
                isshift = true;
            }
            if (window.event) {
                down_keyCode = e.keyCode;
            }
            else if (e.which) {
                down_keyCode = e.which;
            }

            if (down_keyCode && down_keyCode == 20) {
                if (!is_capslockon)
                {
                    is_capslockon=true;
                    show('err_capslock');
                    setTimeout("hide('err_capslock')",1500);
                }
                else
                {
                    is_capslockon=false;
                    hide('err_capslock');
                }
            }
        }
        var is_capslockon = false;

        function show(id) {
            $('#'+id).css('display', 'block');
        }
        function hide(id) {
            $('#'+id).css('display', 'none');
        }
        
     	// 2021.02.04 공지사항, 입찰공고 탭 활성화에 따라 더보기 클릭 시 해당화면으로 이동
        function ActiveClickMove() {
        	if(tabID != 'bidding') {
        		location.href = '/session/viewContents/view.so?realUrl=/mainHtml/03_customer/03_notice_list.jsp'
        	} else {
        		location.href = '/session/viewContents/view.so?realUrl=/mainHtml/03_customer/03_notice_list2.jsp'		
        	}
        }
    </script>
</head>

<body>
<!--wrap-->
<div class="wrap">
    <c:import url="/mainHtml/header/header.jsp" charEncoding="UTF-8"/>

    <section class="main">
        <h2 class="sr-only">빠르고 투명한 전자구매/계약 서비스</h2>
        <div class="box">
            <div class="box_main">
                <div class="contents">
                    <p class="title">빠르고 투명한 <span class="font-weight-bold">전자구매/계약 서비스</span></p>
                    <p class="desc"><span class="font-weight-bold">FIRSTeProcument</span> SOLUTION SERVICE</p>
                </div>
                <div class="contents-login">
                    <div class="box_login">
                        <span class="bar"></span>
                        <div class="inner">
                            <div class="title">
                                <p class="highlight">FIRSTePro</p> 에 오신 걸 환영합니다.
                            </div>
                            <form id="formData" name="formData" onsubmit="return false;">
                            	<input type="hidden" id="isManagerFlag" value="0" /> <!-- 관리자모드 여부 -->
                            	
                                <div class="login_area clearfix">
                                    <div class="float-left">
                                        <div class="form-group">
                                            <label for="userId" class="sr-only">ID</label>
                                            <input type="text" class="form-control" name="userId" id="userId" placeholder="회원ID를 입력해 주세요" tabindex="1" data-enc="on"/>
                                            <input type="hidden" id="RSAModulus" value="${RSAModulus}"/>
                                            <input type="hidden" id="RSAExponent" value="${RSAExponent}"/>
                                        </div>
                                        <div class="form-group">
                                            <label for="password" class="sr-only">Password</label>
                                            <input type="password" class="form-control" name="password" id="password" placeholder="비밀번호를 입력해 주세요" tabindex="2" onkeypress="capslockevt(event);" onkeyup="checkShiftUp(event);" onkeydown="checkShiftDown(event);" autocomplete="off" data-enc="on"/>
                                            <div class="ly_v2" id="err_capslock" style="display: none;">
                                                <div class="ly_box">
                                                    <p role="alert"><strong>Caps Lock</strong>이 켜져 있습니다.</p></div>
                                                <span class="sp ly_point"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="float-right">
                                        <button type="submit" class="btn btn-login" tabindex="3" onclick="doLogin();">로그인</button>
                                    </div>
                                </div>
                               	<div class="custom-control custom-checkbox float-left">
                               		<input type="checkbox" id="AgreeY" name="Agree" class="custom-control-input" onclick="setManageMode()">
                                    <label class="custom-control-label" for="AgreeY">관리자모드</label>
                                </div>
                                <div class="find-info float-right">
                                    <a href="/mainHtml/07_search_id_n_pw/07_search_id_pw.jsp">아이디/패스워드 찾기</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section>
        <div class="box">
            <div class="box_menu">
                <ul class="bg row no-gutters">
                    <li class="col-3">
                        <a class="first" href="/mainHtml/04_service/sub_02.jsp">
                            <i class="fal fa-building"></i>
                            <span class="title">협력사 관리</span>
                            <span class="desc">온라인 협력업체 정보관리</span>
                        </a>
                    </li>
                    <li class="col-3">
                        <a href="/mainHtml/04_service/sub_03.jsp">
                            <i class="fal fa-location-arrow"></i>
                            <span class="title">전자입찰</span>
                            <span class="desc">입찰공고에서 낙찰까지 한눈에</span>
                        </a>
                    </li>
                    <li class="col-3">
                        <a href="/mainHtml/04_service/sub_04.jsp">
                            <i class="fal fa-money-check-edit"></i>
                            <span class="title">전자계약</span>
                            <span class="desc">전자서명으로 간단하게</span>
                        </a>
                    </li>
                    <li class="col-3 ">
                        <a class="last" href="/mainHtml/04_service/sub_05.jsp">
                            <i class="fal fa-receipt"></i>
                            <span class="title">전자세금계산서</span>
                            <span class="desc">더이상 종이없는<br />온라인 전자세금 계산서</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </section>
    <section class="notice">
        <h2 class="sr-only">메뉴</h2>
        <div class="box">
            <div class="box_card">
                <div class="row">
                    <div class="col-6 pl-0">
                        <div class="nav-wrap">
                            <ul class="nav nav-tabs" id="myTab" role="tablist">
                                <li class="nav-item">
                                    <a class="nav-link active" id="notice-tab" data-toggle="tab" href="#notice" role="tab" aria-controls="notice" aria-selected="true">공지사항</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="bidding-tab" data-toggle="tab" href="#bidding" role="tab" aria-controls="bidding" aria-selected="false">입찰공고</a>
                                </li>
                            </ul>
                            <div class="btn-link">
                                <a class="" href="javascript:ActiveClickMove()">더보기</a>
                            </div>
                            <div class="tab-content" id="myTabContent">
                                <div class="tab-pane fade show active" id="notice" role="tabpanel" aria-labelledby="notice-tab">
                                    <ul>
                                    </ul>
                                </div>
                                <div class="tab-pane fade" id="bidding" role="tabpanel" aria-labelledby="bidding-tab">
                                    <ul>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="row no-gutters">
                            <a class="card" href="javascript:window.open('http://www.tradesign.net/ra/firstepro','_new'); void(0);">
                                <p class="card-header">공인인증서 발급</p>
                                <span>공인인증서 발급/재발급</span>
                                <span class="icon"><i class="fas fa-chevron-right"></i></span>
                            </a>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="card card-double">
                            <p class="card-header">고객센터</p>
                            <div class="card-body">
                                <span class="highlight"><a href="tel:031-738-8157">031)738-8157</a></span>
                                <p>이용시간 : <span class="font-weight-bold">평일 09:00~18:00</span></p>
                                <p class="time">(점심시간 12:00 ~ 13:00)</p>
                                <div><a class="btn btn-xl btn-block btn-primary font-weight-bold" href="javascript:window.open('https://rcall.nonghyupit.com','_new'); void(0);"><i class="fal fa-user-headset"></i> 원격지원센터</a></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <c:import url="/mainHtml/footer/footer.jsp" charEncoding="UTF-8"/>
</div>
</body>
</html>