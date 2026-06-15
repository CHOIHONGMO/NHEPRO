<%--
  Date : 2021-06-23
  Scrren ID : CCTR0150
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>

<% String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd"); %>

<c:set var="ManagerCd" value="<%=ManagerCd%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script>
		var grid;
		var gridI;
		var baseUrl = "/nhepro/CCTR/CCTR0150";
		var changeFlag = false;
		
		function init() {
			grid = EVF.C("grid");
			grid.setProperty("shrinkToFit", ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty("rowNumbers", ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty("sortable", ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty("panelVisible", ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty("enterToNextRow", ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty("acceptZero", ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty("multiSelect", ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			grid.setProperty("singleSelect", ${singleSelect});	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

			// Grid Excel Event
			grid.excelExportEvent({
				allItems: "${excelExport.allCol}",
				fileName: "${sreenName }"
			});

			grid.cellClickEvent(function (rowIdx, celName, value) {
				var param;
				var url;

				var buyerCd   = grid.getCellValue(rowIdx, "BUYER_CD");
				var contNum   = grid.getCellValue(rowIdx, "CONT_NUM");
				var contCnt   = grid.getCellValue(rowIdx, "CONT_CNT");
				var vendorCd  = grid.getCellValue(rowIdx, "VENDOR_CD");
				var prBuyerCd = grid.getCellValue(rowIdx, "PR_BUYER_CD");
				var prDeptCd  = grid.getCellValue(rowIdx, "PR_DEPT_CD");
				var contType  = grid.getCellValue(rowIdx, "CONT_TYPE");

				param = {
					BUYER_CD: buyerCd,
					CONT_NUM: contNum,
					CONT_CNT: contCnt,
					VENDOR_CD: vendorCd,
					PR_BUYER_CD: prBuyerCd,
					PR_DEPT_CD: prDeptCd,
					detailView: true
				};

				switch (celName) {
					case "CONT_NUM":
						param["url"] = '/nhepro/CCTR/CCTA0030/view.so';
						everPopup.openContractChangeInformation(param);
						break;

					case "ATT_FILE_CNT":
						if( value == 0 ) return;
						param = {
							bizType: 'EC',
							attFileNum: grid.getCellValue(rowIdx, 'ATT_FILE_NUM'),
							detailView: true
						};
						everPopup.fileAttachPopup(param);
						break;

					case "VENDOR_ATT_FILE_CNT":
						if( value == 0 ) return;
						param = {
							bizType: 'EC',
							attFileNum: grid.getCellValue(rowIdx, 'VENDOR_ATT_FILE_NUM'),
							detailView: true
						};
						everPopup.fileAttachPopup(param);
						break;
					
					case "VENDOR_NM":
						// 1120 : 위수탁계약서
						if( value == "" || contType == '1120' ) return;
						param = {
		                        VENDOR_CD: grid.getCellValue(rowIdx, 'VENDOR_CD'),
		                        detailView: true,
		                        popupFlag: true,
		                        buttonView: false
		                    };
		                everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
		                break;
		                
					case "CONT_CLOSE_RMK":
						if( value == "" ) return;
						param = {
							title : '강제종결사유',
							message : value
						};
						everPopup.commonTextView(param);
						break;
					
					case "CONT_DESC":
						EVF.V("SCH_BUYER_CD", grid.getCellValue(rowIdx, 'BUYER_CD'));
		        		EVF.V("SCH_CONT_NUM", grid.getCellValue(rowIdx, 'CONT_NUM'));
		        		EVF.V("SCH_CONT_CNT", grid.getCellValue(rowIdx, 'CONT_CNT'));
		        		
		        		doSearchDT();
						break;
					
					case "CONT_GROUND":
						if( value == "" ) return;
						param = {
							title : '계약근기',
							message : value
						};
						everPopup.commonTextView(param);
						break;
					
					case "ETC_ATT_FILE_CNT":
						param = {
							bizType: 'EC',
							attFileNum: grid.getCellValue(rowIdx, 'ETC_ATT_FILE_NUM'),
							callBackFunction: 'setAttachFile',
							rowIdx: rowIdx,
							detailView: ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) ? false : true
						};
						everPopup.fileAttachPopup(param);
						break;
						
					case "MANAGER_RMK":
						param = {
							title : '담당자 의견',
							message : value,
							callbackFunction: 'setRMK',
							rowIdx: rowIdx
						};
						if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
							everPopup.commonTextInput(param);
						} else {
							everPopup.commonTextView(param);
						}
						break;
				}
			});
			
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
		    grid.setRowFooter("BUYER_NM", footer);

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
		    grid.setRowFooter("CONT_AMT", distVal);
		    
		 	// ===========================================================
		 	
	 		grid.setColBgColor("ETC_ATT_FILE_CNT", "#F5F5F5");
	 		grid.setColBgColor("MANAGER_RMK", "#F5F5F5");
	 		
	 		
			gridI = EVF.C("gridI");
			gridI.cellClickEvent(function(rowIdx, colIdx, value) {

				if(colIdx == "PR_NUM") {
					if( value == "" ) return;
					var param = {
							buyerCd   : gridI.getCellValue(rowIdx, "PB_BUYER_CD"),
							prNum     : gridI.getCellValue(rowIdx, "PR_NUM"),
							popupFlag : true,
							detailView: true
						};
					everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
				}
				if(colIdx === 'PR_APP_DOC_NUM'){
					if( value == "" ) return;
					
					var ifType = gridI.getCellValue(rowIdx, "IF_TYPE");
					if (ifType == 'ITA' || ifType == 'ITB') {
						var mnt_yn = gridI.getCellValue(rowIdx, "MNT_YN");
						var cm_req_id = '';
						var screen_id = '';
						if (mnt_yn == 'Y') {
							screen_id = 'CPRA0060';
						} else {
							screen_id = 'CPRA0060';
						}
						var param = {
				    			 'MNT_YN'    : mnt_yn
				    			,'CM_REQ_ID' : gridI.getCellValue(rowIdx, "PR_APP_DOC_NUM")
				    			,'detailView': true
							};
						everPopup.openPopupByScreenId(screen_id, 1200, 900, param);
					}
					else {
			            var params = {
				                buyerCd   : gridI.getCellValue(rowIdx, "PB_BUYER_CD"),
				                appDocNum : gridI.getCellValue(rowIdx, "PR_APP_DOC_NUM"),
				                appDocCnt : gridI.getCellValue(rowIdx, "PR_APP_DOC_CNT"),
				                authType  : 'VIEW',	// 결재창 View
				                sendBox	  : false,
		                        detailView: true
				            };
			            var url = '/nhepro/CWOR/CWOR0011/view.so';
			            everPopup.openWindowPopup(url, 1200, 900, params, 'prApprovalPopup');
					}
		       	}
				if(colIdx == "RFX_NUM") {
					if( value == "" ) return;
					var rfxType = gridI.getCellValue(rowIdx, "RFX_TYPE");
					if (rfxType == "BID") {
						var params = {
								'buyerCd'      : gridI.getCellValue(rowIdx, "BUYER_CD"),
								'bidNum'       : gridI.getCellValue(rowIdx, 'RFX_NUM'),
								'bidCnt'       : gridI.getCellValue(rowIdx, 'RFX_CNT'),
								'baseDataType' : "ModifyBID",
								'popupFlag'    : true,
								'detailView'   : true
							};
						everPopup.openWindowPopup("/nhepro/CBDI/CBDI0011/view.so", 1300, 900, params, "bidDetail", true);
					}
					else {
						var params = {
	                			callbackFunction: "",
	                            BUYER_CD  : gridI.getCellValue(rowIdx, "BUYER_CD"),
	                            RFX_NUM   : gridI.getCellValue(rowIdx, "RFX_NUM"),
	                            RFX_CNT   : gridI.getCellValue(rowIdx, "RFX_CNT"),
	                            detailView: true,
	                            buttonView: false
		                    };
	                    everPopup.openPopupByScreenId("CRQI0011", 1200, 900, params);
					}
				}
				if(colIdx === 'RFX_ESTM_RLT'){
					if( value == "" || gridI.getCellValue(rowIdx, 'RFX_NUM') == "" ) return;
					var param = {
							'buyerCd'    : gridI.getCellValue(rowIdx, "BUYER_CD"),
							'bidNum'     : gridI.getCellValue(rowIdx, 'RFX_NUM'),
							'bidCnt'     : gridI.getCellValue(rowIdx, 'RFX_CNT'),
							'popupFlag'  : true,
							'detailView' : true
						};
					everPopup.openWindowPopup("/nhepro/CBDI/CBDI0021/view.so", 1200, 800, param, "bidAppClose", true);
		       	}
				if(colIdx === 'RFX_OPEN_RLT'){
					if( value == "" || gridI.getCellValue(rowIdx, 'RFX_NUM') == "" ) return;
					var rfxType = gridI.getCellValue(rowIdx, "RFX_TYPE");
					if (rfxType == "BID") {
						var param = {
								'BUYER_CD'  : gridI.getCellValue(rowIdx, 'BUYER_CD'),
								'BID_NUM'   : gridI.getCellValue(rowIdx, 'RFX_NUM'),
								'BID_CNT'   : gridI.getCellValue(rowIdx, 'RFX_CNT'),
								'VOTE_CNT'  : gridI.getCellValue(rowIdx, 'VOTE_CNT'),
								'popupFlag' : true,
								'detailView': true
							};
						everPopup.openWindowPopup("/nhepro/CBDR/CBDR0033/view.so", 1200, 900, param, "bidInfo", true);
					}
					else {
						var params = {
		                		BUYER_CD  : gridI.getCellValue(rowIdx, 'BUYER_CD'),
		                		RFX_NUM   : gridI.getCellValue(rowIdx, 'RFX_NUM'),
			                	RFX_CNT   : gridI.getCellValue(rowIdx, 'RFX_CNT'),
			                    popupFlag : true,
			                    detailView: true
			                };
		                everPopup.openPopupByScreenId("CRQI0041", 1300, 900, params);
	        		}
		       	}
				if(colIdx === 'RFX_APP_DOC_NUM'){
					if( value == "" ) return;
		            var params = {
			                buyerCd   : gridI.getCellValue(rowIdx, "BUYER_CD"),
			                appDocNum : gridI.getCellValue(rowIdx, "RFX_APP_DOC_NUM"),
			                appDocCnt : gridI.getCellValue(rowIdx, "RFX_APP_DOC_CNT"),
			                authType  : 'VIEW',	// 결재창 View
			                sendBox	  : false,
	                        detailView: true
			            };
		            var url = '/nhepro/CWOR/CWOR0011/view.so';
		            everPopup.openWindowPopup(url, 1200, 900, params, 'rfxApprovalPopup');
		       	}
				if(colIdx === 'NEGO_APP_DOC_NUM'){
					if( value == "" ) return;
		            var params = {
			                buyerCd   : gridI.getCellValue(rowIdx, "BUYER_CD"),
			                appDocNum : gridI.getCellValue(rowIdx, "NEGO_APP_DOC_NUM"),
			                appDocCnt : gridI.getCellValue(rowIdx, "NEGO_APP_DOC_CNT"),
			                authType  : 'VIEW',	// 결재창 View
			                sendBox	  : false,
	                        detailView: true
			            };
		            var url = '/nhepro/CWOR/CWOR0011/view.so';
		            everPopup.openWindowPopup(url, 1200, 900, params, 'negoApprovalPopup');
		       	}
				if(colIdx === 'FAIL_APP_DOC_NUM'){
					if( value == "" ) return;
		            var params = {
			                buyerCd   : gridI.getCellValue(rowIdx, "BUYER_CD"),
			                appDocNum : gridI.getCellValue(rowIdx, "FAIL_APP_DOC_NUM"),
			                appDocCnt : gridI.getCellValue(rowIdx, "FAIL_APP_DOC_CNT"),
			                authType  : 'VIEW',	// 결재창 View
			                sendBox	  : false,
	                        detailView: true
			            };
		            var url = '/nhepro/CWOR/CWOR0011/view.so';
		            everPopup.openWindowPopup(url, 1200, 900, params, 'failApprovalPopup');
		       	}
				if(colIdx === 'ESTM_APP_DOC_NUM'){
					if( value == "" ) return;
		            var params = {
			                buyerCd   : gridI.getCellValue(rowIdx, "BUYER_CD"),
			                appDocNum : gridI.getCellValue(rowIdx, "ESTM_APP_DOC_NUM"),
			                appDocCnt : gridI.getCellValue(rowIdx, "ESTM_APP_DOC_CNT"),
			                authType  : 'VIEW',	// 결재창 View
			                sendBox	  : false,
	                        detailView: true
			            };
		            var url = '/nhepro/CWOR/CWOR0011/view.so';
		            everPopup.openWindowPopup(url, 1200, 900, params, 'estmApprovalPopup');
		       	}
				if(colIdx == "EXEC_NUM") {
					if( value == "" ) return;
					var param = {
							'buyerCd'   : gridI.getCellValue(rowIdx, 'BUYER_CD'),
							'execNum'   : gridI.getCellValue(rowIdx, 'EXEC_NUM'),
							'tcoFlag'   : null,
							'popupFlag' : true,
							'detailView': true
						};
					everPopup.openWindowPopup("/nhepro/CBDR/CBDI0061/view.so", 1400, 900, param, "createCN", true);
				}
				if(colIdx === 'EXEC_APP_DOC_NUM'){
					if( value == "" ) return;
		            var params = {
			                buyerCd   : gridI.getCellValue(rowIdx, "BUYER_CD"),
			                appDocNum : gridI.getCellValue(rowIdx, "EXEC_APP_DOC_NUM"),
			                appDocCnt : gridI.getCellValue(rowIdx, "EXEC_APP_DOC_CNT"),
			                authType  : 'VIEW',	// 결재창 View
			                sendBox	  : false,
	                        detailView: true
			            };
		            var url = '/nhepro/CWOR/CWOR0011/view.so';
		            everPopup.openWindowPopup(url, 1200, 900, params, 'execApprovalPopup');
		       	}
				if(colIdx === 'CONT_APP_DOC_NUM'){
					if( value == "" ) return;
		            var params = {
			                buyerCd   : gridI.getCellValue(rowIdx, "BUYER_CD"),
			                appDocNum : gridI.getCellValue(rowIdx, "CONT_APP_DOC_NUM"),
			                appDocCnt : gridI.getCellValue(rowIdx, "CONT_APP_DOC_CNT"),
			                authType  : 'VIEW',	// 결재창 View
			                sendBox	  : false,
	                        detailView: true
			            };
		            var url = '/nhepro/CWOR/CWOR0011/view.so';
		            everPopup.openWindowPopup(url, 1200, 900, params, 'contApprovalPopup');
		       	}
				if (colIdx == "PRE_CONT_NUM") {
					if( value == "" ) return;
					var param = {
							callBackFunction: '',
							BUYER_CD  : gridI.getCellValue(rowIdx, "PRE_BUYER_CD"),
							CONT_NUM  : gridI.getCellValue(rowIdx, "PRE_CONT_NUM"),
							CONT_CNT  : gridI.getCellValue(rowIdx, "PRE_CONT_CNT"),
							url       : "/nhepro/CCTR/CCTA0030/view.so",
							popupFlag : true,
							detailView: true
						};
					everPopup.openContractChangeInformation(param);
				}
				if (colIdx == "CONT_GROUND") {
					if( value == "" ) return;
					var param = {
							title   : '계약근기',
							message : value
						};
					everPopup.commonTextView(param);
				}
			});
			
			gridI.setProperty('shrinkToFit', ${shrinkToFit});
            gridI.setProperty('rowNumbers', ${rowNumbers});
            gridI.setProperty('sortable', ${sortable});
            gridI.setProperty('panelVisible', ${panelVisible});
            gridI.setProperty('enterToNextRow', ${enterToNextRow});
            gridI.setProperty('acceptZero', ${acceptZero});
            gridI.setProperty('singleSelect', ${singleSelect});
            gridI.setProperty('multiSelect', false);
            
            gridI.setColGroup([
            	{
                    "groupName": '구매의뢰',
                    "columns": ['PR_NUM', 'PR_APP_DOC_NUM']
                }
            	,{
                    "groupName": '입찰/견적',
                    "columns": ['RFX_NUM', 'RFX_ESTM_RLT', 'RFX_OPEN_RLT', 'RFX_APP_DOC_NUM', 'NEGO_APP_DOC_NUM', 'FAIL_APP_DOC_NUM']
                }
            	,{
                    "groupName": '예정가격',
                    "columns": ['ESTM_PRC_FLAG', 'ESTM_APP_DOC_NUM']
                }
            	,{
                    "groupName": '선정품의',
                    "columns": ['EXEC_NUM', 'EXEC_APP_DOC_NUM']
                }
            	,{
                    "groupName": '계약',
                    "columns": ['CONT_APP_DOC_NUM']
                }
            	,{
                    "groupName": '용역',
                    "columns": ['SW_BIZ_AMT', 'SW_BIZ_DISCOUNT', 'MNT_SANGJU_YN']
                }
                ,{
                    "groupName": '물품(공사,기타,양수)',
                    "columns": ['CONSUMER_AMT', 'CONSUMER_DISCOUNT', 'FC_MNT_TERM', 'CH_RATE']
                }
                ,{
                    "groupName": '유지보수(리스,재리스,렌탈,도급)',
                    "columns": ['DOIB_AMOUNT', 'MNT_RATE', 'MNT_SDAY', 'MNT_EDAY', 'MNT_GUR_MONTH', 'RT_INSP_PERIOD', 'FALT_RC_TG_TIME']
                }
                ,{
                    "groupName": '인터페이스정보(IT포탈)',
                    "columns": ['PRE_CONT_NUM', 'PRE_CONT_CNT', 'CM_REQ_ID', 'IF_TYPE']
                }
            ],65);
            
		 	// ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridI.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridI.setRowFooter("PR_BUYER_DEPT_NM", footer);

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
		    gridI.setRowFooter("ITEM_QT"  , distVal);
		    gridI.setRowFooter("ITEM_AMT" , distVal);
		    gridI.setRowFooter("SW_BIZ_AMT", distVal);
		    gridI.setRowFooter("CONSUMER_AMT", distVal);
		    gridI.setRowFooter("DOIB_AMOUNT" , distVal);
		    
		    // 업무관리자(BR900)인 경우 "저장" 버튼 활성화
		    if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
            	EVF.C("doSave").setVisible(true);
            } else {
		    	EVF.C("doSave").setVisible(false);
		    }
		    
		 	// 그리드머지여부
			EVF.V('MERGE_FLAG', '0');
		    
		    doSearchHD();
		}
		
		function setAttachFile(rowIdx, uuid, fileCount) {
			if(fileCount > 0) {
				grid.setCellValue(rowIdx, 'ETC_ATT_FILE_CNT', fileCount);
				grid.setCellValue(rowIdx, 'ETC_ATT_FILE_NUM', uuid);
			}
		}
		
		function setRMK(data) {
            grid.setCellValue(data.rowIdx, "MANAGER_RMK", data.message);
        }
		
		// 견적결과 팝업에서 "닫기" 버튼 클릭시 호출하는 메소드
		function doSearch() {
		}
		
		// Search
		function doSearchHD() {
			var MERGE_FLAG = EVF.V("MERGE_FLAG");
			var store = new EVF.Store();
			
			if (!store.validate()) return;
			
			store.setGrid([grid]);
			store.setParameter("MERGE_FLAG", MERGE_FLAG);
			store.load(baseUrl + "/cctr0150_doSearch.so", function () {
				var MergeFlag = this.getParameter("MergeFlag");
				if (grid.getRowCount() == 0) {
					return EVF.alert('${msg.M0002}');
				}
				
				if(MergeFlag == '1'){
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "CONT_REQ_CD", "BUYER_NM"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "CONT_DESC", "MANUAL_CONT_FLAG", "CONT_DATE", "CONT_START_DATE", "CONT_END_DATE"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "CONT_AMT_SUM", "PR_AMT", "REQ_DATE", "CUR", "VAT_TYPE", "FORM_NM", "CONT_TYPE1_TEXT", "CONT_TYPE1", "CONT_TYPE2"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "VENDOR_CD", "VENDOR_NM", "CONT_CLOSE_DATE", "CONT_CLOSE_RMK"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "CONT_USER_NM", "SIGN_PATH_NM", "CONT_GROUND", "ETC_ATT_FILE_CNT", "MANAGER_RMK", "IF_TYPE"]);
				} else {
					
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "PR_BUYER_DEPT_NM"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "CONT_REQ_CD", "BUYER_NM", "PR_BUYER_DEPT_NM"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "CONT_DESC", "MANUAL_CONT_FLAG", "CONT_DATE", "CONT_START_DATE", "CONT_END_DATE", "PR_BUYER_DEPT_NM"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "CONT_AMT_SUM", "PR_AMT", "REQ_DATE", "CUR", "VAT_TYPE", "FORM_NM", "CONT_TYPE1_TEXT", "CONT_TYPE1", "CONT_TYPE2", "PR_BUYER_DEPT_NM"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "VENDOR_CD", "VENDOR_NM", "CONT_CLOSE_DATE", "CONT_CLOSE_RMK", "PR_BUYER_DEPT_NM"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "CONT_USER_NM", "SIGN_PATH_NM", "CONT_GROUND", "ETC_ATT_FILE_CNT", "MANAGER_RMK", "IF_TYPE", "PR_BUYER_DEPT_NM"]);
				}
			});
		}
		
	    function doSearchDT() {

            var store = new EVF.Store();
            store.setGrid([gridI]);
            store.load(baseUrl + "/cctr0150_doSearchECMT.so", function() {
            	
            	var allRowId = gridI.getAllRowId();
				for(var i in allRowId) {
					var rowIdx = allRowId[i];
					var purchase_type = gridI.getCellValue(rowIdx, "PURCHASE_TYPE");
					
					if(purchase_type == "S" || purchase_type == "M") {
						onChangeDiscount(rowIdx, "SW_BIZ_AMT");
					} else {
						onChangeDiscount(rowIdx, "CONSUMER_AMT");
					}
				}
            });
        }
	    
	    function onChangeDiscount(rowIdx, colIdx) {
			if (gridI.getCellValue(rowIdx, "ITEM_AMT") == 0) return;
			
			var prAmt     = Number(gridI.getCellValue(rowIdx, "ITEM_AMT"));
			var targetAmt = Number(gridI.getCellValue(rowIdx, colIdx));
			var discount  = ((targetAmt - prAmt) / targetAmt) * 100;
			gridI.setCellValue(rowIdx, colIdx.replace("AMT", "DISCOUNT"), Math.abs(discount.toFixed(1)));
		}
		
		function getBuyer() {
			var param = {
				callBackFunction: "setBuyer"
			};
			everPopup.openCommonPopup(param, "SP0066");
		}

		function setBuyer(data) {
			EVF.V("PR_BUYER_CD", data.CUST_CD);
			EVF.V("PR_BUYER_NM", data.CUST_NM);
		}

		function getVendor() {

			var param = {
				callBackFunction: "setVendor"
			};
			everPopup.openCommonPopup(param, "SP0123");
		}

		function setVendor(data) {
			EVF.V("VENDOR_CD", data.VENDOR_CD);
			EVF.V("VENDOR_NM", data.VENDOR_NM);
		}

		function getDept() {

			var param = {
				callBackFunction: "setDept"
			};
			everPopup.openCommonPopup(param, 'SP0119');
		}

		function setDept(data) {
			EVF.V("PR_DEPT_CD", data.DEPT_CD);
			EVF.V("PR_DEPT_NM", data.DEPT_NM);
		}

		function getCtrlUser() {
			var param = {
					'callBackFunction': 'setCtrlUser',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : "BR040,BR050",	// 계약담당자,계약체결자 권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		function setCtrlUser(data) {
			if(data!=null){
				data = JSON.parse(data);
				EVF.V("CONT_USER_ID", data.USER_ID);
				EVF.V("CONT_USER_NM", data.USER_NM);
			}
		}
		
		function doSave() {
			
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0021}", function () {
               	var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
                store.load(baseUrl + '/cctr0150_doSave.so', function(){
                    EVF.alert(this.getResponseMessage());
                    doSearchHD();
                });
            });
        }
	</script>

	<e:window id="CCTR0150" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999}" labelWidth="130" width="100%" columnCount="3" useTitleBar="true" onEnter="doSearchHD">
			<e:inputHidden id="BUNDLE_NUM"     name="BUNDLE_NUM" />
			<e:inputHidden id="CONT_NUM_CNT"   name="CONT_NUM_CNT" />
			<e:inputHidden id="CONT_CLOSE_RMK" name="CONT_CLOSE_RMK" />
			<e:inputHidden id="TYPE" name="TYPE" value="${param.TYPE}"/>
			
			<!-- 계약명 클릭시 하단 품목현황 조회 -->
			<e:inputHidden id="SCH_BUYER_CD" name="SCH_BUYER_CD"/>
			<e:inputHidden id="SCH_CONT_NUM" name="SCH_CONT_NUM"/>
			<e:inputHidden id="SCH_CONT_CNT" name="SCH_CONT_CNT"/>
			
			<e:row>
				<%--계약일자, 종료일자--%>
				<e:label for="DATE_TYPE">
					<e:select id="DATE_TYPE" name="DATE_TYPE" value="" options="${dateTypeOptions}" readOnly="${form_DATE_TYPE_RO }" width="90" required="${form_DATE_TYPE_R }" disabled="${form_DATE_TYPE_D }"  usePlaceHolder="false" />
				</e:label>
				<e:field>
					<e:inputDate id="REG_DATE_FROM" toDate="REG_DATE_TO" name="REG_DATE_FROM" value="${fromDate }" width="${inputTextDate }" required="${form_REG_DATE_R }" readOnly="${form_REG_DATE_RO }" disabled="${form_REG_DATE_D }" datePicker="true" />
					<e:text>~</e:text>
					<e:inputDate id="REG_DATE_TO" fromDate="REG_DATE_FROM" name="REG_DATE_TO" value="${toDate }" width="${inputTextDate }" required="${form_REG_DATE_R }" readOnly="${form_REG_DATE_RO }" disabled="${form_REG_DATE_D }" datePicker="true" />
				</e:field>
				<%--고객사--%>
				<e:label for="PR_BUYER_CD" title="${form_PR_BUYER_CD_N}"/>
				<e:field>
					<e:search id="PR_BUYER_CD" name="PR_BUYER_CD" value="" width="40%" maxLength="${form_PR_BUYER_CD_M}" onIconClick="${form_PR_BUYER_CD_RO ? 'everCommon.blank' : 'getBuyer'}" disabled="${form_PR_BUYER_CD_D}" readOnly="${form_PR_BUYER_CD_RO}" required="${form_PR_BUYER_CD_R}" maskType="${form_PR_BUYER_CD_MT}" placeHolder="회사코드" />
					<e:inputText id="PR_BUYER_NM" name="PR_BUYER_NM" value="" width="60%" maxLength="${form_PR_BUYER_NM_M}" disabled="${form_PR_BUYER_NM_D}" readOnly="${form_PR_BUYER_NM_RO}" required="${form_PR_BUYER_NM_R}" style="${imeMode}" maskType="${form_PR_BUYER_NM_MT}" placeHolder="회사명"/>
				</e:field>
				<%--협력업체--%>
				<e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
				<e:field>
					<e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" onIconClick="${form_VENDOR_CD_RO ? 'everCommon.blank' : 'getVendor'}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" maskType="${form_VENDOR_CD_MT}" placeHolder="회사코드" />
					<e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}" placeHolder="회사명"/>
				</e:field>
				<%--고객사 부서--%>
				<%--
				<e:label for="PR_DEPT_CD" title="${form_PR_DEPT_CD_N}"/>
				<e:field>
					<e:search id="PR_DEPT_CD" name="PR_DEPT_CD" value="" width="40%" maxLength="${form_PR_DEPT_CD_M}" onIconClick="${form_PR_DEPT_CD_RO ? 'everCommon.blank' : 'getDept'}" disabled="${form_PR_DEPT_CD_D}" readOnly="${form_PR_DEPT_CD_RO}" required="${form_PR_DEPT_CD_R}" maskType="${form_PR_DEPT_CD_MT}" placeHolder="부서코드" />
					<e:inputText id="PR_DEPT_NM" name="PR_DEPT_NM" value="" width="60%" maxLength="${form_PR_DEPT_NM_M}" disabled="${form_PR_DEPT_NM_D}" readOnly="${form_PR_DEPT_NM_RO}" required="${form_PR_DEPT_NM_R}" style="${imeMode}" maskType="${form_PR_DEPT_NM_MT}" placeHolder="부서명"/>
				</e:field>
				--%>
			</e:row>
            <e:row>
				<%--계약담당자--%>
				<e:label for="CONT_USER_ID" title="${form_CONT_USER_ID_N}"/>
				<e:field>
					<e:search id="CONT_USER_ID" name="CONT_USER_ID" value="" width="40%" maxLength="${form_CONT_USER_ID_M}" onIconClick="${form_CONT_USER_ID_RO ? 'everCommon.blank' : 'getCtrlUser'}" disabled="${form_CONT_USER_ID_D}" readOnly="${form_CONT_USER_ID_RO}" required="${form_CONT_USER_ID_R}" maskType="${form_CONT_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="CONT_USER_NM" name="CONT_USER_NM" value="" width="60%" maxLength="${form_CONT_USER_NM_M}" disabled="${form_CONT_USER_NM_D}" readOnly="${form_CONT_USER_NM_RO}" required="${form_CONT_USER_NM_R}" style="${imeMode}" maskType="${form_CONT_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
				<%--계약번호/명--%>
				<e:label for="CONT_NUM" title="${form_CONT_NUM_N}" />
				<e:field>
					<e:inputText id="CONT_NUM" name="CONT_NUM" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
				</e:field>
				<%--계약유형--%>
				<e:label for="FORM_NM" title="${form_FORM_NM_N}"/>
				<e:field>
					<e:inputText id="FORM_NM" name="FORM_NM" value="" width="${form_FORM_NM_W}" maxLength="${form_FORM_NM_M}" disabled="${form_FORM_NM_D}" readOnly="${form_FORM_NM_RO}" required="${form_FORM_NM_R}" style="${imeMode}" maskType="${form_FORM_NM_MT}"/>
				</e:field>
            </e:row>
			<e:row>
				<%--계약방법--%>
				<e:label for="CONT_TYPE1" title="${form_CONT_TYPE1_N}"/>
				<e:field>
					<e:select id="CONT_TYPE1" name="CONT_TYPE1" value="" options="${contType1Options}" width="${form_CONT_TYPE1_W}" disabled="${form_CONT_TYPE1_D}" readOnly="${form_CONT_TYPE1_RO}" required="${form_CONT_TYPE1_R}" placeHolder="" maskType="${form_CONT_TYPE1_MT}" />
				</e:field>
				<%--낙찰자선정방법--%>
				<e:label for="CONT_TYPE2" title="${form_CONT_TYPE2_N}"/>
				<e:field>
					<e:select id="CONT_TYPE2" name="CONT_TYPE2" value="" options="${contType2Options}" width="${form_CONT_TYPE2_W}" disabled="${form_CONT_TYPE2_D}" readOnly="${form_CONT_TYPE2_RO}" required="${form_CONT_TYPE2_R}" placeHolder="" maskType="${form_CONT_TYPE2_MT}" />
				</e:field>
				<%--그리드머지여부--%>
				<e:label for="MERGE_FLAG" title="${form_MERGE_FLAG_N}"/>
				<e:field>
					<e:select id="MERGE_FLAG" name="MERGE_FLAG" value="" options="${mergeFlagOptions}" width="${form_MERGE_FLAG_W}" disabled="${form_MERGE_FLAG_D}" readOnly="${form_MERGE_FLAG_RO}" required="${form_MERGE_FLAG_R}" placeHolder="" maskType="${form_MERGE_FLAG_MT}" />
				</e:field>
			</e:row>
		</e:searchPanel>
		
		<!-- 상단 Grid -->
		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doSearch" name="doSearch" icon="search" label="${doSearch_N }" disabled="${doSearch_D }" onClick="doSearchHD" />
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
		</e:buttonBar>
		<e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="100%" height="fit"/>
		
		<!-- 하단 Grid -->
        <e:buttonBar id="itemBtnBar" align="right" width="100%" title="품목현황" />
		<e:gridPanel id="gridI" name="gridI" gridType="${_gridType}" width="100%" height="250px" />
	</e:window>
</e:ui>
