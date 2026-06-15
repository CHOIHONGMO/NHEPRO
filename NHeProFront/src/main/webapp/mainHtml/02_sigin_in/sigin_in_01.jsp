<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="Referrer" content="origin">
	<meta http-equiv="X-UA-Compatible" content="IE=Edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="apple-mobile-web-app-title" content="FIRSTePro"/>
	<meta name="robots" content="index,nofollow"/>
	<meta name="description" content="FIRSTePro"/>
	<meta name="keywords" content="FIRSTePro"/>
	<meta name="format-detection" content="telephone=no"/>
	<title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
	<link rel="stylesheet" href="/css/nhepro/fonts/NanumGothic.css">
	<link rel="stylesheet" href="/css/nhepro/bootstrap.min.css">
	
	<script type="text/javascript" src="/js/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="/js/nhepro/bundle.js"></script>
    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/js/everuxf/lic/licenseKey.js"></script>
	<script type="text/javascript" src="/js/ever-popup.js"></script>
	<script type="text/javascript" src="/js/ever-string.js"></script>
	<script>
		var irs_flag = false; // true 이면 협력사 회원가입/ 고객사 회원가입 가능
		var customer_flag = false; //  true 이면 고객사 존재
		var supplier_flag = false; // true 이면 협력사 존재
		var nh_flag = false;
		
		$(document).ready(function () {
        	doSearchSV();
        	doSearchPI();
        });
		
		// 2021.06.08 추가
		// 서비스이용약관 STOCNOTC의 공지번호 "NT202099998" 가져와서 보여주기
        function doSearchSV() {
        	var param = {
                    'NOTICE_NUM': 'NT202099998'
                };
        	
            $.post("/nhepro/serviceGuide.so", param, function (data) {
                $('#contentsSV').html(data.TEXT_CONTENTS);
            }, "json");
		}
        
     	// 2021.06.08 추가
		// 개인정보처리방침 STOCNOTC의 공지번호 "NT202099999" 가져와서 보여주기
		// 2022.01.06
		// 회원가입시 개인정보처리방침 STOCNOTC의 공지번호 "NT202200001" 가져와서 보여주기
        function doSearchPI() {
        	var param = {
                    'NOTICE_NUM': 'NT202200001'
                };
        	
            $.post("/nhepro/serviceGuide.so", param, function (data) {
                $('#contentsPI').html(data.TEXT_CONTENTS);
            }, "json");
		}
        
		function validCheck() {
			var checkFlag = true;
			var Agreeval  = "";
			var Agreeval2 = "";
			var Agreeval3 = "";
			
			$('input[name=Agree').each(function(k, v) {
				var val = "";
                if(v.type == 'radio') {
                	Agreeval = $('input[name='+ v.name +']:checked').val();
                } else {
                	Agreeval = $('input[name='+ v.name +']').val();
                }
            });
			
			$('input[name=Agree2').each(function(k, v) {
                if(v.type == 'radio') {
                	Agreeval2 = $('input[name='+ v.name +']:checked').val();
                } else {
                	Agreeval2 = $('input[name='+ v.name +']').val();
                }

            });
			
			$('input[name=Agree3').each(function(k, v) {
                if(v.type == 'radio') {
                	Agreeval3 = $('input[name='+ v.name +']:checked').val();
                } else {
                	Agreeval3 = $('input[name='+ v.name +']').val();
                }

            });
			
			if( Agreeval != "1") {
				checkFlag = false;
				alert("회원가입 약관에 동의해야만 회원가입이 가능합니다. 약관에 동의해주십시요");
				return false;
			}
			
			if( Agreeval2 != "3") {
				checkFlag = false;
				alert("개인정보 수집·이용 필수항목에 동의해야만 회원가입이 가능합니다.\n개인정보 수집 및 이용동의 필수항목에 동의해주십시요");
				return false;
			}
			
			if(checkFlag) {
				if ($('#IRS_NUM').val() == '') {
					$('#IRS_NUM').focus();
					return alert("사업자번호를 입력하여 주시기 바랍니다.");
				}
			} else {
				return;
			}

			if (!checkValidationIrsNo()) {
				alert("사업자번호를 다시 확인하여 주시기 바랍니다.");
			} else {
				// 이미 가입된 사업자 번호인지 체크
				var store = new EVF.Store();
				store.setParameter('IRS_NUM', $('#IRS_NUM').val());
				store.setParameter('USER_TYPE', 'S');
				store.load("/register/doIrsNumCheck.so", function () {
					var companyInfo = JSON.parse(this.getParameter("companyInfo"));
					var url = "/session/viewContents/view.so";
					var realUrl;
					var param = {
						IRS_NUM: $("#IRS_NUM").val(),
						USER_TYPE: 'S'
					};

					irs_flag = true;
					if (companyInfo == null) {
						realUrl = "/nhepro/REGISTER/register_supplier/view.so";
						param.realUrl = realUrl;
						// if (confirm("가입되지 않은 " + userType.text() + " 사업자번호 입니다.\n" +
						if (confirm("가입되지 않은 협력업체 사업자번호 입니다.\n" + "협력업체 회원가입 하시겠습니까?")) {
							everPopup.openWindowPopup(url, 700, 600, param, '_self', true);
						}
					}
					else {
						realUrl = "/nhepro/REGISTER/register_supplier/view.so";
						param.realUrl = realUrl;

						var msg = "이미 가입된 협력업체 사업자번호 입니다.";
						var msg1 = msg + "\n관리자에게 등록요청하시기 바랍니다.";
						var msg2 = msg + "\n농협 소속으로 사용자 등록을 하실 수 없습니다.";

						if ("S" == "S") {
							supplier_flag = true;
							// 승인된 거래요청 고객사가 존재하는 경우
							if(companyInfo.EVAL_FLAG == "E") {
								return alert("이미 승인된 거래 고객사가 존재합니다.\n\n회원가입시 등록한 담당자로 로그인하세요.");
							}
							else {
								// 승인된 거래요청 고객사가 없이 반려된 경우
								if(companyInfo.CONFIRM_FLAG == "R") {
									param.CONFIRM_FLAG = "R";
									if(confirm("회원가입이 반려처리 되었습니다.\n\n반려사유 : " + companyInfo.CONFIRM_REASON+"\n\n재등록 하시겠습니까?")) {
										everPopup.openWindowPopup(url, 700, 600, param, '_self', true);
									}
								}
								else {
									if (companyInfo.RELAT_YN == undefined || companyInfo.RELAT_YN == "1") {
										return alert(msg1);
									} else if (companyInfo.RELAT_YN == "0") {
										nh_flag = true;
										alert(msg2);
									}
								}
							}
						} else {
							customer_flag = true;
							if(confirm(msg1)) {
								everPopup.openWindowPopup(url, 700, 600, param, '_self', true);
							}

						}
					}
				});
			}
		}

		function checkValidationIrsNo() {
			var checkID = [1, 3, 7, 1, 3, 7, 1, 3, 5, 1];
			var tmpBizID, i, chkSum = 0, c2, remainder;
			var irsNum = $('#IRS_NUM').val().trim();
			irsNum = irsNum.replace(/-/gi, '');
			$('#IRS_NUM').val(irsNum);

			for (i = 0; i <= 7; i++)
				chkSum += checkID[i] * irsNum.charAt(i);
			c2 = "0" + (checkID[8] * irsNum.charAt(8));
			c2 = c2.substring(c2.length - 2, c2.length);
			chkSum += Math.floor(c2.charAt(0)) + Math.floor(c2.charAt(1));
			remainder = (10 - (chkSum % 10)) % 10;

			if (Math.floor(irsNum.charAt(9)) == remainder) {
				return true;
			} else {
				return false;
			}
		}

		function doRegisterBS(flag) {

			if (!irs_flag) {
				return alert("가입확인 후 회원가입을 진행하여 주시기 바랍니다.");
			} else {
				// var userType = $("#USER_TYPE option:selected");
				var url = "/session/viewContents/view.so";
				var realUrl;
				var param = {
					IRS_NUM: $("#IRS_NUM").val(),
					USER_TYPE: 'S'
				};

				// if (flag == userType.val()) {
				if (flag == "S") {

					realUrl = "/nhepro/REGISTER/register_user/view.so";
					param.realUrl = realUrl;

					// var msg = "이미 가입된 " + userType.text() + " 사업자번호 입니다.";
					var msg = "이미 가입된 협력업체 사업자번호 입니다.";
					var msg1 = msg + "\n사용자 등록을 하시겠습니까?";
					var msg2 = msg + "\n농협 소속으로 사용자 등록을 하실 수 없습니다.";

					if (supplier_flag) {
						if (!nh_flag) {
							if (confirm(msg1)) {
								everPopup.openWindowPopup(url, 700, 600, param, '_self', true);
							}
						} else {
							return alert(msg2);
						}
					} else if (customer_flag) {
						if (confirm(msg1)) {
							everPopup.openWindowPopup(url, 700, 600, param, '_self', true);
						}
					} else {
						/*if (userType.val() == "S") {
							realUrl = "/nhepro/REGISTER/register_supplier/view.so";
						} else {
							realUrl = "/nhepro/REGISTER/register_customer/view.so";
						}*/
						realUrl = "/nhepro/REGISTER/register_supplier/view.so";
						param.realUrl = realUrl;

						// if (confirm(userType.text() + "회원가입을 진행하시겠습니까?")) {
						if (confirm("협력업체 회원가입을 진행하시겠습니까?")) {
							everPopup.openWindowPopup(url, 700, 600, param, '_self', true);
						}
					}
				} else {
					return alert("협력업체/고객사를 확인 후 가입확인하여 주시기 바랍니다.");
				}
			}

		}

		function irsNumChange() {
			var irsNum = $("#IRS_NUM");
			if(!everString.isNumber(irsNum.val())) {
				irsNum.val("");
				irsNum.focus();
				return alert("숫자만 입력하여 주시기 바랍니다.");
			} else {
				// 사업자번호 변경 시 다시 사업자번호 체크
				irs_flag = false;
				nh_flag = false;
				customer_flag = false;
				supplier_flag = false;
			}
		}
	</script>
