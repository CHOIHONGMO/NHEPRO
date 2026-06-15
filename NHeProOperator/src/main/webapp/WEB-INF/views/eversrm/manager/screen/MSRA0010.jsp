<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

    	var grid = {};
    	var addParam = [];
    	var baseUrl = "/eversrm/manager/screen/";

		function init() {

			grid = EVF.C('grid');

			grid.cellClickEvent(function(rowIdx, colIdx) {
			    var multi_cd;
                var param;

                if (colIdx === 'SCREEN_NM') {
                    if (grid.getCellValue(rowIdx, 'SCREEN_ID') == null || grid.getCellValue(rowIdx, 'SCREEN_ID') == '') {
                        return EVF.alert("${MSRA0010_MSG_0001 }");
                    }
                    multi_cd = 'SC';
                }
                else if (colIdx === 'POPUP_NM_IMG') {
                    if (grid.getCellValue(rowIdx, 'SCREEN_ID') == null || grid.getCellValue(rowIdx, 'SCREEN_ID') == '') {
                        return EVF.alert("${MSRA0010_MSG_0001 }");
                    }
                    multi_cd = 'SCP';
                }
                else if (colIdx === 'AUTH_IMG') {
                    if (grid.getCellValue(rowIdx, 'SCREEN_ID') == null || grid.getCellValue(rowIdx, 'SCREEN_ID') == '') {
                        return EVF.alert("${MSRA0010_MSG_0001 }");
                    }
                    param = {
                        "callbackFunction": "setScreenAuth",
                        "screenId": grid.getCellValue(rowIdx, 'SCREEN_ID'),
                        "rowIdx": rowIdx
                    };
                    var url = '/eversrm/manager/screen/MSRA0034/view.so';
                    return new EVF.ModalWindow(url, param, 700, 400).open();
                }
                else if (colIdx === 'HELP_INFO') {
                    param = {
                        PARAM_SCREEN_ID: grid.getCellValue(rowIdx, 'SCREEN_ID'),
                        POPUPFLAG: "Y",
                        detailView: false
                    };
                    everPopup.openPopupByScreenId('MSRA0012', 950, 665, param);
                    return;
                }
                else {
                    return;
                }

                var screen_id = grid.getCellValue(rowIdx, "SCREEN_ID");
		        var params = {
		            multi_cd: multi_cd,
		            screen_id: screen_id,
                    rowIdx: rowIdx
		        };
		        everPopup.openMultiLanguagePopup(params);
			});

            grid.addRowEvent(function() {
                addParam = [{"USE_FLAG": "1", "INSERT_FLAG": "I", "GATE_CD": "${ses.gateCd }"}];
                grid.addRow(addParam);
            });

            grid.delRowEvent(function() {
                if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                grid.delRow();
            });

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            grid.setProperty('shrinkToFit', ${shrinkToFit});		//컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			//로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				//컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		//그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	//셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			//그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		//[선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); //[선택] 컬럼의 사용여부를 지정한다. [true/false]
        }

        function setScreenAccessibleCount(rowId, count) {
            var c = Number(count);
            grid.setCellValue(rowId, 'AUTH_IMG', (c > 0 ? 'Y' : ''));
        }

        function doSearch() {

        	var store = new EVF.Store();
        	store.setGrid([grid]);
            store.load(baseUrl + 'screenManagement/doSearch.so', function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
                grid.setColIconify("HELP_INFO", "HELP_INFO", "comment", false);
            });
        }

        function doInsert() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

	        var rowIds = grid.getSelRowId();
	        for (var i = 0; i < rowIds.length; i++) {
	            if (grid.getCellValue(rowIds[i], 'INSERT_FLAG') === 'U') {
                    return EVF.alert("${msg.M0005}");
	            }
	        }

			EVF.confirm("${msg.M0011 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'screenManagement/doInsert.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }

		function doUpdate() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

	        for (var i = 0; i < grid.getRowCount(); i++) {
		        if (grid.getCellValue(i, 'INSERT_FLAG') == 'I' || grid.getCellValue(i, 'SCREEN_ID') != grid.getCellValue(i, 'SCREEN_ID_ORG')) {
	                return EVF.alert("${msg.M0007}");
	            }
	        }

			EVF.confirm("${msg.M0012}", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'screenManagement/doUpdate.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }

		function doDelete() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			for (var i = 0; i < grid.getRowCount(); i++) {
	            if (grid.getCellValue(i, 'INSERT_FLAG') == 'I' || grid.getCellValue(i, 'SCREEN_ID') != grid.getCellValue(i, 'SCREEN_ID_ORG')) {
	                return EVF.alert("${msg.M0007}");
	            }
	        }

			EVF.confirm("${msg.M0013 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'screenManagement/doDelete.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
	    }

		function doCopy() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${BSYS_010_MSG_0002}"); }

            if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

            EVF.confirm("${MSRA0010_MSG_0004 }", function () {
                var param = {
                    COPY_SCREEN_ID : EVF.V("COPY_SCREEN_ID"),
                    COPY_SCREEN_NM : EVF.V("COPY_SCREEN_NM"),
                    COPY_SCREEN_URL : EVF.V("COPY_SCREEN_URL"),
                    callbackFunction: 'setURL',
                    detailView: false
                };
                everPopup.openPopupByScreenId("MSRA0011", 700, 120, param);
            });
	    }

		function setURL(data) {

			EVF.V("COPY_SCREEN_ID", data.COPY_SCREEN_ID);
			EVF.V("COPY_SCREEN_NM", data.COPY_SCREEN_NM);
			EVF.V("COPY_SCREEN_URL", data.COPY_SCREEN_URL);

			var store = new EVF.Store();
			store.setGrid([grid]);
        	store.getGridData(grid, 'sel');
	        store.load(baseUrl + 'screenManagement/doCopy.so', function() {
	        	EVF.alert(this.getResponseMessage().replace("@@","\n"), function() {
                    EVF.V("SCREEN_ID", EVF.V("COPY_SCREEN_ID"));
                    doSearch();
                });
	        });
		}

	    function multiLanguagePopupCallBack(multiLanguagePopupReturn) {
	    	if(multiLanguagePopupReturn.multiCd == "SCP") {
	    		grid.setCellValue(multiLanguagePopupReturn.rowIdx, "POPUP_NM_IMG", multiLanguagePopupReturn.multiNm);
	    	}else {
	           grid.setCellValue(multiLanguagePopupReturn.rowIdx, "SCREEN_NM", multiLanguagePopupReturn.multiNm);
	    	}
	    }

    </script>

    <e:window id="MSRA0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${msg.M9999 }" columnCount="3" labelWidth="${labelWidth }" onEnter="doSearch" useTitleBar="false">
        	<e:row>
                <e:label for="MODULE_TYPE" title="${form_MODULE_TYPE_N }" />
                <e:field>
                    <e:select id="MODULE_TYPE" name="MODULE_TYPE" options="${moduleTypeOptions}" readOnly="${form_MODULE_TYPE_RO }" width="${form_MODULE_TYPE_W }" required="${form_MODULE_TYPE_R }" disabled="${form_MODULE_TYPE_D }"  maskType="${form_MODULE_TYPE_MT}"/>
                </e:field>
                <e:label for="SCREEN_ID" title="${form_SCREEN_ID_N }" />
                <e:field>
                	<e:inputText id="SCREEN_ID" name="SCREEN_ID" width="${form_SCREEN_ID_W }" required="${form_SCREEN_ID_R }" disabled="${form_SCREEN_ID_D }" value="" readOnly="${form_SCREEN_ID_RO }" maxLength="${form_SCREEN_ID_M}"  maskType="${form_SCREEN_ID_MT}" />
                </e:field>
                <e:label for="SCREEN_NM" title="${form_SCREEN_NM_N }" />
                <e:field>
	                <e:inputText id="SCREEN_NM" name="SCREEN_NM" width="${form_SCREEN_NM_W }" required="${form_SCREEN_NM_R }" disabled="${form_SCREEN_NM_D }"  readOnly="${form_SCREEN_NM_RO }" maxLength="${form_SCREEN_NM_M}" maskType="${form_SCREEN_NM_MT}" />
                </e:field>
            </e:row>
			<e:row>
				<e:label for="SCREEN_URL" title="${form_SCREEN_URL_N }" />
                <e:field>
                	<e:inputText id="SCREEN_URL" name="SCREEN_URL" width="${form_SCREEN_URL_W }" required="${form_SCREEN_URL_R }" disabled="${form_SCREEN_URL_D }" readOnly="${form_SCREEN_URL_RO }" maxLength="${form_SCREEN_URL_M}"  maskType="${form_SCREEN_URL_MT}" />
                </e:field>
				<e:label for="SCREEN_TYPE" title="${form_SCREEN_TYPE_N }" />
                <e:field>
                    <e:select id="SCREEN_TYPE" name="SCREEN_TYPE" options="${screenTypeOptions}" width="${form_SCREEN_TYPE_W }" required="${form_SCREEN_TYPE_R }" disabled="${form_SCREEN_TYPE_D }" readOnly="${form_SCREEN_TYPE_RO }" maskType="${form_SCREEN_TYPE_MT}"/>
                </e:field>
                <e:label for="DEVELOPER_CD" title="${form_DEVELOPER_CD_N }" />
                <e:field>
                    <e:select id="DEVELOPER_CD" name="DEVELOPER_CD" options="${developerCdOptions}" width="${form_DEVELOPER_CD_W }" required="${form_DEVELOPER_CD_R }" disabled="${form_DEVELOPER_CD_D }" readOnly="${form_DEVELOPER_CD_RO }" maskType="${form_DEVELOPER_CD_MT}"/>
                    <e:inputHidden id="COPY_SCREEN_ID" name="COPY_SCREEN_ID" value="" />
                    <e:inputHidden id="COPY_SCREEN_NM" name="COPY_SCREEN_NM" value="" />
                    <e:inputHidden id="COPY_SCREEN_URL" name="COPY_SCREEN_URL" value="" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
                <e:button id="Copy" name="Copy" align="left" label="${Copy_N }" disabled="${Copy_D }" style="padding-left:3px" onClick="doCopy" />
                <e:text>(${MSRA0010_MSG_0003})</e:text>
                <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
                <e:button id="Insert" name="Insert" label="${Insert_N }" disabled="${Insert_D }" onClick="doInsert" />
                <e:button id="Update" name="Update" label="${Update_N }" disabled="${Update_D }" onClick="doUpdate" />
                <e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" onClick="doDelete" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>