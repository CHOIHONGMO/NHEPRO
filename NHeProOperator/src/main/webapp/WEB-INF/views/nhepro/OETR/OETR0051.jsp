<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	
	<!-- 공인인증서 통한 전자서명 처리하기 -->
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>
    
    <script type="text/javascript">
        var baseUrl = "/nhepro/OETR/";
        var localServerFlag = "${localServerFlag}";
        
        function init() {
            var editor = EVF.C("NOTICE_CONTENTS").getInstance();
            editor.config.contentsCss  = "/css/richText.css";
            editor.config.allowedContent = true;
        }
		
        function doSave() {
            var store = new EVF.Store();
            if(!store.validate()) return;

            var status = this.data.data;
            if( EVF.isEmpty(EVF.V("START_DATE")) ) {
                return EVF.alert("${OETR0051_003 }");
            }
            if( EVF.isEmpty(EVF.V("NOTICE_CONTENTS")) ) {
                return EVF.alert("${OETR0051_002 }");
            }
            if( EVF.V("POPUP_FLAG") == "1" ) {
                return EVF.alert("확정된 건은 수정할 수 없습니다.");
            }
            
            var msg = "${msg.M0021 }";
            if( status == "1" ) {
            	msg = "확정 이후에는 수정이 [불가능]합니다. 현재 계약 및 동의서를 [확정]하시겠습니까?";
            }
			
            EVF.confirm(msg, function () {
            	if( status == "0" ) {
                    store.doFileUpload(function () {
                    	store.setParameter("status", "0");
                        store.load(baseUrl + "oetr0051_doSave.so", function () {
                            var pNoticeNum = this.getParameter("NOTICE_NUM");
                            EVF.alert(this.getResponseMessage(), function() {
                                if (opener != null) {
                                    opener.doSearch();
                                }
                                location.href = baseUrl + "OETR0051/view.so?NOTICE_NUM="+pNoticeNum+"&detailView=false";
                            });
                        });
                    });
            	}
            	else {
    				if(localServerFlag == "Y") {
                		document.reqForm.idn.value = "1234567890";
                	}
					
                	// SIGN_VALUE=계약서내용
                	document.reqForm.signData.value = EVF.V("NOTICE_CONTENTS");
                	
                	var certOdiFilter = "${certOidfilter}";
    				var listOdiArr    = certOdiFilter.split(";");
    				var certOidfilter = "";
    				for(var i in listOdiArr) {
    					certOidfilter = certOidfilter + listOdiArr[i] + ",";
    				}
    				certOidfilter = certOidfilter.substring(0, certOidfilter.length-1);
    				
                    magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBack, certOidfilter);
            	}
            });
        }
		
		function mlCallBack(code, message){
	    	
			if(code == 0){ <%-- 정상메시지 --%>
				if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
				if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
				
				var store = new EVF.Store();
                store.doFileUpload(function () {
                	store.setParameter("status", "1");
                	store.setParameter("localServerFlag", localServerFlag);
                	// 인증정보
                	store.setParameter("signedData", document.reqForm.signedData.value);
    				store.setParameter("vidRandom", document.reqForm.vidRandom.value);
    				store.setParameter("idn", document.reqForm.idn.value);
                    store.load(baseUrl + "oetr0051_doSave.so", function () {
                        var pNoticeNum = this.getParameter("NOTICE_NUM");
                        EVF.alert(this.getResponseMessage(), function() {
                            if (opener != null) {
                                opener.doSearch();
                                doClose();
                            }
                        });
                    });
                });
			} else {
				return EVF.alert("결과값 수신에 실패하였습니다.");
			}
		}
		
        function doDelete() {
            var store = new EVF.Store();
            
            if(EVF.V("POPUP_FLAG") == "1") {
            	return EVF.alert("확정된 건은 삭제할 수 없습니다.");
            }
            
            EVF.confirm("${msg.M0013 }", function () {
                store.load(baseUrl + "oetr0051_doDelete.so", function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        if (opener != null) {
                            opener.doSearch();
                        }
                        doClose();
                    });
                });
            });
        }

        function doClear() {
            EVF.confirm("${OETR0051_005 }", function () {
                location.href = baseUrl + "OETR0051/view.so?NOTICE_NUM=&detailView=false";
            });
        }

        function doClose(){
            EVF.closeWindow();
        }

    </script>

    <e:window id="OETR0051" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" useTitleBar="false" title="${form_CAPTION_N }" labelWidth="${longLabelWidth}" width="100%" columnCount="2">
            <e:inputHidden id="NOTICE_NUM" name="NOTICE_NUM" value="${formData.NOTICE_NUM }" />
            <e:inputHidden id="NOTICE_TEXT_NUM" name="NOTICE_TEXT_NUM" value="${formData.NOTICE_TEXT_NUM }" />
            <e:inputHidden id="POPUP_FLAG" name="POPUP_FLAG" value="${formData.POPUP_FLAG }" /> <!-- 확정여부로 사용(1인 경우 수정할 수 없음) -->
            <e:row>
                <e:label for="SUBJECT" title="${form_SUBJECT_N }" />
                <e:field colSpan="3">
                    <e:inputText id="SUBJECT" name="SUBJECT" value="${formData.SUBJECT }" maxLength="${form_SUBJECT_M}" width="${form_SUBJECT_W }" required="${form_SUBJECT_R }" readOnly="${form_SUBJECT_RO }" disabled="${form_SUBJECT_D }"  maskType="${form_SUBJECT_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="VIEW_TYPE" title="${form_VIEW_TYPE_N}"/>
                <e:field>
                    <e:select id="VIEW_TYPE" name="VIEW_TYPE" value="${formData.VIEW_TYPE }" options="${viewTypeOptions}" width="${form_VIEW_TYPE_W}" disabled="${form_VIEW_TYPE_D}" readOnly="${form_VIEW_TYPE_RO}" required="${form_VIEW_TYPE_R}" placeHolder="" maskType="${form_VIEW_TYPE_MT}" usePlaceHolder="false" />
                </e:field>
                <e:label for="FIXED_TOP_FLAG" title="${form_FIXED_TOP_FLAG_N}"/>
                <e:field>
                    <e:check id="FIXED_TOP_FLAG" name="FIXED_TOP_FLAG" value="" checked="${formData.FIXED_TOP_FLAG=='1'?true:false}" label="" readOnly="${form_FIXED_TOP_FLAG_RO }" disabled="${form_FIXED_TOP_FLAG_D }" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="START_DATE" title="${form_START_DATE_N}" />
                <e:field>
                    <e:inputDate id="START_DATE" toDate="END_DATE" name="START_DATE" value="${formData.START_DATE }" width="${inputDateWidth }" datePicker="true" required="${form_START_DATE_R}" disabled="${form_START_DATE_D}" readOnly="${form_START_DATE_RO}" />
                    <e:text>~&nbsp;</e:text>
                    <e:inputDate id="END_DATE" fromDate="START_DATE" name="END_DATE" value="${formData.END_DATE }" width="${inputDateWidth }" datePicker="true" required="${form_END_DATE_R}" disabled="${form_END_DATE_D}" readOnly="${form_END_DATE_RO}" />
                </e:field>
                <e:label for="REG_USER_NM" title="${form_REG_USER_NM_N }" />
                <e:field>
                    <e:inputDate id="REG_DATE" name="REG_DATE" value="${formData.REG_DATE }" width="${inputDateWidth}" datePicker="true" required="${form_REG_DATE_R}" disabled="${form_REG_DATE_D}" readOnly="${form_REG_DATE_RO}" />
                    <e:inputText id="REG_USER_NM" name="REG_USER_NM" value="${formData.REG_USER_NM }" width="${form_REG_USER_NM_W}" maxLength="${form_REG_USER_NM_M}" disabled="${form_REG_USER_NM_D}" readOnly="${form_REG_USER_NM_RO}" required="${form_REG_USER_NM_R}" style="${imeMode}" maskType="${form_REG_USER_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
	            <e:label for="COMMENT2" title="${form_COMMENT2_N}"/>
				<e:field colSpan="3">
					<e:textArea id="COMMENT2" name="COMMENT2" value="${formData.COMMENT2 }" height="80px" width="100%" maxLength="${form_COMMENT2_M}" disabled="${form_COMMENT2_D}" readOnly="${form_COMMENT2_RO}" required="${form_COMMENT2_R}" />
				</e:field>
            </e:row>
            <e:row>
                <e:label for="NOTICE_CONTENTS" title="${form_NOTICE_CONTENTS_N }" />
                <e:field colSpan="3">
                    <e:richTextEditor id="NOTICE_CONTENTS" name="NOTICE_CONTENTS" width="${form_NOTICE_CONTENTS_W }" height="530px" required="${form_NOTICE_CONTENTS_R }" readOnly="${form_NOTICE_CONTENTS_RO }" disabled="${form_NOTICE_CONTENTS_D }" value="${formData.NOTICE_CONTENTS }" useToolbar="${!param.detailView}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N }" />
                <e:field colSpan="3">
                    <e:fileManager id="ATT_FILE_NUM" name="ATT_FILE_NUM" fileId="${formData.ATT_FILE_NUM}" downloadable="true" width="100%" bizType="EC" height="70px" readOnly="${!param.detailView ? false : true }" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" fileExtension="${fileExtension}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <c:if test="${param.detailView == false}">
                <c:if test="${formData.NOTICE_NUM == null}">
	                <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}" data="0" />
                </c:if>
                <c:if test="${formData.NOTICE_NUM != null and formData.POPUP_FLAG != '1'}">
	                <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}" data="0" />
	                <e:button id="doConfirm" name="doConfirm" label="${doConfirm_N}" onClick="doSave" disabled="${doConfirm_D}" visible="${doConfirm_V}" data="1" />
                    <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
                </c:if>
                <e:button id="doClear" name="doClear" label="${doClear_N}" onClick="doClear" disabled="${doClear_D}" visible="${doClear_V}"/>
            </c:if>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>
        
        <%-- 공인인증정보 영역 --%>
		<form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
            <input type="hidden" id="signData" name="signData" value=""/>
            <input type="hidden" id="signedData" name="signedData"/>
            <input type="hidden" id="vidRandom" name="vidRandom"/>
            <input type="hidden" id="vidType" name="vidType" value="client"/>
            <input type="hidden" id="idn" name="idn" value="${ses.irsNum}"/>
        </form>
        <div id="dscertContainer">
            <iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
        </div>
    </e:window>
</e:ui>