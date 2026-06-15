<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

        var baseUrl = "/eversrm/manager/auth/MAUA0040/";
        var gridL   = {};
        var gridR   = {};

        function init() {

            gridL = EVF.C("gridL");
            gridR = EVF.C("gridR");

            gridL.setProperty('shrinkToFit', true);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridL.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridL.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridL.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridL.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridL.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridL.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            gridR.setProperty('shrinkToFit', true);
            gridR.setProperty('rowNumbers', ${rowNumbers});
            gridR.setProperty('sortable', ${sortable});
            gridR.setProperty('panelVisible', ${panelVisible});
            gridR.setProperty('enterToNextRow', ${enterToNextRow});
            gridR.setProperty('acceptZero', ${acceptZero});
            gridR.setProperty('multiSelect', ${multiSelect});

            gridL.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            gridR.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

        }

        function doSearchL() {

            var authCode = EVF.V("AUTH_CD");

            if (authCode == "") { return EVF.alert("${MAUA0040_0001}"); }

            var store = new EVF.Store(); // formL
            store.setGrid([gridL]);
            store.load(baseUrl + 'doSearchL.so', function() {
                if(gridL.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doSearchR() {

            var store = new EVF.Store(); // formR
            store.setGrid([gridR]);
            store.load(baseUrl + 'doSearchR.so', function() {
                if(gridR.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doSendLeft() {

            var auth_cd = EVF.V("AUTH_CD");
            if (auth_cd == '') { return EVF.alert("${BSYA_020_0001 }"); }

            if (gridR.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var rightRowCount = gridR.getRowCount();
            var kkk = gridR.getSelRowId();

            for (var i = kkk.length - 1; i > -1; i--) {

                var menu_group_cd = gridR.getCellValue(kkk[i], "MENU_GROUP_CD");
                var leftRowCount  = gridL.getRowCount();
                var addOk = "ok";

                for (var j = leftRowCount - 1; j > -1; j--) {
                    if (gridL.getCellValue(j, "MENU_GROUP_CD") == menu_group_cd && gridL.getCellValue(j, "AUTH_CD") == auth_cd) {
                        addOk = "fail";
                    }
                }

                if (addOk == "ok") {
                    gridL.addRow([{
                         'INSERT_FLAG'         : 'I'
                        ,'MENU_GROUP_CD'       : gridR.getCellValue(kkk[i], "MENU_GROUP_CD")
                        ,'MENU_GROUP_NM'       : gridR.getCellValue(kkk[i], "MENU_GROUP_NM")
                        ,'MODULE_TYPE'         : gridR.getCellValue(kkk[i], "MODULE_TYPE")
                        ,'MODULE_TYPE_NM'      : gridR.getCellValue(kkk[i], "MODULE_TYPE_NM")
                        ,'AUTH_CD'             : EVF.V("AUTH_CD")
                        ,'MAIN_MODULE_TYPE'    : EVF.V("MAIN_MODULE_TYPE")
                        ,'AUTH_MAPPING_TYPE'   : 'MUGR'
                        ,'GATE_CD'             : gridR.getCellValue(kkk[i], "GATE_CD")
                    }]);
                }
            }
        }

        function doSave() {

            if (gridL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0021}", function() {
                var store = new EVF.Store();
                store.setGrid([gridL]);
                store.getGridData(gridL, 'sel');
                store.load(baseUrl + 'doSave.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearchL();
                    });
                });
            });
        }

        function doDelete() {

            if (gridL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0013}", function() {
                var store = new EVF.Store();
                store.setGrid([gridL]);
                store.getGridData(gridL, 'sel');
                store.load(baseUrl + 'doDelete.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearchL();
                    });
                });
            });
        }

        function doSearchAUTH(strColumnKey, nRow) {
            var param = {
                callBackFunction: "selectAthorization"
            };
            everPopup.openCommonPopup(param, 'SP0008');
        }

        function selectAthorization(data) {
            EVF.V("AUTH_CD", data.AUTH_CD);
            EVF.V("AUTH_NM", data.AUTH_NM);
            doSearchL();
        }

    </script>

    <e:window id="MAUA0040" onReady="init" initData="${initData}" width="100%" height="100%" name="${screenName}" title="${fullScreenName}">
        <e:panel id="pnl1" width="48%">
            <e:searchPanel id="frmLeft" useTitleBar="false" labelWidth="180px" width="100%" columnCount="1" onEnter="doSearchL">
                <e:row>
                    <e:label for="AUTH_CD" title="${lForm_AUTH_CD_N}"/>
                    <e:field>
                        <e:search id="AUTH_CD" name="AUTH_CD" width="40%" onIconClick="doSearchAUTH" disabled="${form_AUTH_CD_D }" maxLength="${form_AUTH_CD_M}" required="${form_AUTH_CD_R }" readOnly="${form_AUTH_CD_RO }"  maskType="${form_AUTH_CD_MT}" />
                        <e:inputText id="AUTH_NM" name="AUTH_NM" value="" width="60%" maxLength="${lForm_AUTH_NM_M}" disabled="${lForm_AUTH_NM_D}" readOnly="${lForm_AUTH_NM_RO}" required="${lForm_AUTH_NM_R}"  maskType="${form_AUTH_NM_MT}" />
                    </e:field>
                </e:row>
                <e:row>
                    <e:label for="MENU_GROUP_NM_L" title="${lForm_MENU_GROUP_NM_L_N}"/>
                    <e:field>
                        <e:inputText id="MENU_GROUP_NM_L" name="MENU_GROUP_NM_L" width='100%' maxLength="${form_MENU_GROUP_NM_L_M }" required="${form_MENU_GROUP_NM_L_R }" readOnly="${form_MENU_GROUP_NM_L_RO }" disabled="${form_MENU_GROUP_NM_L_D}"  maskType="${form_MENU_GROUP_NM_L_MT}" />
                        <e:inputHidden id="MAIN_MODULE_TYPE" name="MAIN_MODULE_TYPE"/>
                    </e:field>
                </e:row>
            </e:searchPanel>

            <e:buttonBar id="a" width="100%" align="right">
                <e:button id="doSearchL" name="doSearchL" label="${doSearchL_N }" onClick="doSearchL" disabled="${doSearchL_D }" visible="${doSearchL_V }" />
                <e:button id="doSave" name="doSave" label="${doSave_N }" onClick="doSave" disabled="${doSave_D }" visible="${doSave_V }" />
                <e:button id="doDelete" name="doDelete" label="${doDelete_N }" onClick="doDelete" disabled="${doDelete_D }" visible="${doDelete_V }" />
            </e:buttonBar>

            <e:gridPanel gridType="${_gridType}" id="gridL" name="gridL" width="100%" height="100%" readOnly="${param.detailView}"/>

        </e:panel>

        <e:panel id="pnl2" width="20px" height="100%">
            <div ><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                <img src="/images/everuxf/icons/13x22_thumb_prev.png" width="13" height="22" onClick="doSendLeft()" style="cursor: pointer; margin-left: 3px;">
            </div>
        </e:panel>

        <e:panel id="pnl3" width="50%">
            <e:searchPanel id="frmRight" useTitleBar="false" labelWidth="180px" width="100%" columnCount="1" onEnter="doSearchR">
                <e:row>
                    <e:label for="MODULE_TYPE" title="${rForm_MODULE_TYPE_N}"/>
                    <e:field>
                        <e:select id="MODULE_TYPE" name="MODULE_TYPE" value=""   disabled="${form_MODULE_TYPE_D }" options="${moduleTypeOptions}" width="100%" required="${form_MODULE_TYPE_R }" readOnly="${form_MODULE_TYPE_RO }"  maskType="${form_MODULE_TYPE_MT}"/>
                    </e:field>
                </e:row>
                <e:row>
                    <e:label for="MENU_GROUP_NM_R" title="${rForm_MENU_GROUP_NM_R_N}"/>
                    <e:field>
                        <e:inputText id="MENU_GROUP_NM_R" name="MENU_GROUP_NM_R" width='100%' maxLength="${form_MENU_GROUP_NM_R_M }" required="${form_MENU_GROUP_NM_R_R }" readOnly="${form_MENU_GROUP_NM_R_RO }" disabled="${form_MENU_GROUP_NM_R_D}" maskType="${form_MENU_GROUP_NM_R_MT}" />
                    </e:field>
                </e:row>
            </e:searchPanel>

            <e:buttonBar id="b" width="100%" align="right">
                <e:button id="doSearchR" name="doSearchR" label="${doSearchR_N }" onClick="doSearchR" disabled="${doSearchR_D }" visible="${doSearchR_V }" />
            </e:buttonBar>

            <e:gridPanel gridType="${_gridType}" id="gridR" name="gridR" width="100%" height="100%" readOnly="${param.detailView}"/>

        </e:panel>

    </e:window>
</e:ui>

