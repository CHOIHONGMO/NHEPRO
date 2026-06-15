<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer>
	<div class="box">
		<div class="row no-gutters">
			<div class="offset-3 col-9">
				<ul class="c-intro clearfix">
					<li><a id="agree_03" href="javascript:window.open('https://www.nonghyupit.com'); void(0);">회사소개</a></li>
					<li><a id="agree_02" href="/session/viewContents/view.so?realUrl=/mainHtml/01_agreement/agreement_02.jsp">서비스이용약관</a></li>
					<li><span class="font-weight-bold"><a id="agree_01" href="/session/viewContents/view.so?realUrl=/mainHtml/01_agreement/agreement_01.jsp">개인정보처리방침</a></span></li>
				</ul>
			</div>
		</div>
	</div>
	<div class="bg">
		<div class="box">
			<div class="row no-gutters">
				<div class="col-3">
					<div class="img">
						<img src="/images/nhepro/common/logo_footer.png" alt="농협정보시스템">
					</div>
				</div>
				<div class="col-9">
					<ul class="c-info">
						<li>
							<span class="bar">상호 : (주)농협정보시스템</span>
							<span class="bar">대표이사 : 이용노</span>
							<span>사업자등록번호 : 120-87-01755</span>
						</li>
						<li>
							<span class="bar font-weight-bold">대표전화 : <a href="tel:031-738-8157">031-738-8157</a></span>
							<span class="bar font-weight-bold">팩스 : <a href="tel:031-738-8199">031-738-8199</a></span>
							<span class="font-weight-bold">대표이메일 : <a href="mailto:first-epro@nonghyup.com/">first-epro@nonghyup.com</a></span>
						</li>
						<li>
							<span>주소 : 서울특별시 서초구 매헌로 24 농협양재전산센터</span>
						</li>
						<li>
							<span>COPYRIGHTⓒ 2020 NH INFORMATION SYSTEM CO.,LTD ALL RIGHTS RESERVED.</span>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</footer>
<script>
	$("#agree_" + "${param.agreementType}").addClass("font-weight-bold");
</script>