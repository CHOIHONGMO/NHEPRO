<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

        var baseUrl = "/eversrm/manager/auth/MAUB0020/";
        var meGrid;
        var buGrid;
        var SelectRowId;
        var SelectGrid;

        function init() {
            meGrid = EVF.C("meGrid");
            buGrid = EVF.C("buGrid");

            meGrid.setProperty('shrinkToFit', false);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            meGrid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            meGrid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            meGrid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            meGrid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            meGrid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            meGrid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            buGrid.setProperty('shrinkToFit', false);
            buGrid.setProperty('rowNumbers', ${rowNumbers});
            buGrid.setProperty('sortable', ${sortable});
            buGrid.setProperty('panelVisible', ${panelVisible});
            buGrid.setProperty('enterToNextRow', ${enterToNextRow});
            buGrid.setProperty('acceptZero', ${acceptZero});
            buGrid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

            // Grid Excel Export
            meGrid.excelExportEvent({
                allCol : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            buGrid.excelExportEvent({
                allCol : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

        }

        function getContentTab(uu) {
            if (uu == '1') {
                delType = 'me'
            }
            if (uu == '2') {
                delType = 'bu'
            }
        }

        $(document.body).ready(function() {
            $('#e-tabs').height(($('.ui-layout-center').height() - 30)).tabs({
                activate : function(event, ui) {
                    $(window).trigger('resize');
                }
            });
            $('#e-tabs').tabs('option', 'active', 0);
        });

        function doSearch() {
            var store = new EVF.Store();
            store.setGrid([meGrid,buGrid]);
            store.load(baseUrl + "/doSearch.so", function() {
            });
        }

        function getRegUserId() {
            var param = {
                callBackFunction : "setRegUserId"
            };
            everPopup.openCommonPopup(param, 'SP0011');
        }
        function setRegUserId(data) {
            EVF.V("USER_ID", data.USER_ID);
            EVF.V("USER_NM", data.USER_NM);
        }

        function getScreenId() {
            var popupUrl = "/eversrm/manager/screen/MSRA0011/view.so";
            everPopup.openWindowPopup(popupUrl, 1000, 500, {
                onSelect: 'selectScreen',
                screen_Id: ""
            }, 'screenIdPopup');
        }
        function selectScreen(data) {
            EVF.V("SCREEN_ID", data.SCREEN_ID);
            EVF.V("SCREEN_NM", data.SCREEN_NM);
        }



    </script>

    <e:window id="MAUB0020" onReady="init" initData="${initData}" title="${fullScreenName}">
        <e:searchPanel id="form" title="${form_CAPTION_N }" columnCount="3" labelWidth="${labelWidth }" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <e:label for="SCREEN_ID" title="${form_SCREEN_ID_N }" />
                <e:field>
                    <e:search id="SCREEN_ID" name="SCREEN_ID" value="" width="40%" maxLength="${form_SCREEN_ID_M}" onIconClick="getScreenId" disabled="${form_SCREEN_ID_D}" readOnly="${form_SCREEN_ID_RO}" required="${form_SCREEN_ID_R}"  maskType="${form_SCREEN_ID_MT}" />
                    <e:inputText id="SCREEN_NM" name="SCREEN_NM"  value="" width="60%" maxLength="${form_SCREEN_NM_M}" disabled="${form_SCREEN_NM_D}" readOnly="${form_SCREEN_NM_RO}" required="${form_SCREEN_NM_R}"  maskType="${form_SCREEN_NM_MT}" />
                </e:field>
                <e:label for="ACTION_CD" title="${form_ACTION_CD_N }" />
                <e:field>
                    <e:inputText id="ACTION_CD" name="ACTION_CD" maxLength="${form_ACTION_ID_M}" width="${form_ACTION_CD_W }" required="${form_ACTION_CD_R }" readOnly="${form_ACTION_CD_RO }" disabled="${form_ACTION_CD_D }"  maskType="${form_ACTION_CD_MT}" />
                </e:field>
                <e:label for="ACTION_NM" title="${form_ACTION_NM_N }" />
                <e:field>
                    <e:inputText id="ACTION_NM" name="ACTION_NM" maxLength="${form_ACTION_NM_M}" width="${form_ACTION_NM_W }" required="${form_ACTION_NM_R }" readOnly="${form_ACTION_NM_RO }" disabled="${form_ACTION_NM_D }"  maskType="${form_ACTION_NM_MT}" />
                </e:field>

            </e:row>
            <e:row>
                <e:label for="CTRL_NM" title="${form_CTRL_NM_N }" />
                <e:field>
                    <e:select id="CTRL_NM" name="CTRL_NM" value="" options="${ctrlNmOptions}" width="100%" disabled="${form_CTRL_NM_D}" readOnly="${form_CTRL_NM_RO}" required="${form_CTRL_NM_R}" placeHolder="" usePlaceHolder="false" useMultipleSelect="true"  maskType="${form_CTRL_NM_MT}"/>
                </e:field>
                <e:label for="USER_NM" title="${form_USER_NM_N }" />
                <e:field>
                    <e:search id="USER_ID" name="USER_ID" value="" width="40%" maxLength="${form_USER_ID_M}" onIconClick="getRegUserId" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}"  maskType="${form_USER_ID_MT}" />
                    <e:inputText id="USER_NM" name="USER_NM"  value="" width="60%" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}"  maskType="${form_USER_NM_MT}" />
                </e:field>
                <e:label for=""/>
                <e:field/>
            </e:row>
        </e:searchPanel>

        <e:buttonBar align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
        </e:buttonBar>

        <div id="e-tabs" class="e-tabs" style="padding: 0 !important;">
            <tr><td><div>
                <ul>
                    <li id="tab1"><a href="#ui-tabs-1" onclick="getContentTab('1');">${MAUB0020_TAB1}</a></li>
                    <li id="tab2"><a href="#ui-tabs-2" onclick="getContentTab('2');">${MAUB0020_TAB2}</a></li>
                </ul>

                <div id="ui-tabs-1">
                    <div style="height: auto;">
                        <e:gridPanel gridType="${_gridType}" id="meGrid" name="meGrid" height="fit" readOnly="${param.detailView}"/>
                    </div>
                </div>

                <div id="ui-tabs-2">
                    <div style="height: auto;">
                        <e:gridPanel gridType="${_gridType}" id="buGrid" name="buGrid" height="fit" readOnly="${param.detailView}"/>
                    </div>
                </div>
            </div></td></tr>
        </div>

    </e:window>
</e:ui>