</head>
<body>

<div class="wrap">
	<!--header_wrap-->
	<c:import url="../header/header.jsp" charEncoding="UTF-8"/>
	<!--// header_wrap-->
	<section class="personal sign_in">
		<h2 class="sr-only">회원가입</h2>
		<div class="title">
			<p>회원가입</p>
		</div>
		<div class="box">
			<div class="content">
				<div class="clearfix pb-3">
					<ul class="step">
						<li class="current">STEP 1. 약관동의</li>
						<li>STEP 2. 정보입력</li>
						<li>STEP 3. 가입완료</li>
					</ul>
				</div>
				<div class="p-content">
					<p class="p-title">회원가입 약관</p>
					<div class="p-inner">
						<div class="contents_area" id="contentsSV"></div>
						
						<!--
						<p class="title">제 1조(약관의 목적)</p>
						<p class="mb-2">이 약관은 주식회사 ㈜농협정보시스템(이하 “회사”라 합니다)이 제공하는 제공하는 전자구매시스템ASP서비스(이하 “서비스”)를 이용함에 있어서 본 서비스의 공급사와 본 서비스에 가입하여 이를 이용하는 고객(이하 “회원”이라고 합니다)과의 권리, 의무, 책임사항 서비스 이용조건 및 기타 필요한 사항의 정함을 목적으로 합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 2조(용어의 정의)</p>
						<p class="pl-2">① 전자구매시스템 : 기업 간(B2B)에 발생하는 입찰 및 계약 업무에 대한 효율성 증대를 위해 비대면으로 온라인상에서 계약을 체결할 수 있도록 지원하는 시스템을 말합니다.</p>
						<p class="pl-2">② 회원 : 본 서비스의 이용약관에 동의하고 회사가 요구하는 소정의 정보를 제공하여 “회원”으로 등록을 마친 자를 말합니다.</p>
						<p class="pl-2">③ 회원아이디(ID) : “회원”개개인의 인식과 관련 정보의 식별을 통해 서비스 및 관련 고객지원서비스를 원활하게 이용할 수 있도록 하기 위하여 “회원”스스로가 지정하고 “회사”가 승인한 문자와 숫자의 조합을 말합니다.</p>
						<p class="pl-2">④ 비밀번호 : “회사”에 의해 승인된 ID는 정당한 권한을 가진 자임을 확인하고 “회원” 자신의 비밀보호를 위하여 “회원”이 직접 지정한 문자와 숫자의 조합을 말합니다.</p>
						<p class="pl-2">⑤ 인증서 : 전자서명법 제 15조의 규정에 따라 공인인증기관이 발급하는 전자서명 생성정보가 “회원”에게 속한다는 사실을 확인하고 이를 증명하는 행위를 말합니다.</p>
						<p class="pl-2">⑥ 전자서명인증 : 전자문서를 작성한 자의 신원과 전자문서의 변경 여부를 확인할 수 있도록 비대칭 암호화 방식을 이용하여 전자서명 생성키로 생성한 정보로서 당해 전자문서에 고유한 것을 말합니다.</p>
						<p class="pl-2">⑦ 발주사: 계약을 생성하는 법인</p>
						<p class="pl-2">⑧ 공급사: 계약에 의해 물품을 공급하는 법인</p>
						<p class="pl-2">⑨ 사업주: 근로계약 시 근로자를 고용하는 법인</p>
						<p class="pl-2">⑩ 위임사: 계약업무 중 수임사에게 업무 위임을 하는 법인</p>
						<p class="pl-2">⑪ 수임사: 계약업무 중 위임업무를 받는 법인</p>
						<p class="title"></p>
						
						<p class="title">제 3조(약관의 명시 및 개정)</p>
						<p class="pl-2">① “회사”는 동 약관의 내용을 이용자가 알 수 있도록 “회사”의 서비스 홈페이지(www.first-epro.com)(이하 “홈페이지”라 한다)초기 화면에게시하며, 공시함으로써 효력을 발휘합니다.</p>
						<p class="pl-2">② “회사”는 “회사”가 제공하게 되는 새로운 서비스의 적용, 보안체계의 향상 및 유지, 정부에 의한 시정명령의 이행 등 기타 회사의 업무상 약관을 변경하여야 할 중요한 사유가 있다고 판단될 경우 관계법령을 위해 하지 않는 범위에서 동 약관을 개정할 수 있습니다.</p>
						<p class="pl-2">③ “회사”는 이 약관을 개정할 경우, 적용일자 및 개정사유를 명시하여 현행약관과 함께 사이트 초기화면 또는 이외의 방법을 이용하여 그 적용일자 7일 이전부터 공지합니다.</p>
						<p class="pl-2">④ “회원”은 변경된 약관에 동의하지 않을 경우 해지를 요청할 수 있으며, 변경된 약관의 효력발생일로부터 1개월일 이후에도 거부의사를 표시하지 아니하고 서비스를 계속 이용할 경우는 약관변경사항에 동의한 것으로 간주합니다.</p>
						<p class="pl-2">⑤ “회원”이 이의를 제기하는 경우 회사는 회원과 협의를 거친 후 수용여부를 결정하고 이에 불복하는 “회원”은 서비스 이용을 해지할 수 있습니다.</p>
						<p class="title"></p>
						
						<p class="title">제 4조(약관의 적용)</p>
						<p class="mb-2 pl-2">이 약관에 명시되지 아니한 사항에 대해서는 관계법령에 의하며 법에 명시되지 않는 부분에 대하여는 관습에 의합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 5조(개인정보의 보호)</p>
						<p class="mb-2 pl-2">“회사”는 관계법령이 정하는 바에 따라 “회원" 및 “이용자”등록정보를 포함하여 개인정보를 보호하기 위하여 노력합니다. “회원” 및 이용자의 개인정보의 보호 및 사용에 대하여는 관련법령(정보통신망법, 개인정보보호법, 전자상거래 등에서의 소비자보호에 관한 법률 등) 및 회사의 개인정보보호정책이 적용됩니다.</p>
						<p class="title"></p>
						
						<p class="title">제 6조(서비스 종류)</p>
						<p class="mb-2 pl-2">① “회사”가 “회원”에게 제공하는 “서비스”의 내용은 다음 각호와 같습니다.</p>
						<p class="pl-3 mb-2">1. 입찰공고 및 업체선정<br>
						2. 계약의 체결 및 발주/검수/정산<br>
						3. 입찰/계약 정보 조회 및 자료의 보관<br>
						4. 기타 “회사”가 제공하는 서비스</p>
						<p class="pl-2">② 서비스 내용이 추가, 변경 또는 삭제되는 경우 회사는 이를 “홈페이지”또는 기타 “회사”의 공지채널을 이용하여 이를 공지합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 7조(가입신청)</p>
						<p class="pl-2">① 회원가입 신청은 전용사이트로 “서비스”가입 신청하는 경우 “회사”의 기업 및 담당자정보, 수수료 출금정보 등 제반 정보를확인하여야 하며, “홈페이지”에 접속하여 “회사”소정양식의 가입신청에 제반 정보를 입력하여 신청합니다.</p>
						<p class="pl-2">② 가입신청 시 입력한 고객 정보는 모두 실제 데이터로 간주되며, 추후 가명이나 허위정보를 입력한 이용자는 법적 보호를 받을 수 없으며 서비스의 제한을 받을 수 있습니다.</p>
						<p class="pl-2">③ “회원”은 “회사”에 제공한 정보가 변경되었을 경우 즉시 회원정보를 변경하여야 합니다. 상호, 대표자명 등 입찰/계약업무 필수 기재사항에 영향을 주는 사항의 변경 시 홈페이지를 통하여 정보변경 및 사업자등록증을 등록합니다. “회사”는 “회원”으로부터 정보변경 요청이 있을 경우 특별한 제한사항이 없는 한, 요청사항을 반영 변경토록 합니다.</p>
						<p class="pl-2">④ 이용신청서 상의 기업명과 대표자명은 전자공동인증서 상의 명의와 동일하여야 하며, 가입신청 시의 출금계좌의 예금주 명은 기업 또는 대표자 명의와 동일하여야 함을 원칙으로 합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 8조(가입승인)</p>
						<p class="pl-2">① “회사”는 가입 신청자가 제 7조 제 1항에 따라 모든 사항을 성실히 기재하여 가입 신청을 완료하면 필요사항을 확인한 후 서비스 가입에 대한 승인 여부를 결정합니다.</p>
						<p class="mb-2 pl-2">② “회사”는 서비스 가입 신청이 다음 각 호의 1에 해당하는 경우에는 승낙을 하지 아니합니다.</p>
						<p class="pl-3 mb-2">1. 타인명의로 신청한 경우<br>
						2. 가입신청서 상의 입력 정보 내용이 허위인 경우<br>
						3. 기타 가입이 부적절하다고 판단되는 경우 등</p>
						<p class="title"></p>
						
						<p class="title">제 9조(서비스 이용/이용시간)</p>
						<p class="pl-2">① 전자구매 입찰/계약 서비스는 법인용 공동인증서를 통한 전자서명을 이용할 수 있습니다.</p>
						<p class="pl-2">② “서비스” 이용 시간은 연중무휴 1일 24시간을 원칙으로 합니다.</p>
						<p class="mb-2 pl-2">③ 제 2항의 규정에도 불구하고, 다음 각 호에 해당하는 경우에는 그러하지 아니합니다. 또한, “회사”는 다음 각 호의 사유로 이용시간을제한하는 경우, 사전에 그 내용을 알 수 있는 경우 그 사실을 “홈페이지”에 게시합니다.</p>
						<p class="pl-3 mb-2">1. 보안의 유지 및 향상, 주 전산기의 유지 점검 등의 필요로 인하여 회사가 정한 날이나 시간<br>
						2. 데이터의 백업 및 안전한 보관을 위하여 회사가 정한 정기적이고 규칙적인 날이나 시간<br>
						3. 통신장애 또는 기타 불가피한 사유로 인한 서비스 중단<br>
						4. 기타 위 각 호에 준하는 경우</p>
						<p class="title"></p>
						
						<p class="title">제 10조(이용자 S/W설치)</p>
						<p class="mb-2 pl-2">본 “서비스”의 “회원”은 홈페이지로부터 관련 소프트웨어(S/W)를 다운로드(DownLoad) 받은 후 설치하여야 이용이 가능합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 11조(ID 및 비밀번호 변경/관리)</p>
						<p class="mb-2 pl-2">① ID는 다음 각 호의 1에 해당하는 경우 회원 또는 회사의 요청에 의하여 변경할 수 있다.</p>
						<p class="pl-3 mb-2">1. ID가 “회원”의 개인정보 등으로 등록되어 쉽게 노출되거나 프라이버시 침해의 우려가 있는 경우<br>
						2. 타인에게 혐오감을 주거나 미풍양속을 해치는 비속어를 사용하는 경우<br>
						3. 기타 합리적인 사유가 있는 경우</p>
						<p class="pl-2">② 제1항의 경우를 제외하고는 ID 변경은 불가능하며, 비밀번호는 수시로 변경이 가능합니다.</p>
						<p class="pl-3">다만, 이 경우 비밀번호는 전적으로 “회원”의 책임하에 관리하여야 합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 12조(게시물의 관리)</p>
						<p class="mb-2 pl-2">① “회사”는 “회원”이 게시하거나 등록한 내용이 다음 각 호의 1에 해당한다고 판단되는 경우 “회원”에게 사전게시물의 검열, 검색에 따른 어떠한 의무와 게시물의 내용 및 관리에 따른 일체의 손해배상책임을 부담하지 않습니다.</p>
						<p class="pl-3 mb-2">1. 다른 “회원”, 제 3자 또는 “회사”를 비방하거나 중상모략으로 명예를 손상시키는 내용인 경우<br>
						2. 서비스의 안정적인 운영에 지장을 주거나 지장을 초래할 우려가 있는 경우<br>
						3. 특정 제품의 선전, 사이버 시위 등 게시판의 목적에 맞지 않는 내용인 경우<br>
						4. 범죄적 행위와 결부된다고 판단되는 내용인 경우<br>
						5. 제 3자의 재산권 등 기타 권리를 침해하는 내용인 경우<br>
						6. “회원”이 “홈페이지”나 게시판에 음란물을 게재하거나 음란사이트 링크 등을 할 경우<br>
						7. 기타 관계법령에 위배되거나 위배될 우려가 있는 경우</p>
						<p class="pl-2">② “회원”은 “서비스”를 이용하거나 얻은 정보를 가공, 판매하는 행위 등 게재된 자료를 “회사”의 허락없이 상업적으로 이용할 수 없으며, 이를 위반하여 발생하는 제반 문제의 책임은 “회원”에게 있습니다.</p>
						<p class="title"></p>
						
						<p class="title">제 13조(계약기간 및 이용요금)</p>
						<p class="mb-2 pl-2">① 본 계약기간은 서비스 개시일로부터 1년으로 한다.<br/>
						② 본 계약기간 만료 30일 전까지 “회사”또는 “회원”이 서면으로 갱신거절 통지를 하지 않은 경우, 본 계약과 동일한 조건으로 1년씩 연장된다.<br/>
						③ "서비스"의 이용요금은 서비스의 가격정책을 따릅니다.<br/>
						④ "회사"는 "회원"에게 사업자등록번호 단위로 이용요금을 부과합니다. 다만, 별도 계약(제휴업체 등)에 의해 "회원"으로 가입한 경우에는 예외로 할 수 있습니다.<br/>
						⑤ 충전식(선불) 납입 결제방법은 "홈페이지" 안내를 확인 후 이용하시면 됩니다.</p>
						<p class="title"></p>
						
						<p class="title">제 14조(이용요금 반환)</p>
						<p class="mb-2 pl-2">① “회원”은 이용요금 등의 과다 납입 등에 대하여 “회사”의 이용요금 청구일로부터 3월 이내에 이의신청을 할 수 있습니다.<br/>
						② “회사”는 이용요금 등의 과납이 있을 경우 과납금액을 “회원”의 출금계좌로 반환 입금하거나 다음 달 이용금액에서 이를 상계하여 감액 청구할 수 있습니다.<br/>
						③ “회사”는 과소청구액에 대하여는 익월 청구 시 합산하여 청구합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 15조(회사의 의무)</p>
						<p class="mb-2 pl-2">① “회사”는 특별한 사정이 없는 한 이 약관에서 정한 바에 따라 계속적, 안정적으로 서비스를 제공할 의무가 있습니다.<br/>
						② “회사”는 “서비스”의 제공설비를 항상 운용 가능한 상태로 유지보수하며, 설비에 장애가 발생하거나 멸실된 경우 지체 없이 이를 수리 복구할 수 있도록 최선을 노력을 다해야 합니다.<br/>
						③ “회사”는 이용계약의 체결, 계약사항의 변경 및 해지 등 회원과의 계약관련 절차 및 내용 등에 있어 회원에게 편의를 제공하도록 노력합니다.<br/>
						④ “회사”는 “회원”으로부터 제기되는 의견이나 불만이 정당한 것으로 인정될 경우 신속히 처리하여야 합니다. 다만, 신속한 처리가 곤란한 경우 회원에게 그 사유와 처리 일정을이메일, 서면 또는 전화 등의 방법으로 통보합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 16조(회원의 의무)</p>
						<p class="mb-2 pl-2">① “회원”은 서비스 이용대가로서 동 약관에서 정한 이용요금을 지정된 기일까지 납입하여야 하며, 이용요금의 미납으로 인하여 발생하는 모든 책임은 “회원”에게 있습니다.<br/>
						② “회원”은 동 약관 및 관계 법령을 준수하여야 하며, 기타 회사의 업무 수행에 지장을 초래하는 행위를 하여서는 안됩니다.<br/>
						③ “회원”은 담당자, 전화번호, 이메일(e-mail) 등 회원정보(사업자등록번호)의 변경사항이 발생한 경우 회원정보 변경 메뉴를 이용하여 즉시 변경하여야 합니다. 변경 등의 누락으로 인한 불이익에 대해서는 “회원”의 책임으로 합니다.<br/>
						④ “회원”은 서비스를 이용하여 얻은 정보를 가공 판매하거나 “홈페이지”에 게재된 자료를 상업적으로 이용할 수 없으며, 이를 위반하여 발생하는 모든 문제의 책임은 “회원”에게 있습니다.</p>
						<p class="title"></p>
						
						<p class="title">제 17조(서비스의 제공 및 변경)</p>
						<p class="mb-2 pl-2">① “회사”는 “회원”및 이용자에게 아래와 같은 서비스를 제공하며 본 약관에서 규정하지 않는 개별서비스의 이용관련 세부내용은 해당 서비스의 이용규칙을 통해 고지합니다.</p>
						<p class="pl-3 mb-2">1. 입찰/계약 관련 서비스<br>
						2. 메일, 메시지전송등과 같은 온라인 통신 서비스<br>
						3. 게시판 등 커뮤니티 관련 서비스<br>
						4. 회원을 위한 맞춤서비스<br>
						5. 회사의 상품 및 서비스에 대한 홍보(배너 등)에 대한 일체의 서비스<br>
						6. 기타 회사가 필요하다고 판단되는 일체의 내용 등</p>
						<p class="pl-2">② “회사”는 서비스 및 전용사이트와 관련하여 전문적이고 “회원”에게 수준 높은 서비스를 제공하기 위하여 외부 전문사업자(ERP업체 등)와 전략적 제휴협정을 맺고 공동으로 서비스를 제공할 수 있습니다.</p>
						<p class="pl-2">③ 제 17조 ①, ②항의 서비스 내용은 변경될 수 있습니다. 서비스를 변경하여 제공할 경우 사전에 “회원”에게 통지합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 18조(서비스 이용의 제한)</p>
						<p class="mb-2 pl-2">① “회사”는 "회원"이 동 약관 위반 및 다음 각 호의 1에 해당하는 경우 즉시 이를 해소하지않으면 서비스 이용을 사전 통지나 동의 없이 서비스에 한하여 그 이용을 제한할 수 있습니다. 다만, “회원”이 이용제한 사유를 해소한 경우 그러하지 아니할 수 있습니다.</p>
						<p class="pl-3 mb-2">1. 제 16조의 규정에 의한 “회원”의 의무를 이행하지 않은 경우<br>
						2. “서비스”이용요금을 1개월 이상 회원의 사유로 납부하지 아니하는 경우<br>
						3. 가입신청서에 기재한 사업자등록번호(또는 대표자의 주민등록번호)와 출금계좌 예금주의 사업자 등록번호(또는 주민등록번호)가 상이한 경우</p>
						<p class="pl-2">② “회사”는 서비스 이용제한 기간 중에 그 이용제한 사유가 해소된 것이 확인된 경우 즉시 이용제한 조치를 해제하고 그 사실을 “회원”에 통지합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 19조(서비스 제공의 일시 중지)</p>
						<p class="mb-2 pl-2">① “회사”는 다음 각 호의 1에 해당하는 경우“서비스”의 전부 또는 일부를 일시 중단할 수 있습니다.</p>
						<p class="pl-3 mb-2">1.“서비스” 설비점검, 시스템 보수 및 데이터 관리를 위하여 부득이한 경우<br>
						2. 전기통신사업법에 규정된 기간통신사업자가 전기통신서비스를 중지한 경우<br>
						3. 국가 비상사태, 천재지변이 발생하거나 발생할 우려가 있는 경우<br>
						4. “서비스”설비의 장애 또는 “서비스”이용의 폭주 등으로 서비스 이용에 지장이 있는 경우<br>
						5. 기타 중대한 사유로 인하여 서비스 제공을 지속하는 것이 부적당하다고 판단되는 경우</p>
						<p class="pl-2">② 제1항에 의한 “서비스"중단의 경우 “회사”는 그 사유 등을 “홈페이지"에 게시하거나 “회원”에게 통지합니다. 다만, 회사가 통제할 수 없는 사유로 인하여 사전통지가 불가능한 경우 그러하지 아니합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 20조(서비스 해지)</p>
						<p class="pl-2">① “회원”이 서비스 계약을 해지하고자 하는 때에는 “회원”본인이 사전에 “홈페이지”를 통하여 온라인으로 직접 해지 신청을 하여야 합니다.</p>
						<p class="pl-2">② 해지 신청의 처리 여부는 해지를 신청한 “회원”이 본인의 ID와 비밀번호를 사용하여 “홈페이지”에서 로그인을 시도하여 로그인이 되지 않음을 확인함으로써 알 수 있습니다.</p>
						<p class="mb-2 pl-2">③ “회사”는 “회원”이 다음 각 호의 1에 해당하는 경우 회사는 사전 통보 없이 계약을 해지할 수 있습니다.</p>
						<p class="pl-3 mb-2">1. 가입신청서에 기재한 출금계좌 예금주명이 법인명 또는 대표자명과 상이로 인하여 민원이 발생한 경우<br>
						2. 1년간 이용실적이 없을 경우<br>
						3. “서비스”이용금액을 3개월 이상 납부하지 아니하는 경우<br>
						4. 해산 등으로 인하여 법인격 또는 개인사업자격을 상실하거나 기타 법인격이 없다고 볼 만한 상당한 이유가 있을 경우<br>
						5. 타인명의를 도용하여 신청 또는 신청서를 허위로 기재하거나 허위서류를 첨부하여 부정한 방법으로 이용 신청한 사실이 발견된 경우<br>
						6. “회사”, 다른 “회원” 또는 제 3자의 재산권 등 권리를 침해하는 경우<br>
						7. 타인의 ID 또는 비밀번호를 도용하여 부당하게 “서비스”를 이용하는 경우<br>
						8. “서비스”를 이용하여 얻은 정보를 “회사”의 사전 승낙 없이 영리적 목적으로 복제, 출판, 방송 등에 사용하거나 제 3자에게 제공한 경우<br>
						9. “서비스”이용이 제한된 후에 동일한행위가 2회 이상 반복되는 경우<br>
						10. 선량한 풍속, 기타 사회질서에 반하는 행위를 한 경우<br>
						11. 정보통신윤리위원회의 정보내용 심의에 따라 일정한 제재조치를 권고 받은 경우<br>
						12. 해킹, 컴퓨터 바이러스 유포 등의 방법에 의하여 서비스 운영을 고의 또는 중대한 과실로 방해한 경우<br>
						13. 기타 이 약관이나 관계법령에서 정한 사항 위반 등 회원 자격을 그대로 유지시키는 것이 부적합하다고 인정될 만한 상당한 이유가 있는 경우</p>
						<p class="pl-2">④ “회사”는 제3항에 의하여 해지된 회원에 대하여 해지일로부터 1년 동안 재가입을 제한할 수 있습니다.</p>
						<p class="title"></p>
						
						<p class="title">제 21조(서비스 재가입)</p>
						<p class="mb-2 pl-2">“서비스”해지된 “회원”이 “서비스”에 재가입할 경우 미납 요금이 있을 경우 납부한 후 제 7조, 제 8조의 규정에 따라 가입을 신청하여야 합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 22조(서비스 자료의 보관)</p>
						<p class="mb-2 pl-2">① “회사”는 정상적으로 발급된 회원(해지된“회원”포함)의 입찰/계약 완료일로 부터 5년간 보관하며, 동 기간 경과 후에는 임의로 해당 정보를 삭제할 수 있습니다. 다만, “홈페이지”에서 보관 기간을 연장 신청한 경우에는 예외로 합니다.<br/>
						② “회사”는 제22조 서비스 자료의 보관과 관련하여 재해복구용 및 서비스 장애 등에 대비하여 이중서버를 유지하는 등 서비스 자료 보관에 최선의 노력을 기울입니다.<br/>
						③ 해지된 “회원”의 입찰/계약 자료는 본 “서비스”를 이용하여 조회할 수 없으므로, “회원”은 해지 전에 반드시 입찰/계약 관련 자료를 “회원”컴퓨터(PC)로 다운로드 받아저장 보관하여야 하며, 동 자료는 이용자 소프트웨어(S/W)로 출력할 수 있습니다.<br/>
						④ “회사”는 “서비스”및 정책 등의 변경에 의하여 해지된 회원의 입찰/계약 자료를 삭제할 수 있으며, 해지된 “회원”의 입찰/계약 자료에 대한 일체의 보관의무를 지지 아니합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 23조(손해배상)</p>
						<p class="mb-2 pl-2">① “회사”는 “회사”의 귀책사유로 “회원”이 “서비스”를 이용하지 못하는 경우에는 이로 인하여 발생하는 직접적인 손해를 배상하여야 합니다.<br/>
						② “회원”이 동 약관의 규정을 위반하거나 또는 “회원”자신의 귀책사유로 인하여 “회사”가 다른 회원 또는 제 3자에 대하여 책임을 부담하는 손해를 입게 되는 경우 “회원”은 “회사”에게 이에대한 직접적인 손해를 배상하여야 합니다.<br/>
						③ “회사”는 “서비스” 제공과 관련하여 “회원”에게 어떠한 손해가 발생한 경우 고의 또는 중과실이 없는 한 이에 대한 일체의 책임을 지지 않습니다.<br/>
						④ 손해배상은 회사에 청구사유, 청구금액 및 산출근거를 기재하여 서면으로 청구하여야 합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 24조(면책사항)</p>
						<p class="mb-2 pl-2">“회사”는 다음 각 호의 경우에 대하여는 책임을 지지 않습니다.</p>
						<p class="pl-3 mb-2">1. 국가 비상사태, 천재지변, 제 3자의 고의적 서비스 방해 및 기타 불가항력적인 사유로 인해 “서비스”를 제공하지 못한 경우<br>
						2. “회원”이 제공하는 자료의 오류로 인하여 전산 시스템 장애에 의하여 “서비스”를 제공하지 못한 경우<br>
						3. 통신기기, 통신회선 또는 “회사”의 전산 시스템 장애에 의하여 “서비스”를 제공하지 못한 경우<br>
						4. 바이러스 침투, 불법소프트웨어(S/W)설치 등 관리소홀 및 부주의 등 회원의 귀책사유로 인한 “서비스”이용 장애의 경우<br>
						5. “회원”이 서비스 자료에 대한 취사선택하여 이용함으로 발생한 불이익<br>
						6. “회원”이 게시 또는 전송한 자료의 내용<br>
						7. 기타 “회사”의 과실로 인한 것이 아닌 사유로 인하여 “회원”에게 손해가 발생한 경우</p>
						<p class="title"></p>
						
						<p class="title">제 25조(분쟁해결 및 관할법원)</p>
						<p class="mb-2 pl-2">① 본 약관과 관련하여 분쟁이 발생한 경우 관련 법규가 있으며 그 관련법규를 따르고 관련법규가 없으면 관습 및 신의성실의 원칙에 입각, 상호 협의하여 해결하기로 합니다.<br/>
						② 본 약관과 관련하여 발생한 분쟁이 제 1항에 따라 원만하게 해결되지 아니한 경우 이와 관련된 소송의 관할법원의“회사”본점 소재지를 관할하는 법원으로 합니다.</p>
						<p class="title"></p>
						<p class="title"></p>
						<p class="title"></p>
						<p class="mb-2 pl-2">[부칙] 제 1조 (시행일) 이 약관은 2020년 10월 01일부터 시행한다.</p>
						<p class="pl-3 mb-2">- 2020. 10. 01 ~ 현재적용<br>
						<p class="title"></p>
						-->
					</div>
					<div class="row">
                        <div class="pl-3">
                            <div class="custom-control custom-radio custom-control-inline">
                                <input type="radio" id="AgreeY" name="Agree" class="custom-control-input" value="1">
                                <label class="custom-control-label font-weight-bold" style="padding-top: 10px;" for="AgreeY">상기 이용약관에 동의함</label>
                            </div>
                            <div class="custom-control custom-radio custom-control-inline">
                                <input type="radio" id="AgreeN" name="Agree" class="custom-control-input" value="2">
                                <label class="custom-control-label font-weight-bold" style="padding-top: 10px;" for="AgreeN">동의하지 않음</label>
                            </div>
                        </div>
                    </div>
                            
                    <!-- <div class="pl-3">
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="Agree_Y" name="Agree" class="custom-control-input" value="1">
                            <label class="custom-control-label font-weight-bold" style="padding-top: 10px;" for="customRadio1">상기 이용약관에 동의함</label>
                        </div>
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="Agree_N" name="Agree" class="custom-control-input" value="0">
                            <label class="custom-control-label font-weight-bold" style="padding-top: 10px;" for="customRadio2">동의하지 않음</label>
                        </div>
                    </div> -->
				</div>
				<div class="p-content">
					<p class="p-title">개인정보 수집 및 이용 동의</p>
					<div class="p-inner" style="height: 500px;">
						<div class="contents_area" id="contentsPI"></div>
						
						<!-- <p class="mb-2">㈜농협정보시스템(이하 ‘회사’라 함)은 FIRSTePro를 운영함에 있어 정보주체의 동의하에 회원관리 및 서비스 제공을 위하여 다음과 같이 최소한의 개인정보를 수집하고 있습니다.
						수집한 개인정보는 본 수집·이용 목적 외의 다른 목적으로 사용하지 않습니다.</p>
						<p class="title"></p>
						
						<p class="title">1. 수집하는 개인정보 항목</p>
						<p class="pl-2">- (필수) : 사용자아이디, 이름, 휴대전화번호, 이메일, 계좌번호, 예금주명, 수급자 정보</p>
						<p class="mb-2 pl-2">- (선택) : 부서명, 전화번호</p>
						<p class="title"></p>
						
						<p class="title">2. 개인정보의 수집 및 이용 목적</p>
						<p class="pl-2">- 홈페이지 회원 가입 및 관리, 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산</p>
						<p class="title"></p>
						
						<p class="title">3. 개인정보의 이용 및 보유기간</p>
						<p class="pl-2">① 본인확인에 관한 기록 : 6개월(정보통신망 이용촉진 및 정보보호 등에 관한 법률)</p>
						<p class="pl-2">② 계약 또는 청약철회 등에 관한 기록 : 5년(전자상거래 등에서의 소비자보호에 관한 법률)</p>
						<p class="pl-2">④ 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년(전자상거래 등에서의 소비자보호에 관한 법률)</p>
						<p class="title"></p>
						
						<p class="title">4. 동의를 거부할 권리가 있다는 사실과 동의 거부에 따른 불이익 내용</p>
						<p class="pl-2">- 이용자는 회사에서 수집하는 개인정보에 대한 동의를 거부할 권리가 있으며 동의 거부 시에는 회원가입 및 서비스 이용이 제한됩니다.</p>
						<p class="title"></p>
						-->
					</div>
					<div class="row">
                        <div class="pl-3">
                            <div class="custom-control custom-radio custom-control-inline">
                                <input type="radio" id="AgreeY2" name="Agree2" class="custom-control-input" value="3">
                                <label class="custom-control-label font-weight-bold" style="padding-top: 10px;" for="AgreeY2">개인정보 수집·이용에 동의함 (필수)</label>
                            </div>
                            <div class="custom-control custom-radio custom-control-inline">
                                <input type="radio" id="AgreeN2" name="Agree2" class="custom-control-input" value="4">
                                <label class="custom-control-label font-weight-bold" style="padding-top: 10px;" for="AgreeN2">동의하지 않음 (필수)</label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="pl-3">
                            <div class="custom-control custom-radio custom-control-inline">
                                <input type="radio" id="AgreeY3" name="Agree3" class="custom-control-input" value="5">
                                <label class="custom-control-label font-weight-bold" style="padding-top: 10px;" for="AgreeY3">개인정보 수집·이용에 동의함 (선택)</label>
                            </div>
                            <div class="custom-control custom-radio custom-control-inline">
                                <input type="radio" id="AgreeN3" name="Agree3" class="custom-control-input" value="6">
                                <label class="custom-control-label font-weight-bold" style="padding-top: 10px;" for="AgreeN3">동의하지 않음 (선택)</label>
                            </div>
                        </div>
                    </div>
					<!-- <div class="pl-3">
						<div class="custom-control custom-checkbox custom-checkbox-sm mb-3">
							<input type="radio" style="height: 10px;" id="Agree_N" name="Agree" value="0">
				            <label for="Agree_N" style="cursor: pointer;">상기 이용약관에 동의함</label>
				            &nbsp;
				            <input type="radio" style="height: 10px;" id="Agree_Y" name="Agree" value="1">
				            <label for="Agree_Y" style="cursor: pointer; margin-right: 15px;">상기 이용약관에 동의하지 않음</label>
						</div>
					</div>-->
				</div>
				<div class="p-content">
					<p class="p-title">사업자 등록번호 확인</p>
					<div class="form-group pl-3">
						<label class="mr-3" for="IRS_NUM">사업자 번호</label>
						<input type="text" class="form-control" id="IRS_NUM" placeholder="" style="width: 125px;" onchange="irsNumChange();" maxlength="10">
						<%--<select class="custom-select" title="Text" id="USER_TYPE" style="width: 125px;" onchange="irsNumChange();">
							<option value="S">협력사</option>
							<option value="B">고객사</option>
						</select>--%>
						<div class="d-inline-block">
							<a href="javascript:validCheck();" class="btn btn-primary btn-lg">가입확인</a>
						</div>
					</div>
				</div>
				<%--<div class="p-content">
					<div class="btn-area">
						<a href="javascript:doRegisterBS('S');" class="btn btn-xl btn-primary mr-3">협력사 회원가입</a>
						&lt;%&ndash;<a href="javascript:doRegisterBS('B');" class="btn btn-xl btn-primary">고객사 회원가입</a>&ndash;%&gt;
					</div>
				</div>--%>
			</div>
		</div>
	</section>
	<!--footer_wrap-->
	<c:import url="../footer/footer.jsp" charEncoding="UTF-8"/>
	<!--// footer_wrap-->
</div>
</body>
</html>
