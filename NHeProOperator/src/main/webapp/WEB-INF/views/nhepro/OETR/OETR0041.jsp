<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">
        var baseUrl = "/nhepro/OETR/";
		
        function init() {
        	EVF.C('PROGRESS_CD').removeOption('100');
        	EVF.C('PROGRESS_CD').removeOption('200');
        	
        	var PROGRESS_CD = EVF.V("ORG_PROGRESS_CD");
        	if( PROGRESS_CD == "200" || PROGRESS_CD == "300" ) {
            	EVF.C('PROGRESS_CD').setValue("300");
            	EVF.C("DF_RMK").setRequired(false); // 접수(300)인 경우 답변내용 필수 제외
        	} else {
                EVF.C("DF_RMK").setRequired(true);
        	}
        }
		
        function onChangePROGRESS_CD() {
            var C = this;
            var id = C.getID();
            var value = C.getValue();
            var orgValue = EVF.V("ORG_PROGRESS_CD");
			
            if(value != "") {
            	if(value == "300") { // 접수(300)인 경우 답변내용 필수 제외
                	EVF.C("DF_RMK").setRequired(false);
            	} else {
                	EVF.C("DF_RMK").setRequired(true);
            	}
            }
            if(Number(value) < Number(orgValue)) {
                EVF.alert("${OETR0041_001}", function () {
                    EVF.V("PROGRESS_CD", orgValue);
                });
            }
        }

        function doSave() {
            var store = new EVF.Store();
            if (!store.validate()) { return; }
			
            var detailView  = false;
            var PROGRESS_CD = EVF.V("PROGRESS_CD");
            if( PROGRESS_CD == "200" || PROGRESS_CD == "300" || PROGRESS_CD == "400" ) {
                detailView = false;
            } else {
                detailView = true;
            }
            
            EVF.confirm("${msg.M0021}", function () {
                store.doFileUpload(function() {
                    store.load(baseUrl + "oetr0041_doSave.so", function() {
                    	var vcNum = this.getParameter('VC_NO');
                    	var companyCd = this.getParameter('COMPANY_CD');
                    	var param = {
                                VC_NO: vcNum,
                                COMPANY_CD: companyCd,
                                detailView: false
                            };
                    	
                        EVF.alert(this.getResponseMessage(), function() {
                            if(opener) {
                                opener.doSearch();
                            }
                            if(PROGRESS_CD == "500") {
                            	doClose();
                            } else {
                            	location.href = baseUrl + 'OETR0041/view.so?' + $.param(param);
                            }
                        });
                    });
                });
            });
        }
		
        function doClose() {
            EVF.closeWindow();
        }
    </script>

    <e:window id="OETR0041" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="COMPANY_CD" name="COMPANY_CD" value="${formData.COMPANY_CD}"/> <!-- 요청자 고객코드 -->
        <e:inputHidden id="REQ_USER_ID" name="REQ_USER_ID" value="${formData.REQ_USER_ID}"/> <!-- 요청자ID -->
        <e:inputHidden id="DS_USER_ID" name="DS_USER_ID" value="${formData.DS_USER_ID}"/> <!-- 조치자ID -->
        <e:inputHidden id="ORG_PROGRESS_CD" name="ORG_PROGRESS_CD" value="${formData.ORG_PROGRESS_CD}"/>
        <e:inputHidden id="VOC_OBJ" name="VOC_OBJ" value="${formData.VOC_OBJ}"/> <!-- VOC대상코드 -->
        <e:inputHidden id="VOC_OBJ_SUP_CD" name="VOC_OBJ_SUP_CD"/> <!-- VOC대상업체코드 -->
        <e:inputHidden id="VOC_TYPE_NM" name="VOC_TYPE_NM" value="${formData.VOC_TYPE_NM}"/>

        <e:searchPanel id="form1" title="${form_CAPTION_N}" labelWidth="120px" labelAlign="${labelAlign}" columnCount="2" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <e:label for="VC_NO" title="${form_VC_NO_N}" />
                <e:field>
                    <e:inputText id="VC_NO" name="VC_NO" value="${formData.VC_NO}" width="${form_VC_NO_W}" maxLength="${form_VC_NO_M}" disabled="${form_VC_NO_D}" readOnly="${form_VC_NO_RO}" required="${form_VC_NO_R}"  maskType="${form_VC_NO_MT}" />
                </e:field>
                <e:label for="REQ_COM_CD" title="${form_REQ_COM_CD_N}" />
                <e:field>
                    <e:inputText id="REQ_COM_CD" name="REQ_COM_CD" value="${formData.REQ_COM_CD}" width="26%" maxLength="${form_REQ_COM_CD_M}" disabled="${form_REQ_COM_CD_D}" readOnly="${form_REQ_COM_CD_RO}" required="${form_REQ_COM_CD_R}" style="${imeMode}" maskType="${form_REQ_COM_CD_MT}"/>
                    <e:text>/</e:text>
                    <e:inputText id="REQ_COM_NM" name="REQ_COM_NM" value="${formData.REQ_COM_NM}" width="68%" maxLength="${form_REQ_COM_NM_M}" disabled="${form_REQ_COM_NM_D}" readOnly="${form_REQ_COM_NM_RO}" required="${form_REQ_COM_NM_R}" style="${imeMode}" maskType="${form_REQ_COM_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="REQ_USER_NM" title="${form_REQ_USER_NM_N}" />
                <e:field>
                    <e:inputText id="REQ_USER_NM" name="REQ_USER_NM" value="${formData.REQ_USER_NM}" width="40%" maxLength="${form_REQ_USER_NM_M}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}" style="${imeMode}" maskType="${form_REQ_USER_NM_MT}"/>
                    <e:text>/</e:text>
                    <e:inputText id="REQ_DATE" name="REQ_DATE" value="${formData.REQ_DATE}" width="54%" maxLength="${form_REQ_DATE_M}" disabled="${form_REQ_DATE_D}" readOnly="${form_REQ_DATE_RO}" required="${form_REQ_DATE_R}" style="${imeMode}" maskType="${form_REQ_DATE_MT}"/>
                </e:field>
                <e:label for="DEPT_NM" title="${form_DEPT_NM_N}" />
                <e:field>
                    <e:inputText id="DEPT_NM" name="DEPT_NM" value="${formData.DEPT_NM}" width="${form_DEPT_NM_W}" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}" style="${imeMode}" maskType="${form_DEPT_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="VOC_TYPE" title="${form_VOC_TYPE_N}"/>
                <e:field>
                    <e:select id="VOC_TYPE" name="VOC_TYPE" value="${formData.VOC_TYPE}" options="${vocTypeOptions}" width="${form_VOC_TYPE_W}" disabled="${form_VOC_TYPE_D}" readOnly="${form_VOC_TYPE_RO}" required="${form_VOC_TYPE_R}" placeHolder="" maskType="${form_VOC_TYPE_MT}" />
                </e:field>
                <e:label for="PH_DATE" title="${form_PH_DATE_N}"/>
                <e:field>
                    <e:inputDate id="PH_DATE" name="PH_DATE" fromDate="PH_DATE" value="${formData.PH_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_PH_DATE_R}" disabled="${form_PH_DATE_D}" readOnly="${form_PH_DATE_RO}" />
                </e:field>
            </e:row>
            <%-- 사용하지 않음으로 제외
            <e:row>
                <e:label for="VOC_OBJ" title="${form_VOC_OBJ_N}"/>
                <e:field colSpan="3">
                    <e:select id="VOC_OBJ" name="VOC_OBJ" value="${formData.VOC_OBJ}" onChange="onChangeVOC_OBJ" options="${vocObjOptions}" width="${form_VOC_OBJ_W}" disabled="${form_VOC_OBJ_D}" readOnly="${form_VOC_OBJ_RO}" required="${form_VOC_OBJ_R}" placeHolder="" maskType="${form_VOC_OBJ_MT}" />
                </e:field>
                <e:label for="VOC_OBJ_SUP_NM" title="${form_VOC_OBJ_SUP_NM_N}"/>
                <e:field>
                    <e:search id="VOC_OBJ_SUP_NM" name="VOC_OBJ_SUP_NM" value="" width="${form_VOC_OBJ_SUP_NM_W}" maxLength="${form_VOC_OBJ_SUP_NM_M}" onIconClick="onIconClickVOC_OBJ_SUP_NM" disabled="${form_VOC_OBJ_SUP_NM_D}" readOnly="${form_VOC_OBJ_SUP_NM_RO}" required="${form_VOC_OBJ_SUP_NM_R}" maskType="${form_VOC_OBJ_SUP_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="ORDER_NO" title="${form_ORDER_NO_N}" />
                <e:field>
                    <e:inputText id="ORDER_NO" name="ORDER_NO" value="${formData.ORDER_NO}" width="${form_ORDER_NO_W}" maxLength="${form_ORDER_NO_M}" disabled="${form_ORDER_NO_D}" readOnly="${form_ORDER_NO_RO}" required="${form_ORDER_NO_R}" style="${imeMode}" maskType="${form_ORDER_NO_MT}"/>
                </e:field>
                <e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
                <e:field>
                    <e:inputText id="ITEM_CD" name="ITEM_CD" value="${formData.ITEM_CD}" width="${form_ITEM_CD_W}" maxLength="${form_ITEM_CD_M}" disabled="${form_ITEM_CD_D}" readOnly="${form_ITEM_CD_RO}" required="${form_ITEM_CD_R}" style="${imeMode}" maskType="${form_ITEM_CD_MT}"/>
                </e:field>
            </e:row>
            --%>
            <e:row>
	            <e:label for="SUBJECT" title="${form_SUBJECT_N}" />
				<e:field colSpan="3">
					<e:inputText id="SUBJECT" name="SUBJECT" value="${formData.SUBJECT}" width="${form_SUBJECT_W}" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
				</e:field>
			</e:row>
            <e:row>
                <e:label for="REQ_RMK" title="${form_REQ_RMK_N}"/>
                <e:field colSpan="3">
                    <e:textArea id="REQ_RMK" name="REQ_RMK" value="${formData.REQ_RMK}" height="120px" width="${form_REQ_RMK_W}" maxLength="${form_REQ_RMK_M}" disabled="${form_REQ_RMK_D}" readOnly="${form_REQ_RMK_RO}" required="${form_REQ_RMK_R}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="ATTACH_FILE_NO" title="${form_ATTACH_FILE_NO_N}" />
                <e:field colSpan="3">
                    <e:fileManager id="ATTACH_FILE_NO" name="ATTACH_FILE_NO" readOnly="${form_ATTACH_FILE_NO_RO}"  fileId="${formData.ATTACH_FILE_NO}" downloadable="true" width="100%" bizType="MP" height="90px" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" />
                </e:field>
            </e:row>
        </e:searchPanel>
        
        <e:buttonBar title="조치정보" width="100%" align="right" />
		<e:searchPanel id="form2" title="${form_CAPTION_N}" labelWidth="120px" labelAlign="${labelAlign}" columnCount="2" useTitleBar="false" onEnter="">
        	<e:row>
                <e:label for="RECV_DATE" title="${form_RECV_DATE_N}" />
                <e:field>
                    <e:inputText id="RECV_DATE" name="RECV_DATE" value="${formData.RECV_DATE}" width="${form_RECV_DATE_W}" maxLength="${form_RECV_DATE_M}" disabled="${form_RECV_DATE_D}" readOnly="${form_RECV_DATE_RO}" required="${form_RECV_DATE_R}" style="${imeMode}" maskType="${form_RECV_DATE_MT}"/>
                </e:field>
                <e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
                <e:field>
                    <e:select id="PROGRESS_CD" name="PROGRESS_CD" value="${formData.PROGRESS_CD}" onChange="onChangePROGRESS_CD" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="DS_USER_NM" title="${form_DS_USER_NM_N}" />
                <e:field>
                    <e:inputText id="DS_USER_NM" name="DS_USER_NM" value="${formData.DS_USER_NM}" width="${form_DS_USER_NM_W}" maxLength="${form_DS_USER_NM_M}" disabled="${form_DS_USER_NM_D}" readOnly="${form_DS_USER_NM_RO}" required="${form_DS_USER_NM_R}"  maskType="${form_DS_USER_NM_MT}" />
                </e:field>
                <e:label for="CD_DATE" title="${form_CD_DATE_N}"/>
                <e:field>
                    <e:inputDate id="CD_DATE" name="CD_DATE" value="${formData.CD_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_CD_DATE_R}" disabled="${form_CD_DATE_D}" readOnly="${form_CD_DATE_RO}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="DS_DATE" title="${form_DS_DATE_N}" />
                <e:field>
                    <e:inputText id="DS_DATE" name="DS_DATE" value="${formData.DS_DATE}" width="${form_DS_DATE_W}" maxLength="${form_DS_DATE_M}" disabled="${form_DS_DATE_D}" readOnly="${form_DS_DATE_RO}" required="${form_DS_DATE_R}"  maskType="${form_DS_DATE_MT}" />
                </e:field>
                <e:label for="RUB_TYPE" title="${form_RUB_TYPE_N}"/>
                <e:field>
                    <e:select id="RUB_TYPE" name="RUB_TYPE" value="${formData.RUB_TYPE}" options="${rubTypeOptions}" width="${form_RUB_TYPE_W}" disabled="${form_RUB_TYPE_D}" readOnly="${form_RUB_TYPE_RO}" required="${form_RUB_TYPE_R}" placeHolder="" maskType="${form_RUB_TYPE_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="DF_RMK" title="${form_DF_RMK_N}"/>
                <e:field colSpan="3">
                    <e:textArea id="DF_RMK" name="DF_RMK" value="${formData.DF_RMK}" height="90px" width="${form_DF_RMK_W}" maxLength="${form_DF_RMK_M}" disabled="${form_DF_RMK_D}" readOnly="${form_DF_RMK_RO}" required="${form_DF_RMK_R}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="DS_ATTACH_FILE_NO" title="${form_DS_ATTACH_FILE_NO_N}" />
                <e:field colSpan="3">
                    <e:fileManager id="DS_ATTACH_FILE_NO" name="DS_ATTACH_FILE_NO" readOnly="${form_DS_ATTACH_FILE_NO_RO}"  fileId="${formData.DS_ATTACH_FILE_NO}" downloadable="true" width="100%" bizType="MP" height="90px" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar align="right" width="100%">
            <c:if test="${formData.PROGRESS_CD != 500}">
                <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            </c:if>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>
    </e:window>
</e:ui>
