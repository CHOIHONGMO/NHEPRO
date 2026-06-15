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
		var baseUrl = "/nhepro/CBDR/";
		var changeFlag = false;
		
	    function init() {

	        grid = EVF.C("grid");

	        grid.cellClickEvent(function(rowIdx, colIdx, value) {

	        	var buyerCd = grid.getCellValue(rowIdx, 'BUYER_CD');
	        	var bidNum  = grid.getCellValue(rowIdx, 'BID_NUM');
	        	var bidCnt  = grid.getCellValue(rowIdx, 'BID_CNT');
	        	
	        	if(colIdx == "ANN_NO") {
                    var param = {
                        'buyerCd'    : buyerCd,
                        'bidNum'     : bidNum,
                        'bidCnt'     : bidCnt,
                        'popupFlag'  : true,
                        'detailView' : true
                    };
                    <%-- 입찰공고 상세화면을 Popup으로 open. --%>
                    var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
                    var callUrl = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? "/nhepro/CBDI/CBDR0014/view.so" : "/nhepro/CBDI/CBDR0012/view.so");
                    var callHeight = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? 700 : 900);
                    everPopup.openWindowPopup(callUrl, 1200, callHeight, param, "bidAnn", true);
				}
	        	
	        	if(colIdx == "ANN_ITEM") {
	        		var param = {
							'buyerCd'      : buyerCd,
							'bidNum'       : bidNum,
							'bidCnt'       : bidCnt,
							'baseDataType' : "ModifyBID",
							'popupFlag'    : true,
							'detailView'   : true
						};

					<%-- 입찰/취소 공고 상세화면을 Popup으로 open. --%>
                    var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
                    var callUrl = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? "/nhepro/CBDI/CBDR0013/view.so" : "/nhepro/CBDI/CBDI0011/view.so");
                    var callHeight = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? 700 : 900);
					everPopup.openWindowPopup(callUrl, 1300, callHeight, param, "bidDetail", true);
				}
	        	
	        	// 입찰서 제출에 대한 적합/부적합 결과
	        	if(colIdx == "APP_END_DATETIME") {
					var param = {
						'buyerCd'    : buyerCd,
						'bidNum'     : bidNum,
						'bidCnt'     : bidCnt,
						'popupFlag'  : true,
						'detailView' : true
					};
					everPopup.openWindowPopup("/nhepro/CBDI/CBDI0021/view.so", 1200, 800, param, "bidAppClose", true);
	        	}
	        	
	        	// 입찰서 제출에 대한 규격/기술평가 결과
	        	if(colIdx == "BID_END_DATETIME") {
					var contType2  = grid.getCellValue(rowIdx, 'CONT_TYPE2');
					var techEvType = grid.getCellValue(rowIdx, 'TECH_EV_TYPE');

					if(contType2 == "TD" || contType2 == "TS") { <%-- 규격평가결과 화면을 Popup으로 open. --%>
						var param = {
        					'BUYER_CD'   : buyerCd,
        					'BID_NUM'    : bidNum,
        					'BID_CNT'    : bidCnt,
        	                'REBID'      : false,
        					'popupFlag'  : true,
        					'detailView' : true
        				};
        				var callUrl = "/nhepro/CBDR/CBDI0031/view.so";
        				everPopup.openWindowPopup(callUrl, 1100, 600, param, "bidEval", true);
					}
					else if (contType2 == "NE" && techEvType == "10") { <%-- 협상에 의한 낙찰자 선정(NE), 평가결과등록 --%>
						var voteCnt = grid.getCellValue(rowIdx, 'VOTE_CNT');
		                var param = {
	                        'BUYER_CD' : buyerCd,
	                        'BID_NUM' : bidNum,
	                        'BID_CNT' : bidCnt,
	                        'VOTE_CNT' : voteCnt,
	                        'popupFlag' : true,
	                        'detailView' : true
	                    };
	                    everPopup.openWindowPopup("/nhepro/CBDR/CBDI0035/view.so", 1100, 600, param, "openDocument", true);
					}
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
			grid.setProperty('singleSelect', true);					// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
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
	        store.load(baseUrl + 'cbdr0030_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        	
	        	grid.setColIconify("PERIOD_MOD_RSN", "PERIOD_MOD_RSN", "comment", false);
	        });
	    }

	    function doBidUserChange() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if(EVF.isEmpty(EVF.C("BID_USER_ID").getValue())) {
                return EVF.alert("${CBDR0030_001}");
            }

			var rowIds = grid.getSelRowId();
			
			// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
	    	for(var i in rowIds) {
	    		if(!changeFlag) {
		    		if(grid.getCellValue(rowIds[i], 'BID_USER_ID') != "${ses.userId}") {
	    				return EVF.alert("${CBDR0030_005}");
	    			}
	    		}
    		}

			EVF.confirm("${CBDR0030_003 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
	            store.getGridData(grid, 'sel');
	            store.setParameter("CHANGE_TYPE", "B");
	            store.setParameter("CHANGE_USER_ID", EVF.C("BID_USER_ID").getValue());
	            store.load(baseUrl + 'cbdr0030_doUserChange.so', function(){
	        		EVF.alert(this.getResponseMessage(), function() {
	        			doSearch();
					});
	        	});
			});
		}

	    function doOpenUserChange() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if(EVF.isEmpty(EVF.C("OPEN_USER_ID").getValue())) {
                return EVF.alert("${CBDR0030_011}");
            }

			var rowIds = grid.getSelRowId();
			
			// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
	    	for(var i in rowIds) {
	    		if(!changeFlag) {
		    		if(grid.getCellValue(rowIds[i], 'BID_USER_ID') != "${ses.userId}") {
	    				return EVF.alert("${CBDR0030_005}");
	    			}
	    		}
    		}

			EVF.confirm("${CBDR0030_003 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
	            store.getGridData(grid, 'sel');
				store.setParameter("CHANGE_TYPE", "O");
	            store.setParameter("CHANGE_USER_ID", EVF.C("OPEN_USER_ID").getValue());
	            store.load(baseUrl + 'cbdr0030_doUserChange.so', function(){
	        		EVF.alert(this.getResponseMessage(), function() {
	        			doSearch();
					});
	        	});
			});
		}

		var specEvalRowId;
		function doSpecEval() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

			var buyerCd;
			var bidNum;
			var bidCnt;
			var bidStatus;
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				<%--
				if((grid.getCellValue(rowIds[i], 'CONT_TYPE2') == "TD" && grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') != "2353" && grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') != "2354")
                    || ((grid.getCellValue(rowIds[i], 'CONT_TYPE2') == "NE" || grid.getCellValue(rowIds[i], 'CONT_TYPE2') == "TS") && grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') != "2363")) {
					return EVF.alert("${CBDR0030_006}");
				}
				--%>
				
				if(grid.getCellValue(rowIds[i], 'BID_USER_ID') != "${ses.userId}") {
					return EVF.alert("${CBDR0030_005}");
				}
				
				<%-- 2단계 분리입찰이 아닌 경우 또는 2단계 분리입찰이면서 규격평가등록이 아닌 경우 --%>
				if( grid.getCellValue(rowIds[i], 'CONT_TYPE2') != "TD" ||
				   (grid.getCellValue(rowIds[i], 'CONT_TYPE2') == "TD" && grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') != "2354") ) {
					return EVF.alert("${CBDR0030_024}");
				}
				
				buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
				bidNum  = grid.getCellValue(rowIds[i], 'BID_NUM');
				bidCnt  = grid.getCellValue(rowIds[i], 'BID_CNT');
				bidStatus = grid.getCellValue(rowIds[i], 'ORI_BID_STATUS');
				specEvalRowId = rowIds[i];
			}
			
			var param = {
				'BUYER_CD' : buyerCd,
				'BID_NUM' : bidNum,
				'BID_CNT' : bidCnt,
                'REBID' : false,
				'individualFlag' : false,
				'popupFlag' : true,
				'detailView' : false
			};
			<%-- ‘규격평가’ 버튼 클릭시 BID_STATUS가 ‘2353’인 경우에는 규격평가등록결과 화면을… ‘2354’인 경우에는 입찰시간알림 화면을 띄운다. --%>
			<%--var callUrl = (bidStatus == "2354" ? "/nhepro/CBDR/CBDI0032/view.so" : "/nhepro/CBDR/CBDI0031/view.so");--%>
			var callUrl = "/nhepro/CBDR/CBDI0032/view.so";
			var callHeight = (bidStatus == "2354" ? 590 : 600);
			everPopup.openWindowPopup(callUrl, 900, 400, param, "specEval", true);
		}

		function endConfirm(contType2) {

			if(contType2 == "TD") {
				var param = {
					'BUYER_CD': grid.getCellValue(specEvalRowId, 'BUYER_CD'),
					'BID_NUM': grid.getCellValue(specEvalRowId, 'BID_NUM'),
					'BID_CNT': grid.getCellValue(specEvalRowId, 'BID_CNT'),
					'REBID': false,
					'individualFlag' : false,
					'popupFlag': true,
					'detailView': false
				};
				everPopup.openWindowPopup("/nhepro/CBDR/CBDI0032/view.so", 900, 590, param, "setBidTime", true);
			}

			doSearch();
		}

		function doOpenDocument(buyerCd, bidNum, bidCnt, voteCnt, bidStatus) {
			var param = {
				'BUYER_CD'     : buyerCd,
				'BID_NUM'      : bidNum,
				'BID_CNT'      : bidCnt,
				'VOTE_CNT'     : voteCnt,
				'BID_STATUS'   : bidStatus,
                'evResultFlag' : false,
				'popupFlag'    : true,
				'detailView'   : false
			};
			everPopup.openWindowPopup("/nhepro/CBDR/CBDR0033/view.so", 1200, 800, param, "openDocument", true);
		}

		function doBidProgress() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

			var buyerCd; var bidNum; var bidCnt; var voteCnt; var bidStatus;
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				
				if(grid.getCellValue(rowIds[i], 'OPEN_USER_ID') != "${ses.userId}") {
					return EVF.alert("${CBDR0030_017}");	// 개찰담당자만 처리할 수 있습니다.
				}
				
				// 600 : 부적합, 2400 : 선정대기, 2410 : 협상중, 2420 : 적격심사중
				if( (grid.getCellValue(rowIds[i], 'BID_STATUS') != "600") && (grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') != "2400")
				 && (grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') != "2410") && (grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') != "2420")) {
					return EVF.alert("${CBDR0030_006}" + "\n\n현재 진행상태는 (" + grid.getCellValue(rowIds[i], 'BID_STATUS_LOC') + ") 입니다.");	// 진행상태를 확인하세요.
				}
				
				// 취소확정된 공고인 경우
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "2330") {
					return EVF.alert("${CBDR0030_010}");	// 취소된 공고입니다.
				}
				
				// 예정가격을 확정하지 않은 경우
				if(grid.getCellValue(rowIds[i], 'ESTM_FINISH_FLAG') != "Y") {
					return EVF.alert("${CBDR0030_015}");	// 예정가격이 확정되지 않아 개찰을 진행할 수 없습니다.
				}
				
				// 현재일자가 개찰일자 이후인 경우
				if(grid.getCellValue(rowIds[i], 'OPEN_DATE_PASS_FLAG') != "Y") {
					return EVF.alert("${CBDR0030_016}");	// 개찰일시가 지나지 않아 ’입찰진행’을 할 수 없습니다.
				}
				
				// NE(협상에 의한 낙찰자 선정)이면서 기술평가수행(20) : 평가를 진행하지 않은 평가자가 있는 경우
				if(grid.getCellValue(rowIds[i], 'OPEN_POSSIBLE_FLAG') != "Y") {
					return EVF.alert("${CBDR0030_019}");	// 먼저 규격/기술평가수행이 완료되어야 개찰을 진행할 수 있습니다.
				}
				
				// NE(협상에 의한 낙찰자 선정)이면서 기술평가등록(10) : 평가결과가 등록되지 않은 경우
				if(grid.getCellValue(rowIds[i], 'TECH_OPEN_POSSIBLE_FLAG') != "Y") {
					return EVF.alert("${CBDR0030_020}");	// 먼저 평가결과를 등록해야 개찰을 진행할 수 있습니다.
				}

				buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
				bidNum = grid.getCellValue(rowIds[i], 'BID_NUM');
				bidCnt = grid.getCellValue(rowIds[i], 'BID_CNT');
				voteCnt = grid.getCellValue(rowIds[i], 'VOTE_CNT');
				bidStatus = grid.getCellValue(rowIds[i], 'BID_STATUS');
				individualFlag = grid.getCellValue(rowIds[i], 'INDIVIDUAL_FLAG');
				individualVendor = grid.getCellValue(rowIds[i], 'INDIVIDUAL_VENDOR');
			}

			var param = {
				'BUYER_CD'     : buyerCd,
				'BID_NUM'      : bidNum,
				'BID_CNT'      : bidCnt,
				'VOTE_CNT'     : voteCnt,
				'BID_STATUS'   : bidStatus,
                'evResultFlag' : false,
				'popupFlag'    : true,
				'detailView'   : false
			};
			everPopup.openWindowPopup("/nhepro/CBDR/CBDR0033/view.so", 1200, 800, param, "bidClose", true);
		}
		
		// 2021.06.17 입찰신청시간변경 기능 추가
		function doChageAppTime() {
			
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
			
			var rowIds = grid.getSelRowId();
			var rowIdx = rowIds[0];
			
			var bidUserId = grid.getCellValue(rowIdx, "BID_USER_ID");
			var bidNum = grid.getCellValue(rowIdx, 'BID_NUM');
			var bidCnt = grid.getCellValue(rowIdx, 'BID_CNT');
			var buyerCd = grid.getCellValue(rowIdx, 'BUYER_CD');
			var bidStatus = grid.getCellValue(rowIdx, 'BID_STATUS');
			var periodModRsn = grid.getCellValue(rowIdx, 'PERIOD_MOD_RSN');
			
			if(periodModRsn != ''){
				return EVF.alert("${CBDR0030_022}");
			}
			
			if(bidStatus != '400'){
				return EVF.alert("${CBDR0030_021}");
			}
			if("${hasManagerCd}" != 'true' ) {
				return EVF.alert("${CBDR0030_023}");
			}
			
			var param = {
					  BID_NUM  : bidNum
					, BID_CNT  : bidCnt
					, BUYER_CD : buyerCd
					,'baseDataType' : "ModifyBID"
					,'detailView':false
					,'screenID': "CBDR0030"
  			};
  			everPopup.openPopupByScreenId('CBDI0022', 1010, 570, param);
		}
		
		// 2021.08.23 유찰 추가
		function doFailBid() {
			
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
			
			var joinVendor = 0;
			var bidStatus  = "";
			var contType2  = "";
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'BID_USER_ID') != "${ses.userId}" && grid.getCellValue(rowIds[i], 'OPEN_USER_ID') != "${ses.userId}") {
					return EVF.alert("${CBDR0030_005}");	// 본인에게 지정된 건만 처리할 수 있습니다.
				}
				
				// 100 : 규격평가, 500 : 기술평가, 200 : 입찰시간알림, 300 : 입찰대기, 400 : 입출중, 600 : 부적합(개찰대기), 700 : 선정대기, 800 : 협상중, 900 : 적격심사중, 1000 : 재입찰
				bidStatus = grid.getCellValue(rowIds[i], 'BID_STATUS');
				contType2 = grid.getCellValue(rowIds[i], 'CONT_TYPE2');
				if(contType2 != "TD"){	
					if(bidStatus == "200" || bidStatus == "300" || bidStatus == "400") {
						return EVF.alert("${CBDR0030_006}" + "\n\n현재 진행상태는 (" + grid.getCellValue(rowIds[i], 'BID_STATUS_LOC') + ") 입니다.");
					}
				}
				
				// 취소확정된 공고인 경우
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "2330") {
					return EVF.alert("${CBDR0030_010}");	// 취소된 공고입니다.
				}
				
				// 개찰일자 이후에만 유찰이 가능.
				if(contType2 != "TD"){
					if(grid.getCellValue(rowIds[i], 'OPEN_DATE_PASS_FLAG') != "Y") {
						return EVF.alert("${CBDR0030_016}");	// 개찰일시가 도래하지 않았습니다.
					}
				}
				
				// 입찰서 제출한 협력업체 건수
				joinVendor = Number(grid.getCellValue(rowIds[i], 'JOIN_VENDOR_CNT'));
				if(joinVendor > 1) {
					return EVF.alert("${CBDR0030_026}");	// 입찰서 제출업체가 2개 이상인 경우 개찰없이 유찰할 수 없습니다.\n\n＂입찰진행＂ 팝업 화면에서 진행하세요.
				}
				
				EVF.V("SINGLE_FLAG",  "1");	// 입찰진행(CBDR0030) 화면에서 단독 투찰건에 대한 유찰
				EVF.V("SEL_BUYER_CD", grid.getCellValue(rowIds[i], 'BUYER_CD'));
				EVF.V("SEL_BID_NUM",  grid.getCellValue(rowIds[i], 'BID_NUM'));
				EVF.V("SEL_BID_CNT",  grid.getCellValue(rowIds[i], 'BID_CNT'));
				EVF.V("SEL_VOTE_CNT", grid.getCellValue(rowIds[i], 'VOTE_CNT'));
				EVF.V("SEL_CONT_TYPE", grid.getCellValue(rowIds[i], 'CONT_TYPE2'));
				EVF.V("SEL_ORI_BID_STATUS", grid.getCellValue(rowIds[i], 'ORI_BID_STATUS'));
			}
			
            var store = new EVF.Store();
            EVF.confirm("${CBDR0030_007 }", function () {
                store.load(baseUrl + 'cbdr0033_doFailBid.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                    	doSearch();
                    });
                });
            });
        }
		
		// 2021.08.23 재공고 추가
        function doReAnn() {
			
        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
			
        	var joinVendor = 0;
        	var bidStatus  = "";
        	var contType2  = "";
        	var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'BID_USER_ID') != "${ses.userId}" && grid.getCellValue(rowIds[i], 'OPEN_USER_ID') != "${ses.userId}") {
					return EVF.alert("${CBDR0030_005}");	// 본인에게 지정된 건만 처리할 수 있습니다.
				}
				
				// 100 : 규격평가, 500 : 기술평가, 200 : 입찰시간알림, 300 : 입찰대기, 400 : 입출중, 600 : 부적합(개찰대기), 700 : 선정대기, 800 : 협상중, 900 : 적격심사중, 1000 : 재입찰
				bidStatus = grid.getCellValue(rowIds[i], 'BID_STATUS');
				contType2 = grid.getCellValue(rowIds[i], 'CONT_TYPE2');
				if(contType2 != "TD"){
					if(bidStatus == "200" || bidStatus == "300" || bidStatus == "400") {
						return EVF.alert("${CBDR0030_006}" + "\n\n현재 진행상태는 (" + grid.getCellValue(rowIds[i], 'BID_STATUS_LOC') + ") 입니다.");
					}
				} else {
					if(bidStatus == "100") {
						return EVF.alert("${CBDR0030_006}" + "\n\n현재 진행상태는 (" + grid.getCellValue(rowIds[i], 'BID_STATUS_LOC') + ") 입니다.");
					}
				}
				
				// 취소확정된 공고인 경우
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "2330") {
					return EVF.alert("${CBDR0030_010}");	// 취소된 공고입니다.
				}
				
				// 예정가격을 확정하지 않은 경우
				if(grid.getCellValue(rowIds[i], 'ESTM_FINISH_FLAG') != "Y") {
					return EVF.alert("${CBDR0030_015}");	// 예정가격이 확정되지 않아 개찰을 진행할 수 없습니다.
				}
				
				// 현재일자가 개찰일자 이후인 경우
				if(contType2 != "TD"){
					if(grid.getCellValue(rowIds[i], 'OPEN_DATE_PASS_FLAG') != "Y") {
						return EVF.alert("${CBDR0030_016}");	// 개찰일시가 도래하지 않았습니다.
					}
				}
				
				// 입찰서 제출한 협력업체 건수
				joinVendor = Number(grid.getCellValue(rowIds[i], 'JOIN_VENDOR_CNT'));
				if(joinVendor > 1) {
					return EVF.alert("${CBDR0030_027}");	// 입찰서 제출업체가 2개 이상인 경우 개찰없이 재공고할 수 없습니다.\n\n＂입찰진행＂ 팝업 화면에서 진행하세요.
				}
				
				EVF.V("SINGLE_FLAG",  "1");	// 입찰진행(CBDR0030) 화면에서 단독 투찰건에 대한 유찰
				EVF.V("SEL_BUYER_CD", grid.getCellValue(rowIds[i], 'BUYER_CD'));
				EVF.V("SEL_BID_NUM",  grid.getCellValue(rowIds[i], 'BID_NUM'));
				EVF.V("SEL_BID_CNT",  grid.getCellValue(rowIds[i], 'BID_CNT'));
				EVF.V("SEL_VOTE_CNT", grid.getCellValue(rowIds[i], 'VOTE_CNT'));
				EVF.V("SEL_CONT_TYPE", grid.getCellValue(rowIds[i], 'CONT_TYPE2'));
			}
			
            var store = new EVF.Store();
            EVF.confirm("${CBDR0030_028 }", function () {
                store.load(baseUrl + 'cbdr0033_doCheckWithReAnn.so', function(){
                    var param = {
                        'buyerCd'   : EVF.V('SEL_BUYER_CD'),
                        'bidNum'    : EVF.V('SEL_BID_NUM'),
                        'bidCnt'    : EVF.V('SEL_BID_CNT'),
                        'preBuyerCd': EVF.V('SEL_BUYER_CD'),
                        'preBidNum' : EVF.V('SEL_BID_NUM'),
                        'preBidCnt' : EVF.V('SEL_BID_CNT'),
                        'preVoteCnt': EVF.V('SEL_VOTE_CNT'),
                        'preContType': EVF.V('SEL_CONT_TYPE'),
                        'singleFlag': EVF.V('SINGLE_FLAG'),
                        'baseDataType': "ReBID",
                        'callbackFunction': "doCallBackFunction",
                        'popupFlag' : true,
                        'detailView': false
                    };
                    everPopup.openWindowPopup("/nhepro/CBDI/CBDI0011/view.so", 1300, 800, param, "modBidNotice", true);
                });
            });
        }
        
        function doCallBackFunction() {
            var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
            if (popupFlag) {
                opener.doSearch();
                doClose();
            } else {
            	doSearch();
            }
        }
        
	    function getBidUserId() {

			var callBackType = this.getData().data;
			var param = {
					'callBackFunction': (callBackType == "S" ? "setSearchCondition" : (callBackType == "B" ? "setBidUserId" : "setOpenUserId")),
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : (callBackType == "S" ? "BR030" : (callBackType == "B" ? "BR030" : "")),	//구매담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

	    function setSearchCondition(data) {
	    	if(data!=null){
				data = JSON.parse(data);
				EVF.V("sBID_USER_ID", data.USER_ID);
				EVF.V("sBID_USER_NM", data.USER_NM);
	    	}
		}

	    function setBidUserId(data) {
	    	if(data!=null){
				data = JSON.parse(data);
				EVF.V("BID_USER_ID", data.USER_ID);
				EVF.V("BID_USER_NM", data.USER_NM);
	    	}
		}

	    function setOpenUserId(data) {
	    	if(data!=null){
				data = JSON.parse(data);
				EVF.V("OPEN_USER_ID", data.USER_ID);
				EVF.V("OPEN_USER_NM", data.USER_NM);
	    	}
		}

	    function cleanUserId() {
			EVF.V("BID_USER_ID", "");
		}

		function getBuyerCd() {
			var param = {
				callBackFunction : "setBuyerCd"
			};
			everPopup.openCommonPopup(param, 'SP0066');
		}

		function setBuyerCd(data) {
			EVF.V("BUYER_CD", data.CUST_CD);
			EVF.V("BUYER_NM", data.CUST_NM);
		}

		function cleanBuyerCd() {
			EVF.V("BUYER_CD", "");
		}
    </script>
    
	<e:window id="CBDR0030" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<!-- 2021.08.24 : 유찰/재공고 기능 추가 -->
			<e:inputHidden id="SINGLE_FLAG"  name="SINGLE_FLAG" />
			<e:inputHidden id="SEL_BUYER_CD" name="SEL_BUYER_CD" />
	        <e:inputHidden id="SEL_BID_NUM"  name="SEL_BID_NUM" />
	        <e:inputHidden id="SEL_BID_CNT"  name="SEL_BID_CNT" />
	        <e:inputHidden id="SEL_VOTE_CNT" name="SEL_VOTE_CNT" />
	        <e:inputHidden id="SEL_CONT_TYPE" name="SEL_CONT_TYPE" />
	        <e:inputHidden id="SEL_ORI_BID_STATUS" name="SEL_ORI_BID_STATUS" />
			
			<e:row>
				<e:label for="APP_END_FROM" title="${form_APP_END_FROM_N}" />
				<e:field>
					<e:inputDate id="APP_END_FROM" name="APP_END_FROM" toDate="APP_END_TO" value="${reqFromDate }" width="${inputDateWidth }" required="${form_APP_END_FROM_R}" disabled="${form_APP_END_FROM_D}" readOnly="${form_APP_END_FROM_RO}" datePicker="true" />
					<e:text>~&nbsp;</e:text>
					<e:inputDate id="APP_END_TO" name="APP_END_TO" fromDate="APP_END_FROM" value="${reqToDate }" width="${inputDateWidth }" required="${form_APP_END_TO_R}" disabled="${form_APP_END_TO_D}" readOnly="${form_APP_END_TO_RO}" datePicker="true" />
				</e:field>
				<e:label for="BID_STATUS" title="${form_BID_STATUS_N}" />
				<e:field>
					<e:select id="BID_STATUS" name="BID_STATUS" value="" options="${bidStatusOptions }" width="${form_BID_STATUS_W }" disabled="${form_BID_STATUS_D}" readOnly="${form_BID_STATUS_RO}" required="${form_BID_STATUS_R}" placeHolder="" />
				</e:field>
				<e:label for="sBID_USER_ID" title="${form_sBID_USER_ID_N}"/>
				<e:field>
					<e:search id="sBID_USER_ID" name="sBID_USER_ID" value="" width="40%" maxLength="${form_sBID_USER_ID_M}" disabled="${form_sBID_USER_ID_D}" readOnly="${form_sBID_USER_ID_RO}" required="${form_sBID_USER_ID_R}" onIconClick="getBidUserId" data="S" placeHolder="개인번호" />
					<e:inputText id="sBID_USER_NM" name="sBID_USER_NM" value="" width="60%" maxLength="${form_sBID_USER_NM_M}" disabled="${form_sBID_USER_NM_D}" readOnly="${form_sBID_USER_NM_RO}" required="${form_sBID_USER_NM_R}" placeHolder="성명" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
				<e:field>
					<e:inputText id="ANN_NO" name="ANN_NO" value="" width="${form_ANN_NO_W}" maxLength="${form_ANN_NO_M}" disabled="${form_ANN_NO_D}" readOnly="${form_ANN_NO_RO}" required="${form_ANN_NO_R}" />
				</e:field>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
				<e:field>
					<e:inputText id="ANN_ITEM" name="ANN_ITEM" value="" width="${form_ANN_ITEM_W}" maxLength="${form_ANN_ITEM_M}" disabled="${form_ANN_ITEM_D}" readOnly="${form_ANN_ITEM_RO}" required="${form_ANN_ITEM_R}" />
				</e:field>
				<e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
				<e:field>
					<e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" onIconClick="getBuyerCd" placeHolder="회사코드" />
					<e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" placeHolder="회사명" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:text style="color: blue;font-weight: bold;">■ 입찰담당자 : </e:text>
			<e:search id="BID_USER_NM" name="BID_USER_NM" value="" width="${form_BID_USER_NM_W}" maxLength="${form_BID_USER_NM_M}" disabled="${form_BID_USER_NM_D}" readOnly="${form_BID_USER_NM_RO}" required="${form_BID_USER_NM_R}" align="left" onIconClick="getBidUserId" data="B" />
			<e:inputHidden id="BID_USER_ID" name="BID_USER_ID" value="" />
			<e:button id="BidUserChange" name="BidUserChange" label="${BidUserChange_N }" disabled="${BidUserChange_D }" visible="${BidUserChange_V}" style="padding-left:3px;" align="left" onClick="doBidUserChange" />
			
			<e:text style="color: blue;font-weight: bold;">■ 개찰담당자 : </e:text>
			<e:search id="OPEN_USER_NM" name="OPEN_USER_NM" value="" width="${form_OPEN_USER_NM_W}" maxLength="${form_OPEN_USER_NM_M}" disabled="${form_OPEN_USER_NM_D}" readOnly="${form_OPEN_USER_NM_RO}" required="${form_OPEN_USER_NM_R}" align="left" onIconClick="getBidUserId" data="O" />
			<e:inputHidden id="OPEN_USER_ID" name="OPEN_USER_ID" value="" />
			<e:button id="OpenUserChange" name="OpenUserChange" label="${OpenUserChange_N }" disabled="${OpenUserChange_D }" visible="${OpenUserChange_V}" style="padding-left:3px;" align="left" onClick="doOpenUserChange" />
			
			<e:text style="color: red;font-weight: bold;">※ 단독입찰건처리 (&nbsp;</e:text>
			<e:button id="doFailBid" name="doFailBid" label="${doFailBid_N}" onClick="doFailBid" disabled="${doFailBid_D}" visible="${doFailBid_V}" align="left"/>
            <e:button id="doReAnn" name="doReAnn" label="${doReAnn_N}" onClick="doReAnn" disabled="${doReAnn_D}" visible="${doReAnn_V}" align="left"/>
			<e:text style="color: red;font-weight: bold;">)</e:text>
			
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
			<e:button id="SpecEval" name="SpecEval" label="${SpecEval_N }" disabled="${SpecEval_D }" visible="${SpecEval_V}" onClick="doSpecEval" />
			<e:button id="BidProgress" name="BidProgress" label="${BidProgress_N }" disabled="${BidProgress_D }" visible="${BidProgress_V}" onClick="doBidProgress" />
			<c:if test="${hasManagerCd eq true}">
				<e:button id="doChageAppTime" name="doChageAppTime" label="${doChageAppTime_N }" disabled="${doChageAppTime_D }" visible="${doChageAppTime_V}" onClick="doChageAppTime" />
			</c:if>
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>