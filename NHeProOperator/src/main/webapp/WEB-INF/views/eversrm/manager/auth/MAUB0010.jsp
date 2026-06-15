<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

        var grid = {};
        var addParam = [];
        var baseUrl = "/eversrm/manager/auth/";
        var currentRow;

        function init() {

            grid = EVF.C('grid');

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            grid.setProperty('shrinkToFit', true);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            grid.showCheckBar(false);
        }

        function doSearch() {

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + 'doSelect.so', function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doUserSearch(handler) {
            var param = {
                "BUYER_CD": EVF.V('buyerCd'),
                "callBackFunction": handler
            };
            everPopup.openCommonPopup(param, "SP0011");
        }

        function selectUserIdPopupIntoGrid(data) {

            grid.setCellValue(currentRow, 'CTRL_USER_ID', data.USER_ID);
            grid.setCellValue(currentRow, 'CTRL_USER_ID_ORI', data.USER_ID);
            grid.setCellValue(currentRow, 'USER_NM', data.USER_NM);
            grid.setCellValue(currentRow, 'DEPT_NM', data.DEPT_NM);

            var selectedRow = grid.getSelRowValue();
            var selrowIdxs = grid.getSelrowIdx();
            if (selectedRow.length > 1) {
                EVF.confirm('${BSYT_020_001}', function() {
                    for(var x in selrowIdxs) {
                        var rowIdx = selrowIdxs[x];
                        grid.setCellValue(rowIdx, 'CTRL_USER_ID', data.USER_ID);
                        grid.setCellValue(rowIdx, 'USER_NM', data.USER_NM);
                        grid.setCellValue(rowIdx, 'DEPT_NM', data.DEPT_NM);
                    }
                });
            }
        }

        function doTaskSearch(handler) {
            var param = {
                BUYER_CD: grid.getCellValue(currentRow, 'BUYER_CD'),
                callBackFunction: handler
            };
            everPopup.openCommonPopup(param, "SP0003");
        }

        function selectTaskIdPopupIntoGrid(data) {

            grid.setCellValue(currentRow, 'CTRL_CD', data.CTRL_CD);
            grid.setCellValue(currentRow, 'CTRL_NM', data.CTRL_NM);

            var selectedRow = grid.getSelRowValue();
            var selrowIdxs = grid.getSelrowIdx();
            if (selectedRow.length > 1) {
                EVF.confirm('${BSYT_020_001}', function() {
                    for(var x in selrowIdxs) {
                        var rowIdx = selrowIdxs[x];
                        grid.setCellValue(rowIdx, 'CTRL_CD', data.CTRL_CD);
                        grid.setCellValue(rowIdx, 'CTRL_NM', data.CTRL_NM);
                    }
                })
            }
        }

        function getRegUserId() {
            var param = {
                callBackFunction: "setRegUserId"
            };
            everPopup.openCommonPopup(param, 'SP0011');
        }

        function setRegUserId(dataJsonArray) {
            EVF.V("USER_ID", dataJsonArray.USER_ID);
            EVF.V("USER_NM", dataJsonArray.USER_NM);
        }

    </script>

    <e:window id="MAUB0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${form_CAPTION_N }" columnCount="2" labelWidth="${labelWidth }" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <e:label for="buyerCd" title="${form_buyerCd_N}"/>
                <e:field>
                    <e:select id="buyerCd" name="buyerCd" value="${form.buyerCd}" options="${buyercdOptions}" width="${form_buyerCd_W}" disabled="${form_buyerCd_D}" readOnly="${form_buyerCd_RO}" required="${form_buyerCd_R}" placeHolder="" usePlaceHolder="false"  maskType="${form_buyerCd_MT}"/>
                </e:field>
                <e:label for="CTRL_NM" title="${form_CTRL_NM_N}" />
                <e:field>
                    <e:inputText id="CTRL_NM" name="CTRL_NM" value="" width="${form_CTRL_NM_W}" maxLength="${form_CTRL_NM_M}" disabled="${form_CTRL_NM_D}" readOnly="${form_CTRL_NM_RO}" required="${form_CTRL_NM_R}"  maskType="${form_CTRL_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="USER_NM" title="${form_USER_NM_N }" />
                <e:field>
                    <e:search id="USER_ID" name="USER_ID" value="" width="40%" maxLength="${form_USER_ID_M}" onIconClick="getRegUserId" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}"  maskType="${form_USER_ID_MT}" />
                    <e:inputText id="USER_NM" name="USER_NM"  value="" width="60%" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}"  maskType="${form_USER_NM_MT}" />
                </e:field>
                <e:label for="MOD_FROM_DATE" title="${form_MOD_FROM_DATE_N}"/>
                <e:field>
                    <e:inputDate id="MOD_FROM_DATE" name="MOD_FROM_DATE" value="" width="${inputDateWidth}" datePicker="true" required="${form_MOD_FROM_DATE_R}" disabled="${form_MOD_FROM_DATE_D}" readOnly="${form_MOD_FROM_DATE_RO}" />
                    <e:text>~</e:text>
                    <e:inputDate id="MOD_TO_DATE" name="MOD_TO_DATE" value="" width="${inputDateWidth}" datePicker="true" required="${form_MOD_TO_DATE_R}" disabled="${form_MOD_TO_DATE_D}" readOnly="${form_MOD_TO_DATE_RO}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>