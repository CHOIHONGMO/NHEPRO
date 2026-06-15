<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String devFlag = PropertiesManager.getString("eversrm.system.developmentFlag"); %>

<c:set var="devFlag" value="<%=devFlag%>" />
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript" src="/js/ever-math.js"></script>
	<script>
	    var grid;
		var baseUrl = "/nhepro/CPRI/";
		var detailView = "${param.detailView}" == "true";
		
		function init() {
			
		    grid = EVF.C("grid");
		    grid.cellClickEvent(function (rowIdx, colIdx) {
				var param;
		        if (colIdx === 'ATT_FILE_CNT') {
		            param = {
		                attFileNum: grid.getCellValue(rowIdx, 'ATT_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'fileAttachPopupCallback',
						bizType: 'PR',
                        detailView: ${param.detailView == true ? true : false}
		            };
					everPopup.fileAttachPopup(param);
		        }
		        else if (colIdx === 'PR_BUYER_NM') {
		        	if(detailView) return;
		        	
					param = {
						'callBackFunction': 'prBuyerNmCallback',
						'detailView': false,
						'rowIdx': rowIdx
					};
					everPopup.openCommonPopup(param, "SP0119");
				}
		        else if (colIdx === 'EC_BUYER_NM') {
		        	if(detailView) return;
		        	
		        	param = {
						'callBackFunction': 'ecBuyerNmCallback',
						'multiYN' : 'N',         //멀티팝업여부
						'detailView': false,
						'rowIdx': rowIdx
					};
					everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
				}
		        else if (colIdx === 'VENDOR_NM') {
                    var vendor_open_type = grid.getCellValue(rowIdx, 'VENDOR_OPEN_TYPE');
					if (vendor_open_type=='GC') {
						return EVF.alert('계약방법이 일반경재일 경우는 입력하실 수 없습니다.');
					}
					
                    var VN_INFO = grid.getCellValue(rowIdx, "VENDOR_CD");
                    ROWIDX = rowIdx;
                    param = {
                        callBackFunction : "callBackVENDOR_CD",
                        candidateJson: (EVF.isEmpty(VN_INFO) ? [] : VN_INFO),
                        detailView: ${param.detailView == true ? true : false},
                        callType: ""
                    };
                    everPopup.openPopupByScreenId("CBDR0016", 1200, 700, param);
		        }
		        else if (colIdx === 'MAKER_NM') {
		        	if(detailView) return;
		        	
					if (   grid.getCellValue(rowIdx, 'ITEM_CD') != ''
						&& grid.getCellValue(rowIdx, 'MAJOR_ITEM_FLAG') != '1'
					) {
							return EVF.alert('${CPRI0010_0010}');
					}

					if (grid.getCellValue(rowIdx, 'PR_BUYER_CD') == '') {
			        	alert('${CPRI0010_0005}');
						return;
					}
		            everPopup.openCommonPopup({
		                callBackFunction: 'makerNmCallback',
		                BUYER_CD : grid.getCellValue(rowIdx, 'PR_BUYER_CD'),
						rowIdx: rowIdx
		            }, 'SP0120');
		        }
		        else if (colIdx === 'ITEM_CD') {
		        	if (grid.getCellValue(rowIdx, 'PR_BUYER_CD') == '') {
			        	alert('${CPRI0010_0005}');
						return;
					}
		            everPopup.openCommonPopup({
		                callBackFunction: 'itemCdCallback',
		                BUYER_CD : (grid.getCellValue(rowIdx, 'PR_BUYER_CD') == '공동' ? 'C00009' : '${ses.companyCd}') ,
						rowIdx: rowIdx
		            }, 'SP0121');
		        }
		    });

		    grid.cellChangeEvent(function (rowIdx, colIdx, iRow, iCol, newValue, oldValue) {
				var store;
		        switch (colIdx) {
	            	case 'SUBMIT_TYPE':
		                if ( grid.getCellValue(rowIdx, 'VENDOR_OPEN_TYPE') == 'PC' ) {
		                	grid.setCellValue(rowIdx, 'SUBMIT_TYPE', '');
							return EVF.alert('계약방법이 수의계약일 경우 선택하실수 없습니다.');
		                }
						break;

		            case 'UNIT_PRC':
		                if (Number(newValue) < 0) {
		                    grid.setCellValue(rowIdx, colIdx, oldValue);
							return EVF.alert('${CPRI0010_INPUT_VALUE_LESS}');
		                }
						break;

		            case 'PR_QT':
		                if (newValue < 0) {
		                    grid.setCellValue(rowIdx, colIdx, oldValue);
							return EVF.alert('${msg.INPUT_GREATER_THAN_ZERO}');
		                }
		                break;

		            case 'VENDOR_OPEN_TYPE':
		                if (newValue == 'PC') {
		                    grid.setCellValue(rowIdx, 'SUBMIT_TYPE', '');
		                }

		                if (
		                		newValue == 'PC'
			                || newValue == 'GC'
		                ) {
		                    grid.setCellValue(rowIdx, 'VENDOR_NM', '');
		                    grid.setCellValue(rowIdx, 'VENDOR_CD', '');
		                }
		                break;
		        }

		        if (colIdx === 'UNIT_PRC' || colIdx === 'PR_QT') {
		            fillGridItem();
		        }

		        if (colIdx === 'ITEM_DESC'
		        	|| colIdx === 'ITEM_SPEC'
		        	|| colIdx === 'MAKER_NM'
		        	|| colIdx === 'MAKER_CD'
		        	|| colIdx === 'MAKER_PART_NO'
		        	|| colIdx === 'ORIGIN_CD'
		        	|| colIdx === 'UNIT_CD'
		        ) {
					if (
							grid.getCellValue(rowIdx, 'ITEM_CD') != ''
							&& grid.getCellValue(rowIdx, 'MAJOR_ITEM_FLAG') != '1'
					) {
		                    grid.setCellValue(rowIdx, colIdx, oldValue);
							return EVF.alert('${CPRI0010_0010}');
					}
		        }
		    });

			grid.delRowEvent(function () {
				// 2021.10.29 IT포탈 구매의뢰건은 품목 삭제할 수 없음
				var rowIds = grid.getSelRowId();
	            for(var i in rowIds) {
	                if(!EVF.isEmpty(grid.getCellValue(rowIds[i], 'CM_REQ_ID'))) {
	                	return EVF.alert("IT포탈 의뢰건은 '담당자지정' 화면에서 미접수된 건만 삭제할 수 있습니다.");
	                }
				}
				grid.delRow();
				/**
				 * 2021.04.16 삭제
				var selRowIds = grid.getSelRowId();
				for (var x = selRowIds.length - 1; x >= 0; x--) {
					if (grid.getCellValue(selRowIds[x], 'INSERT_FLAG') == 'I') {
						grid.delRow(selRowIds[x]);
					} else {
						if (grid.getCellValue(selRowIds[x], 'INSERT_FLAG') != 'D') {
							grid.setCellValue(selRowIds[x], 'INSERT_FLAG', 'D');
							grid.setRowBgColor(selRowIds[x], '#8C8C8C');
						} else {
							grid.setCellValue(selRowIds[x], 'INSERT_FLAG', 'R');
							grid.setRowBgColor(selRowIds[x], '#FFFFFF');
						}
					}
				}*/
			});

			grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			if(EVF.isEmpty(EVF.V("PR_TYPE"))) {
				EVF.V("PR_TYPE", "10");
			}
			if('${formData.IF_TYPE}' != 'ITA' && '${formData.IF_TYPE}' != 'ITB') {
				grid.setColGroup([
	                {
	                    "groupName": '용역(도급)',
	                    "columns": ['MNT_SANGJU_YN']
	                }
	                ,{
	                    "groupName": '물품(공사,기타,양수)',
	                    "columns": ['CONSUMER_AMT', 'FC_MNT_TERM', 'CH_RATE']
	                }
	                ,{
	                    "groupName": '유지보수(리스,재리스,렌탈)',
	                    "columns": ['DOIB_AMT', 'MNT_RATE', 'MNT_SDAY', 'MNT_EDAY', 'MNT_GUR_MONTH', 'RT_INSP_PERIOD', 'FALT_RC_TG_TIME']
	                }
	            ],50);
				
				grid.hideCol('CM_REQ_DET_NM', true);
				grid.hideCol('BZ_TIMELINE_SDAY', true);
				grid.hideCol('BZ_TIMELINE_EDAY', true);
				grid.hideCol('ACC_CD', true);
				grid.hideCol('BDGT_INFO', true);
				grid.hideCol('PAY_PERIOD_MTHD', true);
				grid.hideCol('PAY_PERIOD_MTHD2', true);
				grid.hideCol('GISANIL', true);
				grid.hideCol('CM_REQ_ID', true);
				grid.hideCol('CM_REQ_DET_ID', true);
				grid.hideCol('MULPUM_ID', true);
				grid.hideCol('PRE_CONT_NUM', true);
				grid.hideCol('PRE_CONT_CNT', true);
			}
			else {
				grid.setColGroup([
	                {
	                    "groupName": '용역(도급)',
	                    "columns": ['MNT_SANGJU_YN']
	                }
	                ,{
	                    "groupName": '물품(공사,기타,양수)',
	                    "columns": ['CONSUMER_AMT', 'FC_MNT_TERM', 'CH_RATE']
	                }
	                ,{
	                    "groupName": '유지보수(리스,재리스,렌탈)',
	                    "columns": ['DOIB_AMT', 'MNT_RATE', 'MNT_SDAY', 'MNT_EDAY', 'MNT_GUR_MONTH', 'RT_INSP_PERIOD', 'FALT_RC_TG_TIME']
	                }
	                ,{
	                	"groupName": '인터페이스정보(IT포탈)',
	                    "columns": ['CM_REQ_ID', 'CM_REQ_DET_ID', 'MULPUM_ID', 'PRE_CONT_NUM', 'PRE_CONT_CNT']
	                }
	            ],50);
			}
			
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
		    grid.setRowFooter("EC_BUYER_NM", footer);

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
		    grid.setRowFooter("CONSUMER_AMT", distVal);
		    grid.setRowFooter("DOIB_AMT", distVal);
		    // ===========================================================
		    
			<%-- 구매요청진행현황 List --%>
			var prList = JSON.stringify(${param.prList});
			if(prList != '') {
				EVF.V('prList', prList);
				doSearch();
			}

			if ('${param.prNum}' !== '' || '${param.appDocNum}' !== '') {
				doSearch();
			}
		}

		function doSearch() {

			var store = new EVF.Store();
			store.setGrid([grid]);
			store.load(baseUrl + "/cpri0010_doSearch.so", function () {
				fillGridItem();
				<%-- 결재 진행중 일 경우 버튼 히든 --%>
				if( EVF.V("SIGN_STATUS") == 'P' ) {
					EVF.C('Save').setVisible(false);
				}
			});
		}

		function doSave() {
			
			if (grid.getRowCount() == 0) { return EVF.alert("${CPRI0010_ITEM_DATA_NOT_EXIST}"); }
			
			if (EVF.V('TRANSACTION_FLAG') == 'Y') { return EVF.alert('${msg.M0123}'); }
			
			var signStatus = this.getData().data;
			var Rcou = 0;
			var allRowIds = grid.getAllRowId();
			for (var i in allRowIds) {
				var rowData = grid.getRowValue(allRowIds[i]);
				
				var vendor_open_type = rowData['VENDOR_OPEN_TYPE'];
				var vendor_cnt = rowData['VENDOR_CNT'];
				if (vendor_open_type == 'PC') {
					if (vendor_cnt == '') {
						return EVF.alert('계약방법이 수의계약일 경우 업체를 반드시 지정해야 합니다.');
					}
					if (vendor_cnt != '1') {
						return EVF.alert('계약방법이 수의계약일 경우 업체는 1개만 입력해야합니다.');
					}
				}
				
				if (EVF.isEmpty(EVF.V('CUR')) && !EVF.isEmpty(rowData['UNIT_PRC'])) {
					return EVF.alert('${CPRI0010_CHOOSE_CURRENCY_VALUE}');
				}
				
				if (EVF.isEmpty(rowData['VENDOR_CD']) && (rowData['VENDOR_OPEN_TYPE'] == 'NC' || rowData['VENDOR_OPEN_TYPE'] == 'PC')) {
					return EVF.alert('계약방법이 수의계약/지명계약일 경우 협력업체를 입력해주세요.');
				}
				
				if (EVF.isEmpty(rowData['SUBMIT_TYPE']) 
				&& (rowData['VENDOR_OPEN_TYPE'] == 'NC' || rowData['VENDOR_OPEN_TYPE'] == 'LC' || rowData['VENDOR_OPEN_TYPE'] == 'GC')) {
					return EVF.alert('계약방법이 일반경쟁,제한경쟁,지명경쟁일 경우 낙찰자결정방법을 입력해주세요.');
				}
				
				if (EVF.isEmpty(rowData['PR_QT'])) {
					return EVF.alert('수량을 넣어주세요.');
				}
				
				if (rowData['PURCHASE_TYPE'] == 'S' && EVF.isEmpty(rowData['MNT_SANGJU_YN'])) { // 용역일때
					return EVF.alert('${CPRI0010_0006}');
				}
			}

			<%-- 구매요청 제목 자동 세팅 --%>
			validationAndSave(signStatus);
		}

		function validationAndSave(signStatus) {

			var store = new EVF.Store();
			if (!store.validate()) { return; }
			if (!grid.validate().flag) { return EVF.alert('${msg.M0014}'); }

			var subject;
			var allRowIds = grid.getAllRowId();
			
			<%-- [xxx외 3건] 수선 요청의 건 --%>
			if(allRowIds.length > 1) {
				subject = "[" + grid.getCellValue(allRowIds[0], "ITEM_DESC");
				if(grid.getCellValue(allRowIds[0], "ITEM_SPEC") != "")
					subject += "/";
			}
			else {
				subject = "[" + grid.getCellValue(allRowIds[0], "ITEM_DESC");
				if(grid.getCellValue(allRowIds[0], "ITEM_SPEC") != "")
					subject += "/";
			}

			var minDate = null;
			var selRowId = grid.getSelRowId();
			for (var i in selRowId) {
				var date = Number(grid.getCellValue(selRowId[i], 'DUE_DATE'));
				if (minDate === null || date < minDate) {
					minDate = date;
				}
			}

			if (minDate1=0) {
				everDate.diffWithServerDate(String(minDate), function (status, message) {
					if (status === '-1') {
						EVF.alert('${CPRI0010_INPUT_DATE_LESS}');
					} else {
						afterValidation(signStatus);
					}
				}, true);
			}
			else {
				afterValidation(signStatus);
			}
		}

		function afterValidation(signStatus) {

			var oldSignStatus = EVF.V('SIGN_STATUS');
			if (oldSignStatus!='E') {
				EVF.V('SIGN_STATUS', signStatus);
			}
			var confirmMessage;
			switch (signStatus) {
				case 'T':
					confirmMessage = '${msg.M0021}';
					break;
				case 'E':
					confirmMessage = '${msg.M0053}';
					break;
				case 'P':
					confirmMessage = '${msg.M0053}';
					break;
			}
			
			// 구매의뢰 예상총금액 > 0 체크
			var prAmt = Number(EVF.V("PR_AMT"));
			if( prAmt == 0 ) {
				return EVF.alert('${CPRI0010_ITEM_AMT_MSG}');
			}
			
			EVF.confirm(confirmMessage, function () {
				if (signStatus === 'T' || signStatus === 'E') {
					goApproval();
				}
				else if (signStatus === 'P') {
					var param = {
						subject: EVF.V('SUBJECT'),
						docType: "PR",
						signStatus: signStatus,
						screenId: "CPRI0010",
						approvalType: 'APPROVAL',
						attFileNum: "",
						docNum: EVF.V('PR_NUM'),
						appDocNum: EVF.V('APP_DOC_NUM'),
						callBackFunction: "goApproval",
                        appAmt: eval(EVF.V('PR_AMT'))
					};
					everPopup.openApprovalRequestIPopup(param);
				}
			});
		}

		function goApproval(formData, gridData, attachData) {

			EVF.V('approvalFormData', formData);
			EVF.V('approvalGridData', gridData);
			EVF.V('attachFileDatas', attachData);

			var store = new EVF.Store();
			if(!store.validate()) return;
			
			store.doFileUpload(function() {
				store.setGrid([grid]);
				store.getGridData(grid, 'all');
				store.load(baseUrl + '/cpri0010_doSave.so', function () {

					var success = this.getParameter('isSuccess');
					var buyerCd = this.getParameter('BUYER_CD');
					var prNum   = this.getParameter('PR_NUM');
					var signStatus = this.getParameter("SIGN_STATUS");
					
					EVF.alert(this.getResponseMessage(), function () {
						
						var param = {
							'buyerCd': buyerCd,
							'prNum': prNum,
							'detailView': false
						};
						
						// 21.01.13 농협중앙회 요청 
                		// 기존에는 저장이후 팝업 close => close 하지 않고 바로 결재상신 할 수 있도록 화면 재조회, 결재상신 이후에는 화면 close
						if (success === 'true') {
							if (opener != null && opener !== undefined && opener['doSearch'] !== undefined) {
								opener['doSearch']();
								if (signStatus === 'P') {
	                                doClose();
								} else {
									param['popupFlag'] = true;
	                                window.location.href = baseUrl + 'CPRI0010/view.so?' + $.param(param);
								}
							} else {
								if (signStatus === 'P') {
	                        		document.location.href = baseUrl + 'CPRI0010/view.so?';
	                        	} else {
	                        		param['popupFlag'] = false;
	                        		document.location.href = baseUrl + 'CPRI0010/view.so?' + $.param(param);
	                        	}
							}
						}
					});
				});
			});
		}

		function prBuyerNmCallback(data) {
			grid.setCellValue(data.rowIdx, "PR_BUYER_NM", data.BUYER_NM + ' ' +data.DEPT_NM );
			grid.setCellValue(data.rowIdx, "PR_BUYER_CD", data.BUYER_CD);
			grid.setCellValue(data.rowIdx, "PR_DEPT_CD", data.DEPT_CD);
		}

		function ecBuyerNmCallback(data) {
		    data = JSON.parse(data);

			if(grid.getRowCount() == 1) {
				grid.setCellValue(data.rowIdx, "EC_BUYER_NM", data.CUST_NM + ' ' +data.DEPT_NM );
				grid.setCellValue(data.rowIdx, "EC_BUYER_CD", data.CUST_CD);
				grid.setCellValue(data.rowIdx, "EC_DEPT_CD", data.DEPT_CD);
			} else{
				EVF.confirm('전체 적용하시겠습니까?', function() {
					var kcou = grid.getRowCount();
					for(var k=0;k < kcou;k++) {
						grid.setCellValue(k, "EC_BUYER_NM", data.CUST_NM + ' ' +data.DEPT_NM );
						grid.setCellValue(k, "EC_BUYER_CD", data.CUST_CD);
						grid.setCellValue(k, "EC_DEPT_CD", data.DEPT_CD);
					}
				}, function() {
					grid.setCellValue(data.rowIdx, "EC_BUYER_NM", data.CUST_NM + ' ' +data.DEPT_NM );
					grid.setCellValue(data.rowIdx, "EC_BUYER_CD", data.CUST_CD);
					grid.setCellValue(data.rowIdx, "EC_DEPT_CD", data.DEPT_CD);

				});
			}
		}

		function doDelete() {

			if (EVF.V('TRANSACTION_FLAG') == 'Y') { return EVF.alert('${msg.M0123}'); }

		    EVF.confirm("${msg.M0013}", function () {
				var store = new EVF.Store();
				store.load(baseUrl + 'CPRI0010/doDelete.so', function () {
					EVF.V('TRANSACTION_FLAG', 'Y');
					EVF.alert(this.getResponseMessage(), function() {
						if (opener != null) {
							opener['doSearch']();
							EVF.closeWindow();
						} else {
							location.href=baseUrl+'/view.so';
						}
					});
				});
			});
		}

		function calculatePrAmount() {
			var prAmt = 0;
		    var gridData = grid.getAllRowValue();
		    for (var i in gridData) {
		        prAmt += gridData[i].PR_AMT;
		    }
		    EVF.V('PR_AMT', prAmt);
		}

		function searchReqUser() {
		    everPopup.openCommonPopup({
		        callBackFunction: 'searchReqUserCallback'
		    }, 'SP0001');
		}

		function searchReqUserCallback(result) {
		    EVF.V('REQ_USER_NM', result.USER_NM);
		    EVF.V('REQ_USER_ID', result.USER_ID);
		    EVF.V('REQ_USER_DEPT', result.DEPT_NM);
		}

		function openItemPopup() {
			var param = {
				'callBackFunction': 'itemPopupCallback',
				'popupFlag': true,
				'detailView': false,
				'openerScreen': 'CPRI0010'
			};
			everPopup.openItemCatalogPopup(param);
		}

		function itemPopupCallback(data) {

			var validData = valid.equalPopupValid(data, grid, "ITEM_CD");
			var arrData = [];
			for(var idx in validData) {
				arrData.push({
					'ITEM_CD': validData[idx].ITEM_CD,
					'ITEM_DESC': validData[idx].ITEM_DESC,
					'ITEM_SPEC': validData[idx].ITEM_SPEC,
					'MAKER': validData[idx].MAKER,
					'PR_QT': validData[idx].ITEM_QT,
					'UNIT_CD': validData[idx].UNIT_CD,
					'UNIT_PRC': EVF.isEmpty(validData[idx].UNIT_PRC, '0'),
					'PR_AMT': Math.floor(Number(validData[idx].ITEM_QT) * Number(EVF.isEmpty(validData[idx].UNIT_PRC)), '0'),
					'ADD_FLAG': 'Y'
				});
			}
		    grid.addRow(arrData);

		    fillGridItem();
		}

		function doAddLine() {
		    grid.addRow();
		    fillGridItem();
		}

		function fillGridItem() {

		    var unitPrice;
		    var qty;
		    var allRowId = grid.getAllRowId();
		    for (var i in allRowId) {
		        var rowId = allRowId[i];

		        unitPrice = Number(grid.getCellValue(rowId, 'UNIT_PRC'));
		        qty       = Number(grid.getCellValue(rowId, 'PR_QT'));
		        grid.setCellValue(rowId, 'PR_AMT', everMath.floor_float(unitPrice * qty));

				// 품목선택 시 "품명/규격/제조사/단위" 수정 불가
				if(grid.getCellValue(rowId, 'ADD_FLAG') == "Y") {
					grid.setCellReadOnly(rowId, 'ITEM_DESC', true);
					grid.setCellReadOnly(rowId, 'ITEM_SPEC', true);
					grid.setCellReadOnly(rowId, 'MAKER', true);
					grid.setCellReadOnly(rowId, 'UNIT_CD', true);
				}
		    }
		    calculatePrAmount();
		}

		function fileAttachPopupCallback(gridRowId, fileId, fileCount) {
		    grid.setCellValue(gridRowId, 'ATT_FILE_CNT', fileCount);
		    grid.setCellValue(gridRowId, 'ATT_FILE_NUM', fileId);
		}

		function makerNmCallback(result) {
		    grid.setCellValue(result.rowIdx, 'MAKER_NM', result.MKBR_NM);
		    grid.setCellValue(result.rowIdx, 'MAKER_CD', result.MKBR_CD);
		}

		function itemCdCallback(result) {
		    grid.setCellValue(result.rowIdx, 'ITEM_CD', result.ITEM_CD);
		    grid.setCellValue(result.rowIdx, 'ITEM_DESC', result.ITEM_DESC);
		    grid.setCellValue(result.rowIdx, 'ITEM_SPEC', result.ITEM_SPEC);
		    grid.setCellValue(result.rowIdx, 'MAKER_NM', result.MAKER_NM);
		    grid.setCellValue(result.rowIdx, 'MAKER_CD', result.MAKER_CD);
		    grid.setCellValue(result.rowIdx, 'MAKER_PART_NO', result.MAKER_PART_NO);
		    grid.setCellValue(result.rowIdx, 'ORIGIN_CD', result.ORIGIN_CD);
		    grid.setCellValue(result.rowIdx, 'UNIT_CD', result.UNIT_CD);
		    grid.setCellValue(result.rowIdx, 'MAJOR_ITEM_FLAG', result.MAJOR_ITEM_FLAG);
		}

		function onCurChange() {
		    fillGridItem();
		}

		function doItemCopy() {
	        if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
	        var argsIndex = 0;
	        var copyArgs = [];
			var rowIds = grid.getSelRowId();
			var domainNmData = "";
			for(var i = 0; i < rowIds.length; i++) {
				var selectedData = [];
				selectedData[0] = grid.getRowValue(rowIds[i]);
				selectedData[0].PR_NUM = '';
				grid.addRow(selectedData);
			}
		}

		function itPotal() {
			var mnt_yn = '${formData.MNT_YN}';
			var cm_req_id = '';
			var screen_id = '';
			if (mnt_yn == 'Y') {
				screen_id = 'CPRA0060';
			} else {
				screen_id = 'CPRA0060';
			}

			var allRowIds = grid.getAllRowId();
			for (var i in allRowIds) {
				cm_req_id = grid.getCellValue(allRowIds[i], 'CM_REQ_ID')
				break;
			}
			var param = {
	    			MNT_YN : mnt_yn
	    			, CM_REQ_ID : cm_req_id
	    			,'detailView':true
			};
			everPopup.openPopupByScreenId(screen_id, 1200, 900, param);
		}

        function doSearchItem() {
            var param = {
                PROJECT_SQ: null,
                detailView: false,
                callbackFunction: "callBackITEM"
            };
            everPopup.openPopupByScreenId("CITR0042", 1150, 810, param);
        }

        function callBackITEM(data) {
        	
			//20210824 계약체결고객사가 품목추가시 의뢰고객사 적용
			var var_PR_BUYER_CD = "";
			var var_PR_DEPT_CD = "";
			
			if ('${param.prNum}' !== '' && EVF.V("BUYER_CD") !== '${ses.companyCd}' && EVF.V("REQ_USER_DEPT_CD") !== '${ses.deptCd}') {
				var_PR_BUYER_CD = EVF.V("BUYER_CD");
				var_PR_DEPT_CD = EVF.V("REQ_USER_DEPT_CD");
			} else {
				var_PR_BUYER_CD = '${ses.companyCd}';
				var_PR_DEPT_CD = '${ses.deptCd}';
			}    
        	
            for(var j in data) {
                var rowIdx = grid.addRow(data[j]);

				grid.setCellValue(rowIdx, 'PR_BUYER_CD', var_PR_BUYER_CD );
				grid.setCellValue(rowIdx, 'PR_DEPT_CD',  var_PR_DEPT_CD);
				grid.setCellValue(rowIdx, 'EC_BUYER_CD', '${ses.companyCd}' );
				grid.setCellValue(rowIdx, 'ITEM_CD', data[j].ITEM_CD);
			    grid.setCellValue(rowIdx, 'ITEM_DESC', data[j].ITEM_DESC);
			    grid.setCellValue(rowIdx, 'ITEM_SPEC', data[j].ITEM_SPEC);
			    grid.setCellValue(rowIdx, 'MAKER_NM', data[j].MAKER_NM);
			    grid.setCellValue(rowIdx, 'MAKER_CD', data[j].MAKER_CD);
			    grid.setCellValue(rowIdx, 'MAKER_PART_NO', data[j].MAKER_PART_NO);
			    grid.setCellValue(rowIdx, 'ORIGIN_CD', data[j].ORIGIN_CD);
			    grid.setCellValue(rowIdx, 'UNIT_CD', data[j].UNIT_CD);
			    grid.setCellValue(rowIdx, 'MAJOR_ITEM_FLAG', data[j].MAJOR_ITEM_FLAG);
            }
        }

        function callBackVENDOR_CD(data) {
            
        	var VN_INFO = JSON.parse(data);
            var VN_INFO_CNT = VN_INFO.length;
            
            var vendor_open_type = grid.getCellValue(ROWIDX, 'VENDOR_OPEN_TYPE');
			if (vendor_open_type=='PC') {
				if (VN_INFO_CNT > 1) {
					return EVF.alert('계약방업이 수의계약일 경우에는 협렵업체를 하나만 입력해주세요.');
				}
			}
			
			if (vendor_open_type=='LC' || vendor_open_type=='NC') {
				if (VN_INFO_CNT < 2) {
					return EVF.alert('계약방법이 제한,지명일 경우에는 협렵업체를 하나 이상 입력해주세요.');
				}
			}
			
			var vendorNm = "";
			if( VN_INFO_CNT == 1 ) {
				vendorNm = VN_INFO[0].VENDOR_NM;
			} else {
				vendorNm = VN_INFO_CNT;
			}
			
			if(grid.getRowCount() == 1) {
	            grid.setCellValue(ROWIDX, "VENDOR_NM" , vendorNm);
	            grid.setCellValue(ROWIDX, "VENDOR_CD" , JSON.stringify(VN_INFO));
	            grid.setCellValue(ROWIDX, "VENDOR_CNT", VN_INFO_CNT);
			} else {
				EVF.confirm('전체 적용하시겠습니까?', function() {
					var kcou = grid.getRowCount();
					for(var k=0;k < kcou;k++) {
						if( vendor_open_type == grid.getCellValue(k, "VENDOR_OPEN_TYPE") ) {
							grid.setCellValue(k, "VENDOR_NM" , vendorNm);
				            grid.setCellValue(k, "VENDOR_CD" , JSON.stringify(VN_INFO));
				            grid.setCellValue(k, "VENDOR_CNT", VN_INFO_CNT);
						}
					}
				}, function() {
		            grid.setCellValue(ROWIDX, "VENDOR_NM" , vendorNm);
		            grid.setCellValue(ROWIDX, "VENDOR_CD" , JSON.stringify(VN_INFO));
		            grid.setCellValue(ROWIDX, "VENDOR_CNT", VN_INFO_CNT);
				});
			}
        }
        
        // 텍스트 품목 추가
        var ROWIDX;
		function doAdd() {
			
			//20210824 계약체결고객사가 품목추가시 의뢰고객사 적용
			var var_PR_BUYER_CD = "";
			var var_PR_DEPT_CD = "";
			
			if ('${param.prNum}' !== '' && EVF.V("BUYER_CD") !== '${ses.companyCd}' && EVF.V("REQ_USER_DEPT_CD") !== '${ses.deptCd}') {
				var_PR_BUYER_CD = EVF.V("BUYER_CD");
				var_PR_DEPT_CD = EVF.V("REQ_USER_DEPT_CD");
			} else {
				var_PR_BUYER_CD = '${ses.companyCd}';
				var_PR_DEPT_CD = '${ses.deptCd}';
			}    

			
			var param = [{
				 'PR_BUYER_CD': var_PR_BUYER_CD
				,'PR_DEPT_CD' : var_PR_DEPT_CD
				,'EC_BUYER_CD': '${ses.companyCd}'
			}];
			grid.addRow(param);
			grid.setCellReadOnly(grid.getRowCount() - 1, 'ITEM_DESC', false);
		}
		
		// 화면 초기화
		function doReset() {
			location.href = baseUrl+'CPRI0010/view.so';
		}

		function doClose() {
			EVF.closeWindow();
		}
	</script>

	<e:window id="CPRI0010" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

        <e:inputHidden id="TRANSACTION_FLAG" name="TRANSACTION_FLAG" value="N"/>
   		<e:inputHidden id='BUYER_CD' name="BUYER_CD" value="${empty formData.BUYER_CD ? ses.companyCd : formData.BUYER_CD}" />
   		<e:inputHidden id='APP_DOC_NUM' name="APP_DOC_NUM" value="${empty param.appDocNum ? formData.APP_DOC_NUM : param.appDocNum}" />
    	<e:inputHidden id='APP_DOC_CNT' name="APP_DOC_CNT" value="${formData.APP_DOC_CNT}" />
    	<e:inputHidden id='SIGN_STATUS' name="SIGN_STATUS" value="${formData.SIGN_STATUS}" />
    	<e:inputHidden id='REQ_USER_DEPT_CD' name="REQ_USER_DEPT_CD" value="${formData.REQ_USER_DEPT_CD}" />
    	<e:inputHidden id="approvalFormData" name="approvalFormData"/>
    	<e:inputHidden id="approvalGridData" name="approvalGridData"/>
	    <e:inputHidden id="attachFileDatas" name="attachFileDatas" visible="false" />
		<e:inputHidden id="prList" name="prList" />

    	<e:buttonBar title="${CPRI0010_GENERAL_INFO}" align="right">
			<c:if test="${formData.IF_TYPE == 'ITA' || formData.IF_TYPE == 'ITB'}">
				<e:button id="itPotal" name="itPotal" label="${itPotal_N}" onClick="itPotal" disabled="${itPotal_D}" visible="${itPotal_V}"/>
			</c:if>
			<%-- 구매의뢰품목의 상태가 접수완료(2200) 이하의 경우에만 수정 가능 --%>
			<c:if test="${formData.PRDT_MAX_PROGRESS < 2200}">
				<e:button id='Save' name="Save" label='${Save_N }' disabled='${Save_D }' visible='${Save_V }' onClick='doSave' data='T' />
			</c:if>
			<%-- 삭제는 "작성중"인 경우에만 가능함 --%>
			<c:if test="${formData.SIGN_STATUS == 'T' || formData.SIGN_STATUS == 'C' || formData.SIGN_STATUS == 'R'}">
				<e:button id='ApprovalReq' name="ApprovalReq" label='${ApprovalReq_N }' disabled='${ApprovalReq_D }' visible='${ApprovalReq_V }' onClick='doSave' data='P' />
				<e:button id='Delete' name="Delete" label='${Delete_N }' disabled='${Delete_D }' visible='${Delete_V }' onClick='doDelete' />
			</c:if>
			<%-- 닫기는 "팝업"에서만 보이도록 함 --%>
			<c:if test="${param.popupFlag eq true}">
				<e:button id='Close' name="Close" label='${Close_N }' disabled='${Close_D }' visible='${Close_V }' onClick='doClose' />
			</c:if>
			<%-- 초기화는 구매의뢰등록 메뉴에서만 보이도록 --%>
			<c:if test="${not param.popupFlag eq true}">
				<e:button id="doClear" name="doClear" label="${doClear_N}" onClick="doReset" disabled="${doClear_D}" visible="${doClear_V}"/>
			</c:if>
	    </e:buttonBar>

    	<e:searchPanel id="form" labelWidth="135" labelAlign="${labelAlign}" columnCount="2" onEnter="doSearch" useTitleBar="false">
			<e:inputHidden id="PR_NM" name="PR_NM" />
			
			<c:if test="${ses.companyCd != 'C00007'}">
				<e:inputHidden id="PROJECT_CD" name="PROJECT_CD" value="${formData.PROJECT_CD}"/>
				<e:inputHidden id="PROJECT_SQ" name="PROJECT_SQ" value="${formData.PROJECT_SQ}"/>
				<e:row>
					<e:label for="PR_NUM" title="${form_PR_NUM_N}"/>
					<e:field colSpan="3">
						<e:inputText id="PR_NUM" name="PR_NUM" value="${empty formData.PR_NUM ? param.prNum : formData.PR_NUM}" label='${form_PR_NUM_N }' width='${form_PR_NUM_W }' maxLength='${form_PR_NUM_M }' required='${form_PR_NUM_R }' readOnly='${form_PR_NUM_RO }' disabled='${form_PR_NUM_D }' visible='${form_PR_NUM_V }' maskType="${form_PR_NUM_MT}" />
					</e:field>
				</e:row>
			</c:if>
			<c:if test="${ses.companyCd == 'C00007'}">
				<e:row>
					<e:label for="PR_NUM" title="${form_PR_NUM_N}"/>
					<e:field>
						<e:inputText id="PR_NUM" name="PR_NUM" value="${empty formData.PR_NUM ? param.prNum : formData.PR_NUM}" label='${form_PR_NUM_N }' width='${form_PR_NUM_W }' maxLength='${form_PR_NUM_M }' required='${form_PR_NUM_R }' readOnly='${form_PR_NUM_RO }' disabled='${form_PR_NUM_D }' visible='${form_PR_NUM_V }' maskType="${form_PR_NUM_MT}" />
					</e:field>
					<e:label for="PROJECT_CD" title="${form_PROJECT_CD_N}" />
					<e:field>
						<c:if test="${formData.IF_TYPE == null || formData.IF_TYPE == ''}">
							<e:inputText id="PROJECT_CD" name="PROJECT_CD" value="${formData.PROJECT_CD}" width="${form_PROJECT_CD_W}" maxLength="${form_PROJECT_CD_M}" disabled="${form_PROJECT_CD_D}" readOnly="${form_PROJECT_CD_RO}" required="${form_PROJECT_CD_R}" style="${imeMode}" maskType="${form_PROJECT_CD_MT}"/>
							<e:text>/</e:text>
							<e:inputNumber id="PROJECT_SQ" name="PROJECT_SQ" value="${formData.PROJECT_SQ}" width="${form_PROJECT_SQ_W}" maxValue="${form_PROJECT_SQ_M}" decimalPlace="${form_PROJECT_SQ_NF}" disabled="${form_PROJECT_SQ_D}" readOnly="${form_PROJECT_SQ_RO}" required="${form_PROJECT_SQ_R}" onNumberKr="${form_PROJECT_SQ_KR}" currencyText="${form_PROJECT_SQ_CT}"/>
						</c:if>
						<c:if test="${formData.IF_TYPE != null && formData.IF_TYPE != ''}">
							<e:inputText id="PROJECT_CD" name="PROJECT_CD" value="${formData.PROJECT_CD}" width="${form_PROJECT_CD_W}" maxLength="${form_PROJECT_CD_M}" disabled="${form_PROJECT_CD_D}" readOnly="true" required="${form_PROJECT_CD_R}" style="${imeMode}" maskType="${form_PROJECT_CD_MT}"/>
							<e:text>/</e:text>
							<e:inputNumber id="PROJECT_SQ" name="PROJECT_SQ" value="${formData.PROJECT_SQ}" width="${form_PROJECT_SQ_W}" maxValue="${form_PROJECT_SQ_M}" decimalPlace="${form_PROJECT_SQ_NF}" disabled="${form_PROJECT_SQ_D}" readOnly="true" required="${form_PROJECT_SQ_R}" onNumberKr="${form_PROJECT_SQ_KR}" currencyText="${form_PROJECT_SQ_CT}"/>
						</c:if>
					</e:field>
				</e:row>
			</c:if>

			<e:row>
				<e:label for="SUBJECT" title="${form_SUBJECT_N}"/>
				<e:field>
					<e:inputText id="SUBJECT" name="SUBJECT" value="${formData.SUBJECT}" label='${form_SUBJECT_N }' width="${form_SUBJECT_W }" maxLength='${form_SUBJECT_M }' required='${form_SUBJECT_R }' readOnly='${form_SUBJECT_RO }' disabled='${form_SUBJECT_D }' visible='${form_SUBJECT_V }' maskType="${form_SUBJECT_MT}" />
				</e:field>
				<e:label for="PR_TYPE" title="${form_PR_TYPE_N}"/>
				<e:field>
					<e:select id="PR_TYPE" name="PR_TYPE" value="${formData.PR_TYPE}" options="${prTypeOptions}" width="${form_PR_TYPE_W}" disabled="${form_PR_TYPE_D}" readOnly="${form_PR_TYPE_RO}" required="${form_PR_TYPE_R}" placeHolder="" maskType="${form_PR_TYPE_MT}" />
				</e:field>
			</e:row>

			<e:row>
				<e:label for="REQ_DATE" title="${form_REQ_DATE_N}"/>
				<e:field>
					<e:inputDate id="REQ_DATE" name="REQ_DATE" value="${formData.REQ_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_REQ_DATE_R}" disabled="${form_REQ_DATE_D}" readOnly="${form_REQ_DATE_RO}" />
				</e:field>
				<e:label for="REQ_USER_NM" title="${form_REQ_USER_NM_N}" />
				<e:field>
					<e:inputText id="REQ_USER_NM" name="REQ_USER_NM" value="${empty formData.REQ_USER_NM ? ses.userNm : formData.REQ_USER_NM}" width="${form_REQ_USER_NM_W}" maxLength="${form_REQ_USER_NM_M}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}" maskType="${form_REQ_USER_NM_MT}"/>
				</e:field>
			</e:row>

			<c:if test="${formData.IF_TYPE != null}">
				<e:row>
					<e:label for="PR_AMT" title="${form_PR_AMT_N}"/>
					<e:field>
						<e:inputNumber id="PR_AMT" name="PR_AMT" value="" maxValue="${form_PR_AMT_M}" decimalPlace="${form_PR_AMT_NF}" disabled="${form_PR_AMT_D}" readOnly="${form_PR_AMT_RO}" required="${form_PR_AMT_R}" width="${form_PR_AMT_W}" onNumberKr="${form_PR_AMT_KR}" currencyText="${form_PR_AMT_CT}" />
						<e:text>&nbsp;</e:text>
						<e:select id="CUR" name="CUR" value="${empty formData.CUR ? 'KRW' : formData.CUR}" options="${curOptions}" width="${form_CUR_W}" required='${form_CUR_R }' readOnly='${form_CUR_RO }' disabled='${form_CUR_D }' visible='${form_CUR_V }' placeHolder='${placeHolder }' maskType="${form_CUR_MT}" onChange="onCurChange" />
					</e:field>
					<e:label for="IF_TYPE" title="${form_IF_TYPE_N}"/>
					<e:field>
						<e:select id="IF_TYPE" name="IF_TYPE" value="${formData.IF_TYPE}" options="${ifTypeOptions}" width="${form_IF_TYPE_W}" disabled="${form_IF_TYPE_D}" readOnly="${form_IF_TYPE_RO}" required="${form_IF_TYPE_R}" placeHolder="" maskType="${form_IF_TYPE_MT}" />
					</e:field>
				</e:row>
			</c:if>
			<c:if test="${formData.IF_TYPE == null}">
				<e:row>
					<e:label for="PR_AMT" title="${form_PR_AMT_N}"/>
					<e:field colSpan="3">
						<e:inputNumber id="PR_AMT" name="PR_AMT" value="" maxValue="${form_PR_AMT_M}" decimalPlace="${form_PR_AMT_NF}" disabled="${form_PR_AMT_D}" readOnly="${form_PR_AMT_RO}" required="${form_PR_AMT_R}" width="140" onNumberKr="${form_PR_AMT_KR}" currencyText="${form_PR_AMT_CT}" />
						<e:text>&nbsp;</e:text>
						<e:select id="CUR" name="CUR" value="${empty formData.CUR ? 'KRW' : formData.CUR}" options="${curOptions}" width="${form_CUR_W}" required='${form_CUR_R }' readOnly='${form_CUR_RO }' disabled='${form_CUR_D }' visible='${form_CUR_V }' placeHolder='${placeHolder }' maskType="${form_CUR_MT}" onChange="onCurChange" />
				        <e:inputHidden id="IF_TYPE" name="IF_TYPE" value=""/>
					</e:field>
				</e:row>
			</c:if>
			
			<e:row>
				<e:label for="RMK" title="${form_RMK_TEXT_NUM_N}"/>
				<e:field colSpan="3">
					<e:richTextEditor id="RMK" name="RMK" value="${formData.RMK}" width='${form_RMK_TEXT_NUM_W }' height="180" disabled='${form_RMK_TEXT_NUM_D }' visible='${form_RMK_TEXT_NUM_V }' readOnly="${form_RMK_TEXT_NUM_RO}" required="${form_RMK_TEXT_NUM_R}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="" title="${form_ATT_FILE_NUM_N}"/>
				<e:field colSpan="3">
					<e:fileManager id="ATT_FILE_NUM" height="100" width="100%" fileId="${formData.ATT_FILE_NUM}" readOnly="${form_ATT_FILE_NUM_RO}" bizType="PR" required="${form_ATT_FILE_NUM_R}"/>
				</e:field>
			</e:row>
	    </e:searchPanel>

		<c:if test="${param.detailView != true}">
			<e:buttonBar title="${CPRI0010_ITEM_INFO}" align="right">
				<e:button id="doAdd" name="doAdd" label="${doAdd_N}" onClick="doAdd" disabled="${doAdd_D}" visible="${doAdd_V}"/>
				<c:if test="${formData.IF_TYPE != 'ITA' && formData.IF_TYPE != 'ITB'}">
					<e:button id="doSearchItem" name="doSearchItem" label="${doSearchItem_N}" onClick="doSearchItem" disabled="${doSearchItem_D}" visible="${doSearchItem_V}"/>
				</c:if>
				<c:if test="${formData.IF_TYPE == 'ITA' || formData.IF_TYPE == 'ITB'}">
					<e:button id="doItemCopy" name="doItemCopy" label="${doItemCopy_N}" onClick="doItemCopy" disabled="${doItemCopy_D}" visible="${doItemCopy_V}"/>
				</c:if>
			</e:buttonBar>
		</c:if>

		<e:gridPanel id="grid" name="grid" height="320px" gridType="${_gridType}" readOnly="${param.detailView}"/>

		<%-- 결재자 리스트 Include --%>
		<jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
			<jsp:param value="${formData.APP_DOC_NUM}" name="APP_DOC_NUM"/>
			<jsp:param value="${formData.APP_DOC_CNT}" name="APP_DOC_CNT"/>
			<jsp:param value="${formData.BUYER_CD}" name="BUYER_CD"/>
		</jsp:include>

	</e:window>
</e:ui>