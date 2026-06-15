<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

	    var baseUrl = "/nhepro/CWOR/";
	    var grid;

	    function init() {

	    	grid = EVF.C("grid");

	        grid.cellClickEvent(function(rowIdx, colIdx, value, iRow, iCol) {

	        	if(colIdx === 'APP_DOC_NUM'){

		            var params = {
		                gateCd : grid.getCellValue(rowIdx, "GATE_CD"),
		                buyerCd : grid.getCellValue(rowIdx, "BUYER_CD"),
		                appDocNum : grid.getCellValue(rowIdx, "APP_DOC_NUM"),
		                appDocCnt : grid.getCellValue(rowIdx, "APP_DOC_CNT"),
		                docType : grid.getCellValue(rowIdx, "DOC_TYPE"),
		                signStatus : grid.getCellValue(rowIdx, "SIGN_STATUS"),
		                sendBox : true,
                        detailView : false
		            };
		            everPopup.openApprovalOrRejectPopup(params);
		       	}
	        	else if(colIdx == "VIEW_CNT"){

		       		var param = {
		       			GATE_CD : grid.getCellValue(rowIdx, "GATE_CD"),
                        BUYER_CD : grid.getCellValue(rowIdx, "BUYER_CD"),
		       			APP_DOC_NUM : grid.getCellValue(rowIdx, "APP_DOC_NUM"),
	                    APP_DOC_CNT : grid.getCellValue(rowIdx, "APP_DOC_CNT")
	                };
	                everPopup.approvalPathSearchPopup(param);
				}
			});

            EVF.C('SIGN_STATUS').removeOption('T');

	        grid.setProperty('shrinkToFit', true);                  // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

	        grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

	        doSearch();
	    }

	    function doSearch() {

	        var store = new EVF.Store();
	        if(!store.validate()) { return; }
	        store.setGrid([grid]);
	        store.load(baseUrl + 'cwor0030_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
                <%--grid.setColIconify("ATT_FILE_NUM", "ATT_FILE_NUM", "file", false);--%>
	        });
	    }

	    function doCancel() {

	    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	    	var rowIds = grid.getSelRowId();
	    	for(var i in rowIds) {
	    		if(grid.getCellValue(rowIds[i], "SIGN_STATUS") != "P") {
	                return EVF.alert("${CWOR0030_0002}");
	            }
	    		noticeNum = grid.getCellValue(rowIds[i], "NOTICE_NUM");
    		}

            EVF.confirm("${CWOR0030_0003 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
	            store.getGridData(grid, 'sel');
	            store.load(baseUrl + 'cwor0030_doCancel.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
	        		    doSearch();
                    });
	        	});
	    	});
	    }

    </script>

    <e:window id="CWOR0030" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999}" labelWidth="${labelWidth}" width="100%" columnCount="2" onEnter="doSearch" useTitleBar="false">
            <e:row>
                <e:label for="START_DATE" title="${form_START_DATE_N}"></e:label>
                <e:field>
                    <e:inputDate id="START_DATE" toDate="END_DATE" name="START_DATE" value="${fromDate}" width="${inputDateWidth}" datePicker="true" required="${form_START_DATE_R}" disabled="${form_START_DATE_D}" readOnly="${form_START_DATE_RO}" />
                	<e:text>~</e:text>
                    <e:inputDate id="END_DATE" fromDate="START_DATE" name="END_DATE" value="${toDate}" width="${inputDateWidth}" datePicker="true" required="${form_END_DATE_R}" disabled="${form_END_DATE_D}" readOnly="${form_END_DATE_RO}" />
                </e:field>
				<e:label for="SIGN_STATUS" title="${form_SIGN_STATUS_N}"/>
				<e:field>
					<e:select id="SIGN_STATUS" name="SIGN_STATUS" value="" options="${signStatusOptions}" width="${form_SIGN_STATUS_W}" disabled="${form_SIGN_STATUS_D}" readOnly="${form_SIGN_STATUS_RO}" required="${form_SIGN_STATUS_R}" placeHolder=""  maskType="${form_SIGN_STATUS_MT}"/>
				</e:field>
			</e:row>
            <e:row>
            	<e:label for="DOC_TYPE" title="${form_DOC_TYPE_N}"/>
				<e:field>
					<e:select id="DOC_TYPE" name="DOC_TYPE" value="" options="${docTypeOptions}" width="${form_DOC_TYPE_W}" disabled="${form_DOC_TYPE_D}" readOnly="${form_DOC_TYPE_RO}" required="${form_DOC_TYPE_R}" placeHolder=""  maskType="${form_DOC_TYPE_MT}"/>
				</e:field>
            	<e:label for="SUBJECT" title="${form_SUBJECT_N}"></e:label>
                <e:field>
					<e:inputText id="SUBJECT" name="SUBJECT" width="${form_SUBJECT_W }" maxLength="${form_SUBJECT_M }" required="${form_SUBJECT_R }" readOnly="${form_SUBJECT_RO }" disabled="${form_SUBJECT_D}" visible="${form_SUBJECT_V}" ></e:inputText>
                </e:field>
			</e:row>
        </e:searchPanel>

    	<e:buttonBar id="buttonBar" title="${CWOR0030_T001}" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
            <e:button id="Cancel" name="Cancel" label="${Cancel_N }" disabled="${Cancel_D }" onClick="doCancel" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>