<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
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

	<script type="text/javascript" src="/js/nhepro/bundle.js"></script>
	<script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
	<script type="text/javascript" src="/js/jquery.serializeObject.js"></script>
	<script type="text/javascript" src="/js/everuxf/lic/licenseKey.js"></script>
	<script type="text/javascript" src="/js/ever-popup.js"></script>
	<script type="text/javascript" src="/js/ever-string.js"></script>
	<script type="text/javascript" src="/js/ever-formutils.js"></script>
	<script>
		var changeIdFlag = true;
		var baseUrl = "/nhepro/REGISTER/";

		function userIdCheck() {
			if($('#USER_ID').val() == '') {
				$('#USER_ID').focus();
				return alert("사용자ID를 입력하여 주시기 바랍니다.");
			}

			var url = baseUrl + "userIdCheck.so";
			var param = {
				USER_ID: $('#USER_ID').val()
			};
			$.post(url, param, function(data) {
				if(data.responseCode == 'fail') {
					alert("이미 등록된 사용자 ID 입니다.");
					$('#USER_ID').val('');
					$('#USER_ID').focus();

					changeIdFlag = true;
				} else {
					alert("사용하실 수 있는 ID 입니다.");

					changeIdFlag = false;
				}

				return;
			}, "json" );
		}

		function doSave() {
			// validation 체크
			var returnFlag = false;
			$('input').closest('.row').find('.fa-check').each(function(k, v) {
				if($(v).closest('.row').find('input').val() == '') {
					var name = $(v).closest('.row').find('input').prop('name');
					formUtil.animate(name, 'form');
					returnFlag = true;
				}
			});

			$('select').closest('.row').find('.fa-check').each(function(k, v) {
				if($(v).closest('.row').find('select').val() == '') {
					var name = $(v).closest('.row').find('select').prop('name');
					formUtil.animate(name, 'form');
					returnFlag = true;
				}
			});

			if(returnFlag) {
				return alert("필수 값을 입력하여 주시기 바랍니다.");
			}

			if(changeIdFlag) {
				return alert("사용자 ID 중복체크를 하여 주시기 바랍니다.");
			}

			if(confirm("가입등록 하시겠습니까?")) {
				// 데이터 저장
				$.post(baseUrl + 'doSave.so', {json: JSON.stringify($('#form').serializeObject())}, function(data) {
					if(data.responseCode == 'success') {
						// alert("회원가입이 완료되었습니다.");

						var url = "/mainHtml/02_sigin_in/sigin_in_03.jsp";
						everPopup.openWindowPopup(url, 700, 600, null, '_self', true);
					}
				}, "json" );
			}
		}

		function doHome() {
			if(confirm("가입취소 하시겠습니까?")) {
				location.href = "/welcome.so";
			}
		}
		
		//2021.03.17 비밀번호 입력시 '%' 특수문자 입력 불가하도록 체크 추가
		function checkCall() {
			
			var pass = everString.getCheckPassWord($("#PPDD").val());
			if (!pass.success) {
		        alert(pass.msg);

		        $("#PPDD").val("");
		        $("#PPDD_CHECK").val("");
		        $("#PPDD").focus();
	        }
			
			var map = everString.getChkPwd($("#PPDD").val());
			if (!map.success) {
				alert(map.msg);

				$("#PPDD").val("");
				$("#PPDD_CHECK").val("");
				$("#PPDD").focus();
			}
		}

		function ppddCheck() {
			if($("#PPDD").val() != $("#PPDD_CHECK").val()) {
				$("#PPDD").val("");
				$("#PPDD_CHECK").val("");
				$("#PPDD").focus();

				return alert("비밀번호가 일치하지 않습니다.");
			}
		}

		function validCheck(element, type) {
			var check = false;
			if(type == "E") {
				if(!everString.isValidEmail($("#"+element.id).val())) {
					check = true;
					clearValidCheck(element);
					return alert("이메일 형식이 일치하지 않습니다.");
				}
			} else {
				if(!everString.isTel($("#"+element.id).val())) {
					clearValidCheck(element);
					if(type == "C") {
						return alert("형식이 일치하지 않습니다. ex)010-0000-0000");
					} else {
						return alert("형식이 일치하지 않습니다. ex)02-0000-0000");
					}
				}
			}
		}

		function clearValidCheck(element) {
			$("#"+element.id).val("");
			$("#"+element.id).focus();
		}
	</script>
</head>

