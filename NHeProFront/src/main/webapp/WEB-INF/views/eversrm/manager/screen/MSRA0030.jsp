<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

        var grid = {};
        var addParam = [];
        var eventRow;
        var eventType;
        var baseUrl = "/eversrm/manager/screen/";

        function init() {

            grid = EVF.C('jqGrid');
            grid.setColEllipsis(['TAG_GUIDE'], true);

            grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            grid.addRowEvent(function() {
                var screenId =  EVF.V("SCREEN_ID") == null ? "" : EVF.V("SCREEN_ID");
                var multiType =  EVF.V("MULTI_TYPE") == null ? "F" : EVF.V("MULTI_TYPE");
                var form_grid_id =  EVF.V("FORM_GRID_ID") == null ? "F" : EVF.V("FORM_GRID_ID");

                addParam = [{
                    "SCREEN_ID": screenId,
                    "LANG_CD": "${ses.langCd}",
                    "MULTI_TYPE": multiType,
                    "COLUMN_TYPE": "text",
                    "USE_FLAG": "1",
                    "DATA_TYPE": "D",
                    "FONT_COLOR_TEXT": "D",
                    "BACK_COLOR_TEXT": "D",
                    "WIDTH_UNIT": "X",
                    "FORM_GRID_ID": form_grid_id
                }];
                grid.addRow(addParam);
            });

            grid.delRowEvent(function() {
                if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                grid.delRow();
            });

            grid._gvo.setPasteOptions({
                checkReadOnly: true
            });

            grid._gvo.onRowsPasted = function (gridObj, items) {

                var baseRowId;
                var columnId = '';

                if(items instanceof Array) {

                    baseRowId = items[0];
                    for(var i = 0; i < items.length; i++) {
                        grid.setCellValue(items[i], "SCREEN_ID", grid.getCellValue(baseRowId, "SCREEN_ID"));
                        grid.setCellValue(items[i], "SCREEN_NM", grid.getCellValue(baseRowId, "SCREEN_NM"));
                        grid.setCellValue(items[i], "LANG_CD", grid.getCellValue(baseRowId, "LANG_CD"));
                        grid.setCellValue(items[i], "FORM_GRID_ID", grid.getCellValue(baseRowId, "FORM_GRID_ID"));
                        grid.setCellValue(items[i], "MULTI_CD", grid.getCellValue(baseRowId, "MULTI_CD"));
                        grid.setCellValue(items[i], "MULTI_TYPE", grid.getCellValue(baseRowId, "MULTI_TYPE"));
                    }

                    _getColumnAttribute(baseRowId, items);

                } else {

                    baseRowId = items.endRow;
                    columnId = grid.getCellValue(items.endRow, "COLUMN_ID");

                    _getColumnAttribute(baseRowId, [baseRowId]);
                }
            };

            grid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value) {

                eventRow = rowIdx;
                eventType = "jqGrid";
                grid.checkRow(rowIdx, true);

                if(colIdx == 'COLUMN_ID') {

                    grid.setCellValue(rowIdx, 'SORT_SQ', Number(grid.getCellValue(rowIdx, 'SORT_SQ'))+1);
                    grid.setCellValue(rowIdx, 'COLUMN_ID', everString.lrTrim(value));
                    var multiType = grid.getCellValue(rowIdx, "MULTI_TYPE");
                    var columnId = everString.lrTrim(grid.getCellValue(rowIdx, 'COLUMN_ID'));

                    if (multiType == "F" || multiType == "G") {
                        var store = new EVF.Store();
                        store.setGrid([grid]);
                        store.setParameter("searchWord", columnId);
                        store.load(baseUrl + 'MSRA0030/doChoiceDomain.so', function() {

                            var openFlag = this.getParameter("openFlag");

                            <!-- MULTI_CD는 항상 COLUMN_ID와 같게 Setting 한다. -->
                            grid.setCellValue(rowIdx, "MULTI_CD", columnId);

                            if (openFlag == "Y") {
                                <!-- 조회된 결과값이 2건 이상이면, Popup창을 띄워 선택하도록 한다. -->
                                openSearchDomainPopup(columnId);
                            } else if (openFlag == "N") {
                                <!-- 조회된 결과값이 1건이면, 자동으로 Setting 한다. -->
                                var domainData = JSON.parse(this.getParameter("domainData"));
                                var mostUsedWord = JSON.parse(this.getParameter("mostUsedWord"));
                                var jsonHDs = [{
                                    source: 'COL_TYPE',
                                    target: 'COLUMN_TYPE'
                                }, {
                                    source: 'DATA_LENGTH',
                                    target: 'MAX_LENGTH'
                                }, {
                                    source: 'ALIGNMENT',
                                    target: 'ALIGNMENT_TYPE'
                                }, {
                                    source: 'COL_WIDTH',
                                    target: 'COLUMN_WIDTH'
                                }];

                                grid.setCellValue(rowIdx, 'USE_FLAG', '1');
                                grid.setCellValue(rowIdx, 'MAX_LENGTH', domainData.DATA_LENGTH);
                                grid.setCellValue(rowIdx, 'DATA_TYPE', domainData.PRE_FORMAT);
                                grid.setCellValue(rowIdx, 'COLUMN_TYPE', domainData.COL_TYPE);
                                grid.setCellValue(rowIdx, 'COLUMN_WIDTH', domainData.COL_WIDTH);
//		                        grid.setCellValue(rowidx, 'MULTI_CONTENTS', domainData.DOMAIN_DESC);
                                grid.setCellValue(rowIdx, 'DOMAIN_NM', domainData.DOMAIN_NM);
                                grid.setCellValue(rowIdx, 'ALIGNMENT_TYPE', domainData.ALIGNMENT);
                                grid.setCellValue(rowIdx, 'FONT_COLOR_TEXT', 'D');
                                grid.setCellValue(rowIdx, 'BACK_COLOR_TEXT', 'D');
                                grid.setCellValue(rowIdx, 'MULTI_CONTENTS', mostUsedWord.DOMAIN_DESC);
                                // grid.setCellReadOnly(rowidx, 'MULTI_CONTENTS', false);
                            } else {
                                <!-- 조회된 결과값이 없으면, Domain 조회 Popup창을 띄운다. -->
                                openSearchDomainPopup(columnId);
                            }
                        }, false);
                    }
                    else {
                        <!-- MULTI_CODE는 항상 COLUMN_ID와 같게 Setting 한다. -->
                        grid.setCellValue(rowIdx, "MULTI_CD", columnId);
                    }
                }
                if (colIdx == 'COLUMN_WIDTH') {
                    if(value > 0 && value < 10)
                        grid.setCellValue(rowIdx, "WIDTH_UNIT", 'F');
                    else {
                        grid.setCellValue(rowIdx, "WIDTH_UNIT", 'X');
                    }
                }
                if (colIdx == "MULTI_TYPE") {
                    if (value == "M") {
                        grid.setCellValue(rowIdx, "FORM_GRID_ID", "msg");
                    } else if (value == "B") {
                        grid.setCellValue(rowIdx, "FORM_GRID_ID", "btn");
                    } else {
                        grid.setCellValue(rowIdx, "FORM_GRID_ID", '');
                    }
                }

                if (colIdx == "EDIT_FLAG") {
                    if (value == '1') {
                        grid.setCellValue(rowIdx, "BACK_COLOR_TEXT", 'O');
                    } else {
                        grid.setCellValue(rowIdx, "BACK_COLOR_TEXT", 'D');
                    }
                }

                if (colIdx == "COLUMN_TYPE") {
                    if (value == "imagetext") {
                        grid.setCellValue(rowIdx, 'FONT_COLOR_TEXT', 'I');
                    } else {
                        grid.setCellValue(rowIdx, 'FONT_COLOR_TEXT', 'D');
                    }
                }

                if (colIdx == "DATA_TYPE") {
                    if (value == "AMT" || value == "PER" || value == "QTY" || value == "MAX" || value == "SCO") {
                        grid.setCellValue(rowIdx, 'MAX_LENGTH', 22.2);
                    } else if (value == "CNT" || value == "NUM" || value == "SEQ") {
                        grid.setCellValue(rowIdx, 'MAX_LENGTH', 22);
                    } else if (value == "PRI" || value == "RAT") {
                        grid.setCellValue(rowIdx, 'MAX_LENGTH', 22.3);
                    } else if (value == "DEC1") {
                        grid.setCellValue(rowIdx, 'MAX_LENGTH', 22.1);
                    } else if (value == "DEC2") {
                        grid.setCellValue(rowIdx, 'MAX_LENGTH', 22.2);
                    } else if (value == "DEC3") {
                        grid.setCellValue(rowIdx, 'MAX_LENGTH', 22.3);
                    } else if (value == "DEC4") {
                        grid.setCellValue(rowIdx, 'MAX_LENGTH', 22.4);
                    }
                }
            });

            grid.cellClickEvent(function(rowIdx, colIdx) {
                eventRow = rowIdx;
                eventType = "jqGrid";
                var param;
                if(colIdx == "DOMAIN_NM") {
                    var searchTxt = grid.getCellValue(rowIdx, 'COLUMN_ID');
                    if(grid.getCellValue(rowIdx, 'MULTI_TYPE') == "M") {
                        searchTxt = "_TEXT";
                    }
                    openSearchDomainPopup(searchTxt);
                }
                else if (colIdx === 'IMAGE_BUTTON') {
                    param = {
                        screen_Id: grid.getCellValue(rowIdx, "SCREEN_ID"),
                        column_Id: grid.getCellValue(rowIdx, "COLUMN_ID"),
                        detailView: false
                    };

                    everPopup.openPopupByScreenId('MSRA0035', 700, 300, param);
                }
            });

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            if ('${param.screenId}' != '') {
                doSearch();
            }

            grid.setColGroup([{
                "groupName": 'PIVOT Option',
                "columns": [ "PIVOT_COLUMN", "PIVOT_ROW", "PIVOT_EXPRESSION", "PIVOT_DATE_TYPE" ]
            }]);

            grid.setColIconify("IMAGE_BUTTON", "IMAGE_BUTTON", "detail", true);
        }

        function _getColumnAttribute(rowIdx, rowIdArray) {

            var value = grid.getCellValue(rowIdx, 'COLUMN_ID');
            console.log(rowIdx, value);

            grid.setCellValue(rowIdx, 'SORT_SQ', Number(grid.getCellValue(rowIdx, 'SORT_SQ'))+1);
            grid.setCellValue(rowIdx, 'COLUMN_ID', everString.lrTrim(value));
            var columnId = everString.lrTrim(grid.getCellValue(rowIdx, 'COLUMN_ID'));

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.setParameter("searchWord", columnId);
            store.load(baseUrl + 'MSRA0030/doChoiceDomain.so', function() {

                console.log(1);

                var openFlag = this.getParameter("openFlag");

                <!-- MULTI_CD는 항상 COLUMN_ID와 같게 Setting 한다. -->
                grid.setCellValue(rowIdx, "MULTI_CD", columnId);
                console.log(2);

                <!-- 조회된 결과값이 1건이면, 자동으로 Setting 한다. -->
                var domainData = '';
                if(this.getParameter("domainData")) {
                    domainData = JSON.parse(this.getParameter("domainData"));
                }
                var mostUsedWord = JSON.parse(this.getParameter("mostUsedWord"));

                console.log(rowIdx, ' log start:');
                console.log('mostUsedWord:', mostUsedWord);
                console.log('domainData:', domainData);
                console.log(rowIdx, ' log finish:');

                if(domainData == null && mostUsedWord != null) {
                    domainData = mostUsedWord;
                }

                grid.setCellValue(rowIdx, 'USE_FLAG', '1');
                grid.setCellValue(rowIdx, 'MAX_LENGTH', domainData.DATA_LENGTH);
                grid.setCellValue(rowIdx, 'DATA_TYPE', domainData.PRE_FORMAT);
                grid.setCellValue(rowIdx, 'COLUMN_TYPE', domainData.COL_TYPE);
                grid.setCellValue(rowIdx, 'COLUMN_WIDTH', domainData.COL_WIDTH);
                grid.setCellValue(rowIdx, 'DOMAIN_NM', domainData.DOMAIN_NM);
                grid.setCellValue(rowIdx, 'ALIGNMENT_TYPE', domainData.ALIGNMENT);
                grid.setCellValue(rowIdx, 'DOMAIN_TYPE', domainData.DOMAIN_TYPE);
                grid.setCellValue(rowIdx, 'DOMAIN_NM', domainData.DOMAIN_NM);
                grid.setCellValue(rowIdx, 'FONT_COLOR_TEXT', 'D');
                grid.setCellValue(rowIdx, 'BACK_COLOR_TEXT', 'D');

                if(mostUsedWord != null) {
                    grid.setCellValue(rowIdx, 'MULTI_CONTENTS', mostUsedWord.DOMAIN_DESC);
//					grid.setCellValue(rowIdx, 'COMMON_ID', mostUsedWord.COMMON_ID);
                }

                if(rowIdArray.length > 0) {
                    var a = rowIdArray.shift();
                    _getColumnAttribute(a, rowIdArray);
                }

            }, false);
            <!-- MULTI_CODE는 항상 COLUMN_ID와 같게 Setting 한다. -->
            grid.setCellValue(rowIdx, "MULTI_CD", columnId);

        }

        function doSearch() {

            var anotherLangVal = EVF.C("ANOTHER_LANG").isChecked() == true ? "1" : "0";

            if((EVF.V('SCREEN_ID') == '' || EVF.V('SCREEN_ID') == null)
                    && (EVF.V('SCREEN_NM') == '' || EVF.V('SCREEN_NM') == null)
                    && (EVF.V('COLUMN_ID') == '' || EVF.V('COLUMN_ID') == null)
                    && (EVF.V('MULTI_CONTENTS') == '' || EVF.V('MULTI_CONTENTS') == null)) {
                return EVF.alert("${msg.M0035 }");
            }

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.setParameter('anotherLangVal', anotherLangVal);
            store.load(baseUrl + 'MSRA0030/doSearch.so', function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doSave() {

            <%-- if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); } --%>

            if (grid.getSelRowCount() > 0) {
                var validM = grid.validate(["SCREEN_ID", "LANG_CD", "MULTI_TYPE", "MULTI_CONTENTS", "FORM_GRID_ID", "COLUMN_ID"]);
                if (!validM.flag) {
                    return EVF.alert(validM.msg);
                }
                var validB = grid.validate(["SCREEN_ID", "LANG_CD", "MULTI_TYPE", "MULTI_CONTENTS", "FORM_GRID_ID", "COLUMN_ID"]);
                if (!validB.flag) {
                    return EVF.alert(validB.msg);
                }
                var validF = grid.validate(["SCREEN_ID", "LANG_CD", "MULTI_TYPE", "MULTI_CONTENTS", "FORM_GRID_ID", "COLUMN_ID", "DOMAIN_NM", "MAX_LENGTH", "EDIT_FLAG"]);
                if (!validF.flag) {
                    return EVF.alert(validF.msg);
                }
                var validG = grid.validate(["SCREEN_ID", "LANG_CD", "MULTI_TYPE", "MULTI_CONTENTS", "FORM_GRID_ID", "COLUMN_ID", "COLUMN_TYPE", "DOMAIN_NM", "MAX_LENGTH", "EDIT_FLAG"]);
                if (!validG.flag) {
                    return EVF.alert(validG.msg);
                }
            }

            for (var i in grid.getAllRowValue()) {
                var rowValue = grid.getAllRowValue()[i];

                if (EVF.isNotEmpty(rowValue.MASK_TYPE) && EVF.V("APPROVAL_TYPE") == "") {
                    formUtil.animateFor(["APPROVAL_TYPE"], "form");
                    return EVF.alert("${MSRA0030_APPROVAL_TYPE_MSG}"); // 개인정보승인유형을 선택하여 주시기 바랍니다.
                }
            }

            EVF.confirm("${msg.M0021 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'MSRA0030/doSave.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }

        function doDelete() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0013 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'MSRA0030/doDelete.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }

        function doCopy() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var argsIndex = 0;
            var copyArgs = [];

            var rowIds = grid.getSelRowId();
            var domainNmData = "";

            //grid.checkAll(false);

            for(var i = 0; i < rowIds.length; i++) {

                var selectedData = [];
                selectedData[0] = grid.getRowValue(rowIds[i]);

                selectedData[0].DOMAIN_NM = '';
                selectedData[0].MULTI_CONTENTS = '';
                selectedData[0].TAG_GUIDE = '';
                selectedData[0].SORT_SQ = '';
                grid.addRow(selectedData);
                // 행복사 시 체크 된 데이터 체크 해제
                grid.checkRow(rowIds[i], false);
            }
        }

        function openSearchDomainPopup(columnId) {

            var param = {
                searchWord: columnId
            };

            var url = baseUrl + 'MSRA0032/view.so';
            var width = 1060;
            var height = 500;
            // everPopup.openWindowPopup(url, width, height, param, 'searchDomainPopup');
            new EVF.ModalWindow(url, param, width, height).open();
        }

        function setDomain(data) {
            data.USE_FLAG = 1;
            data.MAX_LENGTH = data.DATA_LENGTH;
            data.DATA_TYPE = data.PRE_FORMAT;
            data.COLUMN_TYPE = data.COL_TYPE;
            data.COLUMN_WIDTH = data.COL_WIDTH;
            data.ALIGNMENT_TYPE = data.ALIGNMENT;
            data.FONT_COLOR_TEXT = 'D';
            data.BACK_COLOR_TEXT = 'D';
            if(EVF.isEmpty(grid.getCellValue(eventRow, 'MULTI_CONTENTS'))) {
                data.MULTI_CONTENTS = data.DOMAIN_DESC;
            }
            grid.setRowValue(eventRow, deleteItem(data));
            grid.setCellValue(eventRow, 'DOMAIN_NM', data.DOMAIN_NM);
        }

        function deleteItem(JsonObj) {
            delete JsonObj['DATA'];
            delete JsonObj['DATA_LENGTH'];
            delete JsonObj['NUM'];
            delete JsonObj['PRE_FORMAT'];
            delete JsonObj['ALIGNMENT'];
            delete JsonObj['COL_WIDTH'];
            delete JsonObj['COL_TYPE'];
            delete JsonObj['DOMAIN_DESC'];
            return JsonObj;
        }

    </script>
    <e:window id="MSRA0030" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${form_CAPTION_N }" columnCount="3" labelWidth="150" onEnter="doSearch" useTitleBar="false">
            <e:row>
                <e:label for="SCREEN_NM" title="${form_SCREEN_NM_N }" />
                <e:field>
                    <e:inputText id="SCREEN_NM" name="SCREEN_NM" width="100%" maxLength="${form_SCREEN_NM_M }" required="${form_SCREEN_NM_R }" readOnly="${form_SCREEN_NM_RO }" disabled="${form_SCREEN_NM_D }"  maskType="${form_SCREEN_NM_MT}" />
                </e:field>
                <e:label for="SCREEN_ID" title="${form_SCREEN_ID_N }" />
                <e:field>
                    <e:inputText id="SCREEN_ID" name="SCREEN_ID" width="100%" maxLength="${form_SCREEN_ID_M }" required="${form_SCREEN_ID_R }" readOnly="${form_SCREEN_ID_RO }" disabled="${form_SCREEN_ID_D }" value="${param.screenId}" maskType="${form_SCREEN_ID_MT}" />
                </e:field>
                <e:label for="" title="${form_LANGUAGE_LIST_N }" />
                <e:field>
                    <e:select id="LANGUAGE_LIST" name="LANGUAGE_LIST" label="" value="" options="${languageListOptions}" width="100%" required="${form_LANGUAGE_LIST_R }" readOnly="${form_LANGUAGE_LIST_RO }" disabled="${form_LANGUAGE_LIST_D }"  maskType="${form_LANGUAGE_LIST_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="MULTI_TYPE" title="${form_MULTI_TYPE_N }" />
                <e:field>
                    <e:select id="MULTI_TYPE" name="MULTI_TYPE" label="" value="" options="${multiTypeOptions}" width="100%" required="${form_MULTI_TYPE_R }" readOnly="${form_MULTI_TYPE_RO }" disabled="${form_MULTI_TYPE_D }"  maskType="${form_MULTI_TYPE_MT}"/>
                </e:field>
                <e:label for="MODULE_TYPE" title="${form_MODULE_TYPE_N }" />
                <e:field>
                    <e:select id="MODULE_TYPE" name="MODULE_TYPE" label="" value="" options="${moduleTypeOptions}" width="100%" required="${form_MODULE_TYPE_R }" readOnly="${form_MODULE_TYPE_RO }" disabled="${form_MODULE_TYPE_D }"  maskType="${form_MODULE_TYPE_MT}"/>
                </e:field>
                <e:label for="" title="${form_COLUMN_ID_N }" />
                <e:field>
                    <e:inputText id="COLUMN_ID" name="COLUMN_ID" width="100%" maxLength="${form_COLUMN_ID_M }" required="${form_COLUMN_ID_R }" readOnly="${form_COLUMN_ID_RO }" disabled="${form_COLUMN_ID_D }"  maskType="${form_COLUMN_ID_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="" title="${form_FORM_GRID_ID_N }"/>
                <e:field>
                    <e:inputText id="FORM_GRID_ID" name="FORM_GRID_ID" width="100%" maxLength="${form_FORM_GRID_ID_M }" required="${form_FORM_GRID_ID_R }" readOnly="${form_FORM_GRID_ID_RO }" disabled="${form_FORM_GRID_ID_D }" value="" maskType="${form_FORM_GRID_ID_MT}" />
                </e:field>
                <e:label for="ANOTHER_LANG" title="${form_ANOTHER_LANG_N }" />
                <e:field>
                    <e:checkGroup id="cg" name="cg" visible="true" disabled="" readOnly="" required="">
                        <e:check id="ANOTHER_LANG" name="ANOTHER_LANG" value="1" required="${form_ANOTHER_LANG_R }" readOnly="${form_ANOTHER_LANG_RO }" disabled="${form_ANOTHER_LANG_D }" />
                    </e:checkGroup>
                </e:field>
                <e:label for="" title="${form_MULTI_CONTENTS_N }" />
                <e:field>
                    <e:inputText id="MULTI_CONTENTS" name="MULTI_CONTENTS" width="100%" maxLength="${form_MULTI_CONTENTS_M }" required="${form_MULTI_CONTENTS_R }" readOnly="${form_MULTI_CONTENTS_RO }" disabled="${form_MULTI_CONTENTS_D }"  maskType="${form_MULTI_CONTENTS_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 후결, 선결 유형 --%>
                <e:label for="APPROVAL_TYPE" title="${form_APPROVAL_TYPE_N}"/>
                <e:field>
                    <e:select id="APPROVAL_TYPE" name="APPROVAL_TYPE" value="${APPROVAL_TYPE}" options="${approvalTypeOptions}" width="${form_APPROVAL_TYPE_W}" disabled="${form_APPROVAL_TYPE_D}" readOnly="${form_APPROVAL_TYPE_RO}" required="${form_APPROVAL_TYPE_R}" placeHolder="" maskType="${form_APPROVAL_TYPE_MT}" />
                </e:field>
                <e:field colSpan="4" />
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
            <e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" onClick="doSave" />
            <e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" onClick="doDelete" />
            <e:button id="Copy" name="Copy" label="${Copy_N }" disabled="${Copy_D }" onClick="doCopy" />
            <e:button id="do" name="do" label="${do_N}" onClick="do" disabled="${do_D}" visible="${do_V}"/>
        </e:buttonBar>

        <e:gridPanel id="jqGrid" name="jqGrid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>