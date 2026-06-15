<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script>

		var baseUrl = "/eversrm/master/user/";
		var grid    = {};
		var auGrid  = {};
		var acGrid  = {};
		var cRow;
		var currentUserId = '';
		var tagObj = {};
		var selRow;

		function init() {

			grid   = EVF.C('sGrid');
			acGrid = EVF.C('acGrid');
			auGrid = EVF.C('auGrid');

			grid.cellClickEvent(function(rowIdx, colIdx) {
				if( colIdx == 'USER_ID_V') { onCellClickS("USER_ID", rowIdx); }
			});

			auGrid.cellClickEvent(function(rowIdx, colIdx) {
				if(selRow == undefined) selRow = rowIdx;

				if (colIdx == 'SELECTED') {
					if(selRow != rowIdx) {
						auGrid.setCellValue(selRow, "SELECTED", "0");
						auGrid.checkRow(selRow, false);
						selRow = rowIdx;
					}
				}
			});

			grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			acGrid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			auGrid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]

			acGrid.setProperty('shrinkToFit', ${shrinkToFit});
			acGrid.setProperty('rowNumbers', ${rowNumbers});
			acGrid.setProperty('sortable', ${sortable});
			acGrid.setProperty('panelVisible', ${panelVisible});
			acGrid.setProperty('enterToNextRow', ${enterToNextRow});
			acGrid.setProperty('acceptZero', ${acceptZero});
			acGrid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

			auGrid.setProperty('shrinkToFit', true);
			auGrid.setProperty('rowNumbers', ${rowNumbers});
			auGrid.setProperty('sortable', ${sortable});
			auGrid.setProperty('panelVisible', ${panelVisible});
			auGrid.setProperty('enterToNextRow', ${enterToNextRow});
			auGrid.setProperty('acceptZero', ${acceptZero});
			auGrid.setProperty('singleSelect', true);

			grid._gvo.setColumnProperty('USER_NM_DISPLAY', 'renderer', {type:"shape", showTooltip: true});
			grid._gvo.setColumnProperty('USER_NM_DISPLAY', 'dynamicStyles', [{
				criteria: "(value['LOGIN_STATUS'] = 'Y')",
				styles: {figureBackground: "#ff00aa00", figureName: 'ellipse', iconLocation: 'left', figureSize: "60%", paddingRight: 6}
			},
			{criteria: "(value['LOGIN_STATUS'] = 'N')",
				styles: {figureBackground: "#ffeeeeee", figureName: 'ellipse', iconLocation: 'left', figureSize: "60%", paddingRight: 6}
			}]);

			setCommonForm();
			searchProfile();
			UserTypeSearchChange();
		}

		function doSearch() {

			EVF.C('USER_TYPE_SEARCH').setRequired(true);

			var store = new EVF.Store();
			if(EVF.V("USER_TYPE_SEARCH") == ""){
				EVF.C('USER_TYPE_SEARCH').setFocus();
				return EVF.alert("${MTUA0010_0002}");
			}
			store.setParameter("userType", "${ses.userType}");
					
			store.setGrid([grid]);
			store.load(baseUrl + 'MTUA0010/doSearchUser.so', function() {
				if(grid.getRowCount() == 0){
					EVF.alert("${msg.M0002 }");
				} else {
					var gridData = grid.getAllRowValue();
					for (var x in gridData) {
						var rowData = gridData[x];

						if (rowData['USER_ID'] === currentUserId) {
							onCellClickS("USER_ID", x);
							return;
						}
					}
					onCellClickS("USER_ID", 0);
				}
				grid.resize();
			});
		}

		function clearForm() {
			EVF.C('USER_TYPE_SEARCH').setRequired(false);
			document.location.reload();
			setCommonForm();
			EVF.C('USER_TYPE').setReadOnly(false);
			EVF.V('INSERT_FLAG', "I");
		}

		function setCommonForm() {
			if ("${ses.userType}" == 'S') {
				EVF.V('USER_TYPE_SEARCH', "S");
				EVF.V('USER_TYPE_SEARCH', true);
				EVF.V('COMPANY_CD_SEARCH', "${ses.companyCd}");
				EVF.V('COMPANY_CD_SEARCH', true);
				EVF.V('COMPANY_NM_SEARCH', "${ses.companyNm}");
				EVF.V('COMPANY_NM_SEARCH', true);
				EVF.V('DEPT_NM_SEARCH', true);
				EVF.V('USER_TYPE', "S");
				EVF.V('USER_TYPE', true);
				EVF.V('COMPANY_CD', "${ses.companyCd}");
				EVF.V('COMPANY_CD', true);
				EVF.V('COMPANY_NM', "${ses.companyNm}");
				EVF.V('COMPANY_NM', true);
				EVF.V('PLANT_NM', true);
				EVF.V('DEPT_NM', true);
			}
			EVF.V('GATE_CD', "${ses.gateCd}");
		}

		function onCellClickS(strkey, nRow) {
			EVF.C('USER_TYPE_SEARCH').setRequired(false);
			EVF.V("CHANGE_PW", "");

			setRequired(false);

			if (strkey == "USER_ID") {
				// 2021.03.02 사용자정보 좌측 그리드 클릭 시 사용자 정보 form 기존 data를 보여주는 오류때문에 조회전에 form clear
				InfoClear();
				
				EVF.V('USER_ID', grid.getCellValue(nRow, strkey));
				EVF.V('GRID_USER_TYPE', grid.getCellValue(nRow, "USER_TYPE"));

				var store = new EVF.Store();
				store.setParameter("userType", "${ses.userType}");
				store.setParameter("gridData", encodeURIComponent(JSON.stringify(grid.getRowValue(nRow))) );
				store.load(baseUrl + 'MTUA0010/doGetUser.so', function() {
					var data = this.data.formData;
					for( var id in data ) {
						console.log("id ===> "+ id)
						if(id == 'PW_WRONG_CNT'
							|| id == 'MOD_USER_ID'
							|| id == 'MOD_USER_NM'
							|| id == 'PW_RESET_FLAG'
							|| id == 'LAST_LOGIN_TIME'
							|| id == 'PW_RESET_DATE'
							|| id == 'MOD_DATE_LAST'
							|| id == 'DEL_FLAG'
							|| id == 'IP_ADDR'
							|| id == 'LAST_LOGIN_DATE'
							//|| id == 'PASSWORD'
							//|| id == 'PASSWORD_CHECK'
						) { 
							continue; 
						}
						
						EVF.C(id).setValue(data[id]);
					}
					setCommonForm();
					if ("${ses.userType}" == 'S') {
						EVF.V('COMPANY_CD_SEARCH', "${ses.companyCd}");
						EVF.V('COMPANY_NM_SEARCH', "${ses.companyNm}");
						EVF.V('USER_TYPE_SEARCH', "S");
					}
					currentUserId = EVF.C("USER_ID").getValue();
					searchProfile();
					userTypeChange();
				});
			}
		}
		
		function InfoClear() {
            EVF.getComponent("formR").iterator(function() {
                EVF.getComponent(this.getID()).setValue('');
            });
        }

		function searchProfile() {
			var storeR = new EVF.Store();
			storeR.setParameter("userType", "${ses.userType}");
			storeR.setGrid([auGrid, acGrid]);
			storeR.load(baseUrl + 'MTUA0010/doGetProfile.so', function() {
				
				var auGridData = auGrid.getAllRowValue();
				var acGridData = acGrid.getAllRowValue();

				setRequired(true);
				for( var idx in auGridData ) {
					for( var col in auGridData[idx] ) {
						if( col == 'SELECTED' && auGridData[idx][col] == 1 ) {
							auGrid.checkRow( idx, true );
						}
					}
				}

				for( var idx2 in acGridData ) {
					for( var col2 in acGridData[idx2] ) {
						if( col2 == 'SELECTED' && acGridData[idx2][col2] == 1 ) {
							acGrid.checkRow(idx2, true );
						}
					}
				}
			});
		}
		
		function userTypeChange() {
			
			EVF.V("INSERT_FLAG", "U");
			EVF.C('USER_TYPE').setReadOnly(true);

			if(EVF.V("USER_TYPE") == "B"){
				EVF.C("deleteUser").setDisabled(false);
				EVF.C('USE_FLAG').setReadOnly(false);
			}else{
				EVF.C("deleteUser").setDisabled(true);
				EVF.C('USE_FLAG').setReadOnly(true);
			}
        }
		
		function replaceFormNull() {
			EVF.V('MOD_DATE', '');
		}

		function setRequired(valr) {
			var tagIds = [
				'USER_ID',
				'USER_TYPE',
				'USER_NM',
				//'USER_NM_ENG',
				'PASSWORD',
				'PASSWORD_CHECK',
				'COMPANY_CD',
				'COMPANY_NM',
				'USE_FLAG',
				'PROGRESS_CD'
			];

			for( var i in tagIds ) { EVF.C(tagIds[i]).setRequired(valr); }

			<%--
            if ("${ses.userType}" == 'S' || EVF.V('USER_TYPE') == 'S') {
                var tag2 = ['PLANT_CD', 'PLANT_NM', 'DEPT_CD', 'DEPT_NM'];
                for( var i in tag2 ) { EVF.C(tag2[i]).setRequired(false); }
            }
            --%>
		}

		<%--
		function plantCdSearch() {

            if ("${ses.userType}" == 'S') { return; }
            if (EVF.V("USER_TYPE") == "") {
                return EVF.alert("${form_USER_TYPE_N } - ${msg.M0004}.");
            }
            if (EVF.V("COMPANY_CD") == "") {
                return EVF.alert("${form_COMPANY_NM_N } - ${msg.M0004}.");
            }
            if ("${ses.userType}" != 'S' && EVF.V('USER_TYPE') != 'S') {
                var param = {
                    callBackFunction: "selectPlant",
                    BUYER_CD: EVF.V("COMPANY_CD")
                };
                everPopup.openCommonPopup(param, 'SP0005');
            } else {
                EVF.alert("${MTUA0010_0001}");
            }
        } --%>

		function companySearch_S() {

			if ("${ses.userType}" == 'S') { return; }

			if (EVF.V('USER_TYPE_SEARCH') == '') {
				EVF.C('USER_TYPE_SEARCH').setFocus();
				return EVF.alert("${MTUA0010_0002}");
			}

			var param;
			if (EVF.V('USER_TYPE_SEARCH') == 'C') {
				param = {
					callBackFunction: "selectCompany_S"
				};
				everPopup.openCommonPopup(param, 'SP0004');
			}
			else if(EVF.V('USER_TYPE_SEARCH') == 'S') {
				param = {
					callBackFunction: "selectCompany_V"
				};
				everPopup.openCommonPopup(param, 'SP0063');
			}
			else if(EVF.V('USER_TYPE_SEARCH') == 'B') {
				param = {
					callBackFunction: "selectCompany_B"
				};
				everPopup.openCommonPopup(param, 'SP0066');
			}
		}

		function selectCompany_V(dataJsonArray) {
			EVF.V('COMPANY_CD_SEARCH', dataJsonArray.VENDOR_CD);
			EVF.V('COMPANY_NM_SEARCH', dataJsonArray.VENDOR_NM);
		}

		function selectCompany_B(dataJsonArray) {
			EVF.V('COMPANY_CD_SEARCH', dataJsonArray.CUST_CD);
			EVF.V('COMPANY_NM_SEARCH', dataJsonArray.CUST_NM);
		}

		<%--
		function selectPlant(dataJsonArray) {
            EVF.V('PLANT_CD', dataJsonArray.PLANT_CD)
            EVF.V('PLANT_NM', dataJsonArray.PLANT_NM)
        }--%>

		function selectCompany_S(dataJsonArray) {
			EVF.V('COMPANY_CD_SEARCH', dataJsonArray.BUYER_CD);
			EVF.V('COMPANY_NM_SEARCH', dataJsonArray.BUYER_NM);
		}

		function companySearch_I() {

			if ("${ses.userType}" == 'S') { return; }

			if (EVF.V('USER_TYPE') == '') {
				return EVF.alert("${form_USER_TYPE_N } - ${msg.M0004}.");
			}

			var param;
			if (EVF.V('USER_TYPE') == 'S') {
				if ("${ses.userType}" == 'S') {
					EVF.alert("${MTUA0010_0003}");
				}
				else {
					param = {
						callBackFunction: "selectVendor_I"
					};
					everPopup.openCommonPopup(param, 'SP0063');
				}
			}
			else if (EVF.V('USER_TYPE') == 'B') {
				param = {
					callBackFunction : "selectCust_I"
				};
				everPopup.openCommonPopup(param, 'SP0066');
			}
			else {
				param = {
					callBackFunction: "selectCompany_I"
				};
				everPopup.openCommonPopup(param, 'SP0004');
			}
		}

		function selectCompany_I(dataJsonArray) {
			EVF.V('COMPANY_CD', dataJsonArray.BUYER_CD);
			EVF.V('COMPANY_NM', dataJsonArray.BUYER_NM);
		}

		function selectVendor_I(dataJsonArray) {
			EVF.V('COMPANY_CD', dataJsonArray.VENDOR_CD);
			EVF.V('COMPANY_NM', dataJsonArray.VENDOR_NM);
		}

		function selectCust_I(dataJsonArray) {
			EVF.V('COMPANY_CD', dataJsonArray.CUST_CD);
			EVF.V('COMPANY_NM', dataJsonArray.CUST_NM);
		}

		function getDeptCd() {

			if(EVF.V("COMPANY_CD_SEARCH") == ""){
				EVF.C("COMPANY_CD_SEARCH").setFocus();
				return EVF.alert("${MTUA0010_0005}");
			}

//			var popupUrl = "/evermp/SY01/SY0101/SY01_003/view.so";
			var popupUrl = "/eversrm/manager/org/MOGA0032/view.so";
			var param = {
				callBackFunction: "setDeptCd_s",
				'AllSelectYN': true,
				'detailView': false,
				'multiYN': false,
				'ModalPopup': true,
				'custCd' : EVF.V("COMPANY_CD_SEARCH"),
				'custNm' :  EVF.V("COMPANY_NM_SEARCH")
			};
			everPopup.openModalPopup(popupUrl, 500, 600, param, "SearchTeamPopup");
		}

		function setDeptCd_s(data) {
			data = JSON.parse(data);
			EVF.V('S_DEPT_CD', data.DEPT_CD);
			EVF.V('S_DEPT_NM', data.DEPT_NM);
		}

		function selectDept_S(dataJsonArray) {
			EVF.V('DEPT_NM_SEARCH', dataJsonArray.DEPT_NM);
		}

		function deptCdSearch_I() {

			if ("${ses.userType}" == 'S') { return; }

			if (EVF.V("USER_TYPE") == "") {
				return EVF.alert("${MTUA0010_0002}");
			}

			if (EVF.V("COMPANY_CD") == "") {
				EVF.C('COMPANY_CD').setFocus();
				return EVF.alert("${MTUA0010_0005}");
			}

			if (EVF.V('USER_TYPE') == 'S') {
				EVF.alert("${MTUA0010_0004}");
			}
			else {
//				var popupUrl = "/evermp/SY01/SY0101/SY01_003/view.so";
				var popupUrl = "/eversrm/manager/org/MOGA0032/view.so";
				var param = {
					callBackFunction: "selectDept_I",
					'AllSelectYN': false,
					'detailView': false,
					'multiYN': false,
					'ModalPopup': true,
					'custCd' : EVF.V("COMPANY_CD"),
					'custNm' :  EVF.V("COMPANY_NM")
				};
				everPopup.openModalPopup(popupUrl, 500, 600, param, "SearchTeamPopup");
			}
		}

		function selectDept_I(data) {
			var parse = JSON.parse(data);
			EVF.V('DEPT_CD', parse.DEPT_CD);
			EVF.V('DEPT_NM', parse.DEPT_NM);
		}

		function checkPass(type) {

			var pass = EVF.V('PASSWORD');
			var passCheck = EVF.V('PASSWORD_CHECK');

			if(pass != passCheck) {
				return EVF.alert("${msg.M0028}");
			}

			var store = new EVF.Store();
			if(!store.validate()) return;
			store.setAsync(false);
			store.load( baseUrl + "MTUA0010/checkPass.so", function(){
				if (this.getParameter("chkFlag") == "false") {
					EVF.V('PASSWORD_CHECK', this.getParameter("PASSWORD"));
					EVF.alert("${msg.M0028}");
					return -1;
				} else {
					EVF.V('PASSWORD', this.getParameter("PASSWORD"));
					EVF.V('PASSWORD_CHECK', this.getParameter("PASSWORD"));
					if(type === 'saveUser') {
						saveUserLogic();
					}
					return 0;
				}
			});
		}

		function resetLast() {

			var valueNew = EVF.V('USER_ID');
			var valueOld = EVF.V('USER_ID_ORI');

			if (valueNew != valueOld || valueOld == "") {
				return EVF.alert("${msg.M0007}");
			}

			EVF.confirm("${msg.M0029}", function() {
				var store = new EVF.Store();
				store.load(baseUrl + "MTUA0010/doResetLast.so", function() {
					EVF.alert(this.getResponseMessage());
				});
			});
		}

		function issuePass() {

			var valueNew = EVF.V('USER_ID');
			var valueOld = EVF.V('USER_ID_ORI');

			if (valueNew != valueOld || valueOld == "") {
				return EVF.alert('${msg.M0007}');
			}

			var param = {
				"GATE_CD": "${ses.gateCd }",
				"USER_ID": EVF.V('USER_ID'),
				"USER_TYPE": EVF.V('USER_TYPE'),
				"onClose": "doClosePopup"
			};

			// var popupUrl = baseUrl + 'passwordNumberIssue/view.so';
			var popupUrl = baseUrl + 'MTUA0012/view.so';
			everPopup.openWindowPopup(popupUrl, 700, 150, param, 'issuePass', false);
		}

		function InitPass() {

			var valueNew = EVF.V('USER_ID');
			var valueOld = EVF.V('USER_ID_ORI');

			if (valueNew != valueOld || valueOld == "") {
				return EVF.alert('${msg.M0007}');
			}

			EVF.confirm("${MTUA0010_0007}", function() {
				var store = new EVF.Store();
				if(EVF.V("USER_TYPE") == "O"){
					store.load(baseUrl + 'MTUA0010/doInitPassword.so', function() {
						EVF.alert(this.getResponseMessage(), function() {
							doSearch();
						});
					});
				}
				else if(EVF.V("USER_TYPE") == "T"){//2022.12.07 개인근로자 파트너스 추가 
					store.load(baseUrl + 'MTUA0010/doInitPassword_TVUR.so', function() {
						EVF.alert(this.getResponseMessage(), function() {
							doSearch();
						});
					});
				}else{
					store.load(baseUrl + 'MTUA0010/doInitPassword_CVUR.so', function() {
						EVF.alert(this.getResponseMessage(), function() {
							doSearch();
						});
					});
				}
			});
		}

		function doClosePopup() {
			doSearch();
		}

		function saveUser() {
			
			// 개인근로자 및 개인근로자_파트너스는 메뉴프로파일 없음
			if( EVF.V("USER_TYPE") != "P" || EVF.V("USER_TYPE") != "T" ) {
				if (auGrid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			}
			
			var userId = everString.lrTrim(EVF.V('USER_ID').toUpperCase());
			EVF.V('USER_ID', userId);
			setRequired(true);
			
			EVF.confirm("${msg.M0021}", function() {
				if(eval(checkPass('saveUser')) != 0) {}
			});
		}

		function saveUserLogic() {

			var store = new EVF.Store();
			if(!store.validate()) return;
			currentUserId = EVF.V('USER_ID');

			if(EVF.V("USER_TYPE") == "O"){
				var chkRowId = acGrid.getSelRowId();
				for( var rowId in chkRowId ) {
					acGrid.setCellValue(chkRowId[rowId], "USER_ID", currentUserId);
				}

				chkRowId = auGrid.getSelRowId();
				for( var rowIdx in chkRowId ) {
					auGrid.setCellValue(chkRowId[rowIdx], "USER_ID", currentUserId);
				}

				if (auGrid.getSelRowCount() == 0) {
					return EVF.alert("Menu Profile !! " + "${msg.M0004}");
				}

				store.setGrid([acGrid, auGrid]);
				store.getGridData(acGrid, 'sel');
				store.getGridData(auGrid, 'sel');
				store.setParameter("mode", "I");
				store.load( baseUrl + "MTUA0010/doSaveUserInfo.so", function() {
					if (this.getParameter("checkResult") == "confirm") {
						EVF.confirm("${msg.M0027}", function() {
							var store = new EVF.Store();
							store.setGrid([acGrid, auGrid]);
							store.getGridData(acGrid, 'sel');
							store.getGridData(auGrid, 'sel');
							store.setParameter("mode", "O");
							store.load( baseUrl + "MTUA0010/doSaveUserInfo.so", function() {
								EVF.alert(this.getResponseMessage(), function() {
									//2021.04.15 사용자 신규저장및 수정 후 사용자조회 조회조건 없이 사용자 조회 시 오래 걸리는 이유로 재조회 안함
									//doSearch();
								});
							});
						});
					} else {
						EVF.alert(this.getResponseMessage(), function() {
							//2021.04.15 사용자 신규저장및 수정 후 사용자조회 조회조건 없이 사용자 조회 시 오래 걸리는 이유로 재조회 안함
							//doSearch();
						});
					}
				});
			}
			else {
				chkRowId = auGrid.getSelRowId();
				for( var row in chkRowId ) {
					auGrid.setCellValue(chkRowId[row], "USER_ID", currentUserId);
				}
				store.setGrid([auGrid]);
				store.getGridData(auGrid, 'sel');
				store.setParameter("mode", "I");
				store.load( baseUrl + "MTUA0010/doSaveUserInfo_VNGL.so", function() {
					EVF.alert(this.getResponseMessage(), function() {
						//2021.04.15 사용자 신규저장및 수정 후 사용자조회 조회조건 없이 사용자 조회 시 오래 걸리는 이유로 재조회 안함
						//doSearch();
					});
				});
			}
		}

		function deleteUser() {

			var valueNew = EVF.V('USER_ID');
			var valueOld = EVF.V('USER_ID_ORI');

			if (valueNew != valueOld || valueOld == "") {
				return EVF.alert("${msg.M0007}");
			}

			if(grid.isEmpty(valueOld) || !/\S/.test(valueOld) ) {
				return EVF.alert("${msg.M0054 }");
			}

			EVF.confirm("${msg.M0013}", function() {
				var store = new EVF.Store();
				store.load(baseUrl + "MTUA0010/doDeleteUser.so", function() {
					EVF.alert(this.getResponseMessage(), function() {
						clearForm();
					});
				});
			});
		}

		$(document.body).ready(function() {

			$('#e-tabs').height( ($('.ui-layout-center').height()-30) ).tabs(
				{
					activate: function(event, ui) {
						$(window).trigger('resize');
					}
				}
			);
			$('#e-tabs').tabs('option', 'active', 0);
			getContentTab('1');
		});

		function getContentTab(uu) {

			if (uu == '1') {
				window.scrollbars = true;
			}
			if (uu == '2') {
				window.scrollbars = true;
			}
		}

		function UserTypeSearchChange(){

			EVF.V('COMPANY_CD_SEARCH', "");
			EVF.V('COMPANY_NM_SEARCH', "");
			EVF.V('S_DEPT_NM', "");
			EVF.V('S_DEPT_CD', "");

			if(EVF.V("USER_TYPE_SEARCH") == "S") {
				EVF.C('S_DEPT_CD').setDisabled(true);
				EVF.C('S_DEPT_NM').setDisabled(true);
			} else {
				EVF.C('S_DEPT_CD').setDisabled(false);
				EVF.C('S_DEPT_NM').setDisabled(false);
			}

			if(EVF.V("USER_TYPE_SEARCH") == "C") {
				EVF.V('COMPANY_CD_SEARCH', "${ses.companyCd}");
				EVF.V('COMPANY_NM_SEARCH', "${ses.companyNm}");
			}
		}

		// 2020.08.21 : 운영사 부서 필수 제외
		function _onChangeUserType(){
			//if(EVF.V("USER_TYPE") == "O"){
			//	EVF.C("DEPT_NM").setRequired(true);
			//} else {
			//	EVF.C("DEPT_NM").setRequired(false);
			//}
			searchProfile();
		}

		function ModCheckPW(){

			var checkType = this.getData().data;
			if(checkType == "1") {
				EVF.V("PASSWORD", "");
				EVF.V("CHANGE_PW", "Y");
			}
			if(checkType == "2") {
				EVF.V("PASSWORD_CHECK", "");
				EVF.V("CHANGE_PW", "Y");
			}
		}
		
		function pwValid() {
			EVF.V("PASSWORD", "");
			EVF.V("PASSWORD_CHECK", "");
			$('#PASSWORD').focus();
        }
		
		function CheckCall(){

			var str;
			if(this.data.data == "1"){
				str = EVF.V("PASSWORD");
			}else{
				str = EVF.V("PASSWORD_CHECK");
			}
			
			if(!CheckPassWord(str)){
            	pwValid();
            }
			
			if(!chkPwd(str)){
				EVF.V("PASSWORD", "");
				EVF.V("PASSWORD_CHECK", "");
				$('#PASSWORD').focus();
			}
		}
		
		//2021.03.17 비밀번호 입력시 '%' 특수문자 입력 불가하도록 체크
        function CheckPassWord(str){
        	var reg_pwd = new Array();
        	reg_pwd.push("%");
        	for(var i=0; i < reg_pwd.length; i++){
        		if(str.indexOf(reg_pwd[i])!= -1){
            		EVF.alert("비밀번호 입력 시 % 특수문자는 사용할 수 없습니다.");
            		return false;
        		}
        	}
        	
        	return true;
        }
		
		function chkPwd(str){

			if (str == '') return true;
			
			var SamePass_1 = 0;
			var SamePass_2 = 0;

			var reg_pwd = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
			var reg_pwd2 = /^.*(?=.{10,20})(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
			var reg_pwd3 = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[!@#$%^&+=]).*$/;
			var reg_pwd4 = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;

			if(reg_pwd.test(str) || reg_pwd2.test(str)|| reg_pwd3.test(str)|| reg_pwd4.test(str)){

			} else {
				EVF.alert("${MTUA0010_021}");
				return false;
			}

			if(str.length > 20){
				EVF.alert("${MTUA0010_021}");
				return false;
			}
			
			for(var i = 0; i < str.length; i++) {

				var chr_pass_0 = str.charAt(i);
				var chr_pass_1 = str.charAt(i+1);
				
				var SamePass_0 = 0;
				for(var j = i; j < str.length; j++) {
					if(chr_pass_0 == str.charAt(j)) {
						SamePass_0 = SamePass_0 + 1
					}
				}
				if(SamePass_0 > 2) {
					EVF.alert("${MTUA0010_022}");
					return false;
				}
				
				var chr_pass_2 = str.charAt(i+2);
				if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1) {
					SamePass_1 = SamePass_1 + 1
				}

				if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1) {
					SamePass_2 = SamePass_2 + 1
				}
			}
			
			if(SamePass_1 > 1 || SamePass_2 > 1) {
				EVF.alert("${MTUA0010_023}");
				return false;
			}
			return true;
		}

		function checkEmail(){
			if(!everString.isValidEmail(EVF.V("EMAIL"))) {
				EVF.alert("${msg.EMAIL_INVALID}");
				EVF.V("EMAIL", "");
			}
		}

		function checkTelNo() {

			var checkType = this.getData().data;
			if(checkType == "FAX_NUM") {
				if(!everString.isTel(EVF.V("FAX_NUM"))) {
					EVF.alert("${msg.FAX_NUM_INVALID}");
					EVF.V("FAX_NUM", "");
					EVF.C('FAX_NUM').setFocus();
				}
			}
			if(checkType == "TEL_NUM") {
				if(!everString.isTel(EVF.V("TEL_NUM"))) {
					EVF.alert("${msg.TEL_NUM_INVALID}");
					EVF.V("TEL_NUM", "");
					EVF.C('TEL_NUM').setFocus();
				}
			}
		}

		function checkCellNo() {
			var CellNum = EVF.V("CELL_NUM");
			var rgEx = /(01[016789])[-](\d{4}|\d{3})[-]\d{4}$/g;
			
			var chkFlg = rgEx.test(CellNum);
			if(!chkFlg){
				EVF.V("CELL_NUM", "");
				EVF.C('CELL_NUM').setFocus();
				return EVF.alert("${msg.CELL_NUM_INVALID}");
			}
		}

	</script>

	<e:window id="MTUA0010" onReady="init" initData="${initData}" width="100%" height="100%" name="${screenName}" title="${fullScreenName}">

		<e:panel id="pnl1" width="39%" height="100%">

			<e:buttonBar id="a" align="right" width="100%" title="${MTUA0010_TITLE1}">
				<e:button id="searchUser" name="searchUser" label="${searchUser_N }" onClick="doSearch" disabled="${searchUser_D }" visible="${searchUser_V }"  />
			</e:buttonBar>

			<e:searchPanel id="formL" title="${msg.M9999}" onEnter="doSearch" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="1">
				<e:row>
					<e:label for="USER_TYPE_SEARCH" title="${sForm_USER_TYPE_SEARCH_N}"/>
					<e:field>
						<e:select id="USER_TYPE_SEARCH" name="USER_TYPE_SEARCH" value="C" options="${userTypeSearchOptions}" width="100%" disabled="${sForm_USER_TYPE_SEARCH_D}" readOnly="${sForm_USER_TYPE_SEARCH_RO}" required="${sForm_USER_TYPE_SEARCH_R}" placeHolder=""  usePlaceHolder="false" onChange="UserTypeSearchChange"  maskType="${form_USER_TYPE_SEARCH_MT}"/>
						<e:inputHidden id="GRID_USER_TYPE" name="GRID_USER_TYPE" value=""/>
					</e:field>
				</e:row>
				<e:row>
					<e:label for="COMPANY_NM_SEARCH" title="${sForm_COMPANY_NM_SEARCH_N}"/>
					<e:field>
						<e:search id="COMPANY_CD_SEARCH" name="COMPANY_CD_SEARCH" value="${form.COMPANY_CD_SEARCH}" width="40%" maxLength="${form_COMPANY_CD_SEARCH_M}" onIconClick="${form_COMPANY_CD_SEARCH_D ? 'everCommon.blank' : 'companySearch_S'}" disabled="${form_COMPANY_CD_SEARCH_D}" readOnly="${form_COMPANY_CD_SEARCH_RO}" required="${form_COMPANY_CD_SEARCH_R}" maskType="${form_COMPANY_CD_SEARCH_MT}" placeHolder="회사코드" />
						<e:inputText id="COMPANY_NM_SEARCH" name="COMPANY_NM_SEARCH" value="" width="60%" maxLength="${form_COMPANY_NM_SEARCH_M}" disabled="${form_COMPANY_NM_SEARCH_D}" readOnly="${form_COMPANY_NM_SEARCH_RO}" required="${form_COMPANY_NM_SEARCH_R}" maskType="${form_COMPANY_NM_SEARCH_MT}" placeHolder="회사명" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="DEPT_NM_SEARCH" title="${sForm_DEPT_NM_SEARCH_N}"/>

					<e:field>
						<e:search id="S_DEPT_CD" name="S_DEPT_CD" value="" width="40%" maxLength="${sForm_S_DEPT_CD_M}" onIconClick="${sForm_S_DEPT_CD_D ? 'everCommon.blank' : 'getDeptCd'}" data ="S" disabled="${sForm_S_DEPT_CD_D}" readOnly="${sForm_S_DEPT_CD_RO}" required="${sForm_S_DEPT_CD_R}" maskType="${sForm_S_DEPT_CD_MT}" placeHolder="부서코드" />
						<e:inputText id="S_DEPT_NM" name="S_DEPT_NM" value="" width="60%" maxLength="${sForm_S_DEPT_NM_M}" disabled="${sForm_S_DEPT_NM_D}" readOnly="${sForm_S_DEPT_NM_RO}" required="${sForm_S_DEPT_NM_R}" maskType="${sForm_S_DEPT_NM_MT}" placeHolder="부서명" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="USER_ID_SEARCH" title="${sForm_USER_ID_SEARCH_N}"/>
					<e:field>
						<e:inputText id="USER_ID_SEARCH" name="USER_ID_SEARCH" value="${form.USER_ID_SEARCH}" width="100%" maxLength="${sForm_USER_ID_SEARCH_M}" disabled="${sForm_USER_ID_SEARCH_D}" readOnly="${sForm_USER_ID_SEARCH_RO}" required="${sForm_USER_ID_SEARCH_R}"  maskType="${sForm_USER_ID_SEARCH_MT}" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="USER_NM_SEARCH" title="${sForm_USER_NM_SEARCH_N}"/>
					<e:field>
						<e:inputText id="USER_NM_SEARCH" name="USER_NM_SEARCH" value="${form.USER_NM_SEARCH}" width="100%" maxLength="${sForm_USER_NM_SEARCH_M}" disabled="${sForm_USER_NM_SEARCH_D}" readOnly="${sForm_USER_NM_SEARCH_RO}" required="${sForm_USER_NM_SEARCH_R}"  maskType="${sForm_USER_NM_SEARCH_MT}" />
					</e:field>
				</e:row>
			</e:searchPanel>

			<e:gridPanel gridType="${_gridType}" id="sGrid" name="sGrid" width="100%" height="fit" readOnly="${param.detailView}"/>

		</e:panel>

		<e:panel id="blank_pn" width="1%">&nbsp;</e:panel>

		<e:panel id="pnl2" width="60%" 	height="100%">

			<e:buttonBar id="b" width="100%" align="right" title="${MTUA0010_TITLE2}">
				<e:button id="InitPass" name="InitPass" label="${InitPass_N }" onClick="InitPass"  visible="${InitPass_V }"  />
				<e:button id="resetLast" name="resetLast" label="${resetLast_N }" onClick="resetLast"  visible="${resetLast_V }"  />
				<e:button id="issuePass" name="issuePass" label="${issuePass_N }" onClick="issuePass" visible="${issuePass_V }"  />
				<e:button id="saveUser"  name="saveUser"  label="${saveUser_N }" onClick="saveUser" visible="${saveUser_V }"  />
				<e:button id="deleteUser" name="deleteUser" label="${deleteUser_N }" onClick="deleteUser" visible="${deleteUser_V }"  />
				<e:button id="clearForm"  name="clearForm"  label="${clearForm_N }"  onClick="clearForm" visible="${clearForm_V }"  />
			</e:buttonBar>

			<e:searchPanel id="formR" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2">
				<e:row>
					<e:label for="USER_TYPE" title="${form_USER_TYPE_N}"/>
					<e:field>
						<e:select id="USER_TYPE" name="USER_TYPE" value="${form.USER_TYPE}" options="${userTypeOptions}" width="100%" disabled="${form_USER_TYPE_D}" readOnly="${form_USER_TYPE_RO}" required="${form_USER_TYPE_R}" placeHolder=""  onChange="_onChangeUserType"  maskType="${form_USER_TYPE_MT}"/>
					</e:field>
					<e:label for="COMPANY_CD" title="${form_COMPANY_CD_N}"/>
					<e:field>
						<e:search id="COMPANY_CD" name="COMPANY_CD" value="" width="100%" maxLength="${form_COMPANY_CD_M}" onIconClick="companySearch_I" disabled="${form_COMPANY_CD_D}" readOnly="${form_COMPANY_CD_RO}" required="${form_COMPANY_CD_R}"  maskType="${form_COMPANY_CD_MT}" />
						<e:inputHidden id="GATE_CD" name="GATE_CD"/>
					</e:field>
				</e:row>
				<e:row>
					<e:label for="USER_ID" title="${form_USER_ID_N}"/>
					<e:field>
						<e:inputText id="USER_ID" name="USER_ID" value="${form.USER_ID}" width="100%" maxLength="${form_USER_ID_M}" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}"  maskType="${form_USER_ID_MT}" />
					</e:field>
					<e:inputHidden id="WORK_TYPE" name="WORK_TYPE" value="${form.WORK_TYPE}"/>

					<e:label for="COMPANY_NM" title="${form_COMPANY_NM_N}"/>
					<e:field>
						<e:inputText id="COMPANY_NM" name="COMPANY_NM" value="${form.COMPANY_NM}" width="100%" maxLength="${form_COMPANY_NM_M}" disabled="${form_COMPANY_NM_D}" readOnly="true" required="${form_COMPANY_NM_R}"  maskType="${form_COMPANY_NM_MT}" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="USER_NM" title="${form_USER_NM_N}"/>
					<e:field>
						<e:inputText id="USER_NM" name="USER_NM" value="${form.USER_NM}" width="100%" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}"  maskType="${form_USER_NM_MT}" />
					</e:field>
					<e:label for="USER_NM_ENG" title="${form_USER_NM_ENG_N}"/>
					<e:field>
						<e:inputText id="USER_NM_ENG" name="USER_NM_ENG" value="${form.USER_NM_ENG}" width="100%" maxLength="${form_USER_NM_ENG_M}" disabled="${form_USER_NM_ENG_D}" readOnly="${form_USER_NM_ENG_RO}" required="${form_USER_NM_ENG_R}"  maskType="${form_USER_NM_ENG_MT}" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="PASSWORD" title="${form_PASSWORD_N}"/>
					<e:field>
						<e:inputPassword id="PASSWORD" name="PASSWORD" value="${form.PASSWORD}"  width="100%" maxLength="${form_PASSWORD_M}" disabled="${form_PASSWORD_D}" readOnly="${form_PASSWORD_RO}" required="${form_PASSWORD_R}" onChange="CheckCall" data="1" onClick="ModCheckPW"/>
						<e:inputHidden id="CHANGE_PW" name="CHANGE_PW" value="" />
					</e:field>
					<e:label for="PASSWORD_CHECK" title="${form_PASSWORD_CHECK_N}"/>
					<e:field>
						<e:inputPassword id="PASSWORD_CHECK" name="PASSWORD_CHECK" value="${form.PASSWORD_CHECK}"  width="100%" maxLength="${form_PASSWORD_CHECK_M}" disabled="${form_PASSWORD_CHECK_D}" readOnly="${form_PASSWORD_CHECK_RO}" required="${form_PASSWORD_CHECK_R}" onChange="CheckCall" data="2" onClick="ModCheckPW"/>
					</e:field>
				</e:row>
				<e:row>
					<e:label for="EMPLOYEE_NUM" title="${form_EMPLOYEE_NUM_N}"/>
					<e:field>
						<e:inputText id="EMPLOYEE_NUM" name="EMPLOYEE_NUM" value="${form.EMPLOYEE_NUM}" width="100%" maxLength="${form_EMPLOYEE_NUM_M}" disabled="${form_EMPLOYEE_NUM_D}" readOnly="${form_EMPLOYEE_NUM_RO}" required="${form_EMPLOYEE_NUM_R}"  maskType="${form_EMPLOYEE_NUM_MT}" />
					</e:field>
					<e:label for="DEPT_NM" title="${form_DEPT_NM_N}"/>
					<e:field>
						<e:search id="DEPT_NM" name="DEPT_NM" value="" width="100%" maxLength="${form_DEPT_NM_M}" onIconClick="deptCdSearch_I" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}"  maskType="${form_DEPT_NM_MT}" />
						<e:inputHidden id="DEPT_CD" name="DEPT_CD"/>
					</e:field>
				</e:row>
				<e:row>
					<e:label for="POSITION_NM" title="${form_POSITION_NM_N}"/>
					<e:field>
						<e:inputText id="POSITION_NM" name="POSITION_NM" value="${form.POSITION_NM}" width="100%" maxLength="${form_POSITION_NM_M}" disabled="${form_POSITION_NM_D}" readOnly="${form_POSITION_NM_RO}" required="${form_POSITION_NM_R}"  maskType="${form_POSITION_NM_MT}" />
					</e:field>
					<e:label for="DUTY_NM" title="${form_DUTY_NM_N}"/>
					<e:field>
						<e:inputText id="DUTY_NM" name="DUTY_NM" value="${form.DUTY_NM}" width="100%" maxLength="${form_DUTY_NM_M}" disabled="${form_DUTY_NM_D}" readOnly="${form_DUTY_NM_RO}" required="${form_DUTY_NM_R}"  maskType="${form_DUTY_NM_MT}" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="EMAIL" title="${form_EMAIL_N}"/>
					<e:field colSpan="3">
						<e:inputText id="EMAIL" name="EMAIL" value="${form.EMAIL}" width="100%" maxLength="${form_EMAIL_M}" disabled="${form_EMAIL_D}" readOnly="${form_EMAIL_RO}" required="${form_EMAIL_R}" onChange="checkEmail" maskType="${form_EMAIL_MT}" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="TEL_NUM" title="${form_TEL_NUM_N}"/>
					<e:field>
						<e:inputText id="TEL_NUM" name="TEL_NUM" value="${form.TEL_NUM}" placeHolder="000-0000-0000" width="100%" maxLength="${form_TEL_NUM_M}" disabled="${form_TEL_NUM_D}" readOnly="${form_TEL_NUM_RO}" required="${form_TEL_NUM_R}" onChange="checkTelNo" data="TEL_NUM"  maskType="${form_TEL_NUM_MT}" />
					</e:field>
					<e:label for="CELL_NUM" title="${form_CELL_NUM_N}"/>
					<e:field>
						<e:inputText id="CELL_NUM" name="CELL_NUM" value="${form.CELL_NUM}"  placeHolder="000-0000-0000" width="100%" maxLength="${form_CELL_NUM_M}" disabled="${form_CELL_NUM_D}" readOnly="${form_CELL_NUM_RO}" required="${form_CELL_NUM_R}" onChange="checkCellNo" data="CELL_NUM"  maskType="${form_CELL_NUM_MT}" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="FAX_NUM" title="${form_FAX_NUM_N}"/>
					<e:field>
						<e:inputText id="FAX_NUM" name="FAX_NUM" value="${form.FAX_NUM}" placeHolder="000-0000-0000"  width="100%" maxLength="${form_FAX_NUM_M}" disabled="${form_FAX_NUM_D}" readOnly="${form_FAX_NUM_RO}" required="${form_FAX_NUM_R}" onChange="checkTelNo" data="FAX_NUM"  maskType="${form_FAX_NUM_MT}" />
					</e:field>
					<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
					<e:field>
						<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="${form.PROGRESS_CD}" options="${progressCdOptions}" width="100%" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder=""  maskType="${form_PROGRESS_CD_MT}"/>
					</e:field>

					<e:inputHidden id="COUNTRY_CD" name="COUNTRY_CD" value="${form.COUNTRY_CD}" />
				</e:row>
				<e:row>
					<e:label for="SUPER_USER_FLAG" title="${form_SUPER_USER_FLAG_N}"/>
					<e:field>
						<e:select id="SUPER_USER_FLAG" name="SUPER_USER_FLAG" value="${form.SUPER_USER_FLAG}" options="${superUserFlagOptions}" width="100%" disabled="${form_SUPER_USER_FLAG_D}" readOnly="${form_SUPER_USER_FLAG_RO}" required="${form_SUPER_USER_FLAG_R}" placeHolder=""  maskType="${form_SUPER_USER_FLAG_MT}"/>
					</e:field>
					<e:label for="USE_FLAG" title="${form_USE_FLAG_N}"/>
					<e:field>
						<e:select id="USE_FLAG" name="USE_FLAG" value="" options="${useFlagOptions}" width="${form_USE_FLAG_W}" disabled="${form_USE_FLAG_D}" readOnly="${form_USE_FLAG_RO}" required="${form_USE_FLAG_R}" placeHolder=""  maskType="${form_USE_FLAG_MT}"/>

					</e:field>
				</e:row>
				<e:inputHidden id="USER_DATE_FORMAT_CD" name="USER_DATE_FORMAT_CD" value="${form.USER_DATE_FORMAT_CD}" />
				<e:inputHidden id="USER_NUMBER_FORMAT_CD" name="USER_NUMBER_FORMAT_CD" value="${form.USER_NUMBER_FORMAT_CD}" />
				<e:row>
					<e:label for="MOD_DATE" title="${form_MOD_DATE_N}"/>
					<e:field>
						<e:inputDate id="MOD_DATE" name="MOD_DATE" value="${MOD_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_MOD_DATE_R}" disabled="${form_MOD_DATE_D}" readOnly="${form_MOD_DATE_RO}" />
					</e:field>
					<e:label for="CHANGE_USER_ID" title="${form_CHANGE_USER_ID_N}"/>
					<e:field>
						<e:inputText id="CHANGE_USER_ID" name="CHANGE_USER_ID" value="${form.CHANGE_USER_ID}" width="100%" maxLength="${form_CHANGE_USER_ID_M}" disabled="${form_CHANGE_USER_ID_D}" readOnly="${form_CHANGE_USER_ID_RO}" required="${form_CHANGE_USER_ID_R}"  maskType="${form_CHANGE_USER_ID_MT}" />
						<e:inputHidden id="USER_ID_ORI" name="USER_ID_ORI"/>
						<e:inputHidden id="INSERT_FLAG" name="INSERT_FLAG" value="I"/>
						<e:inputHidden id="TMP_WORD" name="TMP_WORD"/>
						<e:inputHidden id="TMP_WORD_CHK" name="TMP_WORD_CHK"/>
					</e:field>
				</e:row>
			</e:searchPanel>

			<e:title title="${form_CAPTION_MENU_N }" />
			<e:gridPanel gridType="${_gridType}" id="auGrid" name="auGrid" width="100%" height="100%" readOnly="${param.detailView}"/>

			<div style="height: 0; width: 0; display: none;">
				<e:gridPanel gridType="${_gridType}" id="acGrid" name="acGrid" width="0" height="0" readOnly="${param.detailView}"/>
			</div>

		</e:panel>
	</e:window>
</e:ui>