<body>
<div class="wrap">
	<c:import url="/mainHtml/header/header.jsp" charEncoding="UTF-8"/>
	<section class="personal sign_in">
		<h2 class="sr-only">회원가입</h2>
		<div class="title">
			<p>회원가입</p>
		</div>
		<div class="box">
			<div class="content">
				<div class="clearfix pb-3">
					<ul class="step">
						<li class="active">STEP 1. 약관동의</li>
						<li class="current">STEP 2. 정보입력</li>
						<li>STEP 3. 가입완료</li>
					</ul>
				</div>
				<div class="p-content">
					<p class="p-title">사용자 등록</p>
					<form>
						<div class="row">
							<p class="title"><i class="fas fa-dot-circle"></i>회원사 정보</p>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>회사명(국문)</span>
									</div>
									<div class="col-desc">
										<span class="text">${form.COMPANY_NM}</span>
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>사업자등록번호</span>
									</div>
									<div class="col-desc">
										<span class="text">${form.IRS_NUM}</span>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>대표자명</span>
									</div>
									<div class="col-desc">
										<span class="text">${form.CEO_USER_NM}</span>
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>설립일자</span>
									</div>
									<div class="col-desc">
										<span class="text">${form.FOUNDATION_DATE}</span>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-12">
								<div class="row">
									<div class="col-title">
										<span>주소</span>
									</div>
									<div class="col-desc">
										<span class="text">${form.ADDR}</span>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>업태</span>
									</div>
									<div class="col-desc">
										<span class="text">${form.BUSINESS_TYPE}</span>
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>종목</span>
									</div>
									<div class="col-desc">
										<span class="text">${form.INDUSTRY_TYPE}</span>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="p-content">
					<form id="form" name="form">
						<div class="row">
							<p class="title"><i class="fas fa-dot-circle"></i>관리자 정보</p>
						</div>
						<input type="hidden" id="CASE" name="CASE" value="3">
						<input type="hidden" id="COMPANY_CD" name="COMPANY_CD" value="${form.COMPANY_CD}">
						<input type="hidden" id="USER_TYPE" name="USER_TYPE" value="${form.USER_TYPE}">
						<input type="hidden" id="IRS_NUM" name="IRS_NUM" value="${form.IRS_NUM}">
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>사용자 ID<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="USER_ID" name="USER_ID" class="form-control d-inline-block" title="example" placeholder="" style="width: 278px">
										<a class="btn btn-outline-secondary d-inline-block" onclick="userIdCheck();">중복체크</a>
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>사용자명<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="USER_NM" name="USER_NM" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>비밀번호<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="password" id="PPDD" name="PPDD" class="form-control" title="example" placeholder="" onchange="checkCall();" autocomplete=off>
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>비밀번호확인<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="password" id="PPDD_CHECK" name="PPDD_CHECK" class="form-control" title="example" placeholder="" onchange="ppddCheck();" autocomplete=off>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>전화번호<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="tel" id="TEL_NUM" name="TEL_NUM" class="form-control" title="example" placeholder="EX) 000-000-0000" onchange="validCheck(this, 'T');">
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>e-Mail<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="email" id="USER_EMAIL" name="USER_EMAIL" class="form-control" title="example" placeholder="Email 형식에 맞게 입력해 주세요." onchange="validCheck(this, 'E');">
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>팩스번호</span>
									</div>
									<div class="col-desc">
										<input type="tel" id="FAX_NUM" name="FAX_NUM" class="form-control" title="example" placeholder="EX) 000-000-0000" onchange="validCheck(this, 'F');">
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>휴대전화<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="tel" id="CELL_NUM" name="CELL_NUM" class="form-control" title="example" placeholder="EX) 000-000-0000" onchange="validCheck(this, 'C');">
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>메일수신여부<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<select class="custom-select" title="Text" id="MAIL_FLAG" name="MAIL_FLAG">
											<option value=""></option>
											<option value="1">Y</option>
											<option value="0">N</option>
										</select>
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>SMS 수신여부<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<select class="custom-select" title="Text" id="SMS_FLAG" name="SMS_FLAG">
											<option value=""></option>
											<option value="1">Y</option>
											<option value="0">N</option>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>직위(직급)</span>
									</div>
									<div class="col-desc">
										<input type="text" id="POSITION_NM" name="POSITION_NM" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>직책</span>
									</div>
									<div class="col-desc">
										<input type="text" id="DUTY_NM" name="DUTY_NM" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-12">
								<div class="row">
									<div class="col-title">
										<span>담당업무</span>
									</div>
									<div class="col-desc">
										<input type="text" id="ROLE_TEXT" name="ROLE_TEXT" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="p-content">
					<div class="btn-area">
						<button class="btn btn-xl btn-primary mr-3" onclick="doSave();">가입등록</button>
						<button class="btn btn-xl btn-primary" onclick="doHome();">가입취소</button>
					</div>
				</div>
			</div>
		</div>
	</section>
	<c:import url="/mainHtml/footer/footer.jsp" charEncoding="UTF-8"/>
</div>
</body>
</html>
