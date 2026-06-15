<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
    <!-- ML4WEB JS -->
    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>

    <script type="text/javascript">
    
        var baseUrl = "/nhepro/SCTR/SCTR0011";
        var localServerFlag = "${localServerFlag}";
        
        function init() {

        }
		
        function doConfirm() {
        	
        	
        	var message = "문서보관료를 결제 하시겠습니까?";
            EVF.confirm(message, function() {
                if(localServerFlag == "Y") {
                	signCompleteCallback();
                } else {
                    document.reqForm.useCard.value = "1";
                    
                    // 공인인증서 팝업창 오픈
                    document.reqForm.signData.value = "${VENDOR_CD}" + "@@" + "${CORP_NO}" + "@@" + "${UUID}" + "@@" + "${UUID_SQ}" + "@@" + "${signDate}";
                    magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBack);                    
                }
            })        	
        	
        }
        
        function mlCallBack(code, message){
            if(code == 0) { <%-- 정상메시지 --%>
                if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
                if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
                signCompleteCallback();
            }
            else {
                return EVF.alert("결과값 수신에 실패하였습니다.");
            }
        }        
        
        // 공인인증 완료후 callback함수
        function signCompleteCallback() {

            var store = new EVF.Store();
            store.setParameter("signedData", document.reqForm.signedData.value);
            store.setParameter("vidRandom", document.reqForm.vidRandom.value);
            store.setParameter("idn", document.reqForm.idn.value);
            store.setParameter("useCard", document.reqForm.useCard.value);
            store.setParameter("localServerFlag", localServerFlag);
            store.setParameter("UUID", "${UUID }");
            store.setParameter("UUID_SQ", "${UUID_SQ }");        
            store.setParameter("VENDOR_CD", "${VENDOR_CD }");            
            store.load(baseUrl+'/docFee_doSaveSignedData.so', function() {
                EVF.alert('결제 처리 되었습니다.');
            	document.getElementById("btn_confirm").style.display = "none";                 
            }, true);
            
        }
        
        function doClose(){
            EVF.closeWindow();
        }
    </script>

    <e:window id="supplyDocFee" onReady="init" initData="${initData}" title="문서보관료 결제" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" useTitleBar="false" title="" labelWidth="${longLabelWidth}" width="100%" columnCount="1">
            <e:inputHidden id="UUID" name="UUID" value="${UUID }" /> 
            <e:inputHidden id="UUID_SQ" name="UUID_SQ" value="${UUID_SQ }" /> 
            <e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="${VENDOR_CD }" />             
            
			
            <e:row>
                <e:label for="REAL_FILE_NM" title="파일명" width="30%" />
                <e:field width="70%" >
                    <e:text>${REAL_FILE_NM }</e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="COST" title="수수료" />
                <e:field>
                	<e:text>${COST }원</e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="FINAL_DATE" title="이전결제일 (등록일,결제일)" />
                <e:field>
                	<e:text>${FINAL_DATE }</e:text>
                </e:field>
            </e:row>            
        </e:searchPanel>
		
        <div style="font-weight: normal; text-align: center; font-size:12px; line-height: 30px; margin-right: 10px">
            	※ 해당 파일 다운로드를 위해 문서보관료를 결제 하시겠습니까?<br>(결제시 해당파일을 1년간 이용 하실 수 있습니다.)
        </div>

        <div style="width: 100%; text-align: center; margin-top: 10px; margin-bottom: 20px;">
            <div id="btn_confirm" class="btn_confirm" style="border-radius: 15px; width: 100px; height: 30px; background-color: #223a6a; text-align: center; display: inline-block; cursor: pointer;" onclick="doConfirm();">
                <span style="color: #fff; font-size: 14px; line-height: 30px;">결제</span>
            </div>
            <div class="btn_close" style="border-radius: 15px; width: 100px; height: 30px; background-color: #223a6a; text-align: center; display: inline-block; cursor: pointer;" onclick="doClose();">
                <span style="color: #fff; font-size: 14px; line-height: 30px;">닫기</span>
            </div>            
        </div>
        
        <form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
            <input type="hidden" id="signData" name="signData" value=""/>
            <input type="hidden" id="signedData" name="signedData"/>
            <input type="hidden" id="vidRandom" name="vidRandom"/>
            <input type="hidden" id="vidType" name="vidType" value="client"/>
            <input type="hidden" id="idn" name="idn" value="${CORP_NO}"/>
            <input type="hidden" id="useCard" name="useCard" value=""/>
        </form>        
        
        <div id="dscertContainer">
            <iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
        </div>        
    </e:window>
</e:ui>

