<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

        var baseUrl = "/eversrm/manager/org/";
        var grid = {};
        var flag = "";

        function init() {

            grid = EVF.C('grid');

            grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            grid.cellClickEvent(function (rowIdx, colIdx, value, iRow, iCol) {
                if (colIdx == "GATE_CD") {
                    setFormData(rowIdx);
                }
            });

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            doSearch();
        }

        function doSearch() {

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + 'houseUnit/selectGate.so', function () {
                if (grid.getRowCount() == 0) {
                    EVF.alert("${msg.M0002 }");
                } else {
                    if (flag != null) {
                        var rowIdxs = grid.getAllRowId();
                        for (var i = 0, length = rowIdxs.length; i < length; i++) {
                            if (grid.getCellValue(rowIdxs[i], "GATE_CD") == EVF.V('gateCd')) {
                                setFormData(rowIdxs[i]);
                                return;
                            }
                        }
                    }
                    setFormData(0);
                }
            });
        }

        function doSave() {

            EVF.confirm("${msg.M0021 }", function () {

                var store = new EVF.Store();
                if (!store.validate()) return;

                store.load(baseUrl + 'houseUnit/saveGate.so', function () {
                    EVF.alert(this.getResponseMessage());
                    flag = 1;
                    doSearch();
                });
            });
        }

        function doDelete() {

            EVF.confirm("${msg.M0013 }", function () {

                flag = null;
                var store = new EVF.Store();
                store.load(baseUrl + 'houseUnit/deleteGate.so', function () {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }

        function clearForm() {

            EVF.confirm("${msg.M0029}", function () {
                EVF.V('gateCd', "");
                EVF.V('gateCdOri', "");
                EVF.V('gateNm', "");
                EVF.V('gateNmEng', "");
                EVF.V('gmtCd', "");
                EVF.V('regDate', "");
                EVF.V('delFlag', "");
            });
        }

        function setFormData(rowIdx) {

            EVF.V('gateCd', grid.getCellValue(rowIdx, "GATE_CD"));
            EVF.V('gateCdOri', grid.getCellValue(rowIdx, "GATE_CD_ORI"));
            EVF.V('gateNm', grid.getCellValue(rowIdx, "GATE_NM"));
            EVF.V('gateNmEng', grid.getCellValue(rowIdx, "GATE_NM_ENG"));
            EVF.V('gmtCd', grid.getCellValue(rowIdx, "GMT_CD"));
            EVF.V('regDate', grid.getCellValue(rowIdx, "REG_DATE"));
            EVF.V('delFlag', grid.getCellValue(rowIdx, "DEL_FLAG"));

        }

    </script>
    <e:window id="MOGA0010" onReady="init" initData="${initData}" title="${fullScreenName}" icon="icon-blue-document-table" breadCrumbs="${breadCrumb }">

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" icon="search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
            <e:button id="Save" name="Save"  label="${Save_N }" disabled="${Save_D }" onClick="doSave" />
            <e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" onClick="doDelete" />
            <e:button id="Clear" name="Clear" label="${Clear_N }" disabled="${Clear_D }" onClick="clearForm" />
        </e:buttonBar>
        <e:panel id="leftPanel" height="fit" width="35%">
            <e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="98%" height="fit" readOnly="${param.detailView}"/>
        </e:panel>
        <e:panel id="rightPanel" height="fit" width="65%">
            <e:searchPanel id="form" title="${form_caption_form_N}" useTitleBar="false" labelWidth="${longLabelWidth}" width="100%" columnCount="1">
                <e:row>
                    <e:label for="gateCd" title="${form_gateCd_N}"></e:label>
                    <e:field>
                        <e:inputText id="gateCd" name="gateCd" width="100%" maxLength="${form_gateCd_M }" required="${form_gateCd_R }" readOnly="${form_gateCd_RO }" disabled="${form_gateCd_D}" visible="${form_gateCd_V}"></e:inputText>
                    </e:field>
                </e:row>
                <e:row>
                    <e:label for="gateNm" title="${form_gateNm_N}"></e:label>
                    <e:field>
                        <e:inputText id="gateNm" name="gateNm" width="100%" maxLength="${form_gateNm_M }" required="${form_gateNm_R }" readOnly="${form_gateNm_RO }" disabled="${form_gateNm_D}" visible="${form_gateNm_V}"></e:inputText>
                    </e:field>
                </e:row>
                <e:row>
                    <e:label for="gateNmEng" title="${form_gateNmEng_N}"></e:label>
                    <e:field>
                        <e:inputText id="gateNmEng" name="gateNmEng" width="100%" maxLength="${form_gateNmEng_M }" required="${form_gateNmEng_R }" readOnly="${form_gateNmEng_RO }" disabled="${form_gateNmEng_D}" visible="${form_gateNmEng_V}"></e:inputText>
                    </e:field>
                </e:row>
                <e:row>
                    <e:label for="gmtCd" title="${form_gmtCd_N}"></e:label>
                    <e:field>
                        <e:select id="gmtCd" name="gmtCd" value="${form.gmtCd}" options="${gmtCdList}" width="100%" disabled="${form_gmtCd_D}" readOnly="${form_gmtCd_RO}" required="${form_gmtCd_R}" placeHolder="" />
                        <e:inputHidden id="gateCdOri" name="gateCdOri" />
                        <e:inputHidden id="regUserId" name="regUserId" />
                        <e:inputHidden id="regDate" name="regDate" />
                        <e:inputHidden id="delFlag" name="delFlag" />
                    </e:field>
                </e:row>
            </e:searchPanel>
        </e:panel>

    </e:window>
</e:ui>