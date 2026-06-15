<%--
  Date: 2020-06-10
  Time: 15:01:18
  Scrren ID : CCTR0071
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>

<%
	String ozSchedulerIp = PropertiesManager.getString("oz.scheduler.ip");
	String ozSchedulerPort = PropertiesManager.getString("oz.scheduler.port");
%>

<c:set var="ozUrl" value="<%=ozUrl%>" />
<c:set var="ozServer" value="<%=ozServer%>" />
<c:set var="ozSchedulerIp" value="<%=ozSchedulerIp%>" />
<c:set var="ozSchedulerPort" value="<%=ozSchedulerPort%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
  
  <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
  <!-- ML4WEB JS -->
  <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>
  
  <script type="text/javascript">

    var grid;
    var baseUrl = '/nhepro/CCTR/CCTR0071';
	var localServerFlag = "${localServerFlag}";

    function init() {
    	
    	var reqNum     = '${form.REQ_NUM}';
    	var reqSeq     = '${form.REQ_SEQ}';
    	var progStatus = "${form.PROGRESS_CD}";
    	var appStatus  = "${form.APP_STATUS}";
    	// 버튼 처리
    	if( ${param.detailView} ){
			EVF.C('doReqSign').setVisible(false); // 결재상신
			EVF.C('doSign').setVisible(false); // 전자서명
			EVF.C('doReject').setVisible(false); // 반려
		} else {
			if( progStatus == "W" ) {
				if( appStatus == "E" ) {
					EVF.C('doReqSign').setVisible(false); // 결재상신
					EVF.C('doSign').setVisible(true); // 전자서명
					EVF.C('doReject').setVisible(true); // 반려
				} else if( appStatus == "P" ) {
					EVF.C('doReqSign').setVisible(false); // 결재상신
					EVF.C('doSign').setVisible(false); // 전자서명
					EVF.C('doReject').setVisible(false); // 반려
				} else {
					EVF.C('doReqSign').setVisible(true); // 결재상신
					EVF.C('doSign').setVisible(false); // 전자서명
					EVF.C('doReject').setVisible(true); // 반려
				}
			}
		}
    	
    	// EFORM 번호가 없는 경우 EFORM 생성
    	var eformId = '${form.EFORM_ID}';
    	if( !EVF.isEmpty(reqNum) && !EVF.isEmpty(reqSeq) && EVF.isEmpty(eformId) ) {
        	eformScheduler();
    	}
    }
	
    // EFORM이 생성되지 않은 경우 생성
    function eformScheduler(signFlag) {
    	
    	var contNum   = '${form.REQ_NUM}';
    	var contseq   = '${form.REQ_SEQ}';
    	var buyerCd   = '${form.BUYER_CD}';			// 수임회사 폴더
		var buyerDept = '${form.REQ_USER_DEPT_CD}';	// 수임회사 사무소 폴더
		var custCd    = '${form.ENTRST_COMP_CD}';	// 위임회사
		
		var eformId  = buyerCd + "_" + contNum + "_" + contseq;
    	
		// 전자서명시 pdf 파일명
		if( signFlag == "E" ) {
    		eformId = eformId + "_" + custCd; 		// eform 파일명(수임사코드 + 요청번호 + 요청순번 + 위임사코드)
    	}
    	
    	// 기생성된 pdf파일번호
    	var uuid    = EVF.V("EFORM_ID");
    	
		// 서브 폼 파일명(주서식에 부서식이 여러개인 경우 부서식별로 pdf 생성)
		// 전자서명시 signFlag = E ('E'인 경우에만 위임장에 원본 마크 생성)
		var subFormFileNm = "";
		var odiParamVal = "BUYER_CD="+buyerCd+",REQ_NUM="+contNum+",REQ_SEQ="+contseq+",STATUS="+signFlag;
		var param = {
				bizType: "EC",
                SUB_FORM_FILE_NM: subFormFileNm,
				odiName: "CCTA0070",
				ozrName: "CCTA0070",
				// OZ Scheduler Info
				serverUrl: "${ozServer}",
				schedulerIp: "${ozSchedulerIp}",
				schedulerPort: "${ozSchedulerPort}",
				exportFileName: eformId,
				exportFormat: "pdf",
				odiParamVal: odiParamVal,
				url: "${ozUrl}"
		};
		
		// eform을 pdf파일로 만들기
		$.ajax({
			url: "${ozUrl}" + "/oz_export_directexport.jsp",
			type: "post",
			data: param,
			async: false,
			success: function(data) {
				// 생성된 PDF 파일 이동
				param = {
					bizType: "EC",
					fileNm: eformId,
					fileExtension: "pdf",
					buyerCd: buyerCd,
					prBuyerCd: buyerCd,
					prDeptCd: buyerDept,
					uuid: uuid,
					fileCnt: 1,
					maxFileCnt: 1
				};
				
				// 생성된 pdf 파일의 폴더 이동하기
				$.ajax({
					url: "/common/file/eformPdfUpload.so",
					type: "post",
					data: param,
					async: false,
					success: function(data) {
						var fileInfo = data;
						
						// 생성된 pdf 파일 ID를 STOCETDT테이블에 저장
						data = JSON.parse(data);
						var eformId = data["UUID"];
						data["BUYER_CD"] = buyerCd;
						data["REQ_NUM"]  = contNum;
						data["REQ_SEQ"]  = contseq;
						
						// STOCATCH 저장 후 PDF UUID 저장(개별 처리)
						$.ajax({
							url: baseUrl + "/doSaveEform.so",
							type: "post",
							data: data,
							success: function(data) {
				    	    	EVF.C('EFORM_ID').setValue(eformId);
				    	    	// 전자서명 완료 후 pdf 파일에 binary 입히기
				    	    	if( signFlag == "E" ) {
					    	    	signCompleteTSA(fileInfo);
				    	    	}
							}
						});
					}
				});
			}
		});
	}
    
 	// 결재상신
	function doReqSign() {
		
		if( EVF.isEmpty(EVF.V("EFORM_ID")) ) {
	    	return EVF.alert("${CCTR0071_0003}");
	    }
		
		var signStatus = EVF.V('APP_STATUS');
		var param = {
			subject: EVF.V('SUBJECT') + "(" + EVF.V('ENTRST_OFCE_NM') + ")",
			docType: "ETST",
			signStatus: signStatus,
			screenId: "CCTR0071",
			approvalType: 'APPROVAL',
			attFileNum: "",
			docNum: EVF.V('REQ_NUM'),
			appDocNum: EVF.V('APP_DOC_NUM'),
			callBackFunction: "goApproval",
			appAmt: 0
		};
		everPopup.openApprovalRequestIPopup(param);
    }
    

    // 결재상신 완료 후 결재창에서 호출하는 메소드
	function goApproval(formData, gridData, attachData) {

		EVF.V('approvalFormData', formData);
		EVF.V('approvalGridData', gridData);
		EVF.V('attachFileDatas',  attachData);

        var store = new EVF.Store();
        store.doFileUpload(function() {
            store.load(baseUrl + '/doReqSign.so', function() {
                EVF.alert('${msg.M0001}', function () {
					location.href = baseUrl + "/view.so";
					if(opener) {
						opener['doSearch']();
						doClose();
					}
				});
            });
        });
    }
    
    // 전자서명
    function doSign() {

		if( EVF.isEmpty(EVF.V("EFORM_ID")) ) {
	    	return EVF.alert("${CCTR0071_0003}");
	    }
	    
		<%-- local에서 테스트시 localServerFlag : "N", skip은 localServerFlag : "Y" --%>
		localServerFlag='N';
		if(localServerFlag == "Y") {
	    	  var res = {
				  code: 0,
				  errorMessage: '에러 메시지입니다.',
				  data: {
					  signedData: null,
				  }
	    	  }
	    	// PDF파일 생성
				eformScheduler('E');
	    	  signCompleteCallback(res);
		}
        else {
            // SIGN_VALUE=위임회사코드@@사업자번호@@요청번호@@요청항번@@signDate
        	document.reqForm.signData.value = EVF.V("ENTRST_COMP_CD") + "@@" + document.reqForm.idn.value + "@@" + EVF.V("BUYER_CD") + "@@" + EVF.V("REQ_NUM") + "@@" + EVF.V("REQ_SEQ") + "@@" + "${signDate}";
            
        	// 사설인증서 팝업창 띄우기
        	var certOdiFilter = "${certOidfilter}";
			var listOdiArr = certOdiFilter.split(";");
			var certOidfilter = "";
			for(var i in listOdiArr) {
				certOidfilter = certOidfilter + listOdiArr[i] + ",";
			}
			certOidfilter = certOidfilter.substring(0, certOidfilter.length-1);
			
			// 사설인증하기
        	magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBack, certOidfilter);
        }
    }
	
    function mlCallBack(code, message){
		if(code == 0) { <%-- 정상메시지 --%>
			if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
			if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
			
			// PDF파일 생성
			eformScheduler('E');
		}
		else {
			return EVF.alert("결과값 수신에 실패하였습니다.");
		}
	}
    
    // 전자서명 이전에 pdf 파일 다시 생성하기
    function signCompleteTSA(fileInfo) {
		var store = new EVF.Store();
		store.setAsync(false);
		store.setParameter("FILE_INFO", fileInfo);
		store.load(baseUrl + '/cctr0071_doSignCompleteTSA.so', function () {
			signCompleteCallback();
		});
	}
	
 	// 인증 완료후 callback함수
    function signCompleteCallback() {
        var store = new EVF.Store();
        store.setAsync(false);
		store.setParameter("signedData", document.reqForm.signedData.value);
		store.setParameter("vidRandom", document.reqForm.vidRandom.value);
		store.setParameter("idn", document.reqForm.idn.value);
		store.setParameter("localServerFlag", localServerFlag);
        store.doFileUpload(function() {
            store.load(baseUrl+'/doSaveSignedData.so', function() {
                alert(this.getResponseMessage());
                if(opener) {
                    opener['${param.callBackFunction}']();
                }
                EVF.closeWindow();
            });
        });
    }
 	
    <%-- 위임장요청 반려(=진행상태가 전자서명대기(W)인 경우에만 반려 가능) --%>
	function doReject() {

		var store = new EVF.Store();
		if (!store.validate()) { return; }
		
		var rejectRmks = EVF.V("REJECT_RMK");
        if(rejectRmks.trim() == "") {
            return EVF.alert("${CCTR0071_0002}");
        }
        
		var progressCd = EVF.V("PROGRESS_CD") == ""?"T":EVF.V("PROGRESS_CD");
		if( progressCd == "W" ){
			EVF.confirm("${CCTR0071_0001}", function() {
				store.load(baseUrl + "/doReject.so", function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        if(opener) {
                            opener.doSearch();
                            doClose();
                        } else {
                            document.location.href = "/nhepro/CCTR/CCTR0071/view.so?";
                        }
                    });
                });
		    });
		}
	}
	
    // eform으로 위임장 내용 보여주기
    function opEntrustForm(param){
    	
    	if( EVF.isEmpty(EVF.V("EFORM_ID")) ) {
      	  return EVF.alert("${CCTR0071_0003}");
        }
    	
		var url = "/common/file/fileAttach/viewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID="+EVF.V("EFORM_ID");
		window.open(url, "eform", "width=850,height=960,scrollbars=yes,resizeable=no,left=0,top=0");
	}
    
    // 창닫기
    function doClose() {
        EVF.closeWindow();
    }
    
  </script>

  <e:window id="CCTR0071" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
    <!-- Button 영역 -->
  	<e:buttonBar width="100%" align="right" title="수임회사">
  	  <e:button id="doReqSign" name="doReqSign" label="${doReqSign_N}" onClick="doReqSign" disabled="${doReqSign_D}" visible="${doReqSign_V}"/>
      <e:button id="doSign" name="doSign" label="${doSign_N}" onClick="doSign" disabled="${doSign_D}" visible="${doSign_V}"/>
      <e:button id="doReject" name="doReject" label="${doReject_N}" onClick="doReject" disabled="${doReject_D}" visible="${doReject_V}"/>
      <e:button id="opEntrustForm" name="opEntrustForm" label="${opEntrustForm_N}" onClick="opEntrustForm" disabled="${opEntrustForm_D}" visible="${opEntrustForm_V}"/>
    </e:buttonBar>
  	
  	<e:searchPanel id="form1" title="" columnCount="3" labelWidth="135" useTitleBar="false">
      <e:row>
      	<e:label for="BUYER_NM" title="${form_BUYER_NM_N}" />
		<e:field>
			<e:inputText id="BUYER_NM" name="BUYER_NM" value="${form.BUYER_NM}" width="100%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}"/>
		</e:field>
      	<e:label for="REQ_USER_NM" title="${form_REQ_USER_NM_N}" />
		<e:field>
			<e:inputText id="REQ_USER_NM" name="REQ_USER_NM" value="${form.REQ_USER_NM}" width="100%" maxLength="${form_REQ_USER_NM_M}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}" style="${imeMode}" maskType="${form_REQ_USER_NM_MT}"/>
		</e:field>
		<e:label for="REQ_USER_TEL_NUM" title="${form_REQ_USER_TEL_NUM_N}" />
		<e:field>
			<e:inputText id="REQ_USER_TEL_NUM" name="REQ_USER_TEL_NUM" value="${form.REQ_USER_TEL_NUM}" width="100%" maxLength="${form_REQ_USER_TEL_NUM_M}" disabled="${form_REQ_USER_TEL_NUM_D}" readOnly="${form_REQ_USER_TEL_NUM_RO}" required="${form_REQ_USER_TEL_NUM_R}" style="${imeMode}" maskType="${form_REQ_USER_TEL_NUM_MT}"/>
		</e:field>
      </e:row>
	</e:searchPanel>
	
	<e:title title="위임회사"/>
	<e:searchPanel id="form2" title="" columnCount="3" labelWidth="135" useTitleBar="false">
      <e:row>
      	<e:label for="ENTRST_COMP_NM" title="${form_ENTRST_COMP_NM_N}" />
		<e:field>
			<e:inputText id="ENTRST_COMP_NM" name="ENTRST_COMP_NM" value="${form.ENTRST_COMP_NM}" width="100%" maxLength="${form_ENTRST_COMP_NM_M}" disabled="${form_ENTRST_COMP_NM_D}" readOnly="${form_ENTRST_COMP_NM_RO}" required="${form_ENTRST_COMP_NM_R}" style="${imeMode}" maskType="${form_ENTRST_COMP_NM_MT}"/>
		</e:field>
      	<e:label for="ENTRST_OFCE_NM" title="${form_ENTRST_OFCE_NM_N}" />
		<e:field colSpan="3">
			<e:inputText id="ENTRST_OFCE_NM" name="ENTRST_OFCE_NM" value="${form.ENTRST_OFCE_NM}" width="100%" maxLength="${form_ENTRST_OFCE_NM_M}" disabled="${form_ENTRST_OFCE_NM_D}" readOnly="${form_ENTRST_OFCE_NM_RO}" required="${form_ENTRST_OFCE_NM_R}" style="${imeMode}" maskType="${form_ENTRST_OFCE_NM_MT}"/>
		</e:field>
      </e:row>
	</e:searchPanel>
	
	<e:title title="위임내용"/> 
    <e:searchPanel id="form" title="${form_CAPTION_N}" labelWidth="135" width="100%" columnCount="3" useTitleBar="false" onEnter="">
	    <e:inputHidden id='BUYER_CD' name='BUYER_CD' value='${form.BUYER_CD}'/>	<%-- BUYER_CD --%>
	    <e:inputHidden id='REQ_USER_DEPT_CD' name='REQ_USER_DEPT_CD' value='${form.REQ_USER_DEPT_CD}'/> <%-- 수임회사사무소코드 --%>
	    <e:inputHidden id='REQ_SEQ' name='REQ_SEQ' value='${form.REQ_SEQ}'/>	<%-- REQ_SEQ --%>
	    <e:inputHidden id='ENTRST_COMP_CD' name='ENTRST_COMP_CD' value='${form.ENTRST_COMP_CD}'/> <%-- 위임회사코드 --%>
	    <e:inputHidden id='ENTRST_OFCE_CD' name='ENTRST_OFCE_CD' value='${form.ENTRST_OFCE_CD}'/> <%-- 위임회사사무소코드 --%>
	    <e:inputHidden id='SIGN_VALUE' name='SIGN_VALUE' value=''/>	<%-- 전자서명 인증값 --%>
	    <e:inputHidden id='EFORM_ID' name='EFORM_ID' value='${form.EFORM_ID}'/>	<%-- EFORM_ID(EFORM 파일명) --%>
	    
	    <!-- 결재관련정보 -->
	    <e:inputHidden id="APP_DOC_NUM" name="APP_DOC_NUM" value="${empty form.APP_DOC_NUM ? param.appDocNum : form.APP_DOC_NUM}"/>
	    <e:inputHidden id="APP_DOC_CNT" name="APP_DOC_CNT" value="${empty form.APP_DOC_CNT ? param.appDocCnt : form.APP_DOC_CNT}"/>
	    <e:inputHidden id="APP_STATUS"  name="APP_STATUS"  value="${form.APP_STATUS}" />
		<e:inputHidden id="approvalFormData" name="approvalFormData" value="" />
		<e:inputHidden id="approvalGridData" name="approvalGridData" value="" />
		<e:inputHidden id="attachFileDatas" name="attachFileDatas" visible="false" />

      <e:row>
		<e:label for="REQ_NUM" title="${form_REQ_NUM_N}" />
		<e:field>
			<e:inputText id="REQ_NUM" name="REQ_NUM" value="${form.REQ_NUM}" width="100%" maxLength="${form_REQ_NUM_M}" disabled="${form_REQ_NUM_D}" readOnly="${form_REQ_NUM_RO}" required="${form_REQ_NUM_R}" style="${imeMode}" maskType="${form_REQ_NUM_MT}"/>
		</e:field>
		<e:label for="REQ_DATE" title="${form_REQ_DATE_N}"/>
		<e:field>
			<e:inputDate id="REQ_DATE" name="REQ_DATE" value="${form.REQ_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_REQ_DATE_R}" disabled="${form_REQ_DATE_D}" readOnly="${form_REQ_DATE_RO}" />
		</e:field>
		<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
		<e:field>
			<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="${form.PROGRESS_CD}" options="${progressCdOptions}" width="100%" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" />
		</e:field>
      </e:row>
      <e:row>
		<e:label for="REQ_TYPE_CD" title="${form_REQ_TYPE_CD_N}"/>
		<e:field>
			<e:select id="REQ_TYPE_CD" name="REQ_TYPE_CD" value="${form.REQ_TYPE_CD}" options="${reqTypeCdOptions}" width="100%" disabled="${form_REQ_TYPE_CD_D}" readOnly="${form_REQ_TYPE_CD_RO}" required="${form_REQ_TYPE_CD_R}" placeHolder="" maskType="${form_REQ_TYPE_CD_MT}" />
		</e:field>
		<e:label for="RCV_REQ_DATE" title="${form_RCV_REQ_DATE_N}"/>
		<e:field>
			<e:inputDate id="RCV_REQ_DATE" name="RCV_REQ_DATE" value="${form.RCV_REQ_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_RCV_REQ_DATE_R}" disabled="${form_RCV_REQ_DATE_D}" readOnly="${form_RCV_REQ_DATE_RO}" />
		</e:field>
		<e:label for="REF_DOC_NO" title="${form_REF_DOC_NO_N}" />
		<e:field>
			<e:inputText id="REF_DOC_NO" name="REF_DOC_NO" value="${form.REF_DOC_NO}" width="100%" maxLength="${form_REF_DOC_NO_M}" disabled="${form_REF_DOC_NO_D}" readOnly="${form_REF_DOC_NO_RO}" required="${form_REF_DOC_NO_R}" style="${imeMode}" maskType="${form_REF_DOC_NO_MT}"/>
		</e:field>
      </e:row>
      <e:row>
      	<e:label for="SUBJECT" title="${form_SUBJECT_N}" />
		<e:field colSpan="5">
			<e:inputText id="SUBJECT" name="SUBJECT" value="${form.SUBJECT}" width="100%" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
		</e:field>
      </e:row>
      <%--
      <e:row>
		<e:label for="CONTENTS" title="${form_CONTENTS_N }" />
		<e:field colSpan="5">
              	<e:richTextEditor id="CONTENTS" name="CONTENTS" width="100%" height="180px" value="${form.CONTENTS }" required="${form_CONTENTS_R }" readOnly="${form_CONTENTS_RO }" disabled="${form_CONTENTS_D }" useToolbar="${!param.detailView}" />
		</e:field>
	  </e:row>
	  --%>
      <e:row>
		<e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}"/>
		<e:field colSpan="5">
			<e:fileManager id="ATT_FILE_NUM" height="100" width="100%" fileId="${form.ATT_FILE_NUM}" readOnly="${not attFileEditable}" bizType="EN" required="false" uploadable="${attFileEditable}"/>
		</e:field>
      </e:row>
      <e:row>
      	<e:label for="RMKS" title="${form_RMKS_N}"/>
		<e:field colSpan="5">
			<e:textArea id="RMKS" name="RMKS" value="${form.RMKS}" height="100px" width="100%" maxLength="${form_RMKS_M}" disabled="${form_RMKS_D}" readOnly="${form_RMKS_RO}" required="${form_RMKS_R}" />
		</e:field>
      </e:row>
      <e:row>
      	<e:label for="REJECT_RMK" title="${form_REJECT_RMK_N}"/>
		<e:field colSpan="5">
			<e:textArea id="REJECT_RMK" name="REJECT_RMK" value="${form.REJECT_RMK}" height="150px" width="100%" maxLength="${form_REJECT_RMK_M}" disabled="${form_REJECT_RMK_D}" readOnly="${form_REJECT_RMK_RO}" required="${form_REJECT_RMK_R}" />
		</e:field>
      </e:row>
    </e:searchPanel>
    
    <%-- 인증정보 영역 --%>
    <form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
        <input type="hidden" id="signData" name="signData" value=""/>
        <input type="hidden" id="signedData" name="signedData"/>
        <input type="hidden" id="vidRandom" name="vidRandom"/>
        <input type="hidden" id="vidType" name="vidType" value="client"/>
        <input type="hidden" id="idn" name="idn" value="${form.ENTRST_IRS_NO}"/>
    </form>

    <div id="dscertContainer">
        <iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
    </div>
    
  </e:window>
</e:ui>
