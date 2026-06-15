<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var grid;
	    var baseUrl = "/nhepro/CPRA/CPRA0040/";
	    
	    function init() {

	        grid = EVF.C("grid");
	        grid.cellClickEvent(function(rowIdx, colIdx, value) {
	        	// cell one click
	    		if (colIdx == "PR_NUM") {
	    			param = {
		    				prNum: grid.getCellValue(rowIdx, "PR_NUM"),
		    				buyerCd : grid.getCellValue(rowIdx, "BUYER_CD"),
		    				popupFlag: true,
		    				detailView : true
		    			};
	    			everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
	    		}
	    		if (colIdx=='ITEM_CD') {
					param = {
							ITEM_CD : grid.getCellValue(rowIdx,"ITEM_CD"),
							STD_ITEM_CD : grid.getCellValue(rowIdx,"ITEM_CD")
						};
					everPopup.openItemDetailInformation(param);
				}
	    		if (colIdx == "PRE_CONT_NUM") {
					if( value == "" ) return;
					param = {
							callBackFunction: '',
							BUYER_CD: grid.getCellValue(rowIdx, "PRE_BUYER_CD"),
							CONT_NUM: value,
							CONT_CNT: grid.getCellValue(rowIdx, "PRE_CONT_CNT"),
							url: "/nhepro/CCTR/CCTA0030/view.so",
							detailView: true,
							popupFlag: true
						};
					everPopup.openContractChangeInformation(param);
				}
			});

	        grid.excelExportEvent({
	        	
			});

			grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
			grid.setColGroup([
				{
                    "groupName": '담당자정보',
                    "columns": ['CTRL_USER_NM', 'PRE_CTRL_USER_NM']
                }
				,{
                    "groupName": '인터페이스정보(IT포탈)',
                    "columns": ['PRE_CONT_NUM', 'PRE_CONT_CNT', 'CM_REQ_ID', 'IF_TYPE']
                }
            ],50);
			
			// ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    grid.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    grid.setRowFooter("PR_BUYER_NM", footer);

		    var distVal = {
		          "styles": {
		              "textAlignment": "far",
		              "numberFormat" : "#,###.###",
		              "fontFmaily": "Nanum Gothic",
		              "paddingRight": 5,
		              "fontBold": true
		          },
		          "expression": ["sum"],
		          "groupExpression": "sum"
		    };
		    grid.setRowFooter("PR_QT", distVal);
		    grid.setRowFooter("PR_AMT", distVal);
		    // ===========================================================
		    
		    // 구매담당자(BR030), 관리자 권한만 IT포탈 구매의뢰건 삭제 가능
			if( ${!havePermission} && "${ses.ctrlCd}".indexOf("BR030") < 0 ) {
				EVF.C('doDelete').setDisabled(true);
			}
			
			doSearch();
	    }

	    function doSearch() {

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }
	        store.setGrid([grid]);
	        store.load(baseUrl + 'CPRA0040_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        });
	    }

	    function onIconClickPRBUYER_CD() {
			param = {
				'detailView': false,
				callBackFunction: "callBackPRBUYER_CD"
			};
			everPopup.openCommonPopup(param, "SP0066");
		}

		function callBackPRBUYER_CD(data) {
			EVF.V("PR_BUYER_CD", data.CUST_CD);
            EVF.V("PR_BUYER_NM", data.CUST_NM);

		}

		// 요청자지정
		function doSearchPRUser(is_ctrl) {
			param = {
					'callBackFunction': 'selectPRUser',
					'READONLY': 'N',        //팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : '',			// 구매담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		// 요청자지정
		function selectPRUser(data) {
			if(data!=null){
	    		data = JSON.parse(data);
			
	    		EVF.V("REQ_USER_ID", data.USER_ID);
				EVF.V("REQ_USER_NM", data.USER_NM);
			}	
		}

		// 담당자 지정 - 유저선택
		function doSearchCTRLUser() {
			param = {
				'callBackFunction': 'selectCTRLUser',
				'READONLY': 'Y',        //팝업 조회조건 변경불가
				'multiYN' : 'N',        //멀티팝업여부
				'CTRL_CD' : 'BR030',	// 구매담당자권한
				'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		// 담당자 지정 - 유저선택
		function selectCTRLUser(data) {
			if(data!=null){
				data = JSON.parse(data);
				EVF.V("CTRL_BUYER_CD", data.CUST_CD);
				EVF.V("CTRL_USER_ID",  data.USER_ID);
				EVF.V("CTRL_USER_NM",  data.USER_NM);
				EVF.V("CTRL_DEPT_CD",  data.DEPT_CD);
			}
		}

		// 담당자 지정 - 담당자 변경
		function ChangeCtrl(){

			// 선택한 담당자가 없습니다
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			// 구매담당자를 입력하세요
			var ctrlUserId = EVF.V("CTRL_USER_ID");
			if( EVF.isEmpty(ctrlUserId) ) {return EVF.alert("${CPRA0040_M0005}");}
			
			var msg = "${CPRA0040_M0004 }";
			var rowIds = grid.getSelRowId();
	    	for(var i in rowIds) {
    			// 미접수된 건만 담당자 지정이 가능합니다
	    		if( grid.getCellValue(rowIds[i], 'RECEIPT_FLAG') != "0" ) {
	    			return EVF.alert("${CPRA0040_M0006}");
    			}
	    		
	    		// 2021.05.18 추가
	    		// 이전구매담당자가 존재하는 경우 = 신규 구매담당자가 이전 구매담당자가 아닌 경우 confirm 창
	    		if( !EVF.isEmpty(grid.getCellValue(rowIds[i], 'PRE_CTRL_USER_ID')) && ctrlUserId != grid.getCellValue(rowIds[i], 'PRE_CTRL_USER_ID') ) {
	    			msg = "이전계약의 구매담당자와 지정하려는 구매담당자가 다른 의뢰건이 있습니다.\n\n담당자를 지정하시겠습니까?";
	    		}
    		}

	    	// 담당자를 지정하시겠습니까?
			EVF.confirm(msg, function () {
	    		var store = new EVF.Store();
	    		store.setGrid([grid]);
	    		store.getGridData(grid, 'sel');
	    		store.setParameter("CTRL_USER_ID", EVF.V("CTRL_USER_ID") );
	    		store.load(baseUrl + 'CPRA0040_doChangeCtrl.so', function(){
	    			EVF.alert(this.getResponseMessage());
	        		doSearch();
	    		});
			});
		}
		
		function selectCTRLUserNm() {
	    	var store = new EVF.Store();
	        store.load(baseUrl + 'CPRA0040_doSearchCtrlUserNm.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        	else {
	        		EVF.V("CTRL_USER_NM", this.getResponseMessage());
	        	}
	        });
	    }
		
		// IT포탈 구매의뢰건 삭제
		function doDelete(){

			// 선택한 데이터가 없습니다
			var selRowCount = grid.getSelRowCount();
			if (selRowCount == 0) { return EVF.alert("${msg.M0004}"); }
			
			// 구매담당자 또는 관리자 권한이 없는 경우
			if( ${!havePermission} && "${ses.ctrlCd}".indexOf("BR030") < 0 ) {
				return EVF.alert("${CPRA0040_M0007}");
			}
			
			var selRowId = grid.getSelRowId();
			for(var i in selRowId) {
				if( grid.getCellValue(selRowId[i], "IF_TYPE") != "ITA" && grid.getCellValue(selRowId[i], "IF_TYPE") != "ITB" ) {
					return alert("${CPRA0040_M0009}"); // IT포탈 구매의뢰건만 삭제할 수 있습니다. Interface 유형을 확인하세요.
				}
				
				if( grid.getCellValue(selRowId[i], "RECEIPT_FLAG") == "1" ) {
					return alert("${CPRA0040_M0008}"); // 미접수인 건만 삭제할 수 있습니다.
				}
			}
			
			if( !confirm("구매담당자 미지정 및 미접수인 건만 삭제됩니다.\n\n선택한 [" + selRowCount + "] 건의 IT포탈 구매의뢰를 삭제 하시겠습니까?") ) {
				return;
			}
			
			var param = {
				title : '구매의뢰 삭제사유',
				message: EVF.V("DEL_RMK"),
				callbackFunction : 'doDeleteApproval',
				detailView : false
			};
			everPopup.commonTextInput(param);
		}
		
		function doDeleteApproval(data) {
			
			var store = new EVF.Store();
			if( EVF.isEmpty(data.message) ) {
                return EVF.alert("구매의뢰 삭제 사유가 없습니다.");
            }
			
			EVF.V("DEL_RMK", data.message);
			EVF.confirm("선택한 IT포탈 구매의뢰를 정말로 삭제 하시겠습니까?", function() {
				store.setGrid([grid]);
				store.getGridData(grid, "sel");
				store.load(baseUrl+'/cpra0040_doDelete.so', function() {
					EVF.alert("${msg.M0001}");
					doSearch();
				});
			});
		}
		
    </script>
    
	<e:window id="CPRA0040" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<!-- 구매담당자 BUYER_CD, DEPT_CD -->
			<e:inputHidden id="CTRL_BUYER_CD" name="CTRL_BUYER_CD"/>
			<e:inputHidden id="CTRL_DEPT_CD" name="CTRL_DEPT_CD"/>
			<!-- 2021.04.12 추가 -->
			<e:inputHidden id="DEL_RMK" name="DEL_RMK"/> <!-- IT포탈 구매의뢰 삭제사유 -->
			
			<e:row>
				<!-- 요청 일자 -->
		        <e:label for="REQ_DATE_FROM" title="${form_REQ_DATE_FROM_N}"/>
				<e:field>
					<e:inputDate id="REQ_DATE_FROM" name="REQ_DATE_FROM" value="${reqFromDate}" width="${inputDateWidth}" datePicker="true" required="${form_REQ_DATE_FROM_R}" disabled="${form_REQ_DATE_FROM_D}" readOnly="${form_REQ_DATE_FROM_RO}" />
					<e:text>~</e:text>
					<e:inputDate id="REQ_DATE_TO" name="REQ_DATE_TO" value="${reqToDate}" width="${inputDateWidth}" datePicker="true" required="${form_REQ_DATE_TO_R}" disabled="${form_REQ_DATE_TO_D}" readOnly="${form_REQ_DATE_TO_RO}" />
				</e:field>
				<!-- 의뢰번호/명 -->
		        <e:label for="PR_NUM" title="${form_PR_NUM_N}"/>
				<e:field>
					<e:inputText id="PR_NUM" name="PR_NUM" value="${form.PR_NUM}" width="36%" maxLength="${form_PR_NUM_M}" disabled="${form_PR_NUM_D}" readOnly="${form_PR_NUM_RO}" required="${form_PR_NUM_R}"  maskType="${form_PR_NUM_MT}" />
					<e:text>/</e:text>
					<e:inputText id="PR_SUBJECT" name="PR_SUBJECT" value="${form.PR_SUBJECT}" width="60%" maxLength="${form_PR_SUBJECT_M}" disabled="${form_PR_SUBJECT_D}" readOnly="${form_PR_SUBJECT_RO}" required="${form_PR_SUBJECT_R}"  maskType="${form_PR_SUBJECT_MT}" />
				</e:field>
				<!-- 고객사 -->
				<e:label for="PR_BUYER_NM" title="${form_PR_BUYER_NM_N}"/>
				<e:field>
					<e:search id="PR_BUYER_CD" name="PR_BUYER_CD" value="" width="40%" maxLength="${form_PR_BUYER_CD_M}" onIconClick="${form_PR_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickPRBUYER_CD'}" disabled="${form_PR_BUYER_CD_D}" readOnly="${form_PR_BUYER_CD_RO}" required="${form_PR_BUYER_CD_R}" maskType="${form_PR_BUYER_CD_MT}" placeHolder="회사코드" />
					<e:inputText id="PR_BUYER_NM" name="PR_BUYER_NM" value="" width="60%" maxLength="${form_PR_BUYER_NM_M}" disabled="${form_PR_BUYER_NM_D}" readOnly="${form_PR_BUYER_NM_RO}" required="${form_PR_BUYER_NM_R}" style="${imeMode}" maskType="${form_PR_BUYER_NM_MT}" placeHolder="회사명"/>
				</e:field>
			</e:row>
			<e:row>
				<!-- 구매유형 -->
				<e:label for="PURCHASE_TYPE" title="${form_PURCHASE_TYPE_N}"/>
				<e:field>
					<e:select id="PURCHASE_TYPE" name="PURCHASE_TYPE" value="" options="${purchaseTypeOptions}" width="${form_PURCHASE_TYPE_W}" disabled="${form_PURCHASE_TYPE_D}" readOnly="${form_PURCHASE_TYPE_RO}" required="${form_PURCHASE_TYPE_R}" placeHolder="" maskType="${form_PURCHASE_TYPE_MT}" />
				</e:field>
				<!-- 담당자 지정 -->
				<e:label for="PURCHASE_YN" title="${form_PURCHASE_YN_N}"/>
				<e:field>
					<e:select id="PURCHASE_YN" name="PURCHASE_YN" value="N" options="${purchaseYnOptions}" width="${form_PURCHASE_YN_W}" disabled="${form_PURCHASE_YN_D}" readOnly="${form_PURCHASE_YN_RO}" required="${form_PURCHASE_YN_R}" placeHolder="" maskType="${form_PURCHASE_YN_MT}" />
				</e:field>
				<!-- 요청자 -->
				<e:label for="REQ_USER_NM" title="${form_REQ_USER_NM_N}"/>
				<e:field>
					<e:search id="REQ_USER_ID" name="REQ_USER_ID" value="" width="40%" maxLength="${form_REQ_USER_ID_M}" onIconClick="${form_REQ_USER_ID_RO ? 'everCommon.blank' : 'doSearchPRUser'}" disabled="${form_REQ_USER_ID_D}" readOnly="${form_REQ_USER_ID_RO}" required="${form_REQ_USER_ID_R}" maskType="${form_REQ_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="REQ_USER_NM" name="REQ_USER_NM" value="" width="60%" maxLength="${form_REQ_USER_NM_M}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}" style="${imeMode}" maskType="${form_REQ_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PR_TYPE" title="${form_PR_TYPE_N}"/>
				<e:field>
					<e:select id="PR_TYPE" name="PR_TYPE" value="" options="${prTypeOptions}" width="${form_PR_TYPE_W}" disabled="${form_PR_TYPE_D}" readOnly="${form_PR_TYPE_RO}" required="${form_PR_TYPE_R}" placeHolder="" maskType="${form_PR_TYPE_MT}" />
				</e:field>
				<e:label for="CM_REQ_ID" title="${form_CM_REQ_ID_N}" />
				<e:field>
					<e:inputText id="CM_REQ_ID" name="CM_REQ_ID" value="" width="${form_CM_REQ_ID_W}" maxLength="${form_CM_REQ_ID_M}" disabled="${form_CM_REQ_ID_D}" readOnly="${form_CM_REQ_ID_RO}" required="${form_CM_REQ_ID_R}" style="${imeMode}" maskType="${form_CM_REQ_ID_MT}"/>
				</e:field>
				<e:label for="IF_TYPE" title="${form_IF_TYPE_N}"/>
				<e:field>
					<e:select id="IF_TYPE" name="IF_TYPE" value="" options="${ifTypeOptions}" width="${form_IF_TYPE_W}" disabled="${form_IF_TYPE_D}" readOnly="${form_IF_TYPE_RO}" required="${form_IF_TYPE_R}" placeHolder="" maskType="${form_IF_TYPE_MT}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:text style="color: blue;font-weight: bold;">■ 구매담당자 : </e:text>
			<e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="" width="${form_CTRL_USER_ID_W}" maxLength="${form_CTRL_USER_ID_M}" onIconClick="doSearchCTRLUser" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" maskType="${form_CTRL_USER_ID_MT}" align="right" />
			<e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="" width="${form_CTRL_USER_NM_W}" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}"/>
			<e:button id="ChangeCtrl" name="ChangeCtrl" label="${ChangeCtrl_N}" onClick="ChangeCtrl" disabled="${ChangeCtrl_D}" visible="${ChangeCtrl_V}" style="padding-left:3px;" align="left"/>
			
			<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
			<%-- 2021.05.31 : 사용자 법인구분이 은행(1) OR 중앙회(5)일 경우만 IT포탈 구매의뢰건 삭제가능. --%>
            <c:if test="${ses.corpType eq '1' or ses.corpType eq '5'}">
				<e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
			</c:if>
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>