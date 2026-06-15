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

		function validCheck() {
			var checkFlag = true;
			$('input[type="checkbox"]').each(function(k, v) {
				if(!v.checked) {
					checkFlag = false;
					$(v).focus();
					alert("상기 이용약관을 체크하여 주시기 바랍니다.");
					return false;
				}
			});

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
						<p class="title">제 1조(약관의 목적)</p>
						<p class="mb-2">이 약관은 주식회사 농협정보시스템㈜(이하 “회사”라 합니다)가 제공하는 FIRSTePro(전자구매/계약) ASP서비스(이하 “서비스”)를 이용함에 있어서 본 서비스의 협력업체 및 고객사와 본 서비스에 가입하여 이를 이용하는 고객(이하 “회원”이라고 합니다)과의 권리, 의무, 책임사항 서비스 이용조건 및 기타 필요한 사항의 정함을 목적으로 합니다.</p>
						<p class="title"></p>

						<p class="title">제 2조(약관의 명시 및 개정)</p>
						<p class="pl-2">① “회사”는 동 약관의 내용을 이용자가 알 수 있도록 “회사”의 서비스 홈페이지(www.first-epro.com)(이하 “홈페이지”라 한다)초기 화면에게시하며, 공시함으로써 효력을 발휘합니다.</p>
						<p class="pl-2">② “회사”는 “회사”가 제공하게 되는 새로운 서비스의 적용, 보안체계의 향상 및 유지, 정부에 의한 시정명령의 이행 등 기타 회사의 업무상 약관을 변경하여야 할 중요한사유가 있다고 판단될 경우 관계법령을 위해 하지 않는 범위에서 동 약관을 개정할 수 있습니다.</p>
						<p class="pl-2">③ “회사”는 이 약관을 개정할 경우, 적용일자 및 개정사유를 명시하여 현행약관과 함께 사이트 초기화면 또는 이외의 방법을 이용하여 그 적용일자 7일 이전부터공지합니다.</p>
						<p class="pl-2">④ “회원”은 변경된 약관에 동의하지 않을 경우 해지를 요청할 수 있으며, 변경된 약관의 효력발생일로부터 1개월일 이후에도 거부의사를 표시하지 아니하고 서비스를 계속 이용할경우는 약관변경사항에동의한 것으로 간주합니다.</p>
						<p class="pl-2">⑤ “회원”이 이의를 제기하는 경우 회사는 회원과 협의를 거친 후 수용여부를 결정하고 이에 불복하는 “회원”은 서비스 이용을 해지할 수 있습니다.</p>
						<p class="title"></p>
						
						<p class="title">제 3조(약관의 적용)</p>
						<p class="mb-2 pl-2">이 약관에 명시되지 아니한 사항에 대해서는 관계법령에 의하며 법에 명시되지 않는 부분에 대하여는 관습에 의합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 4조(개인정보의 보호)</p>
						<p class="mb-2 pl-2">“회사”는 관계법령이 정하는 바에 따라 “회원”및 “이용자”등록정보를 포함하여 개인정보를 보호하기 위하여 노력합니다. “회원”및 이용자의 개인정보의 보호 및 사용에 대하여는관련법령(정보통신망법, 개인정보보호법, 전자상거래 등에서의 소비자보호에 관한 법률 등) 및 회사의 개인정보보호정책이 적용됩니다.</p>
						<p class="title"></p>
						
						<p class="title">제 5조(서비스 종류)</p>
						<p class="mb-2 pl-2">① “회사”가 “회원”에게 제공하는 “서비스”의 내용은 다음 각호와 같습니다.</p>
						<p class="pl-3 mb-2">1. 전자구매/계약을 위한 견적, 입찰, 계약, 발주, 입고/검수, 정산 데이터 생성, 수정, 보관<br>
						2. 전자구매/계약 관련 각종서식 및 자료의 편집, 집계 및 출력<br>
						3. 기타 “회사”가 제공하는 서비스</p>
						<p class="pl-2">② 서비스 내용이 추가, 변경 또는 삭제되는 경우 회사는 이를 “홈페이지”또는 기타 “회사”의 공지채널을 이용하여 이를 공지합니다. </p>
						<p class="title"></p>
						
						<p class="title">제 6조(가입신청)</p>
						<p class="pl-2">① 회원가입 신청은 전용사이트 신청 고객으로 “서비스”가입 신청하는 경우 “회사”의 전자구매/계약 이용신청서 또는 협약서 등에 기업 및 담당자정보, 수수료 출금정보 등 제반 정보를 기입 후 제출하며, 제출 후 “홈페이지”에 접속하여 “회사”소정양식의 가입신청에 제반 정보를 입력하여 신청합니다.</p>
						<p class="pl-2">② 가입신청 시 입력한 고객 정보는 모두 실제 데이터로 간주되며, 추후 가명이나 허위정보를 입력한 이용자는 법적 보호를 받을 수 없으며 서비스의 제한을받을 수 있습니다.</p>
						<p class="pl-2">③ “회원”은 “회사”에 제공한 정보가 변경되었을 경우 즉시 회원정보를 변경하여야 합니다. 상호, 대표자명 등 전자구매/계약의 필수 기재사항에 영향을주는 사항의 변경 시 사업자등록증을 제출하고 홈페이지를 통하여 정보변경을 요청합니다. “회사”는 “회원”으로부터 정보변경 요청이 있을 경우 특별한 제한사항이 없는 한, 요청사항을 반영 변경토록 합니다.</p>
						<p class="pl-2">④ 이용신청서 상의 기업명과 대표자명은 전자공인인증서 상의 명의와 동일하여야 하며, 가입신청 시의 출금계좌의 예금주 명은 기업 또는 대표자 명의와동일하여야 함을원칙으로 합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 7조(가입승인)</p>
						<p class="pl-2">① “회사”는 가입 신청자가 제 6조 제 1항에 따라 모든 사항을 성실히 기재하여 가입 신청을 완료하면 필요사항을 확인한 후 서비스 가입에 대한 승인 여부를결정합니다.</p>
						<p class="mb-2 pl-2">② “회사”는 서비스 가입 신청이 다음 각 호의 1에 해당하는 경우에는 승낙을 하지 아니합니다.</p>
						<p class="pl-3 mb-2">1. 타인명의로 신청한 경우<br>
						2. 가입신청서 상의 입력 정보 내용이 허위인 경우<br>
						3. 기타 가입이 부적절하다고 판단되는 경우 등</p>
						<p class="title"></p>
						
						<p class="title">제 8조(서비스 이용/이용시간)</p>
						<p class="pl-2">① 전자구매/계약 서비스는 범용 공인인증서를 통한 전자서명 후에 이용할 수 있습니다.</p>
						<p class="pl-2">② “서비스” 이용 시간은 연중무휴 1일 24시간을 원칙으로 합니다.</p>
						<p class="mb-2 pl-2">③ 제 2항의 규정에도 불구하고, 다음 각 호에 해당하는 경우에는 그러하지 아니합니다. 또한, “회사”는 다음 각 호의 사유로 이용시간을 제한하는 경우, 사전에 그 내용을알 수 있는 경우 그 사실을 “홈페이지”에 게시합니다.</p>
						<p class="pl-3 mb-2">1. 보안의 유지 및 향상, 주 전산기의 유지 점검 등의 필요로 인하여 회사가 정한 날이나 시간<br>
						2. 데이터의 백업 및 안전한 보관을 위하여 회사가 정한 정기적이고 규칙적인 날이나 시간<br>
						3. 통신장애 또는 기타 불가피한 사유로 인한 서비스 중단<br>
						4. 기타 위 각 호에 준하는 경우</p>
						<p class="title"></p>
						
						<p class="title">제 9조(이용자 S/W설치)</p>
						<p class="mb-2 pl-2">본 “서비스”의 “회원”은 홈페이지로부터 관련 소프트웨어(S/W)를 다운로드(DownLoad) 받은 후 설치하여야 이용이 가능합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 10조(ID 및 비밀번호 변경</p>
						<p class="mb-2 pl-2">① ID는 다음 각 호의 1에 해당하는 경우 회원 또는 회사의 요청에 의하여 변경할 수 있다.</p>
						<p class="pl-3 mb-2">1. ID가 “회원”의 개인정보 등으로 등록되어 쉽게 노출되거나 프라이버시 침해의 우려가 있는 경우<br>
						2. 타인에게 혐오감을 주거나 미풍양속을 해치는 비속어를 사용하는 경우<br>
						3. 기타 합리적인 사유가 있는 경우</p>
						<p class="pl-2">② 제 1항의 경우를 제외하고는 ID 변경은 불가능하며, 비밀번호는 수시로 변경이 가능합니다. 다만, 이 경우 비밀번호는 전적으로 ”회원”의 책임하에 관리하여야 합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 11조(게시물의 관리)</p>
						<p class="mb-2 pl-2">① “회사”는 “회원”이 게시하거나 등록한 내용이 다음 각 호의 1에 해당한다고 판단되는 경우 “회원”에게 사전게시물의 검열, 검색에 따른어떠한 의무와 게시물의 내용 및 관리에 따른 일체의 손해배상책임을 부담하지 않습니다.</p>
						<p class="pl-3 mb-2">1. 다른 “회원”, 제 3자 또는 “회사”를 비방하거나 중상모략으로 명예를 손상시키는 내용인 경우<br>
						2. 서비스의 안정적인 운영에 지장을 주거나 지장을 초래할 우려가 있는 경우<br>
						3. 특정 제품의 선전, 사이버 시위 등 게시판의 목적에 맞지 않는 내용인 경우<br>
						4. 범죄적 행위와 결부된다고 판단되는 내용인 경우<br>
						5. 제 3자의 재산권 등 기타 권리를 침해하는 내용인 경우<br>
						6. “회원”이 “홈페이지”나 게시판에 음란물을 게재하거나 음란사이트 링크 등을 할 경우<br>
						7. 기타 관계법령에 위배되거나 위배될 우려가 있는 경우</p>
						<p class="pl-2">② “회원”은 “서비스”를 이용하거나 얻은 정보를 가공, 판매하는 행위 등 게재된 자료를 “회사”의 허락없이 상업적으로 이용할 수 없으며, 이를위반하여 발생하는 제반 문제의 책임은 “회원”에게 있습니다.</p>
						<p class="title"></p>
						
						<p class="title">제 12조(이용요금)</p>
						<p class="mb-2 pl-2">① “서비스”의 이용요금은 FIRSTePro의 가격정책을 따릅니다.<br/>
						② “회사”는 “회원”에게 사업자등록번호 단위로 이용요금을 부과합니다. 다만, 별도 계약(제휴업체 등)에 의해 “회원”으로 가입한 경우에는 예외로 할 수 있습니다.<br/>
						③ 충전식(선불) 납입 결제방법은 “홈페이지”안내를 확인 후 이용하시면 됩니다.</p>
						<p class="title"></p>
						
						<p class="title">제 13조(이용요금 반환)</p>
						<p class="mb-2 pl-2">① “회원”은 이용요금 등의 과다 납입 등에 대하여 “회사”의 이용요금 청구일로부터 3월 이내에 이의신청을 할 수 있습니다.<br/>
						② “회사”는 이용요금 등의 과납이 있을 경우 과납금액을 “회원”의 출금계좌로 반환 입금하거나 다음 달 이용금액에서 이를 상계하여 감액 청구할 수 있습니다.<br/>
						③ “회사”는 과소청구액에 대하여는 익월 청구 시 합산하여 청구합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 14조(회사의 의무)</p>
						<p class="mb-2 pl-2">① “회사”는 특별한 사정이 없는 한 이 약관에서 정한 바에 따라 계속적, 안정적으로 서비스를 제공할 의무가 있습니다.<br/>
						② “회사”는 “서비스”의 제공설비를 항상 운용 가능한 상태로 유지보수하며, 설비에 장애가 발생하거나 멸실된 경우 지체 없이 이를 수리 복구할 수 있도록 최선을 노력을다해야 합니다.<br/>
						③ “회사”는 이용계약의 체결, 계약사항의 변경 및 해지 등 회원과의 계약관련 절차 및 내용 등에 있어 회원에게 편의를 제공하도록 노력합니다.<br/>
						④ “회사”는 “회원”으로부터 제기되는 의견이나 불만이 정당한 것으로 인정될 경우 신속히 처리하여야 합니다. 다만, 신속한 처리가 곤란한 경우 회원에게 그 사유와 처리일정을 이메일, 서면 또는 전화 등의 방법으로 통보합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 15조(회원의 의무)</p>
						<p class="mb-2 pl-2">① “회원”은 서비스 이용대가로서 동 약관에서 정한 이용요금을 지정된 기일까지 납입하여야 하며, 이용요금의 미납으로 인하여 발생하는 모든책임은 “회원”에게 있습니다.<br/>
						② “회원”은 동 약관 및 관계 법령을 준수하여야 하며, 기타 회사의 업무 수행에 지장을 초래하는 행위를 하여서는 안됩니다.<br/>
						③ “회원”은 담당자, 전화번호, 이메일(e-mail) 등 회원정보(사업자등록번호)의 변경사항이 발생한 경우 회원정보 변경 메뉴를 이용하여 즉시 변경하여야 합니다. 특히수신을 위한 필수사항인이메일(e-mail)정보는 변경 즉시 이를 수정하여야 합니다. 변경 등의 누락으로 인한 불이익에 대해서는 회원의 책임으로 합니다.<br/>
						④ “회원”은 서비스를 이용하여 얻은 정보를 가공 판매하거나“홈페이지”에 게재된 자료를 상업적으로 이용할 수 없으며, 이를 위반하여 발생하는 모든 문제의 책임은 “회원”에게있습니다.</p>
						<p class="title"></p>
						
						<p class="title">제 16조(서비스의 제공 및 변경)</p>
						<p class="mb-2 pl-2">① ”회사”는 “회원”및 이용자에게 아래와 같은 서비스를 제공하며 본 약관에서 규정하지 않는 개별서비스의 이용관련 세부내용은 해당 서비스의이용규칙을 통해 고지합니다.</p>
						<p class="pl-3 mb-2">1. 전자구매/계약 관련 서비스<br>
						2. 메일, 메시지전송등과 같은 온라인 통신 서비스<br>
						3. 게시판 등 커뮤니티 관련 서비스<br>
						4. 회원을 위한 맞춤서비스<br>
						5. 회사의 상품 및 서비스에 대한 홍보(배너 등)에 대한 일체의 서비스<br>
						6. 기타 회사가 필요하다고 판단되는 일체의 내용 등</p>
						<p class="pl-2">② “회사”는 FIRSTePro 및 전용사이트와 관련하여 전문적이고 “회원”에게 수준 높은 서비스를 제공하기 위하여 외부 전문사업자(ERP업체 등)와전략적 제휴협정을 맺고 공동으로 서비스를 제공할 수 있습니다.</p>
						<p class="pl-2">③ 제 16조 ①, ②항의 서비스 내용은 변경될 수 있습니다. 서비스를 변경하여 제공할 경우 사전에 “회원”에게 통지합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 17조(서비스 이용의 제한)</p>
						<p class="mb-2 pl-2">① “회사”는 “회원”이 동 약관 위반 및 다음 각 호의 1에 해당하는 경우 즉시 이를 해소하지 않으면 서비스 이용을 사전 통지나 동의 없이전자구매/계약 서비스에 한하여 그 이용을 제한할 수 있습니다. 다만, “회원”이 이용제한 사유를 해소한 경우 그러하지 아니할 수 있습니다.</p>
						<p class="pl-3 mb-2">1. 제 15조의 규정에 의한 “회원”의 의무를 이행하지 않은 경우<br>
						2. “서비스”이용요금을 1개월 이상 회원의 사유로 납부하지 아니하는 경우<br>
						3. 가입신청서에 기재한 사업자등록번호(또는 대표자의 주민등록번호)와 출금계좌 예금주의 사업자 등록번호(또는 주민등록번호)가 상이한 경우</p>
						<p class="pl-2">② “회사”는 서비스 이용제한 기간 중에 그 이용제한 사유가 해소된 것이 확인된 경우 즉시 이용제한조치를 해제하고 그 사실을 “회원”에통지합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 18조(서비스 제공의 일시 중지)</p>
						<p class="mb-2 pl-2">① “회사”는 다음 각 호의 1에 해당하는 경우“서비스”의 전부 또는 일부를 일시 중단할 수 있습니다.</p>
						<p class="pl-3 mb-2">1.“서비스” 설비점검, 시스템 보수 및 데이터 관리를 위하여 부득이한 경우<br>
						2. 전기통신사업법에 규정된 기간통신사업자가 전기통신서비스를 중지한 경우<br>
						3. 국가 비상사태, 천재지변이 발생하거나 발생할 우려가 있는 경우<br>
						4.“서비스”설비의 장애 또는“서비스”이용의 폭주 등으로 서비스 이용에 지장이 있는 경우<br>
						5. 기타 중대한 사유로 인하여 서비스 제공을 지속하는 것이 부적당하다고 판단되는 경우</p>
						<p class="pl-2">② 제 1항에 의한“서비스”중단의 경우“회사”는 그 사유 등을 “홈페이지”에 게시하거나 “회원”에게 통지합니다. 다만, 회사가 통제할 수 없는 사유로인하여 사전통지가 불가능한 경우 그러하지 아니합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 19조(서비스 해지)</p>
						<p class="pl-2">① “회원”이 서비스 계약을 해지하고자 하는 때에는 “회원”본인이 사전에 “홈페이지”를 통하여 온라인으로 직접 해지 신청을 하여야 합니다.</p>
						<p class="pl-2">② 해지 신청의 처리 여부는 해지를 신청한 “회원”이 본인의 ID와 비밀번호를 사용하여 “홈페이지”에서 로그인을 시도하여 로그인이 되지 않음을 확인함으로써 알 수 있습니다.</p>
						<p class="mb-2 pl-2">③ “회사”는 “회원”이 다음 각 호의 1에 해당하는 경우 회사는 사전 통보 없이 계약을 해지할 수 있습니다.</p>
						<p class="pl-3 mb-2">1. 가입신청서에 기재한 출금계좌 예금주명이 법인명 또는 대표자명과 상이로 인하여 민원이 발생한 경우<br>
						2. 1년간 이용실적이 없을 경우<br>
						3. “서비스”이용금액을 3개월 이상 납부하지 아니하는 경우<br>
						4. 해산 등으로 인하여 법인격 또는 개인사업자격을 상실하거나 기타 법인격이 없다고 볼 만한 상 당한 이유가 있을 경우<br>
						5. 타인명의를 도용하여 신청 또는 신청서를 허위로 기재하거나 허위서류를 첨부하여 부정한 방법 으로 이용 신청한 사실이 발견된 경우<br>
						6. “회사”, 다른 “회원”또는 제 3자의 재산권 등 권리를 침해하는 경우<br>
						7. 타인의 ID 또는 비밀번호를 도용하여 부당하게 “서비스”를 이용하는 경우<br>
						8. “서비스”를 이용하여 얻은 정보를 “회사”의 사전 승낙 없이 영리적 목적으로 복제, 출판, 방송 등에 사용하거나 제 3자에게 제공한 경우<br>
						9. “서비스”이용이 제한된 후에 동일한 행위가 2회 이상 반복되는 경우<br>
						10. 선량한 풍속, 기타 사회질서에 반하는 행위를 한 경우<br>
						11. 정보통신윤리위원회의 정보내용 심의에 따라 일정한 제재조치를 권고 받은 경우<br>
						12. 해킹, 컴퓨터 바이러스 유포 등의 방법에 의하여 서비스 운영을 고의 또는 중대한 과실로 방해한 경우<br>
						13. 기타 이 약관이나 관계법령에서 정한 사항 위반 등 회원 자격을 그대로 유지시키는 것이 부적합하다고 인정될 만한 상당한 이유가 있는 경우</p>
						<p class="pl-2">④ “회사”는 제3항에 의하여 해지된 회원에 대하여 해지일로부터 1년 동안 재가입을 제한할 수 있습니다.</p>
						<p class="title"></p>
						
						<p class="title">제 20조(서비스 재가입)</p>
						<p class="mb-2 pl-2">“서비스”해지된 “회원”이 “서비스”에 재가입할 경우 재가입비(별첨 참조)와 미납 요금을 함께 납부한 후 제 5조의 규정에 따라 가입을 신청하여야합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 21조(서비스 자료의 보관)</p>
						<p class="mb-2 pl-2">① “회사”는 정상적으로 발급된 회원(해지된“회원”포함)의 전자구매/계약에 대한 서류 및 첨부파일을 작성 및 첨부한 날로부터 5년간보관하며, 동 기간 경과 후에는 임의로 해당 정보를 삭제할 수 있습니다. 다만, 고객센타를 통해 보관 기간을 연장 신청한 경우에는 예외로 합니다.<br/>
						② “회사”는 제21조 서비스 자료의 보관과 관련하여 재해복구용 및 서비스 장애 등에 대비하여 이중서버를 유지하는 등 서비스 자료 보관에 최선의 노력을 기울입니다.<br/>
						③ 해지된 “회원”의 전자구매/계약에 대한 서류 및 첨부파일은 본 “서비스”를 이용하여 조회할 수 없으므로, “회원”은 해지 전에 반드시 관련 자료를 “회원”컴퓨터(PC)로 다운로드 받아저장 보관하여야 합니다.<br/>
						④ “회사”는 “서비스”및 정책 등의 변경에 의하여 해지된 회원의 전자구매/계약에 대한 서류 및 첨부파일을 삭제할 수 있으며, 해지된 “회원”의 전자구매/계약에 대한 서류 및 첨부파일에 대한 일체의 보관의무를 지지 아니합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 22조(손해배상)</p>
						<p class="mb-2 pl-2">① “회사”는 “회사”의 귀책사유로 “회원”이 “서비스”를 이용하지 못하는 경우에는 이로 인하여 발생하는 직접적인 손해를 배상하여야합니다.<br/>
						② “회원”이 동 약관의 규정을 위반하거나 또는 “회원”자신의 귀책사유로 인하여 “회사”가 다른 회원 또는 제 3자에 대하여 책임을 부담하는 손해를 입게 되는 경우 “회원”은 “회사”에게 이에대한 직접적인 손해를 배상하여야 합니다.<br/>
						③ “회사”는 “서비스” 제공과 관련하여 “회원”에게 어떠한 손해가 발생한 경우 고의 또는 중과실이 없는 한 이에 대한 일체의 책임을 지지 않습니다.<br/>
						④ 손해배상은 회사에 청구사유, 청구금액 및 산출근거를 기재하여 서면으로 청구하여야 합니다.</p>
						<p class="title"></p>
						
						<p class="title">제 23조(면책사항)</p>
						<p class="mb-2 pl-2">“회사”는 다음 각 호의 경우에 대하여는 책임을 지지 않습니다.</p>
						<p class="pl-3 mb-2">1. 국가 비상사태, 천재지변, 제 3자의 고의적 서비스 방해 및 기타 불가항력적인 사유로 인해 “서비스”를 제공하지 못한 경우<br>
						2. “회원”이 제공하는 자료의 오류로 인하여 전산 시스템 장애에 의하여 서비스를 제공하지 못한 경우<br>
						3. 통신기기, 통신회선 또는 “회사”의 전산 시스템 장애에 의하여 “서비스”를 제공하지 못한 경우<br>
						4. 바이러스 침투, 불법소프트웨어(S/W)설치 등 관리소홀 및 부주의 등 회원의 귀책사유로 인한 “서비스”이용 장애의 경우<br>
						5. “회원”이 서비스 자료에 대한 취사선택하여 이용함으로 발생한 불이익<br>
						6. “회원”이 게시 또는 전송한 자료의 내용<br>
						7. 기타 “회사”의 과실로 인한 것이 아닌 사유로 인하여 “회원”에게 손해가 발생한 경우</p>
						<p class="title"></p>
						
						<p class="title">제 24조(분쟁해결 및 관할법원)</p>
						<p class="mb-2 pl-2">① 본 약관과 관련하여 분쟁이 발생한 경우 관련 법규가 있으며 그 관련법규를 따르고 관련법규가 없으면 관습 및 신의성실의 원칙에 입각, 상호협의하여 해결하기로 합니다.<br/>
						② 본 약관과 관련하여 발생한 분쟁이 제 1항에 따라 원만하게 해결되지 아니한 경우 이와 관련된 소송의 관할법원의“회사”본점 소재지를 관할하는 법원으로 합니다.</p>
						<p class="title"></p>
						<p class="title"></p>
						<p class="title"></p>
						<p class="mb-2 pl-2">[부칙] 제 1조 (시행일) 이 약관은 2017년 10월 31일부터 시행한다.</p>
						<p class="pl-3 mb-2">- 2017. 10. 31 ~ 현재적용<br>
						- 2010. 01. 01 ~ 2017. 10. 30 적용</p>
						<p class="title"></p>
						
						
						
					</div>					
					<div class="pl-3">
						<div class="custom-control custom-checkbox custom-checkbox-sm mb-3">
							<input type="checkbox" class="custom-control-input" id="agreement">
							<label class="custom-control-label font-weight-bold" for="agreement">상기 이용약관에 동의함</label>
						</div>
					</div>
				</div>
				<div class="p-content">
					<p class="p-title">개인정보처리 방침</p>
					<div class="p-inner">
						<p class="mb-2">㈜농협정보시스템(이하 ‘회사’)은 FIRSTePro를 운영함에 있어 개인정보 보호법 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고원활하게 처리할 수 있도록
하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다. 다만 회사가 사업 등의 목적을 위하여 별도의 홈페이지를 운영할 경우 사업 등 관련 개인정보 처리방침은 해당홈페이지
에 공개하며 해당 방침을 우선적으로 적용함을 알려드립니다.</p>
						<p class="title"></p>
						
						<p class="title">제1조(개인정보의 처리목적)</p>
						<p class="mb-2 pl-2">이 방침은 ㈜농협정보시스템이 운영하는 FIRSTePro 서비스를 이용하는 이용자의 개인정보 처리방침을 규정함을 목적으로 합니다. 회사는 다음의 목적을위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 개인정보 보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를이행 할 예정입니다.</p>
						<p class="pl-3 mb-2">① 홈페이지 회원 가입 및 관리<br>
						- 회원제 서비스 이용 및 제한적 본인 확인에 따른 본인확인, 부정이용방지 및 비인가 사용 방지, 가입 의사 확인, 불만 처리 등 민원 처리, 고지사항 전달</p>
						<p class="pl-3 mb-2">② 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산<br>
						- 콘텐츠 제공, 서비스 이용 시 필요한 정보전달 및 요금정산</p>
						<p class="title"></p>
						
						<p class="title">제2조(개인정보의 처리 및 보유기간)</p>
						<p class="pl-2">1. 회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.</p>
						<p class="mb-2 pl-2">2. 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.</p>
						<p class="pl-3 mb-2">① 본인확인에 관한 기록 : 6개월(정보통신망 이용촉진 및 정보보호 등에 관한 법률)<br>
						② 계약 또는 청약철회 등에 관한 기록 : 5년(전자상거래 등에서의 소비자보호에 관한 법률)<br>
						③ 대금결제 및 재화 등의 공급에 관한 기록 : 5년(전자상거래 등에서의 소비자보호에 관한 법률)<br>
						④ 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년(전자상거래 등에서의 소비자보호에 관한 법률)</p>
						<p class="title"></p>
						
						<p class="title">제3조(개인정보의 제3자 제공)</p>
						<p class="mb-2 pl-2">1. 회사는 정보주체의 동의, 법률의 특별한 규정 등 「개인정보 보호법」제17조 및 제18조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.</p>
						<p class="title"></p>
						
						
						<p class="title">제4조(개인정보처리의 위탁)</p>
						<p class="pl-2">1. 회사는 원활한 개인정보 업무처리를 위해 다음과 같이 개인정보 처리업무를 위탁하고 있습니다.</p>
						<table class="table">
						<thead class="thead-light">
						<tr>
							<th scope="col" class="text-center">수탁업체</th>
							<th scope="col" class="text-center">위탁업무내용</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td>(주)인포뱅크, (주)KT, (주)LG U+</td>
							<td>SMS(Short Message Service) 처리와 관련된 업무</td>
						</tr>
						<tr>
							<td>NH협동기획 에스티원즈</td>
							<td>고객센터 운영, 운영관리</td>
						</tr>
						</tbody>
					</table>
						<p class="pl-2">2. 회사는 위탁계약 체결시 「개인정보 보호법」제26조에 따라 위탁업무수행 목적 외 개인정보 처리금지, 기술적·관리적 보호 조치, 재위탁 제한, 수탁자에 대한 관리·감독, 손해배상 등
    책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다.</p>
						<p class="mb-2 pl-2">3. 위탁업무의 내용이나 수탁자가 변경될 경우에는 지체 없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.</p>
						<p class="title"></p>
						
						
						<p class="title">제5조(정보주체의 권리·의무 및 행사방법)</p>
						<p class="mb-2 pl-2">1. 정보주체는 회사에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.</p>
						<p class="pl-3 mb-2">① 개인정보 열람요구<br>
						② 오류 등이 있을 경우 정정 요구<br>
						③ 삭제요구<br>
						④ 처리정지 요구</p>
						<p class="pl-2">2. 제1항에 따른 권리 행사는 회사에 대해 서면, 전화, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 회사는 이에 대해 지체 없이 조치하겠습니다.</p>
						<p class="pl-2">3. 정보주체가 개인정보의 오류 등에 대한 정정 또는 삭제를 요구한 경우에는 회사는 정정 또는 삭제를 완료 할 때까지 당해 개인정보를 이용하거나 제공하지 않습니다.</p>
						<p class="pl-2">4. 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.</p>
						<p class="pl-2">5. 정보주체는 개인정보 보호법 등 관계법령을 위반하여 회사가 처리하고 있는 정보주체 본인이나 타인의 개인정보 및 사생활을 침해하여서는 아니됩니다.</p>
						<p class="title"></p>
						
						
						<p class="title">제6조(처리하는 개인정보 항목·이용목적·수집방법)</p>
						<p class="mb-2 pl-2">1. 회사는 다음의 개인정보 항목을 처리하고 있습니다.</p>
						<p class="pl-3">① 홈페이지 회원 가입 및 관리</p>
					    <p class="pl-3">&nbsp;&nbsp;- 필수항목 : 성명, 사업자번호, 회사명, 대표자명, 회사주소, 부서명, 휴대폰번호, 이메일<br/>
						&nbsp;&nbsp;- 선택항목 : 전화번호, 팩스번호</p>
					    <p class="pl-3">② 인터넷 서비스 이용과정에서 아래 개인정보 항목이 자동으로 생성되어 수집될 수 있습니다.</p>
					    <p class="pl-3">&nbsp;&nbsp;- 서비스 이용기록, 접속 로그, 쿠키, 방문일시 등</p>
						<p class="title"></p>
						
						
						<p class="title">제7조(개인정보의 파기)</p>
						<p class="pl-2">1. 이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서식류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이때 DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.</p>
						<p class="mb-2 pl-2">2. 개인정보 파기의 절차 및 방법은 다음과 같습니다.</p>
						<p class="pl-3">① 파기절차</p>
					    <p class="pl-3">&nbsp;&nbsp;- 회사는 파기하여야 하는 개인정보(또는 개인정보파일)에 대해 개인정보 파기계획을 수립하여 파기합니다. 회사는 파기 사유가 발생한 개인정보(또는 개인정보파일)을 선정하고, 회사의 개인정보 보호책임자의승인을 받아 개인정보(또는 개인정보파일)를 파기합니다.</p>
					    <p class="pl-3">② 파기방법</p>
					    <p class="pl-3">&nbsp;&nbsp;- 회사는 전자적 파일 형태로 기록·저장된 개인정보는 기록을 재생할 수 없도록 기술적 방법을 이용하여 파기하며, 종이 문서에 기록·저장된 개인정보는 분쇄기로 분쇄하거나 소각하여 파기합니다.</p>
						<p class="title"></p>
						
						
						<p class="title">제8조(개인정보의 안전성 확보조치)</p>
						<p class="mb-2 pl-2">1. 회사는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.</p>
						<p class="pl-3">① 관리적 조치</p>
					    <p class="pl-3">&nbsp;&nbsp;- 내부관리계획의 수립 및 시행<br>
					                    &nbsp;&nbsp;&nbsp;&nbsp;개인정보 보호에 관한 내부관리계획을 수립·시행하고 있습니다.</p>
                        <p class="pl-3">&nbsp;&nbsp;- 개인정보 취급 직원의 최소화 및 교육<br>
					                    &nbsp;&nbsp;&nbsp;&nbsp;개인정보에 대한 접근권한을 필요·최소한의 인원으로 제한하고, 개인정보를 처리하는 직원을 대상으로 정기적 교육을 시행하고 있습니다.</p>					                    
					    <p class="pl-3">② 기술적 조치</p>
					    <p class="pl-3">&nbsp;&nbsp;- 해킹 등에 대비한 기술적 대책<br>
					                    &nbsp;&nbsp;&nbsp;&nbsp;회사는 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신·점검을 하며 외부로부터 접근이 통제된 구역에 시스템을 설치하고 기술적/물리적으로 감시 및 차단하고 있습니다.</p>
                        <p class="pl-3">&nbsp;&nbsp;- 개인정보의 암호화<br>
					                    &nbsp;&nbsp;&nbsp;&nbsp;이용자의 개인정보는 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는등의 별도 보안기능을 사용하고 있습니다.</p>
					    <p class="pl-3">&nbsp;&nbsp;- 접속기록의 보관 및 위변조 방지<br>
					                    &nbsp;&nbsp;&nbsp;&nbsp;개인정보처리시스템에 접속한 기록을 최소 6개월 이상 보관, 관리하고 있으며, 접속 기록이 위변조 및 도난, 분실되지 않도록 보안기능 사용하고 있습니다.</p>                
					    <p class="pl-3">&nbsp;&nbsp;- 개인정보에 대한 접근 제한<br>
					                    &nbsp;&nbsp;&nbsp;&nbsp;개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.</p>                
					    <p class="pl-3">③ 물리적 조치</p>
					    <p class="pl-3">&nbsp;&nbsp;- 문서보안을 위한 잠금장치 사용<br>
					                    &nbsp;&nbsp;&nbsp;&nbsp;개인정보가 포함된 서류, 보조저장매체 등을 잠금장치가 있는 안전한 장소에 보관하고 있습니다.</p>
                        <p class="pl-3">&nbsp;&nbsp;- 비인가자에 대한 출입 통제<br>
					                    &nbsp;&nbsp;&nbsp;&nbsp;개인정보를 보관하고 있는 물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다</p>                
						<p class="title"></p>					                    
					                    
					    <p class="title">제9조(개인정보 보호책임자)</p>
						<p class="mb-2 pl-2">1. 회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.</p>
						<p class="pl-3">① 개인정보 보호책임자</p>
					    <p class="pl-3">&nbsp;&nbsp;- 성 명 : 이원삼<br>
					                    &nbsp;&nbsp;- 직 책 : 전무이사<br>
					                    &nbsp;&nbsp;- 연락처 : 02-3497-2004(전화), 02-3497-2199(팩스)<br>
					                    &nbsp;&nbsp;- 전자우편 : nonghyupit_cpo1@nonghyup.com </p>
					    <p class="pl-3">② 개인정보 보호 담당부서</p>
					    <p class="pl-3">&nbsp;&nbsp;- 부서명 : 정보보안전략팀<br>
					                    &nbsp;&nbsp;- 연락처 : 02-3497-2004(전화), 02-3497-2197(팩스)<br>
					                    &nbsp;&nbsp;- 전자우편 : nonghyupit_cpo2@nonghyup.com</p><br>
					   	<p class="mb-2 pl-2">2. 정보주체께서는 회사의 서비스(또는 사업)를 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 회사는 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.</p>
						<p class="pl-3">① (민원처리) 개인정보 열람청구 접수·처리 부서</p>
					    <p class="pl-3">&nbsp;&nbsp;- 부서명 : 컴플라이언스팀<br>
					                    &nbsp;&nbsp;- 연락처 : 02-3497-2004(전화), 02-3497-2199(팩스)</p>                 
						<p class="title"></p>
						
						<p class="title">제10조(개인정보 열람청구)</p>
						<p class="mb-2 pl-2">1. 정보주체는 개인정보 보호법 제35조에 따른 개인정보의 열람 청구를 아래의 부서에 할 수 있습니다. 회사는 정보주체의 개인정보 열람청구가 신속하게 처리되도록 노력하겠습니다.</p>
						<p class="pl-3">① (민원처리) 개인정보 열람청구 접수·처리 부서</p>
					    <p class="pl-3">&nbsp;&nbsp;- 부서명 : 준법지원팀<br>
					                    &nbsp;&nbsp;- 담당자 : 민원처리 담당 책임자<br>
					                    &nbsp;&nbsp;- 연락처 : 02-3497-2931(전화), 02-3497-2197(팩스)</p><br>
					   	<p class="mb-2 pl-2">2. 정보주체께서는 제1항의 열람청구 접수.처리부서 이외에, 행정안전부의 ‘개인정보보호 종합지원 포털’ 웹사이트(www.privacy.go.kr)를 통하여서도 개인정보 열람청구를 하실 수 있습니다.</p>
						<p class="pl-3">▶ 행정안전부 개인정보보호 종합지원 포털→개인정보 민원→개인정보 열람등 요구 (공공아이핀을 통한 실명인증 필요)</p>
						<p class="title"></p>
						
						
						<p class="title">제11조(권익침해 구제방법)</p>
						<p class="mb-2 pl-2">1. 정보주체는 아래의 기관에 대해 개인정보 침해에 대한 피해구제, 상담 등을 문의하실 수 있습니다.<br>
						[ 아래의 기관은 회사와는 별개의 기관으로서, 회사의 자체적인 개인정보 불만처리, 피해구제 결과에 만족하지 못하시거나 보다 자세한 도움이 필요하시면 문의하여 주시기 바랍니다. ]</p>
						<p class="pl-3">① 개인정보 침해신고센터 (한국인터넷진흥원 운영)</p>
					    <p class="pl-3">&nbsp;&nbsp;- 소관업무 : 개인정보 침해사실 신고, 상담 신청<br>
					                    &nbsp;&nbsp;- 홈페이지 : privacy.kisa.or.kr<br>
					                    &nbsp;&nbsp;- 전화 : (국번없이) 118<br>
					                    &nbsp;&nbsp;- 주소 : (05717) 서울특별시 송파구 중대로 135(가락동 78) IT벤처타워</p>
					    <p class="pl-3">② 개인정보 분쟁조정위원회 (한국인터넷진흥원 운영)</p>
					    <p class="pl-3">&nbsp;&nbsp;- 소관업무 : 개인정보 분쟁조정신청, 집단분쟁조정 (민사적 해결)<br>
					                    &nbsp;&nbsp;- 홈페이지 : www.kopico.go.kr<br>
					                    &nbsp;&nbsp;- 전화 : (국번없이) 118<br>
					                    &nbsp;&nbsp;- 주소 : (03171) 서울특별시 종로구 세종대로 209 정부서울청사 4층</p>
					    <p class="pl-3">③ 대검찰청 사이버범죄수사단 : (국번없이)1301 (cybercid.spo.go.kr)</p>
					    <p class="pl-3">④ 경찰청 사이버안전국 : (국번없이)182(cyberbureau.police.go.kr)</p>
						<p class="title"></p>
						
						<p class="title">제12조(영상정보처리기기 설치·운영)</p>
						<p class="mb-2 pl-2">회사는 아래와 같이 영상정보처리기기를 설치·운영하고 있습니다.</p>
						<p class="pl-3">① 영상정보처리기기 설치근거·목적 : 회사의 시설 보안, 안전·화재예방</p>
						<p class="pl-3">② 설치 대수, 설치 위치, 촬영 범위</p>
					    <p class="pl-3">&nbsp;&nbsp;- 설치대수 : 본사 8대, 의왕 6대, 여의도 48대<br>
					                    &nbsp;&nbsp;- 설치위치 및 촬영범위 : 사무실, 통신실, 운영실 등 주여 시설의 출입구 및 비상구</p>
					    <p class="pl-3">③ 관리책임자, 담당부서 및 영상정보에 대한 접근권한자</p>
					    <p class="pl-3">&nbsp;&nbsp;- 관리책임자 : 정보보안팀 팀장<br>
					                    &nbsp;&nbsp;- 담당부서 : 정보보안팀<br>
					                    &nbsp;&nbsp;- 접근권한자 : 정보보안팀 팀원</p>
                        <p class="pl-3">④ 영상정보 촬영시간, 보관기간, 보관장소, 처리방법</p>					                    
					    <p class="pl-3">&nbsp;&nbsp;- 촬영시간 : 24시간 촬영<br>
					                    &nbsp;&nbsp;- 보관기간 : 촬영시부터 60일<br>
					                    &nbsp;&nbsp;- 보관장소 : 통신실<br>
					                    &nbsp;&nbsp;- 처리방법 : 개인영상정보의 목적 외 이용, 제3자 제공, 열람 등 요구, 파기에 관한 사항을 기록ㆍ관리하고, 보관기간 만료시 복원이 불가능한 방법으로 영구 삭제(출력물의경우 파쇄 또는소각)</p>                
					    <p class="pl-3">⑤ 영상정보 확인 방법 및 장소 : 관리책임자에 요구(정보보안팀)</p>
					    <p class="pl-3">⑥ 정보주체의 영상정보 열람 등 요구에 대한 조치 : 개인영상정보 열람·존재확인 청구서로 신청하여야 하며, 정보주체자신이 촬영된 경우 또는 명백히 정보주체의 생명·신체·재산 이익을 위해필요한 경우에 한해 열람을 허용함</p>
					    <p class="pl-3">⑦ 영상정보 보호를 위한 기술적·관리적·물리적 조치 : 내부관리계획 수립, 접근통제 및 접근권한 제한, 영상정보의 안전한저장·전송 기술 적용, 처리기록 보관 및 위·변조 방지조치, 보관시설마련 및 잠금장치 설치 등</p>
					    <p class="pl-3">&nbsp;&nbsp;- 소관업무 : 개인정보 침해사실 신고, 상담 신청<br>
					                    &nbsp;&nbsp;- 홈페이지 : privacy.kisa.or.kr<br>
					                    &nbsp;&nbsp;- 전화 : (국번없이) 118<br>
					                    &nbsp;&nbsp;- 주소 : (05717) 서울특별시 송파구 중대로 135(가락동 78) IT벤처타워</p>                
					    <p class="pl-3">② 개인정보 분쟁조정위원회 (한국인터넷진흥원 운영)</p>
					    <p class="pl-3">&nbsp;&nbsp;- 소관업무 : 개인정보 분쟁조정신청, 집단분쟁조정 (민사적 해결)<br>
					                    &nbsp;&nbsp;- 홈페이지 : www.kopico.go.kr<br>
					                    &nbsp;&nbsp;- 전화 : (국번없이) 118<br>
					                    &nbsp;&nbsp;- 주소 : (03171) 서울특별시 종로구 세종대로 209 정부서울청사 4층</p>
					    <p class="pl-3">③ 대검찰청 사이버범죄수사단 : (국번없이)1301 (cybercid.spo.go.kr)</p>
					    <p class="pl-3">④ 경찰청 사이버안전국 : (국번없이)182(cyberbureau.police.go.kr)</p>
						<p class="title"></p>
					</div>
					<div class="pl-3">
						<div class="custom-control custom-checkbox custom-checkbox-sm mb-3">
							<input type="checkbox" class="custom-control-input" id="agreement2">
							<label class="custom-control-label font-weight-bold" for="agreement2">상기 이용약관에 동의함</label>
						</div>
					</div>
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
