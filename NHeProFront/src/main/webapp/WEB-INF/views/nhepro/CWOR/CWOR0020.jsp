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
		                gateCd    : grid.getCellValue(rowIdx, "GATE_CD"),
		                buyerCd   : grid.getCellValue(rowIdx, "BUYER_CD"),
		                appDocNum : grid.getCellValue(rowIdx, "APP_DOC_NUM"),
		                appDocCnt : grid.getCellValue(rowIdx, "APP_DOC_CNT"),
		                docType   : grid.getCellValue(rowIdx, "DOC_TYPE"),
		                signStatus: grid.getCellValue(rowIdx, "SIGN_STATUS"),
		                sendBox	  : false,
                        detailView : true
		            };
		            everPopup.openApprovalOrRejectPopup(params);

		       	} else if(colIdx == "VIEW_CNT"){

		            var params = {
		                GATE_CD     : grid.getCellValue(rowIdx, "GATE_CD"),
		                BUYER_CD    : grid.getCellValue(rowIdx, "BUYER_CD"),
		                APP_DOC_NUM : grid.getCellValue(rowIdx, "APP_DOC_NUM"),
			            APP_DOC_CNT : grid.getCellValue(rowIdx, "APP_DOC_CNT"),
			            from: 'mailBox',
			            callBackFunction: ''
		       		};
		       		everPopup.approvalPathSearchPopup(params);

		   		} else if(colIdx == "ATT_FILE_CNT") {

	        	    if(EVF.isNotEmpty(grid.getCellValue(rowIdx, 'ATT_FILE_NUM'))) {
                        var uuid = grid.getCellValue(rowIdx, 'ATT_FILE_NUM');
                        var param = {
                            attFileNum: uuid,
                            rowIdx: rowIdx,
                            callBackFunction: '',
                            bizType: 'APP',
                            detailView: true
                        };
                        everPopup.fileAttachPopup(param);
                        // everPopup.openPopupByScreenId('commonFileAttach', 650, (param.detailView == true ? 310 : 340), param);
                    }
				}
			});

            grid.setProperty('shrinkToFit', true);        // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
	        grid.setProperty('multiSelect', false);                 // [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

	        grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

            if("${ses.userType}" == "C") { grid.setColWidth('APP_AMT', 0); }

            EVF.C('SIGN_STATUS').removeOption('T');
            EVF.C('SIGN_STATUS').removeOption('C');

	        doSearch();
	    }

	    function doSearch() {

	        var store = new EVF.Store();
	        if(!store.validate()) { return; }
	        store.setGrid([grid]);
	        store.load(baseUrl + 'cwor0020_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
                grid.setColIconify("ATT_FILE_CNT", "ATT_FILE_NUM", "file", false);
	        });
	    }

	    function doUserSearch() {

            var userType = "${ses.userType}";
            var custCd = "${ses.companyCd}";

            if(userType == "O") {
                everPopup.openCommonPopup({
                    callBackFunction: 'selectUser'
                }, 'SP0012');
            } else {
            	param = {
    					'callBackFunction': 'selectUser',
    					'READONLY': 'N',         //팝업 조회조건 변경불가
    					'multiYN' : 'N',         //멀티팝업여부
    					'detailView': false
    			};
    			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
            }
	    }

	    function selectUser(data) {
	    	if(data!=null){
	    		data = JSON.parse(data);
	    		
	    		EVF.V("USER_ID", data.USER_ID);
	    		EVF.V("USER_NM", data.USER_NM);
	    	}
	    }

	    function clearUser() {
	    	EVF.V("USER_ID", "");
		}

    </script>

    <e:window id="CWOR0020" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

		<e:inputHidden id="LOGIN_STATUS" name="LOGIN_STATUS" value="${loginStatus }"/>

		<e:searchPanel id="form" title="${msg.M9999}" labelWidth="${labelWidth}" width="100%" columnCount="3" onEnter="doSearch" useTitleBar="false">
            <e:row>
                <e:label for="RFA_FROM_DATE" title="${form_RFA_FROM_DATE_N}"></e:label>
                <e:field>
                    <e:inputDate id="RFA_FROM_DATE" toDate="RFA_TO_DATE" name="RFA_FROM_DATE" value="${fromDate}" width="${inputDateWidth}" datePicker="true" required="${form_RFA_FROM_DATE_R}" disabled="${form_RFA_FROM_DATE_D}" readOnly="${form_RFA_FROM_DATE_RO}" />
                	<e:text>~</e:text>
                    <e:inputDate id="RFA_TO_DATE" fromDate="RFA_FROM_DATE" name="RFA_TO_DATE" value="${toDate}" width="${inputDateWidth}" datePicker="true" required="${form_RFA_TO_DATE_R}" disabled="${form_RFA_TO_DATE_D}" readOnly="${form_RFA_TO_DATE_RO}" />
                </e:field>
				<e:label for="DOCUMENT_TYPE" title="${form_DOCUMENT_TYPE_N}"/>
				<e:field>
					<e:select id="DOCUMENT_TYPE" name="DOCUMENT_TYPE" value="" options="${documentTypeOptions}" width="${form_DOCUMENT_TYPE_W}" disabled="${form_DOCUMENT_TYPE_D}" readOnly="${form_DOCUMENT_TYPE_RO}" required="${form_DOCUMENT_TYPE_R}" placeHolder=""  maskType="${form_DOCUMENT_TYPE_MT}"/>
				</e:field>
                <e:label for="SIGN_STATUS" title="${form_SIGN_STATUS_N}"/>
                <e:field>
                    <e:select id="SIGN_STATUS" name="SIGN_STATUS" value="" options="${signStatusOptions}" width="${form_SIGN_STATUS_W}" disabled="${form_SIGN_STATUS_D}" readOnly="${form_SIGN_STATUS_RO}" required="${form_SIGN_STATUS_R}" placeHolder=""  maskType="${form_SIGN_STATUS_MT}"/>
                </e:field>
			</e:row>
            <e:row>
                <e:label for="USER_NM" title="${form_USER_NM_N}"/>
                <e:field>
                    <e:search id="USER_ID" name="USER_ID" value="" width="40%" maxLength="${form_USER_ID_M}" onIconClick="${form_USER_ID_D ? 'everCommon.blank' : 'doUserSearch'}" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}"  maskType="${form_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="USER_NM" name="USER_NM" value="" width="60%" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" maskType="${form_USER_NM_MT}" placeHolder="성명" />
                </e:field>
				<e:label for="DOCUMENT_NM" title="${form_DOCUMENT_NM_N}"></e:label>
                <e:field colSpan="3">
					<e:inputText id="DOCUMENT_NM" name="DOCUMENT_NM" width="${form_DOCUMENT_NM_W }" maxLength="${form_DOCUMENT_NM_M }" required="${form_DOCUMENT_NM_R }" readOnly="${form_DOCUMENT_NM_RO }" disabled="${form_DOCUMENT_NM_D}" visible="${form_DOCUMENT_NM_V}"  maskType="${form_DOCUMENT_NM_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

    	<e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>