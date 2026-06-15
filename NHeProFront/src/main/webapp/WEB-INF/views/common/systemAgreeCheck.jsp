<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<link rel="stylesheet" href="/css/nhepro/fonts/NanumGothic.css">
    <link rel="stylesheet" href="/css/nhepro/bootstrap.min.css">
    
    <script type="text/javascript" src="/js/nhepro/bundle.js"></script>
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>

	<!-- 공인인증서 통한 전자서명 처리하기 -->
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>

    <script type="text/javascript">
   		var baseUrl = "/eversrm/";
   		var localServerFlag = "${localServerFlag}";
   		
        function init() {
            var editor = EVF.C("NOTICE_CONTENTS").getInstance();
            editor.config.contentsCss  = "/css/richText.css";
            editor.config.allowedContent = true;
        }
		
        function doConfirm() {
        	
        	var noticeNum = EVF.V("NOTICE_NUM");
        	var noticeTextNum = EVF.V("NOTICE_TEXT_NUM");
        	if (EVF.isEmpty(noticeNum) || EVF.isEmpty(noticeTextNum)) {
                return EVF.alert("동의할 내용이 없습니다. 고객센터에 문의하세요.");
            }
        	
            var checkedVal = $('input[name=Agree]:checked').val();
            if (checkedVal == undefined) {
                return EVF.alert("계약일반조건 및 개인정보처리에 대해 '동의여부'를 체크해주세요.");
            }
            
            if (checkedVal == "0") {
                opener.checkLoginY("");
                EVF.closeWindow();
            }
            else {
            	if(localServerFlag == "Y") {
            		document.reqForm.idn.value = "1234567890";
            		//mlCallBack(0, null);
            	}
            	
        		// SIGN_VALUE=사용자사업자번호@@로그인ID@@공고번호@@공고텍스트번호@@signDate
            	document.reqForm.signData.value = document.reqForm.idn.value+"@@"+"${userId}"+"@@"+EVF.V("NOTICE_NUM")+"@@"+EVF.V("NOTICE_TEXT_NUM")+"@@"+EVF.V("SIGN_DATE");
            	
            	var certOdiFilter = "${certOidfilter}";
				var listOdiArr    = certOdiFilter.split(";");
				var certOidfilter = "";
				for(var i in listOdiArr) {
					certOidfilter = certOidfilter + listOdiArr[i] + ",";
				}
				certOidfilter = certOidfilter.substring(0, certOidfilter.length-1);
				
                magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBack, certOidfilter);
            }
        }
        
		function mlCallBack(code, message){
	    	
			if(code == 0){
				if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
				if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
				
				// 동의여부
	            var checkedVal = $('input[name=Agree]:checked').val();
	            if (checkedVal == undefined) {
	                return EVF.alert("계약일반조건 및 개인정보처리에 대해 '동의여부'를 체크해주세요.");
	            }
	            
				var store = new EVF.Store();
				store.setParameter("checkYN", checkedVal);
                store.setParameter("userId", "${userId}");
				store.setParameter("localServerFlag", localServerFlag);
                // 인증정보
				store.setParameter("signedData", document.reqForm.signedData.value);
				store.setParameter("vidRandom", document.reqForm.vidRandom.value);
				store.setParameter("idn", document.reqForm.idn.value);
	            store.load('/systemConfirmAgree.so', function () {
                    opener.checkLoginY("Y");
                    EVF.closeWindow();
                }, false);
			} else {
				return EVF.alert("결과값 수신에 실패하였습니다.");
			}
		}
		
        function doClose(){
            EVF.closeWindow();
        }
    </script>

    <e:window id="systemAgreeCheck" onReady="init" initData="${initData}" title="범농협 통합전자구매시스템 ASP 이용계약" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" useTitleBar="false" title="" labelWidth="${longLabelWidth}" width="100%" columnCount="2">
            <e:inputHidden id="NOTICE_NUM" name="NOTICE_NUM" value="${formData.NOTICE_NUM }" /> <!-- STOCNOTC의 계약서 폼번호 -->
            <e:inputHidden id="NOTICE_TEXT_NUM" name="NOTICE_TEXT_NUM" value="${formData.NOTICE_TEXT_NUM }" /> <!-- STOCNOTC의 계약서 폼 text번호 -->
			<e:inputHidden id="VENDOR_IRS_NUM" name="VENDOR_IRS_NUM" value="${formData.VENDOR_IRS_NUM }" /> <!-- 사용자 사업자의 사업자번호(서명값용) -->
			<e:inputHidden id="SIGN_DATE" name="SIGN_DATE" value="${formData.SIGN_DATE }" /> <!-- 전자서명일시(서명값용) -->
            
			<!-- 1. 계약일반정보 -->
            <e:row>
                <e:label for="SUBJECT" title="계약명" />
                <e:field colSpan="3">
                    <e:text>${formData.SUBJECT } </e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="IRS_NUM" title="사업자번호" />
				<e:field>
					<e:text>${formData.IRS_NUM_TEXT } </e:text>
				</e:field>
				<e:label for="COMPANY_NM" title="사업자명" />
				<e:field>
					<e:text>${formData.COMPANY_NM } </e:text>
				</e:field>
            </e:row>
            <%--
            <e:row>
                <e:label for="UNIT_PRC_TEXT" title="계약단가" />
				<e:field colSpan="3">
					<e:text>${formData.UNIT_PRC_TEXT } </e:text>
				</e:field>
            </e:row>
            --%>
            <e:row>
                <e:label for="START_DATE" title="계약기간" />
                <e:field colSpan="3">
                	<e:text>${formData.START_DATE } </e:text>
                    <e:text>&nbsp;~&nbsp;</e:text>
                	<e:text>${formData.END_DATE } </e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="AP_TEXT" title="대금정산" />
				<e:field colSpan="3">
					<e:textArea id="AP_TEXT" name="AP_TEXT" width="100%" height="65px" value="${formData.AP_TEXT }" required="false" disabled="false" maxLength="" readOnly="true"/>
				</e:field>
            </e:row>
            
            <%-- 2. 계약내용 --%>
            <e:row>
                <e:field colSpan="4">
                    <e:richTextEditor id="NOTICE_CONTENTS" name="NOTICE_CONTENTS" value="${formData.NOTICE_CONTENTS }" width="100%" height="500px" required="false" readOnly="true" disabled="false" />
                </e:field>
            </e:row>
        </e:searchPanel>
        
        <div style="font-weight: bold; text-align: center; font-size:13px; line-height: 40px; margin-right: 10px">
            ${formData.SIGN_DATE_TEXT }
        </div>
        
        <!-- 3. 계약담당자 정보(갑) -->
        <e:panel id="panel2" height="25px" width="100%">
            <e:title title="계약담당자(갑)" depth="1" />
        </e:panel>
        <e:searchPanel id="form1" useTitleBar="false" title="" labelWidth="${longLabelWidth}" width="100%" columnCount="2">
            <e:row>
                <e:label for="ADDR" title="주소" />
                <e:field colSpan="3">
                    <e:text>${formData.ADDR1 } ${formData.ADDR2 }</e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="COMPANY_NM" title="상호" />
                <e:field colSpan="3">
                    <e:text>${formData.COMPANY_NM }</e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="CEO_USER_NM" title="대표자" />
                <e:field colSpan="3">
                    <e:text>${formData.CEO_USER_NM }</e:text>
                </e:field>
            </e:row>
        </e:searchPanel>

        <!-- 4. 계약담당자 정보(을) -->
        <e:panel id="panel3" height="25px" width="100%">
            <e:title title="계약담당자(을)" depth="1" />
        </e:panel>
        <e:searchPanel id="form2" useTitleBar="false" title="" labelWidth="${longLabelWidth}" width="100%" columnCount="2">
            <e:row>
                <e:label for="ADDR" title="주소" />
                <e:field colSpan="3">
                    <e:text>${formData.VENDOR_ADDR1 } ${formData.VENDOR_ADDR2 }</e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="VENDOR_NM" title="상호" />
                <e:field colSpan="3">
                    <e:text>${formData.VENDOR_NM }</e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="VENDOR_CEO_NM" title="대표자" />
                <e:field colSpan="3">
                    <e:text>${formData.VENDOR_CEO_NM }</e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="VENDOR_IRS_NUM" title="사업자번호" />
                <e:field colSpan="3">
                    <e:text>${formData.VENDOR_IRS_NUM }</e:text>
                </e:field>
            </e:row>
        </e:searchPanel>
		
		<div id="top" style="margin:0 auto; font-size: 14px !important; line-height: 25px; text-align: right;">
            <input type="radio" style="height: 10px;" id="Agree_N" name="Agree" value="0">
            <label for="Agree_N" style="cursor: pointer;">동의하지 않음</label>
            &nbsp;
            <input type="radio" style="height: 10px;" id="Agree_Y" name="Agree" value="1">
            <label for="Agree_Y" style="cursor: pointer; margin-right: 15px;">동의함</label>
        </div>
        <div style="font-weight: normal; text-align: center; font-size:12px; line-height: 30px; margin-right: 10px">
            	※ 위의 계약에 대하여 계약 담당자와 계약상대자는 붙임의 계약문서에 의하여 이용계약을 체결하고 신의에 따라 성실히 계약상의 의무를 이행할 것을 확약하며<br>
            	본 계약의 증거로서 사용자(갑)의 사업자 공동인증서로 전자서명을 한다.
        </div>

        <div style="width: 100%; text-align: center; margin-top: 10px; margin-bottom: 20px;">
            <div class="btn_confirm" style="border-radius: 15px; width: 100px; height: 30px; background-color: #223a6a; text-align: center; display: inline-block; cursor: pointer;" onclick="doConfirm();">
                <span style="color: #fff; font-size: 14px; line-height: 30px;">확인</span>
            </div>
        </div>
        
        <%-- 공인인증정보 영역 --%>
		<form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
            <input type="hidden" id="signData" name="signData" value=""/>
            <input type="hidden" id="signedData" name="signedData"/>
            <input type="hidden" id="vidRandom" name="vidRandom"/>
            <input type="hidden" id="vidType" name="vidType" value="client"/>
            <input type="hidden" id="idn" name="idn" value="${formData.VENDOR_IRS_NUM}"/>
        </form>
        <div id="dscertContainer">
            <iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
        </div>
    </e:window>
</e:ui>

