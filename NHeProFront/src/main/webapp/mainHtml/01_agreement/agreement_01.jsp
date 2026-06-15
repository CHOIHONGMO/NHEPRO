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
	<script>
        $(document).ready(function () {
        	doSearch();
        });
		
     	// 2021.06.08 추가
		// 개인정보처리방침 STOCNOTC의 공지번호 "NT202099999" 가져와서 보여주기
        function doSearch() {
        	var param = {
                    'NOTICE_NUM': 'NT202099999'
                };
        	
            $.post("/nhepro/serviceGuide.so", param, function (data) {
                $('#contents').html(data.TEXT_CONTENTS);
            }, "json");
		}
    </script>
</head>

<body>
<div class="wrap">
	<!--header_wrap-->
	<c:import url="../header/header.jsp" charEncoding="UTF-8"/>
	<!--// header_wrap-->

	<section class="personal sign_in">
		<h2 class="sr-only">개인정보처리방침</h2>
		<div class="title">
			<p>개인정보처리방침</p>
		</div>
		<div class="box">
			<div class="border-top"></div>
			<div class="content">
				<div class="contents_area" id="contents"></div>
				
				<!--
				<p class="mb-4">㈜농협정보시스템(이하 ‘회사’)은 FIRSTePro를 운영함에 있어 개인정보 보호법 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고
					원활하게 처리할 수 있도록<br/>
					하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다. 다만 회사가 사업 등의 목적을 위하여 별도의 홈페이지를 운영할 경우 사업 등 관련 개인정보 처리방침은 해당
					홈페이지<br/>
					에 공개하며 해당 방침을 우선적으로 적용함을 알려드립니다.</p>
				<div class="p-box clearfix">
					<div class="p-index float-left">
						<ul>
							<li><a href="">1. 개인정보의 처리목적</a></li>
							<li><a href="">2. 개인정보의 처리 및 보유기간</a></li>
							<li><a href="">3. 개인정보의 제3자 제공</a></li>
							<li><a href="">4. 개인정보처리의 위탁</a></li>
							<li><a href="">5. 정보주체의 권리.의무 및 행사방법</a></li>
							<li><a href="">6. 처리하는 개인정보 항목.이용목적.수집방법</a></li>
							<li><a href="">7. 개인정보의 파기</a></li>
						</ul>
					</div>
					<div class="p-index float-left">
						<ul>
							<li><a href="">8. 개인정보의 안정성 확보조치</a></li>
							<li><a href="">9. 개인정보 보호책임자</a></li>
							<li><a href="">10. 개인정보 열람청구</a></li>
							<li><a href="">11. 권익침해 구제방법</a></li>
							<li><a href="">12. 영상정보처리기긱 설치.운영</a></li>
						</ul>
					</div>
				</div>
				<div class="p-content">
					<p class="title">제1조(개인정보의 처리목적)</p>
					<p class="mb-2">이 방침은 ㈜농협정보시스템이 운영하는 FIRSTePro 서비스를 이용하는 이용자의 개인정보 처리방침을 규정함을 목적으로 합니다. 회사는 다음의 목적을
						위하여 개인정보를 처리합니다.
						처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 개인정보 보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를
						이행 할 예정입니다.</p>
					<p class="font-weight pl-2">① 홈페이지 회원 가입 및 관리</p>
					<p class="pl-3 mb-2">- 회원제 서비스 이용 및 제한적 본인 확인에 따른 본인확인, 부정이용방지 및 비인가 사용 방지, 가입 의사 확인, 불만 처리 등 민원 처리, 고지사항 전달</p>
					<p class="font-weight pl-2">② 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산</p>
					<p class="pl-3">- 콘텐츠 제공, 서비스 이용 시 필요한 정보전달 및 요금정산</p>
				</div>
				<div class="p-content">
					<p class="title">제2조(개인정보의 처리 및 보유기간)</p>
					<p class="mb-2">1. 회사는 법령에 따른개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.<br/>
						2. 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.</p>
					<p class="font-weight pl-2">① 본인확인에 관한 기록 : 6개월(정보통신망 이용촉진 및 정보보호 등에 관한 법률)</p>
					<p class="font-weight pl-2">② 계약 또는 청약철회 등에 관한 기록 : 5년(전자상거래 등에서의 소비자보호에 관한 법률)</p>
					<p class="font-weight pl-2">③ 대금결제 및 재화 등의 공급에 관한 기록 : 5년(전자상거래 등에서의 소비자보호에 관한 법률)</p>
					<p class="font-weight pl-2">④ 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년(전자상거래 등에서의 소비자보호에 관한 법률)</p>
				</div>
				<div class="p-content">
					<p class="title">제3조(개인정보의 제3자 제공)</p>
					<p>1. 회사는 정보주체의 동의, 법률의 특별한 규정 등 「개인정보 보호법」제17조 및 제18조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.</p>
				</div>
				<div class="p-content">
					<p class="title">제4조(개인정보처리의 위탁)</p>
					<p class="mb-1">1. 회사는 원활한 개인정보 업무처리를 위해 다음과 같이 개인정보 처리업무를 위탁하고 있습니다. </p>
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
							<td>(주)에스티원즈</td>
							<td>시스템 유지보수</td>
						</tr>
						</tbody>
					</table>
					<p>2. 회사는 위탁계약 체결시 「개인정보 보호법」제26조에 따라 위탁업무수행 목적 외 개인정보 처리금지, 기술적·관리적 보호 조치, 재위탁 제한, 수탁자에 대한 관리·감독, 손해배상 등<br/>
						&nbsp;&nbsp;&nbsp;&nbsp;책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다.<br/>
						3. 위탁업무의 내용이나 수탁자가 변경될 경우에는 지체 없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.</p>
				</div>
				<div class="p-content">
					<p class="title">제5조(정보주체의 권리·의무 및 행사방법)</p>
					<p class="mb-2"> 1. 정보주체는 회사에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.</p>
					<p class="mb-2 pl-3 font-weight">① 개인정보 열람요구<br/>
						② 오류 등이 있을 경우 정정 요구<br/>
						③ 삭제요구<br/>
						④ 처리정지 요구</p>
					<p>2. 제1항에 따른 권리 행사는 회사에 대해 서면, 전화, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 	회사는 이에 대해 지체 없이 조치하겠습니다.<br/>
						3. 정보주체가 개인정보의 오류 등에 대한 정정 또는 삭제를 요구한 경우에는 회사는 정정 또는 삭제를 완료 할 때까지 당해 개인정보를 이용하거나 제공하지 않습니다.<br/>
						4. 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제11호 서식에 따른 위임장을<br/>&nbsp;&nbsp;&nbsp;&nbsp;제출하셔야 합니다.<br/>
						5. 정보주체는 개인정보 보호법 등 관계법령을 위반하여 회사가 처리하고 있는 정보주체 본인이나 타인의 개인정보 및 사생활을 침해하여서는 아니됩니다.</p>
				</div>
				<div class="p-content">
					<p class="title">제6조(처리하는 개인정보 항목·이용목적·수집방법)</p>
					<p class="mb-1"> 1. 회사는 다음의 개인정보 항목을 처리하고 있습니다.</p>
					<p class="ml-2 font-weight">① 홈페이지 회원 가입 및 관리</p>
					<p class="pl-3">- 필수항목 : 성명, 사업자번호, 회사명, 대표자명, 회사주소, 부서명, 휴대폰번호, 이메일<br/>
						- 선택항목 : 실명번호, 전화번호, 팩스번호</p>
					<p class="pl-2 font-weight">② 인터넷 서비스 이용과정에서 아래 개인정보 항목이 자동으로 생성되어 수집될 수 있습니다.</p>
					<p class="pl-3">- 서비스 이용기록, 접속 로그, 쿠키, 방문일시 등</p>
				</div>
				<div class="p-content">
					<p class="title">제7조(개인정보의 파기)</p>
					<p>1. 이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서식류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다.
						이때 DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.</p>
					<p class="mb-2">2. 개인정보 파기의 절차 및 방법은 다음과 같습니다.</p>
					<p class="pl-2 font-weight">① 파기절차</p>
					<p class="pl-3">- 회사는 파기하여야 하는 개인정보(또는 개인정보파일)에 대해 개인정보 파기계획을 수립하여 파기합니다. 회사는 파기 사유가 발생한 개인정보(또는 개인정보파일)을 선정하고, 회사의 개인정보 보호책임자의
						승인을 받아 개인정보(또는 개인정보파일)를 파기합니다.</p>
					<p class="pl-2 font-weight">② 파기방법</p>
					<p class="pl-3">- 회사는 전자적 파일 형태로 기록·저장된 개인정보는 기록을 재생할 수 없도록 기술적 방법을 이용하여 파기하며, 종이 문서에 기록·저장된 개인정보는 분쇄기로 분쇄하거나 소각하여 파기합니다.</p>
				</div>
				<div class="p-content">
					<p class="title">제8조(개인정보의 안전성 확보조치)</p>
					<p class="mb-2">1. 회사는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.</p>
					<p class="pl-2 font-weight">① 관리적 조치</p>
					<p class="pl-3">- 내부관리계획의 수립 및 시행<br/>
						개인정보 보호에 관한 내부관리계획을 수립·시행하고 있습니다.<br/>
						- 개인정보 취급 직원의 최소화 및 교육<br/>
						개인정보에 대한 접근권한을 필요·최소한의 인원으로 제한하고, 개인정보를 처리하는 직원을 대상으로 정기적 교육을 시행하고 있습니다.</p>
					<p class="pl-2 font-weight">② 기술적 조치</p>
					<p class="pl-3">- 해킹 등에 대비한 기술적 대책<br/>
						회사는 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신·점검을 하며 외부로부터 접근이 통제된 구역에 시스템을 설치하고 기술적/물리적으로 감시 및 차단하고 있습니다.<br/>
						- 개인정보의 암호화<br/>
						이용자의 개인정보는 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는등의 별도 보안기능을 사용하고 있습니다.<br/>
						- 접속기록의 보관 및 위변조 방지<br/>
						개인정보처리시스템에 접속한 기록을 최소 6개월 이상 보관, 관리하고 있으며, 접속 기록이 위변조 및 도난, 분실되지 않도록 보안기능 사용하고 있습니다.<br/>
						- 개인정보에 대한 접근 제한<br/>
						개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.</p>
					<p class="pl-2 font-weight">③ 물리적 조치</p>
					<p class="pl-3">- 문서보안을 위한 잠금장치 사용<br/>
						개인정보가 포함된 서류, 보조저장매체 등을 잠금장치가 있는 안전한 장소에 보관하고 있습니다.<br/>
						- 비인가자에 대한 출입 통제<br/>
						개인정보를 보관하고 있는 물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다</p>
				</div>
				<div class="p-content">
					<p class="title">제9조(개인정보 보호책임자)</p>
					<p class="mb-2"> 1. 회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리
						및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.</p>
					<p class="pl-2 font-weight">① 개인정보 보호책임자</p>
					<p class="pl-3">- 성 명 : 이원삼<br/>
						- 직 책 : 전무이사<br/>
						- 연락처 : 02-3497-2004(전화), 02-3497-2199(팩스)<br/>
						- 전자우편 : nonghyupit_cpo1@nonghyup.com
					</p>
					<p class="pl-2 font-weight">② 개인정보보호 담당부서</p>
					<p class="pl-3 mb-3">- 부서명 : 정보보안전략팀<br/>
						- 연락처 : 02-3497-2004(전화), 02-3497-2197(팩스)<br/>
						- 전자우편 : nonghyupit_cpo2@nonghyup.com</p>
					<p class="mb-2">2. 정보주체께서는 회사의 서비스(또는 사업)를 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 회사는 정보주
						체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.</p>

					<p class="pl-2 font-weight">① (민원처리) 개인정보 열람청구 접수·처리 부서</p>
					<p class="pl-3">- 부서명 : 컴플라이언스팀<br/>
						- 연락처 : 02-3497-2004(전화), 02-3497-2199(팩스)</p>
				</div>
				<div class="p-content">
					<p class="title">제10조(개인정보 열람청구)</p>
					<p class="mb-2"> 1. 정보주체는 개인정보 보호법 제35조에 따른 개인정보의 열람 청구를 아래의 부서에 할 수 있습니다. 회사는 정보주체의 개인정보 열람청구가 신속하게 처리되도록 노력하겠습니다.</p>
					<p class="pl-2 font-weight">① (민원처리) 개인정보 열람청구 접수·처리 부서</p>
					<p class="pl-3 mb-2">- 부서명 : 준법지원팀<br/>
						- 담당자 : 민원처리 담당 책임자<br/>
						- 연락처 : 02-3497-2931(전화), 02-3497-2197(팩스)</p>
				</div>
				<div class="p-content">
					<p class="title">제11조(권익침해 구제방법)</p>
					<p class="mb-2">1. 정보주체는 아래의 기관에 대해 개인정보 침해에 대한 피해구제, 상담 등을 문의하실 수 있습니다.<br/>
						< 아래의 기관은 회사와는 별개의 기관으로서, 회사의 자체적인 개인정보 불만처리, 피해구제 결과에 만족하지 못하시거나 보다 자세한 도움이 필요하시면 문의하여 주시기 바랍니다. ></p>
					<p class="pl-2 font-weight">① 개인정보 침해신고센터 (한국인터넷진흥원 운영)</p>
					<p class="pl-3">- 소관업무 : 개인정보 침해사실 신고, 상담 신청<br/>
						- 홈페이지 : privacy.kisa.or.kr<br/>
						- 전화 : (국번없이) 118<br/>
						- 주소 : (58342) 전남 나주시 진흥길 9(빛가람동) 한국인터넷진흥원 개인정보침해 신고센터</p>
					<p class="pl-2 font-weight">② 개인정보 분쟁조정위원회 (한국인터넷진흥원 운영)</p>
					<p class="pl-3">- 소관업무 : 개인정보 분쟁조정신청, 집단분쟁조정 (민사적 해결)<br/>
						- 홈페이지 : www.kopico.go.kr<br/>
						- 전화 : (국번없이) 118<br/>
						- 주소 : (03171) 서울특별시 종로구 세종대로 209 정부서울청사 4층</p>
					<p class="pl-2 font-weight">③ 대검찰청 사이버범죄수사단 : (국번없이)1301 (cybercid.spo.go.kr)</p>
					<p class="pl-2 font-weight">④ 경찰청 사이버안전국 : (국번없이)182(cyberbureau.police.go.kr)</p>
				</div>
				<div class="p-content">
					<p class="title">제12조(영상정보처리기기 설치·운영)</p>
					<p class="mb-2">회사는 아래와 같이 영상정보처리기기를 설치·운영하고 있습니다.</p>
					<p class="pl-2 font-weight">① 영상정보처리기기 설치근거·목적 : 회사의 시설 보안, 안전·화재예방</p>
					<p class="pl-2 font-weight">② 설치 대수, 설치 위치, 촬영 범위</p>
					<p class="pl-3">- 설치대수 : 본사 8대, 의왕 6대, 여의도 48대<br/>
						- 설치위치 및 촬영범위 : 사무실, 통신실, 운영실 등 주여 시설의 출입구 및 비상구</p>
					<p class="pl-2 font-weight">③ 관리책임자, 담당부서 및 영상정보에 대한 접근권한자</p>
					<p class="pl-3">- 관리책임자 : 정보보안팀 팀장<br/>
						- 담당부서 : 정보보안팀<br/>
						- 접근권한자 : 정보보안팀 팀원</p>
					<p class="pl-2 font-weight">④ 영상정보 촬영시간, 보관기간, 보관장소, 처리방법</p>
					<p class="pl-3">- 촬영시간 : 24시간 촬영<br/>
						- 보관기간 : 촬영시부터 60일<br/>
						- 보관장소 : 통신실<br/>
						- 처리방법 : 개인영상정보의 목적 외 이용, 제3자 제공, 열람 등 요구, 파기에 관한 사항을 기록ㆍ관리하고, 보관기간 만료시 복원이 불가능한 방법으로 영구 삭제(출력물의
						경우 파쇄 또는
						소각)</p>
					<p class="pl-2 font-weight">⑤ 영상정보 확인 방법 및 장소 : 관리책임자에 요구(정보보안팀)</p>
					<p class="pl-2 font-weight">⑥ 정보주체의 영상정보 열람 등 요구에 대한 조치 : 개인영상정보 열람·존재확인 청구서로 신청하여야 하며, 정보주체
						자신이 촬영된 경우 또는 명백히 정보주체의 생명·신체·재산 이익을 위해
						필요한 경우에 한해 열람을 허용함</p>
					<p class="pl-2 font-weight">⑦ 영상정보 보호를 위한 기술적·관리적·물리적 조치 : 내부관리계획 수립, 접근통제 및 접근권한 제한, 영상정보의 안전한
						저장·전송 기술 적용, 처리기록 보관 및 위·변조 방지조치, 보관시설
						마련 및 잠금장치 설치 등</p>
					<p class="pl-3">- 소관업무 : 개인정보 침해사실 신고, 상담 신청<br/>
						- 홈페이지 : privacy.kisa.or.kr<br/>
						- 전화 : (국번없이) 118<br/>
						- 주소 : (05717) 서울특별시 송파구 중대로 135(가락동 78) IT벤처타워</p>
					<p class="pl-2 font-weight">② 개인정보 분쟁조정위원회 (한국인터넷진흥원 운영)</p>
					<p class="pl-3">- 소관업무 : 개인정보 분쟁조정신청, 집단분쟁조정 (민사적 해결)<br/>
						- 홈페이지 : www.kopico.go.kr<br/>
						- 전화 : (국번없이) 118<br/>
						- 주소 : (03171) 서울특별시 종로구 세종대로 209 정부서울청사 4층</p>
					<p class="pl-2 font-weight">③ 대검찰청 사이버범죄수사단 : (국번없이)1301 (cybercid.spo.go.kr)</p>
					<p class="pl-2 font-weight">④ 경찰청 사이버안전국 : (국번없이)182(cyberbureau.police.go.kr)</p>
				</div>
				-->
			</div>
			<div class="border-bottom"></div>
		</div>
	</section>
  	<!--footer_wrap-->
	<c:import url="../footer/footer.jsp" charEncoding="UTF-8">
		<c:param name="agreementType" value="01" />
	</c:import>
  	<!--// footer_wrap-->
</div>
</body>
</html>
