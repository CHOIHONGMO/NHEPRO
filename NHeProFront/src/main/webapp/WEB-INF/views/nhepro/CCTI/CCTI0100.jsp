<%--
  Date: 2020-07-05
  Time: 17:00:20
  Scrren ID : CCTI0100
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>

<%
	// 2021.07.16 : itPortal 계약서 전송고객 추가
	String itPortalCustCd = PropertiesManager.getString("eversrm.default.itPortal.custCd");
	String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd");
%>

<c:set var="itPortalCustCd" value="<%=itPortalCustCd%>" />
<c:set var="ManagerCd" value="<%=ManagerCd%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script>

		var grid;
		var gridMTGL;
		var baseUrl = '/nhepro/CCTI/CCTI0100';
		var changeFlag = false;
		
		function init() {
			
			if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
		    	changeFlag = true;
            }
			
			grid = EVF.C('grid');
			grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			
			gridMTGL = EVF.C('gridMTGL');
			gridMTGL.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			gridMTGL.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
			gridMTGL.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridMTGL.setProperty('panelVisible', ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridMTGL.setProperty('enterToNextRow', ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridMTGL.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridMTGL.setProperty('multiSelect', ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			gridMTGL.setProperty('singleSelect', ${singleSelect});	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			
			//2021.01.14
			//수기계약발주서를 추가할 경우 발주생성은 하지 않음
			//발주서 생성은 "계약대기현황"에서 "수기계약이관"을 통해 들어온 건만 선택할 수 있도록 함
			grid.addRowEvent(function () {
				
				var addParam = [{
                    BUYER_CD: "${ses.companyCd}",
                    BUYER_NM: "${ses.companyNm}",
                    CUR: "KRW",
                    VAT_TYPE: "1",
                    PO_CREATE_FLAG: "0",
                    CONT_USER_ID: "${ses.userId}",
                    CONT_USER_NM: "${ses.userNm}"
                }];
                grid.addRow(addParam);
			});
			
			// Grid Excel Event
			grid.excelExportEvent({
				allItems: "${excelExport.allCol}",
				fileName: "${screenName }"
			});
			
			grid.cellClickEvent(function (rowIdx, celName, value) {
			    var param;
				// cell one click
                switch (celName) {
	                case "CONT_NUM":
	                	if(value == '') return;
	                	EVF.V("SCH_BUYER_CD", grid.getCellValue(rowIdx, "BUYER_CD"));
	                	EVF.V("SCH_CONT_NUM", grid.getCellValue(rowIdx, "CONT_NUM"));
	                	EVF.V("SCH_CONT_CNT", grid.getCellValue(rowIdx, "CONT_CNT"));
	                    doSearchMTGL();
	            	  	break;
	                    
                	case "PR_BUYER_DEPT_NM":
                    	var progressCd = grid.getCellValue(rowIdx, "PROGRESS_CD");
                    	if( progressCd == "4300" ) { return }
                        param = {
                  				'callBackFunction': 'callBackBuyerDept',
                  				'READONLY': 'Y',	//팝업 조회조건 변경불가
                  				'multiYN': 'N',		//멀티팝업여부
                  				'rowIdx': rowIdx,
                  				'detailView': false
                	  		};
                	  		everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
                        break;

                    case "VENDOR_NM":
                    	var progressCd = grid.getCellValue(rowIdx, "PROGRESS_CD");
                    	if( progressCd == "4300" ) { return }
                        param = {
                            callBackFunction: "setVendorGrid",
                            rowIdx: rowIdx
                        };
                        everPopup.openCommonPopup(param, "SP0123");
                        break;

                    case "CONT_USER_NM":
                    	var progressCd = grid.getCellValue(rowIdx, "PROGRESS_CD");
                    	if( progressCd == "4300" ) { return }
	                    var param = {
		                    'callBackFunction': 'setCtrlUserGrid',
		                    'READONLY': 'Y',		//팝업 조회조건 변경불가
		                    'multiYN' : 'N',        //멀티팝업여부
		                    'CTRL_CD' : "BR040,BR050",	// 계약담당자,계약체결자 권한
		                    'detailView': false,
		                    rowIdx: rowIdx
	                    };
	                    everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
                        break;

                    case "CONT_RMK":
                    	var progressCd = grid.getCellValue(rowIdx, "PROGRESS_CD");
                        param = {
                            title: "비고",
                            message: value,
                            rowIdx: rowIdx,
                            detailView: (progressCd == '4300' ? true : false),
                            callbackFunction: 'setRMK'
                        };
                        var url = "/common/popup/common_text_input/view.so";
                        everPopup.openModalPopup(url, 500, 320, param);
                        break;

                    case "ATT_FILE_CNT":
                    	var progressCd = grid.getCellValue(rowIdx, "PROGRESS_CD");
                        param = {
                          bizType: 'EC',
                          attFileNum: grid.getCellValue(rowIdx, 'ATT_FILE_NUM'),
                          detailView: (progressCd == '4300' ? true : false),
                          rowIdx: rowIdx,
                          callBackFunction: 'setFileAttachCnt',
                          fileExtension: '*'
                        };
                        everPopup.fileAttachPopup(param);
                        break;
                    case "EXEC_NUM":
                    	if(value == '') return;
						param = {
							'execNum': grid.getCellValue(rowIdx, 'EXEC_NUM'),
							'buyerCd': grid.getCellValue(rowIdx, 'BUYER_CD'),
							'tcoFlag': null,
							'popupFlag': true,
							'detailView': true
						};
						everPopup.openWindowPopup("/nhepro/CBDR/CBDI0061/view.so", 1400, 800, param, "createCN", true);
						break;
                }
			});

			grid.cellChangeEvent(function (rowIdx, celName, iRow, iCol, value, oldValue) {
				switch (celName) {
					case "CONT_NUM":
						for (var i in grid.getAllRowValue()) {
							var rowValue = grid.getAllRowValue()[i];

							if(i != rowIdx) {
								console.log(i);
								if(grid.getCellValue(rowIdx, "CONT_NUM") == rowValue.CONT_NUM) {
									grid.setCellValue(rowIdx, "CONT_NUM", "");
									return EVF.alert("동일한 계약번호를 사용하실 수 없습니다.");
								}
							}
						}
						break;
				}
			});
			
			<%--
			2021.08.26 : 사용자 법인구분이 은행(1) OR 중앙회(5)일 경우만 "IT포탈전송" 버튼 활성화. 
	 		if ("${ses.companyCd}".indexOf("${itPortalCustCd}") > -1) {
	 		--%>
 			if ("${ses.corpType}" == "1" || "${ses.corpType}" == "5") {
            	// 수기계약서이관등록 화면에서 "관리자직무(BR900)" 만 "IT포탈전송" 버튼 보이도록 함
            	if(changeFlag) {
            		EVF.C('doSendITPortal').setVisible(true);
                } else {
                	EVF.C('doSendITPortal').setVisible(false);
                }
            } else {
		    	EVF.C('doSendITPortal').setVisible(false);
		    	grid.hideCol("IF_YN", true);
            }
		}

        function setFileAttachCnt(rowIdx, fileId, fileCnt) {
            grid.setCellValue(rowIdx, 'ATT_FILE_CNT', fileCnt);
            grid.setCellValue(rowIdx, 'ATT_FILE_NUM', fileId);
        }

        function setRMK(data) {
            grid.setCellValue(data.rowIdx, "CONT_RMK", data.message);
            grid.setColIconify("CONT_RMK", "CONT_RMK", "comment", true);
        }

        function callBackBuyerDept(data) {
        	if( data != null ) {
        		data = JSON.parse(data);
        		
	            var prBuyerDeptNm = data.CUST_NM + " " + data.DEPT_NM;
        		/** 2021.01.19 로직 제외
        		 * 계약건별 의뢰고객사는 동일할 수 있음
	            var allRowId = grid.getSelRowId();
	            for(var i in allRowId) {
	            	var rowIdx = allRowId[i];
	              	if( grid.getCellValue(rowIdx, "PR_BUYER_DEPT_NM") == prBuyerDeptNm ) {
	                	return EVF.alert("동일한 체결 고객사가 존재합니다.\n확인하여 주시기 바랍니다.");
	              	}
	            }*/
				
	            grid.setCellValue(data.rowIdx, "PR_BUYER_CD", data.CUST_CD);
	            grid.setCellValue(data.rowIdx, "PR_DEPT_CD", data.DEPT_CD);
	            grid.setCellValue(data.rowIdx, "PR_BUYER_DEPT_NM", prBuyerDeptNm);
        	}
        }

		// Search
		function doSearch() {
			var store = new EVF.Store();

			// form validation Check
			if (!store.validate()) return;

			store.setGrid([grid]);
			store.load(baseUrl + '/doSearch.so', function () {
				if (grid.getRowCount() == 0) {
					return EVF.alert('${msg.M0002}');
				} else {
					var allRowId = grid.getAllRowId();
		            for(var i in allRowId) {
		            	var rowIdx = allRowId[i];
		              	if( grid.getCellValue(rowIdx, "EXEC_NUM") != "" ) {
		              		grid.setCellReadOnly(rowIdx, "PO_CREATE_FLAG", false);
		              	}
		            }
                    grid.setColIconify("CONT_RMK", "CONT_RMK", "comment", true);
                }
			});
		}
		
		// Search 품목
		function doSearchMTGL() {
			var store = new EVF.Store();
			// form validation Check
			if (!store.validate()) return;
			store.setGrid([gridMTGL]);
			store.load(baseUrl + '/doSearchMTGL.so', function () {
			});
		}

		// Save
		function doSave() {
			
			var store = new EVF.Store();
			
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var progressCd = this.data.data;
			var selRowIdx  = grid.getSelRowId();
			for(var i in selRowIdx) {
				var rowIdx = selRowIdx[i];
				if (grid.getCellValue(rowIdx, "CONT_USER_ID") != "${ses.userId}") {
					return alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
				}
				if (grid.getCellValue(rowIdx, "PROGRESS_CD") == "4300") {
					return EVF.alert("이미 계약이 완료된 건입니다.");
				}
				if (grid.getCellValue(rowIdx, "ATT_FILE_CNT") == "0") {
					return EVF.alert("파일이 첨부되지 않았습니다.");
				}
			}
			
			var validate = grid.validate();
			if (!grid.validate().flag) {
				return EVF.alert(grid.validate().msg);
			}
			
			var confirmMsg = (progressCd == "4200" ? "${msg.M0021}" : "${CCTI0100_003}");
			EVF.confirm(confirmMsg, function () {
				store.setParameter('progressCd', progressCd);
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + '/doSave.so', function () {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
		}
		
		// Delete
		function doDelete() {
			
			var store = new EVF.Store();
			
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var selRowIdx  = grid.getSelRowId();
			for(var i in selRowIdx) {
				var rowIdx = selRowIdx[i];
				if (grid.getCellValue(rowIdx, "CONT_USER_ID") != "${ses.userId}") {
					return alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
				}
				if (grid.getCellValue(rowIdx, "PROGRESS_CD") == "4300") {
					return EVF.alert("이미 계약이 완료된 건입니다.");
				}
			}
			
			EVF.confirm("${CCTI0100_004}", function () {
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + '/doDelete.so', function () {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
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

        function setVendorGrid(data) {
            grid.setCellValue(data.rowIdx, "VENDOR_CD", data.VENDOR_CD);
            grid.setCellValue(data.rowIdx, "VENDOR_NM", data.VENDOR_NM);
        }

        function getDept() {
	        var param = {
	  				'callBackFunction': 'setDept',
	  				'READONLY': 'Y',	//팝업 조회조건 변경불가
	  				'multiYN': 'N',		//멀티팝업여부
	  				'detailView': false
		  		};
		  	everPopup.openPopupByScreenId("", 1000, 700, param);
        }

        function setDept(data) {
        	if(data != null){
        		data = JSON.parse(data);
	          	EVF.V("PR_DEPT_CD", data.DEPT_CD);
	          	EVF.V("PR_DEPT_NM", data.DEPT_NM);
        	}
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
			data = JSON.parse(data);
          	EVF.V("CONT_USER_ID", data.USER_ID);
          	EVF.V("CONT_USER_NM", data.USER_NM);
        }

        function setCtrlUserGrid(data) {
	        data = JSON.parse(data);
          	grid.setCellValue(data.rowIdx, "CONT_USER_ID", data.USER_ID);
          	grid.setCellValue(data.rowIdx, "CONT_USER_NM", data.USER_NM);
        }

		function doFind() {
			// 팝업 호출 전 실제 디렉토리가 존재하는지 확인
			var store = new EVF.Store();
			store.load(baseUrl + '/isFileDirectory.so', function () {
				var ezFinderInfo = JSON.parse(this.getParameter("ezFinderInfo"));
				if (ezFinderInfo.isFolder == "0") {
					return EVF.alert("검색할 수 있는 폴더가 존재하지 않습니다.");
				} else {
					ezfinder(ezFinderInfo);
				}
			});
		}

		function ezfinder(info) {
			// ezFinder 팝업호출
			var url = info.ezFinderUrl + "?company="+encodeURIComponent(info.folderEncNm);
			window.open(url,'_blank','scrollbars=no,toolbar=no,resizable=no');
		}
		
		function changeBuyer() {
			var param = {
	  				'callBackFunction': 'setAllBuyer',
	  				'READONLY': 'Y',	//팝업 조회조건 변경불가
	  				'multiYN': 'N',		//멀티팝업여부
	  				'detailView': false
		  		};
		  	everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
		}
		
		function setAllBuyer(data) {
			if( data != null ) {
        		data = JSON.parse(data);
	            var prBuyerDeptNm = data.CUST_NM + " " + data.DEPT_NM;
	          	EVF.V("AP_PR_BUYER_CD", data.CUST_CD);
	          	EVF.V("AP_PR_DEPT_CD", data.DEPT_CD);
	          	EVF.V("AP_PR_BUYER_NM", prBuyerDeptNm);
        	}
        }
		
	    function doApplyBuyer() {
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			if( EVF.V("AP_PR_BUYER_CD") == "" || EVF.V("AP_PR_DEPT_CD") == "" ) {
				return EVF.alert("일괄적용할 의뢰고객사가 선택되지 않았습니다.");
			}
			
			var selectedRow = grid.getSelRowId();
			if (selectedRow.length > 1) {
				EVF.confirm('${CCTI0100_001}', function() {
					for(var i in selectedRow) {
						grid.setCellValue(selectedRow[i], "PR_BUYER_CD", EVF.V("AP_PR_BUYER_CD"));
						grid.setCellValue(selectedRow[i], "PR_DEPT_CD", EVF.V("AP_PR_DEPT_CD"));
						grid.setCellValue(selectedRow[i], "PR_BUYER_DEPT_NM", EVF.V("AP_PR_BUYER_NM"));
					}
				});
			}
		}
		
		function changeVendor() {
			var param = {
		           	callBackFunction: "setAllVendor"
		    	};
			everPopup.openCommonPopup(param, "SP0123");
		}

        function setAllVendor(data) {
          	EVF.V("AP_VENDOR_CD", data.VENDOR_CD);
          	EVF.V("AP_VENDOR_NM", data.VENDOR_NM);
        }
		
		function doApplyVendor() {
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			if( EVF.V("AP_VENDOR_CD") == "" || EVF.V("AP_VENDOR_NM") == "" ) {
				return EVF.alert("일괄적용할 협력업체가 선택되지 않았습니다.");
			}
			
			var selectedRow = grid.getSelRowId();
			if (selectedRow.length > 1) {
				EVF.confirm('${CCTI0100_002}', function() {
					for(var i in selectedRow) {
						grid.setCellValue(selectedRow[i], "VENDOR_CD", EVF.V("AP_VENDOR_CD"));
						grid.setCellValue(selectedRow[i], "VENDOR_NM", EVF.V("AP_VENDOR_NM"));
					}
				});
			}
		}
		
		// 2021.08.10 추가
		// 농협중앙회 IT전략본부 직원인 경우 계약서 IT포탈전송 버튼 활성화
		function doSendITPortal() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var msg = "${CCTI0100_012}";
			
			var buyerCd = "";
			var contNum = "";
			var contCnt = "";
			var contNumCnt = "";	// 계약고객사 + 계약번호번호 + 계약차수
			var selRowId = grid.getSelRowId();
			for(var i in selRowId) {
				
				if (grid.getCellValue(selRowId[i], "PROGRESS_CD") != '4300') {
					return EVF.alert("${CCTI0100_011}");
				}
				
				if (grid.getCellValue(selRowId[i], "IF_TYPE") != 'ITA' && grid.getCellValue(selRowId[i], "IF_TYPE") != 'ITB') {
					return EVF.alert("ITPortal에서 전송된 계약건이 아닙니다.\n\nInterface유형을 확인하세요.");
				}
				
				if (grid.getCellValue(selRowId[i], "CONT_REQ_CD") != '10') {
					return EVF.alert("계약구분이 '신규'인 계약건만 전송이 가능합니다.\n\n계약구분을 확인하세요.");
				}
				
				if (grid.getCellValue(selRowId[i], "IF_YN") == '1') {
					msg = "이미 전송된 건입니다. 재전송 하시겠습니까?";
				}
				
				// 동일한 체결고객, 계약번호, 계약차수는 1번만 조회함
				if(buyerCd == grid.getCellValue(selRowId[i], "BUYER_CD") && contNum == grid.getCellValue(selRowId[i], "CONT_NUM") && contCnt == grid.getCellValue(selRowId[i], "CONT_CNT")) {
					continue;
				} else {
					if( (Number(i) + 1) == selRowId.length ) {
						contNumCnt += grid.getCellValue(selRowId[i], "BUYER_CD") + grid.getCellValue(selRowId[i], "CONT_NUM") + grid.getCellValue(selRowId[i], "CONT_CNT");
					} else {
						contNumCnt += grid.getCellValue(selRowId[i], "BUYER_CD") + grid.getCellValue(selRowId[i], "CONT_NUM") + grid.getCellValue(selRowId[i], "CONT_CNT") + ",";
					}
					buyerCd = grid.getCellValue(selRowId[i], "BUYER_CD");
					contNum = grid.getCellValue(selRowId[i], "CONT_NUM");
					contCnt = grid.getCellValue(selRowId[i], "CONT_CNT");
				}
			}

			var store = new EVF.Store();
			EVF.confirm(msg, function () {
				store.setParameter('CONT_NUM_CNT', contNumCnt);
				store.load('/nhepro/CCTR/CCTR0050/doSendITPortal.so', function() {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
		}
	</script>

	<e:window id="CCTI0100" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999}" labelWidth="130" width="100%" columnCount="3" useTitleBar="true" onEnter="doSearch">
			<e:inputHidden id="SCH_BUYER_CD" name="SCH_BUYER_CD" />
			<e:inputHidden id="SCH_CONT_NUM" name="SCH_CONT_NUM" />
			<e:inputHidden id="SCH_CONT_CNT" name="SCH_CONT_CNT" />
			
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
                    <e:search id="PR_BUYER_CD" name="PR_BUYER_CD" value="" width="40%" maxLength="${form_PR_BUYER_CD_M}" onIconClick="${form_PR_BUYER_CD_RO ? 'everCommon.blank' : 'getBuyer'}" disabled="${form_PR_BUYER_CD_D}" readOnly="${form_PR_BUYER_CD_RO}" required="${form_PR_BUYER_CD_R}" maskType="${form_PR_BUYER_CD_MT}" />
                    <e:inputText id="PR_BUYER_NM" name="PR_BUYER_NM" value="" width="60%" maxLength="${form_PR_BUYER_NM_M}" disabled="${form_PR_BUYER_NM_D}" readOnly="${form_PR_BUYER_NM_RO}" required="${form_PR_BUYER_NM_R}" style="${imeMode}" maskType="${form_PR_BUYER_NM_MT}"/>
                </e:field>
                <%--계약부서명--%>
                <e:label for="PR_DEPT_CD" title="${form_PR_DEPT_CD_N}"/>
                <e:field>
                    <e:search id="PR_DEPT_CD" name="PR_DEPT_CD" value="" width="40%" maxLength="${form_PR_DEPT_CD_M}" onIconClick="${form_PR_DEPT_CD_RO ? 'everCommon.blank' : 'getDept'}" disabled="${form_PR_DEPT_CD_D}" readOnly="${form_PR_DEPT_CD_RO}" required="${form_PR_DEPT_CD_R}" maskType="${form_PR_DEPT_CD_MT}" />
                    <e:inputText id="PR_DEPT_NM" name="PR_DEPT_NM" value="" width="60%" maxLength="${form_PR_DEPT_NM_M}" disabled="${form_PR_DEPT_NM_D}" readOnly="${form_PR_DEPT_NM_RO}" required="${form_PR_DEPT_NM_R}" style="${imeMode}" maskType="${form_PR_DEPT_NM_MT}"/>
                </e:field>
			</e:row>
            <e:row>
                <%--계약담당자--%>
                <e:label for="CONT_USER_ID" title="${form_CONT_USER_ID_N}"/>
                <e:field>
                    <e:search id="CONT_USER_ID" name="CONT_USER_ID" value="" width="40%" maxLength="${form_CONT_USER_ID_M}" onIconClick="${form_CONT_USER_ID_RO ? 'everCommon.blank' : 'getCtrlUser'}" disabled="${form_CONT_USER_ID_D}" readOnly="${form_CONT_USER_ID_RO}" required="${form_CONT_USER_ID_R}" maskType="${form_CONT_USER_ID_MT}" />
                    <e:inputText id="CONT_USER_NM" name="CONT_USER_NM" value="" width="60%" maxLength="${form_CONT_USER_NM_M}" disabled="${form_CONT_USER_NM_D}" readOnly="${form_CONT_USER_NM_RO}" required="${form_CONT_USER_NM_R}" style="${imeMode}" maskType="${form_CONT_USER_NM_MT}"/>
                </e:field>
                <%--계약번호/명--%>
                <e:label for="CONT_NUM" title="${form_CONT_NUM_N}" />
                    <e:field>
                    <e:inputText id="CONT_NUM" name="CONT_NUM" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
                </e:field>
                <%--협력업체--%>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
                <e:field>
                    <e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" onIconClick="${form_VENDOR_CD_RO ? 'everCommon.blank' : 'getVendor'}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" maskType="${form_VENDOR_CD_MT}" />
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}"/>
                </e:field>
              </e:row>
		</e:searchPanel>
		
		<e:buttonBar width="100%" align="right">
			<e:text style="color: blue;font-weight: bold;">■ 의뢰고객사 : </e:text>
			<e:inputHidden id="AP_PR_BUYER_CD" name="AP_PR_BUYER_CD" />
			<e:inputHidden id="AP_PR_DEPT_CD" name="AP_PR_DEPT_CD" />
			<e:search id="AP_PR_BUYER_NM" name="AP_PR_BUYER_NM" value="" width="140" maxLength="${for_AP_PR_BUYER_NM_M}" onIconClick="changeBuyer" disabled="${form_AP_PR_BUYER_NM_D}" readOnly="${form_AP_PR_BUYER_NM_RO}" required="${form_AP_PR_BUYER_NM_R}" />
			<e:button id="doApplyAll" name="doApplyAll" label="${doApplyAll_N}" onClick="doApplyBuyer" disabled="${doApplyAll_D}" visible="${doApplyAll_V}" align="left" style="padding-left: 3px;"/>
			
			<e:text style="color: blue;font-weight: bold;">■ 협력업체 : </e:text>
			<e:inputHidden id="AP_VENDOR_CD" name="AP_VENDOR_CD" />
			<e:search id="AP_VENDOR_NM" name="AP_VENDOR_NM" value="" width="140" maxLength="${for_AP_VENDOR_NM_M}" onIconClick="changeVendor" disabled="${form_AP_VENDOR_NM_D}" readOnly="${form_AP_VENDOR_NM_RO}" required="${form_AP_VENDOR_NM_R}" />
			<e:button id="doApplyVendor" name="doApplyVendor" label="${doApplyVendor_N}" onClick="doApplyVendor" disabled="${doApplyVendor_D}" visible="${doApplyVendor_V}" align="left" style="padding-left: 3px;"/>

			<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}" data="4200"/>
			<e:button id="doConfirm" name="doConfirm" label="${doConfirm_N}" onClick="doSave" disabled="${doConfirm_D}" visible="${doConfirm_V}" data="4300"/>
			<e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
			<e:button id="doFind" name="doFind" label="${doFind_N}" onClick="doFind" disabled="${doFind_D}" visible="${doFind_V}"/>
			<!-- 2021.08.10 : 농협중앙회(C00009) IT전략본부(00036) 직원인 경우 IT포탈계약서전송 버튼 활성화 -->
			<e:button id="doSendITPortal" name="doSendITPortal" label="${doSendITPortal_N}" onClick="doSendITPortal" disabled="${doSendITPortal_D}" visible="${doSendITPortal_V}"/>
		</e:buttonBar>
		<e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="100%" height="fit" readOnly="${param.detailView}"/>
		<e:gridPanel id="gridMTGL" name="gridMTGL" gridType="${_gridType}" width="100%" height="180" readOnly="${param.detailView}"/>
	</e:window>
</e:ui>
