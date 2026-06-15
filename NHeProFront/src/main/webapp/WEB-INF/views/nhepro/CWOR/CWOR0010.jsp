<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <%--<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>--%>
    <!-- ML4WEB JS -->
    <%--<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>--%>

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
		                sendBox	  : false
		            };
		            everPopup.openApprovalOrRejectPopup(params);
		       	}
				if(colIdx == "VIEW_CNT"){

		            var params = {
		                GATE_CD     : grid.getCellValue(rowIdx, "GATE_CD"),
                        BUYER_CD    : grid.getCellValue(rowIdx, "BUYER_CD"),
		                APP_DOC_NUM : grid.getCellValue(rowIdx, "APP_DOC_NUM"),
			            APP_DOC_CNT : grid.getCellValue(rowIdx, "APP_DOC_CNT"),
			            from: 'mailBox',
			            callBackFunction: ''
		       		};
		       		everPopup.approvalPathSearchPopup(params);
		   		}
				if(colIdx == "ATT_FILE_NUM") {

		   			var uuid = grid.getCellValue(rowIdx, 'ATT_FILE_NUM');
					var param = {
						attFileNum     : uuid,
                        rowIdx         : rowIdx,
						callBackFunction: '',
						bizType: 'APP',
                        detailView : true
					};
					everPopup.fileAttachPopup(param);
				}
				/*
				if(colIdx == 'REG_USER_NM') {
                    if( grid.getCellValue(rowIdx, 'REG_USER_ID') == '' ) return;
                    var param = {
                        callbackFunction : "",
                        USER_TYPE : 'B',  // O:운영사, B:고객사, S:공급사
                        USER_ID : grid.getCellValue(rowIdx, 'REG_USER_ID'),
                        detailView : true
                    };
                    everPopup.openPopupByScreenId("BYM1_062", 600, 190, param);
                }
                if(colIdx == 'NEXT_SIGN_USER_NM') {
                    if( grid.getCellValue(rowIdx, 'NEXT_SIGN_USER_ID') == '' ) return;
                    var param = {
                        callbackFunction : "",
                        USER_TYPE : 'B',  // O:운영사, B:고객사, S:공급사
                        USER_ID : grid.getCellValue(rowIdx, 'NEXT_SIGN_USER_ID'),
                        detailView : true
                    };
                    everPopup.openPopupByScreenId("BYM1_062", 600, 190, param);
                }
                */
			});

	        grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

            grid.setProperty('shrinkToFit', true);        // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            doSearch();
	    }

	    function doSearch() {

	        var store = new EVF.Store();
	        if(!store.validate()) { return; }
	        store.setGrid([grid]);
	        store.load(baseUrl + 'cwor0010_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
	            }
                grid.setColIconify("ATT_FILE_NUM", "ATT_FILE_NUM", "file", false);
	        });
	    }

	    function doApproval() {

	    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0025 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                <%--
                store.setParameter("signedData", document.reqForm.signedData.value);
                store.setParameter("vidRandom", document.reqForm.vidRandom.value);
                --%>
                store.load(baseUrl + 'cwor0010_doApproval.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });

	    	<%-- 전자결재에서 전자서명 로직 삭제 : 2020-07-22
	    	var signData = "";
            var rowIds = grid.getSelRowId();
            for(var i in rowIds) {
                signData = signData + grid.getCellValue(rowIds[i], 'APP_DOC_NUM') + "@@" + grid.getCellValue(rowIds[i], 'APP_DOC_CNT') + "@@";
            }
            signData = signData.substring(0, signData.length-2);

            var localServerFlag = "${localServerFlag}";
            EVF.confirm("${msg.M0025 }", function () {

                if (localServerFlag == "Y") {
                    doTransaction();
                } else {
                    document.reqForm.signData.value = signData;

                    var certOdiFilter = "${certOidfilter}";
                    var listOdiArr = certOdiFilter.split(";");
                    var certOidfilter = "";
                    for(var i in listOdiArr) {
                        certOidfilter = certOidfilter + listOdiArr[i] + ",";
                    }
                    certOidfilter = certOidfilter.substring(0, certOidfilter.length-1);

                    magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBack, certOidfilter);
                }
	    	});
            --%>
	    }

        function mlCallBack(code, message){
            if(code == 0){ <%-- 정상메시지 --%>
                if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
                if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
                doTransaction();
            }
            else {
                return EVF.alert("결과값 수신에 실패하였습니다.");
            }
        }

	    function doTransaction() {

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.getGridData(grid, 'sel');
            store.setParameter("signedData", document.reqForm.signedData.value);
            store.setParameter("vidRandom", document.reqForm.vidRandom.value);
            store.load(baseUrl + 'cwor0010_doApproval.so', function(){
                EVF.alert(this.getResponseMessage(), function() {
                    doSearch();
                });
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

    <e:window id="CWOR0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

		<e:inputHidden id="LOGIN_STATUS" name="LOGIN_STATUS" value="${loginStatus }"/>

		<e:searchPanel id="form" title="${msg.M9999}" labelWidth="${labelWidth}" width="100%" columnCount="2" onEnter="doSearch" useTitleBar="false">
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
			</e:row>
            <e:row>
                <e:label for="USER_NM" title="${form_USER_NM_N}"/>
                <e:field>
                    <e:search id="USER_ID" name="USER_ID" value="" width="40%" maxLength="${form_USER_ID_M}" onIconClick="${form_USER_ID_D ? 'everCommon.blank' : 'doUserSearch'}" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}"  maskType="${form_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="USER_NM" name="USER_NM" value="" width="60%" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" maskType="${form_USER_NM_MT}" placeHolder="성명" />
                </e:field>
				<e:label for="DOCUMENT_NM" title="${form_DOCUMENT_NM_N}"></e:label>
                <e:field>
					<e:inputText id="DOCUMENT_NM" name="DOCUMENT_NM" width="${form_DOCUMENT_NM_W }" maxLength="${form_DOCUMENT_NM_M }" required="${form_DOCUMENT_NM_R }" readOnly="${form_DOCUMENT_NM_RO }" disabled="${form_DOCUMENT_NM_D}" visible="${form_DOCUMENT_NM_V}" ></e:inputText>
                </e:field>
            </e:row>
        </e:searchPanel>

    	<e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
            <e:button id="Approval" name="Approval" label="${Approval_N }" disabled="${Approval_D }" onClick="doApproval" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

        <%--
        <form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
            <input type="hidden" id="signData" name="signData" value="Login"/>
            <input type="hidden" id="signedData" name="signedData"/>
            <input type="hidden" id="vidRandom" name="vidRandom"/>
            <input type="hidden" id="vidType" name="vidType" value="client"/>
            <input type="hidden" id="idn" name="idn" value=""/>
        </form>

        <div id="dscertContainer">
            <iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
        </div>
        --%>

    </e:window>
</e:ui>