<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/OETR/";

        function init(){
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", true);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            
            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                var USER_ID = "";
                var USER_TYPE = "";

                if(colIdx === "VC_NO") {
                    param = {
                        callbackFunction: "",
                        VC_NO: value,
                        COMPANY_CD: grid.getCellValue(rowIdx, "COMPANY_CD"),
                        detailView: false
                    };
                    everPopup.openPopupByScreenId("OETR0041", 860, 750, param);
                }
                else if(colIdx === "REQ_USER_NM") {
                    USER_TYPE = grid.getCellValue(rowIdx, "REQ_USER_TYPE");
                    USER_ID = grid.getCellValue(rowIdx, "REQ_USER_ID");
                }
                else if(colIdx === "DS_USER_NM") {
                    USER_TYPE = grid.getCellValue(rowIdx, "DS_USER_TYPE");
                    USER_ID = grid.getCellValue(rowIdx, "DS_USER_ID");
                }

                if(USER_ID !== "") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: USER_TYPE,
                        USER_ID: USER_ID,
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
            });
            
            doSearch();
        }

        function onIconClickREQ_COM_CD() {
            var param = {
                callBackFunction: "callbackREQ_COM_CD"
            };
            everPopup.openCommonPopup(param, "SP0118");
        }

        function callbackREQ_COM_CD(data) {
            EVF.V("REQ_COM_CD", data.COMPANY_CD);
            EVF.V("REQ_COM_NM", data.COMPANY_NM);
        }

        function doSearch() {
            var store = new EVF.Store();
            if (!store.validate()) { return; }

            store.setGrid([grid]);
            store.load(baseUrl + "oetr0040_doSearch.so", function () {
            	
            });
        }
    </script>

    <e:window id="OETR0040" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

        <e:searchPanel id="form" title="${form_CAPTION_N}" labelWidth="${labelWidth}" labelAlign="${labelAlign}" columnCount="3" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <e:label for="START_DATE" title="${form_START_DATE_N}"/>
                <e:field>
                    <e:inputDate id="START_DATE" name="START_DATE" value="${START_DATE}" toDate="END_DATE" width="${inputDateWidth}" datePicker="true" required="${form_START_DATE_R}" disabled="${form_START_DATE_D}" readOnly="${form_START_DATE_RO}" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="END_DATE" name="END_DATE" value="${END_DATE}" fromDate="START_DATE" width="${inputDateWidth}" datePicker="true" required="${form_END_DATE_R}" disabled="${form_END_DATE_D}" readOnly="${form_END_DATE_RO}" />
                </e:field>
                <e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
                <e:field>
                    <e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder=""  maskType="${form_PROGRESS_CD_MT}"/>
                </e:field>
                <e:label for="DS_USER_NM" title="${form_DS_USER_NM_N}" />
                <e:field>
                    <e:inputText id="DS_USER_NM" name="DS_USER_NM" value="" width="${form_DS_USER_NM_W}" maxLength="${form_DS_USER_NM_M}" disabled="${form_DS_USER_NM_D}" readOnly="${form_DS_USER_NM_RO}" required="${form_DS_USER_NM_R}"  maskType="${form_DS_USER_NM_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="REQ_COM_CD" title="${form_REQ_COM_CD_N}"/>
                <e:field>
                    <e:search id="REQ_COM_CD" name="REQ_COM_CD" value="" width="40%" maxLength="${form_REQ_COM_CD_M}" onIconClick="${form_REQ_COM_CD_RO ? 'everCommon.blank' : 'onIconClickREQ_COM_CD'}" disabled="${form_REQ_COM_CD_D}" readOnly="${form_REQ_COM_CD_RO}" required="${form_REQ_COM_CD_R}" maskType="${form_REQ_COM_CD_MT}" />
                    <e:inputText id="REQ_COM_NM" name="REQ_COM_NM" value="" width="60%" maxLength="${form_REQ_COM_NM_M}" disabled="${form_REQ_COM_NM_D}" readOnly="${form_REQ_COM_NM_RO}" required="${form_REQ_COM_NM_R}" style="${imeMode}" maskType="${form_REQ_COM_NM_MT}"/>
                </e:field>
                <e:label for="VOC_TYPE" title="${form_VOC_TYPE_N}"/>
                <e:field>
                    <e:select id="VOC_TYPE" name="VOC_TYPE" value="" options="${vocTypeOptions}" width="${form_VOC_TYPE_W}" disabled="${form_VOC_TYPE_D}" readOnly="${form_VOC_TYPE_RO}" required="${form_VOC_TYPE_R}" placeHolder=""  maskType="${form_VOC_TYPE_MT}"/>
                </e:field>
                <e:label for="SUBJECT" title="${form_SUBJECT_N}" />
                <e:field>
					<e:inputText id="SUBJECT" name="SUBJECT" value="" width="${form_SUBJECT_W}" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="REQ_RMK" title="${form_REQ_RMK_N}" />
                <e:field>
					<e:inputText id="REQ_RMK" name="REQ_RMK" value="" width="${form_REQ_RMK_W}" maxLength="${form_REQ_RMK_M}" disabled="${form_REQ_RMK_D}" readOnly="${form_REQ_RMK_RO}" required="${form_REQ_RMK_R}" style="${imeMode}" maskType="${form_REQ_RMK_MT}"/>
                </e:field>
                <e:label for="" title=""/>
				<e:field> </e:field>
				<e:label for="" title=""/>
				<e:field> </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
