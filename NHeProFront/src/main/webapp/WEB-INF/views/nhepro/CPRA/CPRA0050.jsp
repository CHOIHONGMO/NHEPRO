<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>

<!-- 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가 -->
<% String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd"); %>

<c:set var="ManagerCd" value="<%=ManagerCd%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">
		
        var grid;
        var baseUrl = "/nhepro/CPRA/CPRA0050/";
		var changeFlag = false;
        
        function init() {

            grid = EVF.C("grid");
            grid.cellClickEvent(function(rowIdx, colIdx, value) {
            	// 2021.05.18 추가
				// 동일한 이전계약번호, 이전계약차수는 한꺼번에 선택되도록 한다.
				if(colIdx == "multiSelect") {
					if( grid.getCellValue(rowIdx, 'PRE_CONT_NUM') != '' ) {
						if(value == "1") {
	                       	grid.checkEqualRow(["PRE_CONT_NUM", "PRE_CONT_CNT"], [grid.getCellValue(rowIdx, "PRE_CONT_NUM"), grid.getCellValue(rowIdx, "PRE_CONT_CNT")]);
	                    } else {
	                        grid.checkNotEqualRow(["PRE_CONT_NUM", "PRE_CONT_CNT"], [grid.getCellValue(rowIdx, "PRE_CONT_NUM"), grid.getCellValue(rowIdx, "PRE_CONT_CNT")]);
	                    }
					}
				}
            	if(colIdx == "PR_NUM") {
            		var detailViewFlag = true;
            		
                    // 접수대기(2100)인 건만 수정 가능
                    // 해당 구매의뢰의 MAX_PROGRESS_CD가 접수대기(2100)인 건만 수정 가능
                    // 구매담당자가 자신의 것만 수정 가능
                    if (grid.getCellValue(rowIdx, 'PROGRESS_CD') == '2100' && grid.getCellValue(rowIdx, 'MAX_PROGRESS_CD') == '2100' && grid.getCellValue(rowIdx, 'CTRL_USER_ID') == "${ses.userId}") {
                    	detailViewFlag = false;
                    }
            		
                    param = {
                        prNum: grid.getCellValue(rowIdx, "PR_NUM"),
                        buyerCd : grid.getCellValue(rowIdx, "BUYER_CD"),
                        popupFlag: true,
                        detailView : detailViewFlag
                    };
                    everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
                }
                if(colIdx == "REJECT_RMK_ICON") {
                    if(!EVF.isEmpty(grid.getCellValue(rowIdx, "REJECT_RMK"))) {
                        var param = {
                            title: "${CPRA0050_019}",
                            message: grid.getCellValue(rowIdx, 'REJECT_RMK')
                        };
                        var url = '/common/popup/common_text_view/view.so';
                        everPopup.openModalPopup(url, 500, 300, param);
                    }
                }
		        if (colIdx === 'VENDOR_NM') {
                    var VN_INFO = grid.getCellValue(rowIdx, "VENDOR_CD");
                    ROWIDX = rowIdx;
                    param = {
                        callBackFunction : "",
                        candidateJson: (EVF.isEmpty(VN_INFO) ? [] : VN_INFO),
                        detailView: true,
                        callType: ""
                    };
                    everPopup.openPopupByScreenId("CBDR0016", 1200, 700, param);
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
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
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
		   
		    // 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
		    if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
		    	changeFlag = true;
            }
		    
            doSearch();
        }

        function doSearch() {

            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.load(baseUrl + 'CPRA0050_doSearch.so', function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doReceipt() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			var msg = '${CPRA0050_008}';
			var sVat ;
			

            var rowIds = grid.getSelRowId();
            for(var i in rowIds) {
                if(grid.getCellValue(rowIds[i], 'CONFIRM_FLAG_CD') == "Y") {
                    return EVF.alert("${CPRA0050_001 }");
                }
                if(eval(grid.getCellValue(rowIds[i], 'PROGRESS_CD')) > 2200) {
                    return EVF.alert("${msg.M0044 }");
                }
                if(eval(grid.getCellValue(rowIds[i], 'PROGRESS_CD')) == 1200) {
                    return EVF.alert("${CPRA0050_018 }");
                }
                if(grid.getCellValue(rowIds[i], 'CTRL_USER_ID') != "${ses.userId}") {
                    return EVF.alert("${CPRA0050_002 }");
                }
                sVat = grid.getCellValue(rowIds[i], 'VAT_TYPE');
                // 부가세 구분이 비어있는 경우
                if(sVat =='' || sVat ==null ) {
               	 	return alert("${CPRA0050_031 }");
                }
                if(grid.getCellValue(rowIds[i], 'IF_TYPE') == 'ITA' || grid.getCellValue(rowIds[i], 'IF_TYPE') == 'ITB') {
                    msg = '${CPRA0050_100}';
                }
            }
			
            EVF.confirm(msg, function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'CPRA0050_doReceipt.so', function(){
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }

        function doReject() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var rowIds = grid.getSelRowId();
            for(var i in rowIds) {
                if(grid.getCellValue(rowIds[i], 'CTRL_USER_ID') != "${ses.userId}") {
                    return EVF.alert("${CPRA0050_002 }");
                }
                if(eval(grid.getCellValue(rowIds[i], 'PROGRESS_CD')) > 2200) {
                    return EVF.alert("${CPRA0050_021 }");
                }
                if(eval(grid.getCellValue(rowIds[i], 'PROGRESS_CD')) == 1200) {
                    return EVF.alert("${CPRA0050_018 }");
                }
            }

            EVF.confirm("${CPRA0050_009 }", function () {
                var param = {
                    title: "${CPRA0050_019}",
                    message: "",
                    callbackFunction: 'setRMK',
                    rowIdx: 0
                };
                var url = '/common/popup/common_text_input/view.so';
                everPopup.openModalPopup(url, 500, 320, param);
            });
        }

        function setRMK(data) {

            if(EVF.isEmpty(data.message)) {
                return EVF.alert("${CPRA0050_011}");
            }

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.getGridData(grid, 'sel');
            store.setParameter("REJECT_RMK", data.message);
            store.load(baseUrl + 'CPRA0050_doReject.so', function(){
                EVF.alert(this.getResponseMessage());
                doSearch();
            });
        }

        function doTrans() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if(EVF.isEmpty(EVF.V("sCTRL_USER_ID"))) {
                return EVF.alert("${CPRA0050_004}");
            }

         	// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
            var rowIds = grid.getSelRowId();
            for(var i in rowIds) {
            	if(!changeFlag) {
	                if(grid.getCellValue(rowIds[i], 'CTRL_USER_ID') != "${ses.userId}") {
	                    return EVF.alert("${CPRA0050_002 }");
	                }
            	}
            }
         	
            EVF.confirm("${CPRA0050_006 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.setParameter("CTRL_USER_ID", EVF.V("sCTRL_USER_ID"));
                store.load(baseUrl + 'CPRA0050_doTrans.so', function(){
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }

        /** 2021.05.18 로직 변경
         * STOCPRHD의 PR_TYPE(구매유형)
         * 1. 신규(10) = 견적, 수의시담, 입찰 가능
         * 2. 변경(20) = 부속합의
         * 3. 연장(30) = 견적/입찰등이 불가하며, '계약체결현황'에서 기존 계약건에 대한 변경만 가능
         */
        // 입찰공고
        function doTender() {
			
            if (grid.getSelRowCount() == 0) { return alert("${msg.M0004}"); }
			
            var paramPrNumSq = "";
            var sCur = "";
            var curDiffCnt = 0;
            var sVat = "";
            var vatDiffCnt = 0;
            var subject = "";
            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
                var rowData = selRowValue[i];
            	
                // 통화가 다를 경우
            	if(sCur != rowData.CUR) {
                    sCur = rowData.CUR;
                    curDiffCnt++;
                }
                
                // 부가세 구분이 다를 경우
                if(sVat != rowData.VAT_TYPE) {
                    sVat = rowData.VAT_TYPE;
                    vatDiffCnt++;
                }
             	
                // 부가세 구분이 비어있는 경우
                if(sVat =='' || sVat ==null ) {
                	 return alert("${CPRA0050_031 }");
                }
                
                // 권한이 다를 경우
                if(rowData.CTRL_USER_ID != "${ses.userId}") {
                    return alert("'" + rowData.ITEM_DESC + "'" + "은(는) " + "${CPRA0050_002 }"); <%-- 본인에게 지정된 구매요청건이 아닙니다. --%>
                }
                
                <%-- 상태가 접수상태인 건만 가능합니다. --%>
                if(eval(rowData.PROGRESS_CD) != 2200 && eval(rowData.PROGRESS_CD) != 1300) {
                    return alert("${CPRA0050_021 }");
                }
                
                <%-- 이미 입찰이 진행중인 건입니다. --%>
                if(rowData.POSSIBLE_FLAG == "N") {
                    return alert("'" + rowData.ITEM_DESC + "'" + "은(는) " + "${CPRA0050_022 }");
                }
             	
                <%-- 이미 수의시담 및 견적이 진행중인 건입니다. --%>
                if(rowData.RFX_POSSIBLE_FLAG == "N") {
                    return alert("'" + rowData.ITEM_DESC + "'" + "은(는) " + "${CPRA0050_030 }");
                }
                
             	// 2021.05.18 추가
                // RFX_TYPE=RCA(부속합의)인 경우 IT포탈의 변경 구매의뢰건만 진행 가능함
                if((rowData.IF_TYPE == 'ITA' || rowData.IF_TYPE == 'ITB') && rowData.PR_TYPE == '20') {
                	return EVF.alert("계약구분이 '변경'인 IT포탈 구매의뢰건은 '부속합의'로만 진행할 수 있습니다.");
                }
                
             	// 2021.05.18 추가
             	// IT포탈의 연장 구매의뢰건은 소싱 진행불가함
                if((rowData.IF_TYPE == 'ITA' || rowData.IF_TYPE == 'ITB') && rowData.PR_TYPE == '30') {
                	return EVF.alert("계약구분이 '연장'인 IT포탈 구매의뢰건은 '연장계약'으로만 진행할 수 있습니다.");
                }
                
                paramPrNumSq = paramPrNumSq + rowData.BUYER_CD + rowData.PR_NUM + rowData.PR_SQ + "@@";
                if(subject == "") { subject = rowData.SUBJECT; }
            }

            if(curDiffCnt > 1) { return alert("${CPRA0050_023}"); } <%-- 통화가 동일한 경우에만 입찰을 진행할 수 있습니다. --%>
            if(vatDiffCnt > 1) { return alert("${CPRA0050_024}"); } <%-- 부가세구분이 동일한 경우에만 입찰을 진행할 수 있습니다. --%>

            var param = {
                'buyerCd' : '',
                'bidNum' : '',
                'bidCnt' : '',
                'paramPrNumSq' : paramPrNumSq,
                'paramCur' : sCur,
                'paramVat' : sVat,
                'subject' : subject,
                'baseDataType': "CreateBID",
                'popupFlag' : true,
                'detailView' : false
            };
            everPopup.openWindowPopup("/nhepro/CBDI/CBDI0011/view.so", 1300, 800, param, "regBidNotice", true);
        }

        function getUserId() {
            var param = {
                callBackFunction : "setUserId"
            };
            everPopup.openCommonPopup(param, 'SP0011');
        }

        function setUserId(dataJsonArray) {
            EVF.V("REQ_USER_NM", dataJsonArray.USER_NM);
            EVF.V("REQ_DEPT_NM", dataJsonArray.DEPT_NM);
        }

        function getCtrlId() {
        	var param = {
                callBackFunction : "setCtrlId",
                'READONLY': 'Y',         //팝업 조회조건 변경불가
                'multiYN' : 'N',         //멀티팝업여부
                'CTRL_CD' : 'BR030',
                'detailView': false
            };
            everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function setCtrlId(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("CTRL_USER_ID", data.USER_ID);
	            EVF.V("CTRL_USER_NM", data.USER_NM);
        	}
        }

        function getCtrlUserId() {
            var param = {
                callBackFunction : "setCtrlUserId",
                'READONLY': 'Y',         //팝업 조회조건 변경불가
    			'multiYN' : 'N',         //멀티팝업여부
                'CTRL_CD' : 'BR030',
    			'detailView': false

            };
            everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function setCtrlUserId(data) {
        	if(data!=null){
        		data = JSON.parse(data);

            	EVF.V("sCTRL_USER_NM", data.USER_NM);
            	EVF.V("sCTRL_USER_ID", data.USER_ID);
        	}
        }

        function getPrBuyerCd() {
            param = {
                'callBackFunction': 'ecBuyerNmCallback',
                'detailView': false,
                callBackFunction: "setPrBuyerCd"
            };
            everPopup.openCommonPopup(param, "SP0119");
        }

        function setPrBuyerCd(data) {
            EVF.V("PR_BUYER_NM", data.BUYER_NM + ' ' +data.DEPT_NM);
            EVF.V("PR_BUYER_CD", data.BUYER_CD);
            EVF.V("PR_DEPT_CD", data.DEPT_CD);
        }

        //요청자
        function doSearchUser() {
            param = {
                'callBackFunction': 'selectUser',
                'READONLY': 'N',         //팝업 조회조건 변경불가
                'multiYN' : 'N',         //멀티팝업여부
                'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function selectUser(data) {
        	if(data!=null){
	    		data = JSON.parse(data);
            	EVF.V("REQ_USER_ID", data.USER_ID);
            	EVF.V("REQ_USER_NM", data.USER_NM);
        	}
        }

        function doModify() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
            var buyerCd = "";
            var prNum = "";
            var prCnt = "";
            var rowIds = grid.getSelRowId();
            for(var i in rowIds) {
                prNum   = grid.getCellValue(rowIds[i], 'PR_NUM');
                prCnt   = grid.getCellValue(rowIds[i], 'PR_CNT');
                buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
                
                // 접수대기(2100)인 건만 수정 가능
                if (grid.getCellValue(rowIds[i], 'PROGRESS_CD') != '2100') {
                	return EVF.alert("${CPRA0050_0002}");
                }
                
             	// 해당 구매의뢰의 MAX_PROGRESS_CD가 접수대기(2100)인 건만 수정 가능
                if (grid.getCellValue(rowIds[i], 'MAX_PROGRESS_CD') != '2100') {
                	return EVF.alert("구매 의뢰건중에 수정할 수 없는 진행상태의 품목이 존재합니다.");
                }
                
                // 구매담당자가 자신의 것만 수정 가능
                if( grid.getCellValue(rowIds[i], 'CTRL_USER_ID') != "${ses.userId}") {
                    return EVF.alert("${CPRA0050_026}");
                }
            }
            
            var param = {
                'prNum': prNum,
                'prCnt': prCnt,
                'buyerCd': buyerCd,
                'detailView': false,
                'popupFlag': true
            };
            everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
        }
		
        /** 2021.05.18 로직 변경
         * STOCPRHD의 PR_TYPE(구매유형)
         * 1. 신규(10) = 견적, 수의시담, 입찰 가능
         * 2. 변경(20) = 부속합의
         * 3. 연장(30) = 견적/입찰등이 불가하며, '계약체결현황'에서 기존 계약건에 대한 변경만 가능
         */
        // RFQ(견적), RPC(수의시담), RCA(부속합의)
        function CRQI_POP(RFX_TYPE) {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var gridSel = [];
            var confirm = "";
            var VAT_TYPE;
            var AMT_TYPE;
            var CUR;
            var RFX_SUBJECT;
            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
                var rowData = selRowValue[i];
                
                // 구매담당자 권한 체크
                if(rowData.CTRL_USER_ID != "${ses.userId}") {
                	return EVF.alert("'" + rowData.ITEM_DESC + "'" + "은(는) " + "${CPRA0050_002}"); <%-- 본인에게 지정된 구매요청건이 아닙니다. --%>
                }
				
                // 구매의뢰접수(2200), 유찰(1300)인 경우 다시 작성 가능함
                if(rowData.PROGRESS_CD != "2200" && rowData.PROGRESS_CD != "1300") {
                    return EVF.alert("${CPRA0050_021}"); // 접수완료 및 유찰된 의뢰건만 (수의시담, 입찰, 견적, 부속합의)가 가능합니다.
                }
				
                // 이미 입찰이 진행중인 건
                if(rowData.POSSIBLE_FLAG == "N") {
                    return alert("'" + rowData.ITEM_DESC + "'" + "은(는) " + "${CPRA0050_022 }"); // 이미 입찰이 진행중인 건입니다.
                }
				
                // 이미 수의시담 및 견적이 진행중인 건
                if(rowData.RFX_POSSIBLE_FLAG == "N") {
                    return alert("'" + rowData.ITEM_DESC + "'" + "은(는) " + "${CPRA0050_030 }"); // 이미 (수의시담, 견적, 부속합의)가 진행중인 의뢰건입니다.
                }
                
             	// 2021.05.18 부속합의 추가
             	if(RFX_TYPE == 'RCA' && rowData.IF_TYPE != 'ITA' && rowData.IF_TYPE != 'ITB') {
                	return EVF.alert("IT포탈의 구매의뢰건만 '부속합의'를 진행할 수 있습니다.");
                }
             	
             	// 2024.03.11 추가
                // 부속합의는 IT포탈의 계약구분이 '변경'인 건만 진행함
                if((rowData.IF_TYPE == 'ITA' || rowData.IF_TYPE == 'ITB') && rowData.PR_TYPE == '10' && RFX_TYPE == 'RCA') {
                	return EVF.alert("계약구분이 '신규'인 IT포탈의 구매의뢰건은 '부속합의'로 진행할 수 없습니다.");
                }
             	
                // RFX_TYPE=RCA(부속합의)인 경우 IT포탈의 변경 구매의뢰건만 진행 가능함
                if((rowData.IF_TYPE == 'ITA' || rowData.IF_TYPE == 'ITB') && rowData.PR_TYPE == '20' && RFX_TYPE != 'RCA') {
                	return EVF.alert("계약구분이 '변경'인 IT포탈의 구매의뢰건은 '부속합의'로만 진행할 수 있습니다.");
                }
             	
             	// RFX_TYPE=RCA(부속합의)인 경우 IT포탈의 변경 구매의뢰건만 진행 가능함
                if((rowData.IF_TYPE == 'ITA' || rowData.IF_TYPE == 'ITB') && rowData.PR_TYPE == '20' && (rowData.PRE_CONT_NUM == '' || rowData.PRE_CONT_CNT == '')) {
                	return EVF.alert("부속합의를 진행하려는 품목의 '이전계약정보'가 없습니다.\n\n처리할 수 없습니다.");
                }
                
             	// 2021.05.18 추가
             	// IT포탈의 연장 구매의뢰건은 소싱 진행불가함
             	// 2023.11.16 추가
             	// 농협은행IT부문 고객사는 계약구분 연장인 건도 수의시담 및 부속합의 진행 가능하도록 변경
             	if("C00013" == "${ses.companyCd}"){ //농협은행 IT부문만
             		if((rowData.IF_TYPE == 'ITA' || rowData.IF_TYPE == 'ITB') && rowData.PR_TYPE == '30' && RFX_TYPE == 'RFQ') {
                    	return EVF.alert("계약구분이 '연장'인 IT포탈의 구매의뢰건은 '연장계약 또는 수의시담 및 부속합의'로만 진행할 수 있습니다.");
                    }
             	} else { //농협은행 IT부문이 아닌경우
             		if((rowData.IF_TYPE == 'ITA' || rowData.IF_TYPE == 'ITB') && rowData.PR_TYPE == '30') {
	                	return EVF.alert("계약구분이 '연장'인 IT포탈 구매의뢰건은 '연장계약'으로만 진행할 수 있습니다.");
	                }
             	}
                
                for(var j in selRowValue) {
                    // 계약방법이 다른 건이 있습니다. 계속 진행하시겠습니까?
                	if(rowData.VENDOR_OPEN_TYPE != selRowValue[j].VENDOR_OPEN_TYPE) {
                        confirm = "${CPRA0050_028}";
                    }
                    
                    // 통화/부가세구분이 동일 건만 (수의시담/견적/부속합의)가 가능합니다.
                    if(rowData.VAT_TYPE != selRowValue[j].VAT_TYPE || rowData.CUR != selRowValue[j].CUR) {
                        return EVF.alert("${CPRA0050_029}"); // 통화 및 부가세구분이 동일한 의뢰건만 (수의시담, 견적, 부속합의)가 가능합니다.
                    }
                    
                    // 2021.05.18 추가
                 	// IT포탈 의뢰건중에 변경건은 부속합의만 가능함
                    if(rowData.PR_TYPE != selRowValue[j].PR_TYPE) {
                        return EVF.alert("계약구분이 동일한 구매 의뢰건만 선택할 수 있습니다.");
                    }
                }
				
                gridSel.push({
                    BUYER_CD: rowData.BUYER_CD,
                    PR_NUM: rowData.PR_NUM,
                    PR_SQ: rowData.PR_SQ
                });

                VAT_TYPE = rowData.VAT_TYPE;	// 부가세 구분
                CUR 	 = rowData.CUR;			// 통화
                if( i == 0 ) {
                	AMT_TYPE = rowData.AMT_TYPE;	// 금액구분
                	RFX_SUBJECT = rowData.SUBJECT;	// 구매의뢰명
                }
            }

            var param = {
                callbackFunction: "",
                BUYER_CD: '',
                RFX_NUM: '',
                RFX_CNT: '',
                RFX_TYPE: RFX_TYPE,
                VAT_TYPE: VAT_TYPE,
                AMT_TYPE: AMT_TYPE,
                CUR: CUR,
                RFX_SUBJECT: RFX_SUBJECT,
                gridSel: JSON.stringify(gridSel),
                baseDataType: "PR",
                detailView: false,
                popupFlag: true,
                buttonView: true
            };

            if(confirm != "") {
                EVF.confirm(confirm, function () {
                    everPopup.openPopupByScreenId("CRQI0011", 1200, 900, param);
                });
            } else {
                everPopup.openPopupByScreenId("CRQI0011", 1200, 900, param);
            }
        }
		
     	// 견적요청
        function doEstimatePop() {
            CRQI_POP("RFQ");
        }
     	
     	// 수의시담
        function doSuSiDam() {
            CRQI_POP("RPC");
        }
        
        // 2021.05.18 부속합의 추가
        function doChangeAgree() {
            CRQI_POP("RCA");
        }
        
        // 2021.05.24 추가 (연장계약)
        function doAutoExtend() {
			
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
            var exec_num_sq = "";	// 구매의뢰번호 + 의뢰항번
            var oriRowId = grid.getSelRowId()[0];
			var selRowId = grid.getSelRowId();
			
			// 이전 계약서 기본정보 셋팅
			var prType = grid.getCellValue(oriRowId, "PR_TYPE");
			var cont_desc = grid.getCellValue(oriRowId, "PRE_CONT_DESC");
			var cur = grid.getCellValue(oriRowId, "PRE_CUR");
			var vat_type = grid.getCellValue(oriRowId, "PRE_VAT_TYPE");
			var amt_type = grid.getCellValue(oriRowId, "PRE_AMT_TYPE");
			var vendor_cd = grid.getCellValue(oriRowId, "PRE_VENDOR_CD");
			var vendor_nm = grid.getCellValue(oriRowId, "PRE_VENDOR_NM");
			var vendor_pic_user_nm = grid.getCellValue(oriRowId, "PRE_VENDOR_PIC_USER_NM");
			var vendor_pic_user_cell_num = grid.getCellValue(oriRowId, "PRE_VENDOR_PIC_USER_CELL_NUM");
			var vendor_pic_user_email = grid.getCellValue(oriRowId, "PRE_VENDOR_PIC_USER_EMAIL");
			
			// 이전계약번호가 존재하는 경우 동일한 이전계약번호로 계약서를 작성할 수 있음
			var pre_buyer_cd = grid.getCellValue(oriRowId, "PRE_BUYER_CD");
			var pre_cont_num = grid.getCellValue(oriRowId, "PRE_CONT_NUM");
			var pre_cont_cnt = grid.getCellValue(oriRowId, "PRE_CONT_CNT");
			
            var gridSel = [];
            var confirm = "";
            var selRowValue = grid.getSelRowValue();
            for(var i in selRowId) {
                var rowIdx = selRowId[i];
                
                // 구매담당자 권한 체크
                if(grid.getCellValue(rowIdx, "CTRL_USER_ID") != "${ses.userId}") {
                	return EVF.alert("'" + grid.getCellValue(rowIdx, "ITEM_DESC") + "'" + "은(는) " + "${CPRA0050_002}");
                }
				
                // 구매의뢰접수(2200), 유찰(1300)인 경우 다시 작성 가능함
                if(grid.getCellValue(rowIdx, "PROGRESS_CD") != "2200" && grid.getCellValue(rowIdx, "PROGRESS_CD") != "1300") {
                    return EVF.alert("${CPRA0050_021}"); // 접수완료 및 유찰된 의뢰건만 (수의시담, 입찰, 견적, 부속합의)가 가능합니다.
                }
				
                // 이미 입찰이 진행중인 건
                if(grid.getCellValue(rowIdx, "POSSIBLE_FLAG") == "N") {
                    return alert("'" + grid.getCellValue(rowIdx, "ITEM_DESC") + "'" + "은(는) " + "${CPRA0050_022 }"); // 이미 입찰이 진행중인 건입니다.
                }
				
                // 이미 수의시담 및 견적이 진행중인 건
                if(grid.getCellValue(rowIdx, "RFX_POSSIBLE_FLAG") == "N") {
                    return alert("'" + grid.getCellValue(rowIdx, "ITEM_DESC") + "'" + "은(는) " + "${CPRA0050_030 }"); // 이미 (수의시담, 견적, 부속합의)가 진행중인 의뢰건입니다.
                }
             	
             	if(grid.getCellValue(rowIdx, "IF_TYPE") != 'ITA' && grid.getCellValue(rowIdx, "IF_TYPE") != 'ITB') {
                	return EVF.alert("IT포탈의 구매의뢰건만 '연장계약'을 진행할 수 있습니다.");
                }
             	
                if((grid.getCellValue(rowIdx, "IF_TYPE") == 'ITA' || grid.getCellValue(rowIdx, "IF_TYPE") == 'ITB') && grid.getCellValue(rowIdx, "PR_TYPE") != '30') {
                	return EVF.alert("계약구분이 '연장'인 IT포탈의 구매의뢰건만 '연장계약'을 진행할 수 있습니다.");
                }
                
             	// 이전 계약번호가 존재하는지 보고 존재 시 공백이 아닐 때 값이 다른지 체크
				if( pre_cont_num != "" && (pre_cont_num != grid.getCellValue(rowIdx, "PRE_CONT_NUM") || pre_cont_cnt != grid.getCellValue(rowIdx, "PRE_CONT_CNT")) ) {
					return EVF.alert("계약구분이 '연장'인 경우 동일한 '이전계약번호 및 차수'로 전자계약서 작성이 가능합니다.\n\n확인하여 주시기 바랍니다.");
				}
             	
             	// 이전계약번호 및 차수가 존재하는지 체크
				if(grid.getCellValue(rowIdx, "PRE_CONT_NUM") == '' || grid.getCellValue(rowIdx, "PRE_CONT_CNT") == '') {
                	return EVF.alert("연장계약을 진행하려는 품목의 '이전계약정보'가 없습니다.\n\n처리할 수 없습니다.");
                }
                
                for(var j in selRowValue) {
                	if(grid.getCellValue(rowIdx, "VENDOR_OPEN_TYPE") != selRowValue[j].VENDOR_OPEN_TYPE) {
                        confirm = "${CPRA0050_028}"; // 계약방법이 다른 건이 있습니다. 계속 진행하시겠습니까?
                    }
                    
                    if(grid.getCellValue(rowIdx, "VAT_TYPE") != selRowValue[j].VAT_TYPE || grid.getCellValue(rowIdx, "CUR") != selRowValue[j].CUR) {
                        return EVF.alert("${CPRA0050_029}"); // 통화 및 부가세구분이 동일한 의뢰건만 (수의시담, 견적, 부속합의)가 가능합니다.
                    }
                    
                    // 2021.05.18 추가
                    if(grid.getCellValue(rowIdx, "PR_TYPE") != selRowValue[j].PR_TYPE) {
                        return EVF.alert("계약구분(신규, 변경, 연장)이 동일한 구매 의뢰건만 선택할 수 있습니다.");
                    }
                }
                
                if( (Number(i) + 1) == selRowId.length ) {
					exec_num_sq+=grid.getCellValue(rowIdx,"BUYER_CD")+grid.getCellValue(rowIdx,"PR_NUM")+grid.getCellValue(rowIdx,"PR_SQ");
				} else {
					exec_num_sq+=grid.getCellValue(rowIdx,"BUYER_CD")+grid.getCellValue(rowIdx,"PR_NUM")+grid.getCellValue(rowIdx,"PR_SQ")+",";
				}
            }
			
			// 기존 계약의 계약금액, 지체상금율 및 인지세여부/금액, 비고 등
			var cont_amt = grid.getCellValue(oriRowId, "PRE_CONT_AMT");
			var delay_rmk = grid.getCellValue(oriRowId, "PRE_DELAY_RMK");
            var delay_nume_rate = grid.getCellValue(oriRowId, "PRE_DELAY_NUME_RATE");
            var delay_deno_rate = grid.getCellValue(oriRowId, "PRE_DELAY_DENO_RATE");
            var stamp_duty_flag = grid.getCellValue(oriRowId, "PRE_STAMP_DUTY_FLAG");
            var stamp_duty_amt = grid.getCellValue(oriRowId, "PRE_STAMP_DUTY_AMT");
            var cont_rmk = grid.getCellValue(oriRowId, "PRE_CONT_RMK");
            
            var store = new EVF.Store();
            // 구매의뢰(pr), 선정품의(stoccnhd)를 기준으로 계약서 작성 : copyFlag=true
            EVF.confirm("연장 계약서를 작성 하시겠습니까?", function () {
            	
            	store.setGrid([grid]);
				store.getGridData(grid, "sel");
				store.load('/nhepro/CCTR/CCTR0020/cctr0020_doResume.so', function() {
					if( this.getResponseMessage() != null && this.getResponseMessage() == '1' ){
						EVF.alert("이미 진행중인 건이 있습니다. 다시 확인하세요.");
					} else {
						var param = {
								url: "/nhepro/CCTR/CCTA0030/view.so",
								CONT_DESC: cont_desc,
								CUR: cur,
								VAT_TYPE: vat_type,
								AMT_TYPE: amt_type,
								VENDOR_CD: vendor_cd,
								VENDOR_NM: vendor_nm,
								//2023.02.03 계약담당자가 계약서 작성 시 "협력업체 담당자", "협력업체 담당자 이메일", "협력업체 담당자 전화번호"를 직접 입력 하도록 변경
								//VENDOR_PIC_USER_NM: vendor_pic_user_nm,
								//VENDOR_PIC_USER_CELL_NUM: vendor_pic_user_cell_num,
								//VENDOR_PIC_USER_EMAIL: vendor_pic_user_email, 
								EXEC_NUM_SQ: exec_num_sq,
								PRE_BUYER_CD: pre_buyer_cd,
								PRE_CONT_NUM: pre_cont_num,
								PRE_CONT_CNT: pre_cont_cnt,
								CONT_REQ_CD: prType,
								CONT_AMT: cont_amt,
								DELAY_RMK: delay_rmk,
								DELAY_NUME_RATE: delay_nume_rate,
								DELAY_DENO_RATE: delay_deno_rate,
								STAMP_DUTY_FLAG: stamp_duty_flag,
								STAMP_DUTY_AMT: stamp_duty_amt,
								CONT_RMK: cont_rmk,
								CREATE_TYPE: "PR",
								copyFlag: "true",
								detailView: false,
								popupFlag: true
							};
						everPopup.openContractChangeInformation(param);
					}
				});
			});
        }
    </script>

    <e:window id="CPRA0050" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
        	<e:inputHidden id="PR_DEPT_CD" name="PR_DEPT_CD"/>

            <e:row>
                <e:label for="REQ_FROM_DATE" title="${form_REQ_FROM_DATE_N}" />
                <e:field>
                    <e:inputDate id="REQ_FROM_DATE" toDate="REQ_TO_DATE" name="REQ_FROM_DATE" value="${reqFromDate }" width="${inputDateWidth }" datePicker="true" required="${form_REQ_FROM_DATE_R}" disabled="${form_REQ_FROM_DATE_D}" readOnly="${form_REQ_FROM_DATE_RO}" />
                    <e:text>~</e:text>
                    <e:inputDate id="REQ_TO_DATE" fromDate="REQ_FROM_DATE" name="REQ_TO_DATE" value="${reqToDate }" width="${inputDateWidth }" datePicker="true" required="${form_REQ_TO_DATE_R}" disabled="${form_REQ_TO_DATE_D}" readOnly="${form_REQ_TO_DATE_RO}" />
                </e:field>
                <e:label for="PR_NUM" title="${form_PR_NUM_N}"/>
                <e:field>
                    <e:inputText id="PR_NUM" name="PR_NUM" value="" width="36%" maxLength="${form_PR_NUM_M}" disabled="${form_PR_NUM_D}" readOnly="${form_PR_NUM_RO}" required="${form_PR_NUM_R}" maskType="${form_PR_NUM_MT}" />
                    <e:text>/</e:text>
                    <e:inputText id="PR_SUBJECT" name="PR_SUBJECT" value="" width="60%" maxLength="${form_PR_SUBJECT_M}" disabled="${form_PR_SUBJECT_D}" readOnly="${form_PR_SUBJECT_RO}" required="${form_PR_SUBJECT_R}" maskType="${form_PR_SUBJECT_MT}" />
                </e:field>
                <e:label for="PR_BUYER_CD" title="${form_PR_BUYER_CD_N}"/>
				<e:field>
					<e:search id="PR_BUYER_CD" name="PR_BUYER_CD" value="" width="40%" maxLength="${form_PR_BUYER_CD_M}" onIconClick="${form_PR_BUYER_CD_RO ? 'everCommon.blank' : 'getPrBuyerCd'}" disabled="${form_PR_BUYER_CD_D}" readOnly="${form_PR_BUYER_CD_RO}" required="${form_PR_BUYER_CD_R}" maskType="${form_PR_BUYER_CD_MT}" placeHolder="회사코드" />
					<e:inputText id="PR_BUYER_NM" name="PR_BUYER_NM" value="" width="60%" maxLength="${form_PR_BUYER_NM_M}" disabled="${form_PR_BUYER_NM_D}" readOnly="${form_PR_BUYER_NM_RO}" required="${form_PR_BUYER_NM_R}" style="${imeMode}" maskType="${form_PR_BUYER_NM_MT}" placeHolder="회사명"/>
				</e:field>
            </e:row>
            <e:row>
                <e:label for="PURCHASE_TYPE" title="${form_PURCHASE_TYPE_N}"/>
                <e:field>
                    <e:select id="PURCHASE_TYPE" name="PURCHASE_TYPE" value="" options="${purchaseTypeOptions}" width="${form_PURCHASE_TYPE_W}" disabled="${form_PURCHASE_TYPE_D}" readOnly="${form_PURCHASE_TYPE_RO}" required="${form_PURCHASE_TYPE_R}" placeHolder="" maskType="${form_PURCHASE_TYPE_MT}" />
                </e:field>
                <e:label for="RECEIPT_FLAG" title="${form_RECEIPT_FLAG_N}"/>
                <e:field>
                    <e:select id="RECEIPT_FLAG" name="RECEIPT_FLAG" value="" options="${receiptFlagOptions}" width="${form_RECEIPT_FLAG_W}" disabled="${form_RECEIPT_FLAG_D}" readOnly="${form_RECEIPT_FLAG_RO}" required="${form_RECEIPT_FLAG_R}" placeHolder="" maskType="${form_RECEIPT_FLAG_MT}" />
                </e:field>
                <e:label for="REQ_USER_ID" title="${form_REQ_USER_ID_N}"/>
				<e:field>
					<e:search id="REQ_USER_ID" name="REQ_USER_ID" value="" width="40%" maxLength="${form_REQ_USER_ID_M}" onIconClick="${form_REQ_USER_ID_RO ? 'everCommon.blank' : 'doSearchUser'}" disabled="${form_REQ_USER_ID_D}" readOnly="${form_REQ_USER_ID_RO}" required="${form_REQ_USER_ID_R}" maskType="${form_REQ_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="REQ_USER_NM" name="REQ_USER_NM" value="" width="60%" maxLength="${form_REQ_USER_NM_M}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}" style="${imeMode}" maskType="${form_REQ_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
            </e:row>
            <e:row>
	            <e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}"/>
				<e:field>
					<e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="${not empty param.ctrlUserId ? param.ctrlUserId : ses.userId }" width="40%" maxLength="${form_CTRL_USER_ID_M}" onIconClick="${form_CTRL_USER_ID_RO ? 'everCommon.blank' : 'getCtrlId'}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" maskType="${form_CTRL_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="${not empty param.ctrlUserNm ? param.ctrlUserNm : ses.userNm }" width="60%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}" placeHolder="성명"/>
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
            <e:search id="sCTRL_USER_ID" name="sCTRL_USER_ID" value="" width="${form_sCTRL_USER_ID_W}" maxLength="${form_sCTRL_USER_ID_M}" disabled="${form_sCTRL_USER_ID_D}" readOnly="${form_sCTRL_USER_ID_RO}" required="${form_sCTRL_USER_ID_R}" align="right" onIconClick="getCtrlUserId"  maskType="${form_sCTRL_USER_ID_MT}" />
            <e:inputText id="sCTRL_USER_NM" name="sCTRL_USER_NM" value="" width="${form_sCTRL_USER_NM_W }" maxLength="${form_sCTRL_USER_NM_M}" disabled="${form_sCTRL_USER_NM_D}" readOnly="${form_sCTRL_USER_NM_RO}" required="${form_sCTRL_USER_NM_R}"  maskType="${form_sCTRL_USER_NM_MT}" />
            <e:button id="Trans" name="Trans" label="${Trans_N }" disabled="${Trans_D }" visible="${Trans_V}" style="padding-left:3px;" align="left" onClick="doTrans" />
			<e:text style="color: red;font-weight: bold;">&nbsp;( '접수대기건 의뢰수정' 은 '구매의뢰번호' 클릭하여 수정하세요 )</e:text>
            
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
            <e:button id="Receipt" name="Receipt" label="${Receipt_N }" disabled="${Receipt_D }" visible="${Receipt_V}" onClick="doReceipt" />
            <e:button id="Reject" name="Reject" label="${Reject_N }" disabled="${Reject_D }" visible="${Reject_V}" onClick="doReject" />
            <%--
            <e:button id="doModify" name="doModify" label="${doModify_N}" onClick="doModify" disabled="${doModify_D}" visible="${doModify_V}"/>
			--%>
			
            <e:button id="doSuSiDam" name="doSuSiDam" label="${doSuSiDam_N}" onClick="doSuSiDam" disabled="${doSuSiDam_D}" visible="${doSuSiDam_V}"/>	<!-- 수의시담작성 -->
            <e:button id="doTender" name="doTender" label="${doTender_N}" onClick="doTender" disabled="${doTender_D}" visible="${doTender_V}"/>			<!-- 입찰공고 -->
            <e:button id="doEstimatePop" name="doEstimatePop" label="${doEstimatePop_N}" onClick="doEstimatePop" disabled="${doEstimatePop_D}" visible="${doEstimatePop_V}"/>	<!-- 견적서작성 -->
			
			<%-- 2021.05.26 : 사용자 법인구분이 은행(1) OR 중앙회(5)일 경우만 (연장, 변경계약) 처리. --%>
            <c:if test="${ses.corpType eq '1' or ses.corpType eq '5'}">
	            <e:button id="doChangeAgree" name="doChangeAgree" label="${doChangeAgree_N}" onClick="doChangeAgree" disabled="${doChangeAgree_D}" visible="${doChangeAgree_V}"/>	<!-- IT포탈 변경계약 부속합의 -->
	            <e:button id="doAutoExtend" name="doAutoExtend" label="${doAutoExtend_N}" onClick="doAutoExtend" disabled="${doAutoExtend_D}" visible="${doAutoExtend_V}"/>			<!-- IT포탈 연장계약 -->
            </c:if>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

    </e:window>
</e:ui>