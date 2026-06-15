<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 협력회사선택 화면 --%>
<%@ taglib uri="http://www.st-ones.com/eversrm" prefix="e"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

        var gridL;
        var gridR;
        var baseUrl = "/nhepro/CBDI/";
        var conFlag = "${empty param.CON_FLAG ? "Y" : param.CON_FLAG}";

        function init() {

            gridL = EVF.C("gridL");
            gridR = EVF.C("gridR");
            var json = ${empty param.candidateJson ? '[]' : param.candidateJson};
            var callType = "${empty param.callType ? "" : param.callType}";

            if(json.length != 0) {
                var vendors = [];
                for(var v in json) {
                    if(json.hasOwnProperty(v)){
                        vendors.push(json[v].VENDOR_CD);
                    }
                }
                var store = new EVF.Store();
                store.setGrid([gridR]);
                store.setParameter('selectedVendors', JSON.stringify(vendors));
                store.load(baseUrl + "cbdr0016_doSearchCandidate.so", function() {
                    gridR.checkAll(true);
                });
            }
			
            gridL.cellClickEvent(function(rowIdx, colIdx, value) {
                switch (colIdx) {
                    case "VENDOR_NM":
                    	gridL.checkRow(rowIdx, true);
                    	doSendRight(rowIdx, false);
                        break;
                }
            });
            
            gridL.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            gridR.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            gridL.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridL.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridL.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridL.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridL.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridL.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridL.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            gridL.setProperty('multiSelect', true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]

            gridR.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridR.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridR.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridR.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridR.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridR.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridR.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            gridR.setProperty('multiSelect', true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            doSearch();
        }

        function doSearch() {

            var store = new EVF.Store();
            store.setGrid([gridL, gridR]);
            store.setParameter("CON_FLAG", conFlag);
            store.load(baseUrl + "cbdr0016_doSearchCandidate.so", function() {

                if (gridL.getRowCount() == 0) {
                    EVF.alert("${msg.M0002 }");
                }
                if (gridL.getRowCount() == 1) {
                    gridL.checkAll(true);
                    doSendRight('', true);
                }
            });
        }

        function doSelect() {

            var selAllRowDataR = gridR.getSelRowValue();
            if (gridR.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            opener.window['${param.callBackFunction}'](JSON.stringify(selAllRowDataR));
            doClose();
        }

        function doSendLeft() {
        	if (gridR.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
            var rowIdx = gridR.getSelRowId();
            for(var x = rowIdx.length - 1; x >= 0; x--) {
                gridR.delRow(rowIdx[x]);
            }
        }

        function doSendRight(rowIdx, btnFlag) {
        	var data;
            if(btnFlag) {
                if (gridL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				
                data = valid.equalPopupValid(JSON.stringify(gridL.getSelRowValue()), gridR, "VENDOR_CD");
            } else {
                var dataArr = [];
                dataArr.push(gridL.getRowValue(rowIdx));
                data = valid.equalPopupValid(JSON.stringify(dataArr), gridR, "VENDOR_CD");
            }
            gridR.addRow(data);
            /**
             * 2021.03.30 제외
            if (gridL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
            gridR.checkAll(true);
            var selAllRowDataL = gridL.getSelRowValue();
            var selAllRowDataR = gridR.getSelRowValue();

            var vendors = [];
            for(var v in selAllRowDataL) {
                if(selAllRowDataL.hasOwnProperty(v)){
                    vendors.push(selAllRowDataL[v].VENDOR_CD);
                }
            }

            for(var v in selAllRowDataR) {
                if(selAllRowDataR.hasOwnProperty(v)){
                    vendors.push(selAllRowDataR[v].VENDOR_CD);
                }
            }

            var store = new EVF.Store();
            store.setGrid([gridR]);
            store.setParameter('selectedVendors', JSON.stringify(vendors));
            store.load(baseUrl + "cbdr0016_doSearchCandidate.so", function() {
                gridR.checkAll(true);
            });
            */
        }

        function searchVendorCd() {
            var param = {
                callBackFunction : "selectVendorCd"
            };
            everPopup.openCommonPopup(param, (conFlag == "Y" ? "SP0013" : "SP0063"));
        }

        function selectVendorCd(data) {
            EVF.V("VENDOR_CD", data.VENDOR_CD);
            EVF.V("VENDOR_NM", data.VENDOR_NM);
            if(!EVF.isEmpty(data.VENDOR_CD)) {
                doSearch();
            }
        }

        function doClose() {
            EVF.closeWindow();
        }

    </script>

    <e:window id="CBDR0016" onReady="init" initData="${initData}" title="${screenName}">
        <e:searchPanel id="form1" title="${msg.M9999 }" columnCount="2" labelWidth="135" onEnter="doSearch" useTitleBar="false">
            <e:row>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
                <e:field>
                    <e:inputText id="VENDOR_CD" style="${imeMode}" name="VENDOR_CD" value="" width="${form_VENDOR_CD_W}" maxLength="${form_VENDOR_CD_M}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}"/>
                    <%-- e:search id="VENDOR_NM" style="ime-mode:inactive" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" onIconClick="${form_VENDOR_NM_RO ? 'everCommon.blank' : 'searchVendorCd'}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" / --%>
                </e:field>
                <e:label for="VENDOR_NM" title="${form_VENDOR_NM_N}"/>
                <e:field>
                    <e:inputText id="VENDOR_NM" style="${imeMode}" name="VENDOR_NM" value="" width="${form_VENDOR_NM_W}" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}"/>
                </e:field>

            </e:row>
        </e:searchPanel>

        <e:buttonBar align="right">
            <e:button id="Search" name="Search" label='${Search_N }' disabled='${Search_D }' visible='${Search_V }' onClick='doSearch' />
        <c:if test="${!param.detailView}">
            <e:button id="Select" name="Select" label='${Select_N }' disabled='${Select_D }' visible='${Select_V }' onClick='doSelect' />
        </c:if>
            <e:button id="Close" name="Close" label='${Close_N }' disabled='${Close_D }' visible='${Close_V }' onClick='doClose' />
        </e:buttonBar>

        <e:panel height="fit" width="100%">
            <e:panel width="49%">
                <e:title title="${CBDR0016_0002 }" />
                <e:gridPanel gridType="${_gridType}" id="gridL" name="gridL" height="fit" width="100%"/>
            </e:panel>
            <e:panel width="2%" height="100%">
                <div style="width: 100%; margin-top: 200px; vertical-align: middle;" align="center">
                <c:if test="${param.VENDORSELTYPE != 'NOTSEL'}">
                    <div id="doSendRight" style="background: url(/images/eversrm/button/thumb_next.png) no-repeat; width: 13px; height: 22px; display: inline-block; cursor: pointer;" onclick="doSendRight('', true);">&nbsp;</div>
                </c:if>
                    <div id="doSendLeft" style="background: url(/images/eversrm/button/thumb_prev.png) no-repeat; width: 13px; height: 22px; display: inline-block; margin-top: 10px; cursor: pointer;" onclick="doSendLeft();">&nbsp;</div>
                </div>
            </e:panel>
            <e:panel width="49%">
                <e:title title="${CBDR0016_0001}" />
                <e:gridPanel gridType="${_gridType}" id="gridR" name="gridR" height="fit" width="100%"/>
            </e:panel>
        </e:panel>
    </e:window>
</e:ui>
