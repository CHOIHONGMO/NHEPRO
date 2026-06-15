<%--
  Date: 2020-04-17
  Time: 13:15:36
  Scrren ID : CCTR0020
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>

<%
	String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd");
	String ksfcUrl = PropertiesManager.getString("eversrm.ksfc.url");
	String sgicUrl = PropertiesManager.getString("eversrm.sgic.url");
%>

<c:set var="ksfcUrl" value="<%=ksfcUrl%>" />
<c:set var="sgicUrl" value="<%=sgicUrl%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script>

		var grid;
		var baseUrl = "/nhepro/CCTR/CCTR0053";
		var userFlag = false;
		
		function init() {

			grid = EVF.C("grid");
			grid.setProperty("shrinkToFit", true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty("rowNumbers", ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty("sortable", ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty("panelVisible", ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty("enterToNextRow", ${enterToNextRow});  // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty("acceptZero", ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			grid.setProperty("singleSelect", ${singleSelect});	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

			grid._gvo.setFooter({
				'mergeCells' : ["PR_BUYER_DEPT_NM", "GUAR_TYPE", "GUAR_PERCENT", "GUAR_QT"]
			});

			// GUAR_APP_FLAG 여부에 따라 숨김 처리
			if ("${form.GUAR_APP_FLAG}" == "true") {
				//grid.hideCol("GUAR_APP", false);
				grid.setColReadOnly("GUAR_TYPE2", false);
				grid.setColReadOnly("GUARANTEER", false);
			} else {
				//grid.hideCol("GUAR_APP", true);
			}

			// Grid Excel Event
			grid.excelExportEvent({
				allItems: "${excelExport.allCol}",
				fileName: "${screenName }"
			});

			grid.cellClickEvent(function (rowIdx, celName, value) {
				var param;
				var guar_type2 = grid.getCellValue(rowIdx, "GUAR_TYPE2");
				var guaranteer = grid.getCellValue(rowIdx, "GUARANTEER");

				switch (celName) {
					case "ATT_FILE_CNT":
						if(value != 0) {
							param = {
								bizType: 'EC',
								attFileNum: grid.getCellValue(rowIdx, 'ATT_FILE_NUM'),
								detailView: true
							};
	
							everPopup.fileAttachPopup(param);
						}
						break;
					
					case "GUAR_NUM":
						if( value == "" ) return;
						
						if (guaranteer == "10") {
	                		var url = "${sgicUrl}";
	                		window.open(url);
	            		} else if (guaranteer == "20") {
	                		var url = "${ksfcUrl}";
	                		window.open(url);
	            		}
                    	break;
                    	
					case "GUAR_APP":

						// 증권 보증을 신청한다.
						if(guar_type2 == "20" && (guaranteer == "10" || guaranteer == "20")) {
							grid.checkRow(rowIdx, true);
							doGuarApp();
						} else {
							return EVF.alert("신청하실 수 없습니다.");
						}

						break;
				}

			});
			
			if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
				userFlag = true;
            }
			
			doSearch();
			setLinkStyle(); 
		}

		function setLinkStyle() {
			grid.setColFontColor("GUAR_NUM", "#FF0000");
        }
		
		function doGuarApp() {

			EVF.confirm("신청하시겠습니까?", function() {
				var store = new EVF.Store();

				store.setGrid([grid]);
				store.getGridData(grid, "sel");
				store.load(baseUrl + "/cctr0051_doSave.so", function () {
					return EVF.alert("${CCTR0053_0001}"); // 성공적으로 신청 되었습니다.
				});
			});
		}

		function doSearch() {
			var store = new EVF.Store();

			store.setGrid([grid]);
			store.load(baseUrl + "/cctr0053_doSearch.so", function () {
				
				var val = {"visible": true, "count": 1, "height": 32};
				grid.setProperty('footerVisible', val);

				var footer = {
					"styles": {
						"textAlignment": "cetner",
						"font": "굴림,12"
					},
					"text": ["합 계"]
				};

				var footer1 = {
					"styles": {
						"textAlignment": "far",
						"numberFormat": "#,##0",
						"foreground":"#FF0000",
						/*"background":"#ffffff",*/
						/*"suffix": " 원",*/
						"font": "Arial,12"
					},
					"text": "",
					"expression": ["sum"],
					"groupExpression": "sum"
				};

				grid.setRowFooter("PR_BUYER_DEPT_NM", footer);
				grid.setRowFooter("GUAR_AMT", footer1);
			});
		}
		
	</script>

	<e:window id="CCTR0053" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${form.BUYER_CD}"/>
		<e:inputHidden id="CONT_NUM" name="CONT_NUM" value="${form.CONT_NUM}"/>
		<e:inputHidden id="CONT_CNT" name="CONT_CNT" value="${form.CONT_CNT}"/>
		<e:inputHidden id="PR_BUYER_CD" name="PR_BUYER_CD" value="${form.PR_BUYER_CD}"/>
		<e:inputHidden id="PR_DEPT_CD" name="PR_DEPT_CD" value="${form.PR_DEPT_CD}"/>
		<e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="${form.VENDOR_CD}"/>
		<e:inputHidden id="PAY_CNT" name="PAY_CNT" value=""/>
		
		<e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="100%" height="fit"/>
	</e:window>
</e:ui>
