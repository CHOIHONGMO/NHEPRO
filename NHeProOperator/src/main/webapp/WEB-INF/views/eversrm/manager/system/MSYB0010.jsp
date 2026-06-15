<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var grid1 = {};
        var grid2 = {};
        var grid3 = {};
        var baseUrl = "/eversrm/manager/system/";
        var position = [
            {text: "중앙정렬[C]", value: "C"},
            {text: "왼쪽정렬[L]", value: "L"},
            {text: "오른쪽정렬[R]", value: "R"}
        ];
        var columnType = [
            {text: "Text[text]", value: "text"},
            {text: "Number[number]", value: "number"},
            {text: "Date[date]", value: "date"}
        ];

        function init() {

            if ('${detailData.COMMON_ID}'.indexOf("CB") == -1) {
                grid1 = EVF.C("grid1");
                grid2 = EVF.C("grid2");
                grid3 = EVF.C("grid3");

                grid1.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
                grid1.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
                grid1.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
                grid1.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
                grid1.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
                grid1.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
                grid1.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

                grid2.setProperty('shrinkToFit', ${shrinkToFit});
                grid2.setProperty('rowNumbers', ${rowNumbers});
                grid2.setProperty('sortable', ${sortable});
                grid2.setProperty('panelVisible', ${panelVisible});
                grid2.setProperty('enterToNextRow', ${enterToNextRow});
                grid2.setProperty('acceptZero', ${acceptZero});
                grid2.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

                grid3.setProperty('shrinkToFit', ${shrinkToFit});
                grid3.setProperty('rowNumbers', ${rowNumbers});
                grid3.setProperty('sortable', ${sortable});
                grid3.setProperty('panelVisible', ${panelVisible});
                grid3.setProperty('enterToNextRow', ${enterToNextRow});
                grid3.setProperty('acceptZero', ${acceptZero});
                grid3.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

                setGrid1();
                setGrid2();
                setGrid3();

                // 그리드 동적 셋팅 후 값 셋팅
                setIninData();
                setCommonInitData('${detailData.SEARCH_CONDITION_TEXT}', grid3, 'ST', '${detailData.MULTI_SQ3}');
                setCommonInitData('${detailData.LIST_ITEM_TEXT}', grid2, 'LT', '${detailData.MULTI_SQ2}');
            }

            if(window.opener != undefined) {
                EVF.C('doClose').setVisible(true);
            } else {
                EVF.C('doClose').setVisible(false);
            }
        }

        function setGrid1() {

            grid1.createColumn('LIST_ITEM_CD', 'List Item Code', 100, 'left', 'text', 100, true, true, '');
            grid1.createColumn('MASK_TYPE', '마스킹타입', 100, 'center', 'combo', 20, true, true, '', ${maskType});
            grid1.createColumn('POSITION', '정렬', 100, 'center', 'combo', 20, true, true, '', position);
            grid1.createColumn('WIDTH', '컬럼사이즈', 100, 'center', 'text', 20, true, true, '');
            grid1.createColumn('COLUMN_TYPE', '컬럼타입', 100, 'center', 'combo', 20, true, true, '', columnType);
            grid1.createColumn('SORT_SQ', '순서', 60, 'center', 'text', 20, true, true, '');

            grid1.gridColBound();

            grid1.addRowEvent(function () {
                grid1.addRow({SORT_SQ: grid1.getRowCount() + 1});
            });

            grid1.delRowEvent(function () {
                grid1.delRow();
            });

            grid1.cellChangeEvent(function (rowId, colId, iRow, iCol, newValue, oldValue) {
                numSort(grid1);
            });

            grid1.setColRequired("LIST_ITEM_CD", true);
        }

        function setGrid2() {

            grid2.createColumn('LIST_ITEM_TEXT', 'List Item Text', 100, 'left', 'text', 100, true, true, '');
            grid2.createColumn('LANG_CD', '언어', 100, 'center', 'combo', 100, true, true, '', ${langData});
            grid2.createColumn('SORT_SQ', '순서', 60, 'center', 'text', 20, true, true, '');
            grid2.createColumn('MULTI_CD', 'MULTI_CD', 0, 'left', 'text', 100, true, true, '');
            grid2.createColumn('MULTI_SQ', 'MULTI_SQ', 0, 'left', 'text', 100, true, true, '');
            grid2.createColumn('COMMON_ID', 'COMMON_ID', 0, 'left', 'text', 100, true, true, '');
            grid2.createColumn('INSERT_FLAG', 'INSERT_FLAG', 0, 'left', 'text', 100, true, true, '');
            grid2.gridColBound();

            grid2.addRowEvent(function () {

				if (EVF.V("COMMON_ID") == '') { return; }

                grid2.addRow({
                    MULTI_CD: 'LT',
                    COMMON_ID: EVF.V("COMMON_ID"),
                    MULTI_SQ: EVF.V("MULTI_SQ2"),
                    INSERT_FLAG: 'I',
                    SORT_SQ: grid2.getRowCount() + 1
                });
            });

            grid2.delRowEvent(function () {
                grid2.delRow();
            });

            grid2.cellChangeEvent(function (rowId, colId, iRow, iCol, newValue, oldValue) {
                numSort(grid2);
            });

            grid2.setColRequired("LIST_ITEM_TEXT", true);
        }

        function setGrid3() {

            grid3.createColumn('SEARCH_CONDITION_TEXT', '조회조건', 100, 'left', 'text', 100, true, true, '');
            grid3.createColumn('LANG_CD', '언어', 100, 'center', 'combo', 100, true, true, '', ${langData});
            grid3.createColumn('SORT_SQ', '순서', 60, 'center', 'text', 20, true, true, '');
            grid3.createColumn('MULTI_CD', 'MULTI_CD', 0, 'left', 'text', 100, true, true, '');
            grid3.createColumn('MULTI_SQ', 'MULTI_SQ', 0, 'left', 'text', 100, true, true, '');
            grid3.createColumn('COMMON_ID', 'COMMON_ID', 0, 'left', 'text', 100, true, true, '');
            grid3.createColumn('INSERT_FLAG', 'INSERT_FLAG', 0, 'left', 'text', 100, true, true, '');
            grid3.gridColBound();

            grid3.addRowEvent(function () {

				if (EVF.V("COMMON_ID") == '') { return; }

                grid3.addRow({
                    MULTI_CD: 'ST',
                    COMMON_ID: EVF.V("COMMON_ID"),
                    MULTI_SQ: EVF.V("MULTI_SQ3"),
                    INSERT_FLAG: 'I',
                    SORT_SQ: grid3.getRowCount() + 1
                });
            });

            grid3.delRowEvent(function () {
                grid3.delRow();
            });

            grid3.cellChangeEvent(function (rowId, colId, iRow, iCol, newValue, oldValue) {
                numSort(grid3);
            });

            grid3.setColRequired("SEARCH_CONDITION_TEXT", true);
        }

        function setIninData() {

            var list_item_cd = '${detailData.LIST_ITEM_CD}';
            var list_item_arr = list_item_cd.split("###");
            var sortSq = 1;

            for(var i in list_item_arr) {
                var list_item = list_item_arr[i];

                var list_item_value = "", mask_value = "", position_value = "", width_value = "", column_type= "";

                var maskIndex = list_item.indexOf("_$");
                var positionIndex = list_item.indexOf("(");
                var lastIndex = list_item.indexOf(")") - 1;
                var optionArr = list_item.substr(positionIndex + 1, lastIndex - positionIndex).split(":");


                list_item_value = list_item.substr(0, maskIndex);

                if (maskIndex > -1) {
                    list_item_value = list_item.substr(0, maskIndex);
                    mask_value =  list_item.substr(maskIndex + 2, 1);
                } else if (positionIndex > -1) {
                    list_item_value = list_item.substr(0, positionIndex);
                } else {
                    list_item_value = list_item;
                }

                for(var i in optionArr) {
                    var option = optionArr[i];

                    if (!EVF.isNumber(Number(option))) {
                        if (option == "C" || option == "L" || option == "R") {
                            position_value = option;
                        } else {
                            column_type = option;
                        }
                    } else {
                        width_value = option;
                    }

                }

                grid1.addRow({
                    "LIST_ITEM_CD": list_item_value,
                    "MASK_TYPE": mask_value,
                    "POSITION": position_value,
                    "WIDTH": width_value,
                    "COLUMN_TYPE": column_type,
                    "SORT_SQ": sortSq
                });

                sortSq++;
            }
            grid1.checkAll(false);

            setGridCurrent(grid1);
        }

        function setCommonInitData(value, grid, multi_cd, multi_sq) {

            var valueArr = value.split('###');
            var param = {};
            var sortSq = 1;
            for (var i in valueArr) {
                param[grid.columns[0].name] = valueArr[i];
                param['MULTI_CD'] = multi_cd;
                param['COMMON_ID'] = '${detailData.COMMON_ID}';
                param['INSERT_FLAG'] = 'U';
                param['MULTI_SQ'] = multi_sq;
                param['LANG_CD'] = '${ses.langCd}';
                param['SORT_SQ'] = sortSq;

                if (!EVF.isEmpty(valueArr[i])) {
                    grid.addRow(param);
                }

                sortSq++;
            }

            grid.checkAll(false);

            setGridCurrent(grid);
        }

        function setGridCurrent(grid) {
            setTimeout(function() {
                grid.setCurrent(0);
            }, 500)
        }

        function delete2() {
            EVF.confirm("${msg.M0013 }", function() {
                var store = new EVF.Store();
                store.load(baseUrl + 'MSYB0010/doDelete.so', function(){
                    EVF.alert(this.getResponseMessage());

                    if ('${param.POPUPFLAG}' == 'Y' ){
                        opener.search();
                        EVF.closeWindow();
                    }
                });
            });
        }

        function save() {

            if ('${detailData.COMMON_ID}'.indexOf("CB") == -1) {
                if (!grid1.validate().flag) {
                    return EVF.alert(grid1.validate().msg);
                }

                if (!grid2.validate().flag) {
                    return EVF.alert(grid2.validate().msg);
                }

                if (!grid3.validate().flag) {
                    return EVF.alert(grid3.validate().msg);
                }

                if (grid1.getRowCount() != grid2.getRowCount()) {
                    return EVF.alert("LIST_ITEM_CD 와 LIST_ITEM_TEXT 컬럼 갯수를\n확인하시기 바랍니다.");
                }

                // 저장 시 하나의 컬럼으로 만듬...
                setField();
                setCommonField("LIST_ITEM_TEXT", grid2);
                setCommonField("SEARCH_CONDITION_TEXT", grid3);
            }

            EVF.confirm("${msg.M0021 }", function () {
                var store = new EVF.Store();
                if ('${detailData.COMMON_ID}'.indexOf("CB") == -1) {
                    store.setGrid([grid2, grid3]);
                    store.getGridData(grid2, 'sel');
                    store.getGridData(grid3, 'sel');
                }
                store.load(baseUrl + 'MSYB0010/doSave.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        if ('${param.POPUPFLAG}' == 'Y' ){
                            opener.search();
                        }
                    });
                });
            });
        }

        function setField() {

            var data = '';
            for (var i in grid1.getAllRowValue()) {
                var rowValue = grid1.getRowValue(i);

                if (i == 0) {
                    data += rowValue['LIST_ITEM_CD'];
                } else {
                    data += "###" + rowValue['LIST_ITEM_CD'];
                }

                data += rowValue['MASK_TYPE'] != '' ? '_$' + rowValue['MASK_TYPE'] : '';
                data += rowValue['POSITION'] != '' || rowValue['WIDTH'] != '' || rowValue['COLUMN_TYPE'] != '' ? '(' : '';
                data += rowValue['POSITION'];
                data += rowValue['POSITION'] != '' && (rowValue['WIDTH'] != '' || rowValue['COLUMN_TYPE'] != '') ? ':' : '';
                data += rowValue['WIDTH'];
                data += rowValue['WIDTH'] != '' && rowValue['COLUMN_TYPE'] != '' ? ':' : '';
                data += rowValue['COLUMN_TYPE'];
                data += rowValue['POSITION'] != '' || rowValue['WIDTH'] != '' || rowValue['COLUMN_TYPE'] != '' ? ')' : '';
            }
            EVF.V('LIST_ITEM_CD', data);
        }

        function setCommonField(column, grid) {

            var data = '';
            for (var i in grid.getAllRowValue()) {
                var rowValue = grid.getRowValue(i);

                if (i == 0) {
                    data += rowValue[column];
                } else {
                    data += '###' + rowValue[column];
                }
            }
            EVF.V(column, data);
        }

        function verify() {
            var store = new EVF.Store();
            store.load(baseUrl + 'MSYB0010/doVerify.so', function(){
                EVF.alert(this.getResponseMessage());
            });
        }

        function search() {
            location.href =baseUrl + 'MSYB0010/view.so?COMMON_ID='+EVF.V('COMMON_ID')+'&DATABASE_CD='+EVF.V('DATABASE_CD')+'&POPUPFLAG=${param.POPUPFLAG}';
        }

        function insTitleText() {

            if (!checkCommonId()) return;

            var param = {
                "multi_cd": "TT",
                "common_id": EVF.V('COMMON_ID'),
                "callBackFunction": "setCommonTitle"
            };
            everPopup.openMultiLanguagePopup(param);
        }

        function setCommonTitle(multiLangReturn) {
            EVF.V("TITLE_TEXT", multiLangReturn.multiNm);
        }

        function insCommonDesc() {

            if (!checkCommonId()) return;

            var param = {
                "multi_cd": "CC",
                "common_id": EVF.V('COMMON_ID'),
                "callBackFunction": "setCommonDesc"
            };
            everPopup.openMultiLanguagePopup(param);
        }

        function setCommonDesc(multiLangReturn) {
            EVF.V("COMMON_DESC", multiLangReturn.multiNm);
        }

        function checkCommonId() {

            if (EVF.V('COMMON_ID') == "") {
                EVF.alert("${MSYB0010_MSG_0001 }");
                return false;
            } else {
                return true;
            }
        }

        function doView() {
            everPopup.openCommonPopup({}, EVF.V('COMMON_ID'));
        }

        function closePopup() {
            EVF.closeWindow();
        }

        function numSort(grid) {
        	return;
            var value = grid.getAllRowValue().sort(function(a,b) {
                return a.SORT_SQ - b.SORT_SQ
            });

            grid.delAllRow();
            grid.addRow(value);
        }

    </script>
    <e:window id="MSYB0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }" margin="0 5px">
        <%-- 히든 컬럼 --%>
        <e:inputHidden id="SEARCH_CONDITION_TEXT" name="SEARCH_CONDITION_TEXT" />
        <e:inputHidden id="LIST_ITEM_TEXT" name="LIST_ITEM_TEXT" />
        <e:inputHidden id="LIST_ITEM_CD" name="LIST_ITEM_CD" />


        <e:inputHidden id="MULTI_SQ2" name="MULTI_SQ2"  value="${detailData.MULTI_SQ2 }"/>
        <e:inputHidden id="MULTI_SQ3" name="MULTI_SQ3"  value="${detailData.MULTI_SQ3 }"/>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N }" disabled="${doSearch_D }" onClick="search" />
            <e:button id="doSave" name="doSave" label="${doSave_N }" disabled="${doSave_D }" onClick="save" />
            <e:button id="doDelete" name="doDelete" label="${doDelete_N }" disabled="${doDelete_D }" onClick="delete2" />
            <e:button id="doClose" name="doClose" label="${doClose_N }" disabled="${doClose_D }" onClick="closePopup" />
            <e:button id="doView" name="doView" label="${doView_N}" onClick="doView" disabled="${doView_D}" visible="${fn:indexOf(detailData.COMMON_ID, 'CB') eq -1 ? true : false}"/>
        </e:buttonBar>

        <e:searchPanel id="form" useTitleBar="false" title="${form_CAPTION_N }" labelWidth="150" width="100%" columnCount="2">
            <e:row>
                <e:label for="COMMON_ID" title="${form_COMMON_ID_N }" />
                <e:field>
                    <e:inputText id="COMMON_ID" name="COMMON_ID"   readOnly="${form_COMMON_ID_RO }"   maxLength="${form_COMMON_ID_M}"  value="${detailData.COMMON_ID }" width="100%" required="${form_COMMON_ID_R }" disabled="${form_COMMON_ID_D }"  maskType="${form_COMMON_ID_MT}" />
                </e:field>
                <e:label for="COMMON_DESC" title="${form_COMMON_DESC_N }" />
                <e:field>
                    <e:search id="COMMON_DESC" name="COMMON_DESC"  readOnly="${form_COMMON_DESC_RO }"  maxLength="${form_COMMON_DESC_M }" value="${detailData.COMMON_DESC}" width="100%" required="${form_COMMON_DESC_R }" disabled="${form_COMMON_DESC_D }"  onIconClick="${form_COMMON_DESC_D ? 'everCommon.blank' : 'insCommonDesc'}"  maskType="${form_COMMON_DESC_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="DATABASE_CD" title="${form_DATABASE_CD_N }" />
                <e:field>
                    <e:select id="DATABASE_CD" name="DATABASE_CD"  readOnly="${form_DATABASE_CD_RO }"  value="${detailData.DATABASE_CD}"  options="${databaseCdOptions}" width="100%" required="${form_DATABASE_CD_R }" disabled="${form_DATABASE_CD_D }" onFocus="onFocus"  maskType="${form_DATABASE_CD_MT}"/>
                </e:field>
                <e:label for="TYPE_CD" title="${form_TYPE_CD_N }" />
                <e:field>
                    <e:select id="TYPE_CD" name="TYPE_CD" value="${detailData.TYPE_CD}" readOnly="${form_TYPE_CD_RO }" options="${typeCdOptions}" width="100%" required="${form_TYPE_CD_R }" disabled="${form_TYPE_CD_D }" onFocus="onFocus"  maskType="${form_TYPE_CD_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="USE_FLAG" title="${form_USE_FLAG_N }" />
                <e:field>
                    <e:select id="USE_FLAG" name="USE_FLAG"  value="${detailData.USE_FLAG}"  readOnly="${form_USE_FLAG_RO }"  options="${useFlagOptions}" width="100%" required="${form_USE_FLAG_R }" disabled="${form_USE_FLAG_D }" onFocus="onFocus"  maskType="${form_USE_FLAG_MT}"/>
                </e:field>
                <e:label for="AUTO_SEARCH_FLAG" title="${form_AUTO_SEARCH_FLAG_N }" />
                <e:field>
                    <e:select id="AUTO_SEARCH_FLAG" name="AUTO_SEARCH_FLAG"  value="${detailData.AUTO_SEARCH_FLAG}"  readOnly="${form_AUTO_SEARCH_FLAG_RO }"   options="${autoSearchFlagOptions}" width="100%" required="${form_AUTO_SEARCH_FLAG_R }" disabled="${form_AUTO_SEARCH_FLAG_D }" onFocus="onFocus"  maskType="${form_AUTO_SEARCH_FLAG_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="WINDOW_WIDTH" title="${form_WINDOW_WIDTH_N }" />
                <e:field>
                    <e:inputNumber id="WINDOW_WIDTH" name="WINDOW_WIDTH" readOnly="${form_WINDOW_WIDTH_RO }" value="${detailData.WINDOW_WIDTH}" width="${form_WINDOW_WIDTH_W }" required="${form_WINDOW_WIDTH_R }" disabled="${form_WINDOW_WIDTH_D }"  onNumberKr="${form_WINDOW_WIDTH_KR}" currencyText="${form_WINDOW_WIDTH_CT}" />
                </e:field>
                <e:label for="WINDOW_HEIGHT" title="${form_WINDOW_HEIGHT_N }" />
                <e:field>
                    <e:inputNumber id="WINDOW_HEIGHT" name="WINDOW_HEIGHT" readOnly="${form_WINDOW_HEIGHT_RO }" value="${detailData.WINDOW_HEIGHT}" width="${form_WINDOW_HEIGHT_W }" required="${form_WINDOW_HEIGHT_R }" disabled="${form_WINDOW_HEIGHT_D }"  onNumberKr="${form_WINDOW_HEIGHT_KR}" currencyText="${form_WINDOW_HEIGHT_CT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="TITLE_TEXT" title="${form_TITLE_TEXT_N }" />
                <e:field>
                    <e:search id="TITLE_TEXT" name="TITLE_TEXT" value="${detailData.TITLE_TEXT}" maxLength="${form_TITLE_TEXT_M }" readOnly="${form_TITLE_TEXT_RO }"  width="100%" required="${form_TITLE_TEXT_R }" disabled="${form_TITLE_TEXT_D }"  onIconClick="${form_TITLE_TEXT_D ? 'everCommon.blank' : 'insTitleText'}"  maskType="${form_TITLE_TEXT_MT}" />
                </e:field>
                <e:label for="SHRINK_TO_FIT" title="${form_SHRINK_TO_FIT_N}" />
                <e:field>
                    <e:checkGroup id="SHRINK_TO_FIT" name="SHRINK_TO_FIT" width="100%" value="${detailData.SHRINK_TO_FIT}" disabled="${form_SHRINK_TO_FIT_D}" readOnly="${form_SHRINK_TO_FIT_RO}" required="${form_SHRINK_TO_FIT_R}">
                        <e:check id="SHRINK_TO_FIT_FLAG" name="SHRINK_TO_FIT_FLAG" value="1"  />
                    </e:checkGroup>
                </e:field>
            </e:row>
            <c:if test="${fn:indexOf(detailData.COMMON_ID, 'CB') eq -1}">
            <e:row>
                <e:label for="SEARCH_CONDITION_TEXT" title="${form_SEARCH_CONDITION_TEXT_N }" />
                <e:field colSpan="3">
                    <e:gridPanel gridType="RG" id="grid3" name="grid3" width="100%" height="120" readOnly="${param.detailView}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="LIST_ITEM_CD" title="${form_LIST_ITEM_CD_N }" alt="GATE_CD(L:50)###COMPANY_CD" />
                <e:field>
                    <e:gridPanel gridType="RG" id="grid1" name="grid1" width="100%" height="370" readOnly="${param.detailView}"/>
                </e:field>
                <e:label for="LIST_ITEM_TEXT" title="${form_LIST_ITEM_TEXT_N }" />
                <e:field>
                    <e:gridPanel gridType="RG" id="grid2" name="grid2" width="100%" height="370" readOnly="${param.detailView}"/>
                </e:field>
            </e:row>
            </c:if>
            <e:row>
                <e:label for="SQL_TEXT" title="${form_SQL_TEXT_N }"  />
                <e:field colSpan="3">
                    <e:textArea id="SQL_TEXT" name="SQL_TEXT" width="100%" height="400px" readOnly="${form_SQL_TEXT_RO }" maxLength="${form_SQL_TEXT_M }"  required="${form_SQL_TEXT_R }" disabled="${form_SQL_TEXT_D }" value="${detailData.SQL_TEXT}" style="font-family: 'Consolas' !important" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="REG_DATE" title="${form_REG_DATE_N }" />
                <e:field>
                    <e:inputText id="REG_DATE" name="REG_DATE" maxLength="${form_REG_DATE_M}" value="${detailData.REG_DATE}" width="${inputTextDate }" required="${form_REG_DATE_R }" readOnly="${form_REG_DATE_RO }" disabled="true"  maskType="${form_REG_DATE_MT}" />
                </e:field>
                <e:label for="REG_USER_NM" title="${form_REG_USER_NM_N }" />
                <e:field>
                    <e:inputText id="REG_USER_NM" name="REG_USER_NM" maxLength="${form_REG_USER_NM_M}" value="${detailData.REG_USER_NM}" width="${inputTextDate }" required="${form_REG_USER_NM_R }" readOnly="${form_REG_USER_NM_RO }" disabled="true"  maskType="${form_REG_USER_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="MOD_DATE" title="${form_MOD_DATE_N }" />
                <e:field>
                    <e:inputText id="MOD_DATE" name="MOD_DATE" maxLength="${form_MOD_DATE_M}" value="${detailData.MOD_DATE}" width="${inputTextDate }" required="${form_MOD_DATE_R }" readOnly="${form_MOD_DATE_RO }" disabled="true"  maskType="${form_MOD_DATE_MT}" />
                </e:field>
                <e:label for="CHANGE_USER_NM" title="${form_CHANGE_USER_NM_N }" />
                <e:field>
                    <e:inputText id="CHANGE_USER_NM" name="CHANGE_USER_NM" maxLength="${form_CHANGE_USER_NM_M}" value="${detailData.MOD_USER_NM}" width="${inputTextDate }" required="${form_CHANGE_USER_NM_R }" readOnly="${form_CHANGE_USER_NM_RO }" disabled="true"  maskType="${form_CHANGE_USER_NM_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>
    </e:window>
</e:ui>