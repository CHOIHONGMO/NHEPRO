<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var grid;
        var baseUrl = "/nhepro/SBDR/";
        var eventRowId = 0;

        function init() {

            grid = EVF.C("grid");

            grid.cellClickEvent(function(rowIdx, colIdx, value) {

                if(colIdx == "ANN_NO") {

                    var param = {
                        'buyerCd' : grid.getCellValue(rowIdx, 'BUYER_CD'),
                        'bidNum' : grid.getCellValue(rowIdx, 'BID_NUM'),
                        'bidCnt' : grid.getCellValue(rowIdx, 'BID_CNT'),
                        'popupFlag' : true,
                        'detailView' : true
                    };
                    <%-- 입찰공고 상세화면을 Popup으로 open. --%>
                    var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
                    var callUrl = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? "/nhepro/SBDR/SBDR0012/view.so" : "/nhepro/SBDR/SBDR0011/view.so");
                    var callHeight = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? 700 : 900);
                    everPopup.openWindowPopup(callUrl, 1200, callHeight, param, "bidDetail", true);
                }
                if(colIdx == "BID_AMT") {

                    var param = {
                        buyerCd: grid.getCellValue(rowIdx, 'BUYER_CD'),
                        bidNum: grid.getCellValue(rowIdx, 'BID_NUM'),
                        bidCnt : grid.getCellValue(rowIdx, 'BID_CNT'),
                        voteCnt : grid.getCellValue(rowIdx, 'VOTE_CNT'),
                        vendorCd : "${ses.companyCd}",
                        detailView: ((grid.getCellValue(rowIdx, 'ADJ_PRC_STATUS') == "100" || grid.getCellValue(rowIdx, 'ADJ_PRC_STATUS') == "300") ? false : true),
                        popupFlag: true
                    };
                    var url = '/nhepro/SBDR/SBDI0021/view.so';
                    everPopup.openWindowPopup(url, 1200, 800, param, 'sendBidDocumentPopup');
                }
            });

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            grid.setProperty('shrinkToFit', false);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${multiSelect});        // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            doSearch();

        }

        function doSearch() {

            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.load(baseUrl + 'sbdr0030_doSearch.so', function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002}");
                } else {
                    var rowIds = grid.getAllRowId();
                    for(var i in rowIds) {
                        if(grid.getCellValue(rowIds[i], 'SETTLE_FLAG') == "Y") {
                            grid.setCellFontColor(rowIds[i], 'SETTLE_FLAG', "#b57946");
                            grid.setCellFontWeight(rowIds[i], 'SETTLE_FLAG', true);
                        }
                        if(grid.getCellValue(rowIds[i], 'SETTLE_VENDOR_CD') == "${ses.companyCd}") {
                            grid.setCellFontColor(rowIds[i], 'SETTLE_VENDOR_NM', "#b57946");
                            grid.setCellFontWeight(rowIds[i], 'SETTLE_VENDOR_NM', true);
                            grid.setCellFontColor(rowIds[i], 'SETTLE_AMT', "#b57946");
                            grid.setCellFontWeight(rowIds[i], 'SETTLE_AMT', true);
                        }
                        if(grid.getCellValue(rowIds[i], 'SETTLE_VENDOR_CD') == "-") {
                            grid.setCellFontAlign(rowIds[i], 'SETTLE_VENDOR_NM', "center");
                        }
                    }
                }
            });
        }

        function doSendPrc() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
			
            var buyerCd;
            var bidNum;
            var bidCnt;
            var voteCnt;
            var adjPrcStatus;
            var rowIds = grid.getSelRowId();
            for(var i in rowIds) {
                buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
                bidNum  = grid.getCellValue(rowIds[i], 'BID_NUM');
                bidCnt  = grid.getCellValue(rowIds[i], 'BID_CNT');
                voteCnt = grid.getCellValue(rowIds[i], 'VOTE_CNT');
                adjPrcStatus = grid.getCellValue(rowIds[i], 'ADJ_PRC_STATUS');
                
                // 2021.11.02 : 임시저장 기능 추가
                // 100 : 대상, 150 : 임시저장, 300 : 반려
                if(adjPrcStatus != "100" && adjPrcStatus != '150' && adjPrcStatus != "300") {
                    return EVF.alert("${SBDR0030_002}");
                }
            }
			
            var param = {
                buyerCd: buyerCd,
                bidNum: bidNum,
                bidCnt : bidCnt,
                voteCnt : voteCnt,
                vendorCd : "${ses.companyCd}",
                detailView: ((adjPrcStatus == "100" || adjPrcStatus == "150" || adjPrcStatus == "300") ? false : true),
                popupFlag: true
            };
            var url = '/nhepro/SBDR/SBDI0021/view.so';
            everPopup.openWindowPopup(url, 1200, 800, param, 'sendBidDocumentPopup');
        }

    </script>
    <e:window id="SBDR0030" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <e:label for="BID_FROM_DATE" title="${form_BID_FROM_DATE_N}"/>
                <e:field>
                    <e:inputDate id="BID_FROM_DATE" name="BID_FROM_DATE" toDate="BID_TO_DATE" value="${fromDate }" width="${inputDateWidth }" datePicker="true" required="${form_BID_FROM_DATE_R}" disabled="${form_BID_FROM_DATE_D}" readOnly="${form_BID_FROM_DATE_RO}" />
                    <e:text>~</e:text>
                    <e:inputDate id="BID_TO_DATE" name="BID_TO_DATE" fromDate="BID_FROM_DATE" value="${toDate }" width="${inputDateWidth }" datePicker="true" required="${form_BID_TO_DATE_R}" disabled="${form_BID_TO_DATE_D}" readOnly="${form_BID_TO_DATE_RO}" />
                </e:field>
                <e:label for="SETTLE_FLAG" title="${form_SETTLE_FLAG_N}" />
                <e:field>
                    <e:select id="SETTLE_FLAG" name="SETTLE_FLAG" value="" options="${settleFlagOptions }" width="${form_SETTLE_FLAG_W }" disabled="${form_SETTLE_FLAG_D}" readOnly="${form_SETTLE_FLAG_RO}" required="${form_SETTLE_FLAG_R}" placeHolder="" />
                </e:field>
            </e:row>
            <e:row >
                <e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
                <e:field>
                    <e:inputText id="ANN_NO" name="ANN_NO" value="" width="${form_ANN_NO_W}" maxLength="${form_ANN_NO_M}" disabled="${form_ANN_NO_D}" readOnly="${form_ANN_NO_RO}" required="${form_ANN_NO_R}" />
                </e:field>
                <e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
                <e:field>
                    <e:inputText id="ANN_ITEM" name="ANN_ITEM" value="" width="${form_ANN_ITEM_W}" maxLength="${form_ANN_ITEM_M}" disabled="${form_ANN_ITEM_D}" readOnly="${form_ANN_ITEM_RO}" required="${form_ANN_ITEM_R}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N}" disabled="${Search_D}" visible="${Search_V}" onClick="doSearch" />
            <e:button id="SendPrc" name="SendPrc" label="${SendPrc_N}" disabled="${SendPrc_D}" visible="${SendPrc_V}" onClick="doSendPrc" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

    </e:window>
</e:ui>
