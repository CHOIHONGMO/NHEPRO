<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/CETR/";

        function init(){
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", true);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            
            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                var USER_ID = "";
                var USER_TYPE;
                var detailView;
                var REQ_COM_CD  = grid.getCellValue(rowIdx, "REQ_COM_CD");
                var REQ_DEPT_CD = grid.getCellValue(rowIdx, "DEPT_CD");

                if(colIdx == "VC_NO") {
                    var PROGRESS_CD = grid.getCellValue(rowIdx, "MAX_PROGRESS_CD");
                    if(PROGRESS_CD == "200" || PROGRESS_CD == "300" || PROGRESS_CD == "400" || PROGRESS_CD == "500") {
                        if(REQ_COM_CD == "${ses.companyCd}" && REQ_DEPT_CD == "${ses.deptCd}") {
                            detailView = true;
                            buttonView = false;
                        } else {
                            detailView = true;
                            buttonView = true;
                        }
                    } else {
                        detailView = false;
                        buttonView = false;
                    }
                    
                    param = {
                        callbackFunction: "",
                        VC_NO: grid.getCellValue(rowIdx, "VC_NO"),
                        VC_SQ: "",
                        COMPANY_CD: grid.getCellValue(rowIdx, "COMPANY_CD"),
                        detailView: detailView,
                        buttonView: buttonView
                    };
                    everPopup.openPopupByScreenId("CETR0051", 860, 950, param);
                }
                else if(colIdx == "VOC_OBJ_SUP_NM") {
                    var PROGRESS_CD = grid.getCellValue(rowIdx, "PROGRESS_CD");
                    if( PROGRESS_CD == "" || PROGRESS_CD == "100" ) {
                    	return EVF.alert("요청되지 않았습니다. 진행상태를 확인하세요.");
                    }
                    
                    if(REQ_COM_CD == "${ses.companyCd}" && REQ_DEPT_CD == "${ses.deptCd}") {
                        detailView = true;
                        buttonView = false;
                    } else {
                        detailView = true;
                        buttonView = true;
                    }
                    
                    param = {
                        callbackFunction: "",
                        VC_NO: grid.getCellValue(rowIdx, "VC_NO"),
                        VC_SQ: grid.getCellValue(rowIdx, "VC_SQ"),
                        COMPANY_CD: grid.getCellValue(rowIdx, "COMPANY_CD"),
                        detailView: detailView,
                        buttonView: buttonView
                    };
                    everPopup.openPopupByScreenId("CETR0051", 860, 950, param);
                }
                else if(colIdx == "REQ_USER_NM") {
                    USER_TYPE = grid.getCellValue(rowIdx, "REQ_USER_TYPE");
                    USER_ID   = grid.getCellValue(rowIdx, "REQ_USER_ID");
                }
                else if(colIdx == "DS_USER_NM") {
                    USER_TYPE = grid.getCellValue(rowIdx, "DS_USER_TYPE");
                    USER_ID   = grid.getCellValue(rowIdx, "DS_USER_ID");
                }
				
                if( USER_ID != "" ) {
                    param = {
	                        callbackFunction: "",
	                        USER_TYPE: USER_TYPE,
	                        USER_ID: USER_ID,
	                        detailView: true
	                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
            });
            
            // 컬럼 통합
            grid.setColMerge(["VC_NO", "VOC_TYPE", "VOC_TYPE_NM", "REQ_USER_ID", "REQ_USER_NM", "REQ_COM_CD", "REQ_COM_NM", "SUBJECT", "REQ_DATE", "PH_DATE"]);
            
            doSearch();
        }

        function onIconClickVOC_OBJ_SUP_CD() {
            var param = {
                callBackFunction: "callbackVOC_OBJ_SUP_CD"
            };
            everPopup.openCommonPopup(param, "SP0066");
        }

        function callbackVOC_OBJ_SUP_CD(data) {
            EVF.V("VOC_OBJ_SUP_CD", data.CUST_CD);
            EVF.V("VOC_OBJ_SUP_NM", data.CUST_NM);
        }

        function doSearch() {
            var store = new EVF.Store();
            if (!store.validate()) { return; }
            store.setGrid([grid]);
            store.load(baseUrl + "cetr0050_doSearch.so", function () {
                if(grid.getRowCount() === 0) {
                    return EVF.alert("${msg.M0002}");
                }
            });
        }
        
        function doSearchMyBiz() {
            var store = new EVF.Store();
            if (!store.validate()) { return; }
            store.setGrid([grid]);
            store.load(baseUrl + "cetr0050_doSearchMyBiz.so", function () {
                if(grid.getRowCount() === 0) {
                    return EVF.alert("${msg.M0002}");
                }
            });
        }

        function doCreate() {
            var param = {
                callbackFunction: "doSearch",
                VC_NO: "",
                vocType: "",
                detailView: false
            };
            everPopup.openPopupByScreenId("CETR0051", 860, 950, param);
        }
    </script>

    <e:window id="CETR0050" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

        <e:searchPanel id="form" title="${form_CAPTION_N}" labelWidth="${labelWidth}" labelAlign="${labelAlign}" columnCount="3" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <e:label for="START_DATE" title="${form_START_DATE_N}"/>
                <e:field>
                    <e:inputDate id="START_DATE" name="START_DATE" value="${START_DATE}" toDate="END_DATE" width="${inputDateWidth}" datePicker="true" required="${form_START_DATE_R}" disabled="${form_START_DATE_D}" readOnly="${form_START_DATE_RO}" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="END_DATE" name="END_DATE" value="${END_DATE}" fromDate="START_DATE" width="${inputDateWidth}" datePicker="true" required="${form_END_DATE_R}" disabled="${form_END_DATE_D}" readOnly="${form_END_DATE_RO}" />
                </e:field>
                <e:label for="VOC_TYPE" title="${form_VOC_TYPE_N}"/>
                <e:field>
                    <e:select id="VOC_TYPE" name="VOC_TYPE" value="" options="${vocTypeOptions}" width="${form_VOC_TYPE_W}" disabled="${form_VOC_TYPE_D}" readOnly="${form_VOC_TYPE_RO}" required="${form_VOC_TYPE_R}" placeHolder=""  maskType="${form_VOC_TYPE_MT}"/>
                </e:field>
                <e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
                <e:field>
                    <e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder=""  maskType="${form_PROGRESS_CD_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="PH_FLAG" title="${form_PH_FLAG_N}" />
                <e:field>
					<e:checkGroup id="PH_FLAG" name="PH_FLAG" width="${form_PH_FLAG_W}" value="" disabled="${form_PH_FLAG_D}" readOnly="${form_PH_FLAG_RO}" required="${form_PH_FLAG_R}">
						<e:check id="PH_FLAG1" name="PH_FLAG1" value="1" />
					</e:checkGroup>
                </e:field>
                <e:label for="DS_USER_NM" title="${form_DS_USER_NM_N}" />
				<e:field>
					<e:inputText id="DS_USER_NM" name="DS_USER_NM" value="" width="${form_DS_USER_NM_W}" maxLength="${form_DS_USER_NM_M}" disabled="${form_DS_USER_NM_D}" readOnly="${form_DS_USER_NM_RO}" required="${form_DS_USER_NM_R}" style="${imeMode}" maskType="${form_DS_USER_NM_MT}"/>
				</e:field>
                <e:label for="VOC_OBJ_SUP_CD" title="${form_VOC_OBJ_SUP_CD_N}"/>
                <e:field>
                    <e:search id="VOC_OBJ_SUP_CD" name="VOC_OBJ_SUP_CD" value="" width="40%" maxLength="${form_VOC_OBJ_SUP_CD_M}" onIconClick="${form_VOC_OBJ_SUP_CD_RO ? 'everCommon.blank' : 'onIconClickVOC_OBJ_SUP_CD'}" disabled="${form_VOC_OBJ_SUP_CD_D}" readOnly="${form_VOC_OBJ_SUP_CD_RO}" required="${form_VOC_OBJ_SUP_CD_R}" maskType="${form_VOC_OBJ_SUP_CD_MT}" />
                    <e:inputText id="VOC_OBJ_SUP_NM" name="VOC_OBJ_SUP_NM" value="" width="60%" maxLength="${form_VOC_OBJ_SUP_NM_M}" disabled="${form_VOC_OBJ_SUP_NM_D}" readOnly="${form_VOC_OBJ_SUP_NM_RO}" required="${form_VOC_OBJ_SUP_NM_R}" style="${imeMode}" maskType="${form_VOC_OBJ_SUP_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="SUBJECT" title="${form_SUBJECT_N}" />
                <e:field>
					<e:inputText id="SUBJECT" name="SUBJECT" value="" width="${form_SUBJECT_W}" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
                </e:field>
                <e:label for="" title=""/>
				<e:field> </e:field>
				<e:label for="" title=""/>
				<e:field> </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar align="right" width="100%" title="업무연락 회신시 '업무연락 대상고객' 클릭하여 회신 가능">
            <e:button id="doCreate" name="doCreate" label="${doCreate_N}" onClick="doCreate" disabled="${doCreate_D}" visible="${doCreate_V}" align="left"/>
            
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doSearchMyBiz" name="doSearchMyBiz" label="${doSearchMyBiz_N}" onClick="doSearchMyBiz" disabled="${doSearchMyBiz_D}" visible="${doSearchMyBiz_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

    </e:window>
</e:ui>

