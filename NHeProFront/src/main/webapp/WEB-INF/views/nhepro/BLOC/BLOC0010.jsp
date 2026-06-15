<%--
  Date: 2020-07-23
  Time: 14:33:27
  Scrren ID : BLOC0010
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
  <script>
  	var kcbData;
  	$(document).ready(function() {

		var param = {};
    	var url = "${NPKI_URL}";
    	var option = "width = 1000, height = 800"

    	if(!EVF.isEmpty(url)) {
        	window.open(url, "블록체인 인증센터", option);
    	}
  	});

		/**
		* 2020.08.28 핑거 이호원
		* 1. 링크 클릭하여 통신사 본인인증은 현재 주석처리
		* 2. 통신사 본인인증은 사설인증센터 웹 - 개인 인증서 발급 시에 진행
		* 위 사항은 농협정보 박세현 차장과 협의 완료
		*/
		/*  	$(document).ready(function() {

 		// 핸드폰 인증(KCB)
         var url = "/kcb/phone_popup2.jsp";
        var param = {
            CP_CD: "${CP_CD}",
            SITE_NAME: "농협정보시스템"
        };
       	console.log(">> CP_CD : " + "${CP_CD}");
        everPopup.openWindowPopup(url, 430, 640, param, 'auth_popup', true);
        //핸드폰인증(KCB 끝)

        //핸드폰인증 callBack함수
        function kcbCallbackFunction(data) {
	        kcbData = data;
            if (data.RSLT_MSG == "본인인증 완료" && data.RSLT_NAME == $("#P_USER_NM").val()) {
        		var param = {};
            	var url = "${NPKI_URL}";
            	var option = "width = 1000, height = 800"
				var obj;
            	if(!EVF.isEmpty(url)) {
                	obj = window.open(url, "블록체인 인증센터", option);
                	obj.document.getElementById('kcbSeq').value = data.TX_SEQ_NO;
            	}
            } else {
                alert("본인인증 정보가 일치하지 않습니다.\n확인하여 주시기 바랍니다.");
			}
        }
  	});*/
  </script>
</e:ui>
