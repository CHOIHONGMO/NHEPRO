<!--

화면ID : CCPR1010_B
화면명 : 계약현황
작성자 : 김하은
생성일 : 2022.11.18

-->
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>

<e:ui>
	<script type="text/javascript">

		var grid = {};
		var baseUrl = "/nhepro/CCPR/CCPR1010_B";
		var havePermission = ("${havePermission}" == "true");
		var selRow;
		var type = '${param.TYPE}'.substr(0, 1);
		
		function init() {
			
			grid = EVF.C("grid");
			
			grid.setProperty('panelVisible', ${panelVisible});
			
		    grid.hideCol('PDF_ATT_FILE_CNT', false);
		    grid.hideCol('PDF_ATT_FILE_NUM', false);
						
			grid.cellClickEvent(function (rowIdx, colId, value) {
				var isAuthUser = false;

				selRow = rowIdx;
				switch (colId) {
					case 'CONT_NUM':
						if(value != '') {
							var signStatus = grid.getCellValue(rowIdx, "SIGN_STATUS");
							var progressCd = grid.getCellValue(rowIdx, "PROGRESS_CD");
							var param = {
									callBackFunction: '',
									buyerCd: grid.getCellValue(rowIdx, "BUYER_CD"),
									CONT_NUM: grid.getCellValue(rowIdx, "CONT_NUM"),
					                bundleNum : grid.getCellValue(rowIdx, "BUNDLE_NUM"),
		                            contCnt: grid.getCellValue(rowIdx, "CONT_CNT"),
					                detailView: (signStatus=='P'||signStatus=='E'),
					            };
							console.log(grid.getCellValue(rowIdx, "CONT_NUM"));
							
							//2022.10.05 계약번호 클릭 추가
							/*=================================================*/
							// 임시저장
							
							if (Number(progressCd) == 4200 && (signStatus == "T" || signStatus == "C" || signStatus == "R")) {
								param["detailView"] = false;
							}
							
							
							param["BUNDLE_NUM"]  = grid.getCellValue(rowIdx, "BUNDLE_NUM");
								
							// 일괄계약의 단일계약번호 클릭시 단일계약여부=0
							param["singleFlag"] = "1";
							/*=================================================*/					   
							
							var cont_type = grid.getCellValue(rowIdx, "CONT_TYPE");
							console.log(cont_type);
							if(cont_type == 1){//도급
								everPopup.openPopupByScreenId('CCPI1000', 1450, 800, param);
							}
							else if(cont_type == 2){//파견
								everPopup.openPopupByScreenId('CCPI1100', 1450, 800, param);
							}
							else if(cont_type == 3){//단기간
								everPopup.openPopupByScreenId('CCPI1200', 1450, 800, param);
							}							
							else if(cont_type == 4){//일용직
								everPopup.openPopupByScreenId('CCPI1300', 1450, 800, param);
							}							
						}
						break;
						//2022.10.05 일괄계약번호 클릭 추가
						/*=================================================*/	
					case "BUNDLE_NUM":
						//if( value == "" || (prBuyerCd != "${ses.companyCd}") ) return;
						param = {
								callBackFunction : '',
								buyerCd: grid.getCellValue(rowIdx, "BUYER_CD"),
								BUNDLE_NUM : value,
								contNum: grid.getCellValue(rowIdx, "CONT_NUM"),
								contCnt: grid.getCellValue(rowIdx, "CONT_CNT"),
							/*	CONT_TYPE: grid.getCellValue(rowIdx, "CONT_TYPE"),*/
								singleFlag: "0"
							};
						
						
						
						if( (grid.getCellValue(rowIdx, "PROGRESS_CD") == "4200" ))
						{
							param["detailView"] = false;
						} 
						
						else if( (grid.getCellValue(rowIdx, "PROGRESS_CD") == "4300") || 
								 (grid.getCellValue(rowIdx, "PROGRESS_CD") == "4210")
							   )
						{
							param["detailView"] = false;
						} 
					
						
						var cont_type = grid.getCellValue(rowIdx, "CONT_TYPE");
						console.log(cont_type);
						if(cont_type == 1){//도급
							everPopup.openPopupByScreenId('CCPI1000', 1450, 800, param);
						}
						else if(cont_type == 2){//파견
							everPopup.openPopupByScreenId('CCPI1100', 1450, 800, param);
						}
						else if(cont_type == 3){//단기간
							everPopup.openPopupByScreenId('CCPI1200', 1450, 800, param);
						}							
						else if(cont_type == 4){//일용직
							everPopup.openPopupByScreenId('CCPI1300', 1450, 800, param);
						}	
						break;	
						/*=================================================*/

					 case 'PDF_ATT_FILE_CNT':
						if(value != '' && Number(value) > 0) {
							var pdfAttFileNum = grid.getCellValue(rowIdx, 'PDF_ATT_FILE_NUM');
							
							var url = "/common/file/fileAttach/viewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=" + pdfAttFileNum;
							window.open(url, "eform", "width=850,height=960,scrollbars=yes,resizeable=no,left=0,top=0");
							
						}
						else {
							return EVF.alert("${CCPR1010_013}");
						}
						break; 
					case 'STOP_RMK':
						if(value != '') {
							var param = {
								callbackFunction : '',
								rowId : rowIdx,
								title : '계약체결 중단사유',
								message : grid.getCellValue(rowIdx, 'STOP_RMK'),
								detailView : true
							};
							everPopup.commonTextInput(param);
						}
						break;
				}
			});
			
			//직무관리자인 경우 계약담당자 조회조건 변경이 가능함
            if( !havePermission ) {
            	EVF.C("CONT_USER_ID").setReadOnly(true);
            	EVF.C("CONT_USER_ID").setDisabled(true);
            	EVF.C("CONT_USER_NM").setReadOnly(true);
            }
			
			grid.excelExportEvent({
				allCol: "${excelExport.allCol}",
				fileName: "${screenName }"
			});

			setType();
			
			// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
		    if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
		    	changeFlag = true;
            }
			
			// 2020.12.02 자동조회 추가
			//doSearch();
		}

		function setType() {
			var proNm = "";
			var signNm = "";
			// PROGRESS_CD : 진행상태, SIGN_STATUS : 결재상태
 						 				
			$('input[name=multiselect_PROGRESS_CD]').each(function (k, v) {
				if(v.value == "4300") {
					proNm += v.title + ", ";
					v.checked = true;
				} else {
					$(v).parent().remove();
				}
			}); 
			$('#PROGRESS_CD').next().find('span, .e-select-text').text(proNm.substr(0, proNm.length - 2));
			EVF.C("PROGRESS_CD").setReadOnly(true);
		}
		
		// 계약체결현황 조회
		function doSearch() {
			var store = new EVF.Store();
			if (!store.validate()) return;
			
			store.setGrid([grid]);
			store.load(baseUrl + '/doSearch.so', function () {
				if (grid.getRowCount() == 0) {
					EVF.alert("${msg.M0002 }");
				} else {
		        	grid.setColIconify("STOP_RMK", "STOP_RMK", "comment", false);
		        }
				//grid.setColMerge(['BUYER_CD','CONT_NUM','CONT_CNT','CONT_DESC','BUYER_NM','CONT_USER_ID','CONT_USER_NM','DEPT_CD','DEPT_NM','SIGN_STATUS','SEND_DATE']);
			});
		}
		
 		// 계약체결중단
		function doStop() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }
			
            var selRowId = grid.getSelRowId();
            for(var i in selRowId) {
            	if (!${havePermission} && grid.getCellValue(selRowId[i], "CONT_USER_ID") != '${ses.userId}') {
                    return EVF.alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
                }
/*             	var progressCd = grid.getCellValue(selRowId[i], "PROGRESS_CD");
                if (grid.getCellValue(selRowId[i], "SIGN_STATUS") != 'E' || grid.getCellValue(selRowId[i], "PROGRESS_CD") != 100) {
                    return EVF.alert("${CCPR1010_003}"); // 계약진행중인건만 중단가능
                } */
            }
			
            var param = {
      				title : '계약체결 중단사유',
      				callbackFunction : 'setStopApproval',
      				detailView : false
      			};
    	    everPopup.commonTextInput(param);
		}
		
		function setStopApproval(data) {
        	var store = new EVF.Store();
        	
        	if( data != undefined && data != null ) {
        		EVF.V("CONT_CLOSE_RMK", data.message);
        	}
        	
        	EVF.confirm('${CCPR1010_004}', function () {
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl+'/doStop.so', function() {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
        }
		
		//고객사
		function onIconClickBUYER_CD() {
            var param = {
                'callBackFunction': 'callBackBUYER_CD',
                'READONLY': 'Y',		//팝업 조회조건 변경불가
				'multiYN' : 'N',        //멀티팝업여부
				'detailView': false
            };
            everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
        }

        function callBackBUYER_CD(data) {
            if(data!=null){
        		data = JSON.parse(data);
        		
        		EVF.V("BUYER_CD", data.CUST_CD);
        		EVF.V("BUYER_NM", data.CUST_NM);
        	}	
        }
        
        //계약담당자
		function getContUser() {

			var param = {
				'callBackFunction': 'setContUser',
				'READONLY': 'Y',		//팝업 조회조건 변경불가
				'multiYN' : 'N',        //멀티팝업여부
				//'CTRL_CD' : 'BR040',	//게약담당자권한
				'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		function setContUser(data) {
			if(data!=null){
        		data = JSON.parse(data);
        		
        		EVF.V("CONT_USER_ID", data.USER_ID);
        		EVF.V("CONT_USER_NM", data.USER_NM);
        	}
		}
		
		// 계약체결 고객사 부서 조회
		function getDept() {

			var param = {
			    BUYER_CD : "${ses.companyCd}",
				callBackFunction: "setDept"
			};
			everPopup.openCommonPopup(param, 'SP0119');
		}

		function setDept(data) {
			EVF.V("DEPT_CD", data.DEPT_CD);
			EVF.V("DEPT_NM", data.DEPT_NM);
		}
		
		//거래처팝업
		function getCust() {
			var param = {
					callBackFunction: 'setCust',
					READONLY: 'Y',         //팝업 조회조건 변경불가
					multiYN : 'N',         //멀티팝업여부
					detailView: false
				};
			everPopup.openCommonPopup(param, 'SP0168');
		}

		function setCust(cust) {
			EVF.V("CUST_CODE", cust.CUST_CODE);
			EVF.V("CUST_NAME", cust.CUST_NAME);
		}
		
		//현장
		function changeSubcustNm() {
			var param = {
	  				'callBackFunction': 'setSubcustNm',
	  				 CUST_CODE : EVF.C('CUST_CODE').getValue(),
					 CUST_NAME : EVF.C('CUST_NAME').getValue(),
	  				'detailView': false
		  		};
		  	everPopup.openPopupByScreenId("CCPR0010", 1000, 700, param);
		}
		
		function setSubcustNm(data) {
			if( data != null ) {
        		data = JSON.parse(data);
	          	EVF.V("SUBCUST_CODE", data.SUBCUST_CODE);
	          	EVF.V("SUBCUST_NAME", data.SUBCUST_NAME);
        	}
        }

	</script>

	<e:window id="CCPR1010_B" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999 }" columnCount="3" labelWidth="130" onEnter="doSearch" useTitleBar="false">
			<e:inputHidden id="CONT_CLOSE_RMK" name="CONT_CLOSE_RMK" /> <!-- 계약체결중단사유 -->
			<e:row>
				<%--계약일자--%>
				<e:label for="CONT_DATE_START" title="${form_CONT_DATE_START_N}"/>
				<e:field>
					<e:inputDate id="CONT_DATE_START" name="CONT_DATE_START" toDate="CONT_DATE_END" value="${fromDate }" width="${inputDateWidth}" datePicker="true" required="${form_CONT_DATE_START_R}" disabled="${form_CONT_DATE_START_D}" readOnly="${form_CONT_DATE_START_RO}" />
					<e:text>~</e:text>
					<e:inputDate id="CONT_DATE_END" name="CONT_DATE_END" fromDate="CONT_DATE_START" value="${toDate }" width="${inputDateWidth}" datePicker="true" required="${form_CONT_DATE_END_R}" disabled="${form_CONT_DATE_END_D}" readOnly="${form_CONT_DATE_END_RO}" />
				</e:field>
				<%--고객사--%>
				<e:label for="BUYER_NM" title="${form_BUYER_NM_N}"/>
                <e:field>
                    <e:search id="BUYER_CD" name="BUYER_CD" value="${ses.companyCd}" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickBUYER_CD'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="BUYER_NM" name="BUYER_NM" value="${ses.companyNm}" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
                </e:field>
                <%--계약부서--%>
				<e:label for="DEPT_CD" title="${form_DEPT_CD_N}"/>
				<e:field>
					<e:search id="DEPT_CD" name="DEPT_CD" value="" width="40%" maxLength="${form_DEPT_CD_M}" onIconClick="${form_DEPT_CD_RO ? 'everCommon.blank' : 'getDept'}" disabled="${form_DEPT_CD_D}" readOnly="${form_DEPT_CD_RO}" required="${form_DEPT_CD_R}" maskType="${form_DEPT_CD_MT}" placeHolder="부서코드" />
					<e:inputText id="DEPT_NM" name="DEPT_NM" value="" width="60%" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}" style="${imeMode}" maskType="${form_DEPT_NM_MT}" placeHolder="부서명"/>
				</e:field>
			</e:row>
			<e:row>
				 <%--계약담당자--%>
				<e:label for="CONT_USER_ID" title="${form_CONT_USER_ID_N}"/>
				<e:field>
					<e:search id="CONT_USER_ID" name="CONT_USER_ID" value="${ses.userId }" width="40%" maxLength="${form_CONT_USER_ID_M}" disabled="${form_CONT_USER_ID_D}" readOnly="${form_CONT_USER_ID_RO}" required="${form_CONT_USER_ID_R}" onIconClick="getContUser" placeHolder="개인번호" />
					<e:inputText id="CONT_USER_NM" name="CONT_USER_NM" value="${ses.userNm }" width="60%" maxLength="${form_CONT_USER_NM_M}" disabled="${form_CONT_USER_NM_D}" readOnly="${form_CONT_USER_NM_RO}" required="${form_CONT_USER_NM_R}" placeHolder="성명" />
				</e:field>
				<%--계약명--%>
				<e:label for="CONT_DESC" title="${form_CONT_DESC_N}" />
				<e:field>
					<e:inputText id="CONT_DESC" name="CONT_DESC" value="" width="${form_CONT_DESC_W}" maxLength="${form_CONT_DESC_M}" disabled="${form_CONT_DESC_D}" readOnly="${form_CONT_DESC_RO}" required="${form_CONT_DESC_R}"  maskType="${form_CONT_DESC_MT}" />
				</e:field>
				<%--진행상태--%>
				<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
				<e:field>
					<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" useMultipleSelect="true" maskType="${form_PROGRESS_CD_MT}"/>
				</e:field>			
			</e:row>
			<e:row>
				<%--근로자명--%>
				<e:label for="USER_NM" title="${form_USER_NM_N}"/>
				<e:field>
					<!--<e:search id="USER_ID" name="USER_ID" value="" width="40%" maxLength="${form_USER_ID_M}" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}" onIconClick="getUser" placeHolder="아이디" />-->
					<e:inputText id="USER_NM" name="USER_NM" value="" width="100%" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" placeHolder="근로자명" />
				</e:field>
				<%--거래처--%>
				<e:label for="CUST_CODE" title="${form_CUST_CODE_N}"/>
				<e:field>
					<e:search id="CUST_CODE" name="CUST_CODE" value="" width="40%" maxLength="${form_CUST_CODE_M}" disabled="${form_CUST_CODE_D}" readOnly="${form_CUST_CODE_RO}" required="${form_CUST_CODE_R}" onIconClick="getCust" placeHolder="거래처" />
					<e:inputText id="CUST_NAME" name="CUST_NAME" value="" width="60%" maxLength="${form_CUST_NAME_M}" disabled="${form_CUST_NAME_D}" readOnly="${form_CUST_NAME_RO}" required="${form_CUST_NAME_R}" placeHolder="거래처명" />
				</e:field>
				<%--현장--%>
				<e:label for="SUBCUST_CODE" title="${form_SUBCUST_CODE_N}"/>
				<e:field>
					<e:search id="SUBCUST_CODE" name="SUBCUST_CODE" value="" width="40%" maxLength="${form_SUBCUST_CODE_M}" onIconClick="changeSubcustNm" disabled="${form_SUBCUST_CODE_D}" readOnly="${form_SUBCUST_CODE_RO}" required="${form_SUBCUST_CODE_R}" placeHolder="현장" /> <!-- onIconClick="getSubCust"  -->
					<e:inputText id="SUBCUST_NAME" name="SUBCUST_NAME" value="" width="60%" maxLength="${form_SUBCUST_NAME_M}" disabled="${form_SUBCUST_NAME_D}" readOnly="${form_SUBCUST_NAME_RO}" required="${form_SUBCUST_NAME_R}" placeHolder="현장명" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doSearch" name="doSearch" label="${doSearch_N }" disabled="${doSearch_D }" onClick="doSearch" />
		</e:buttonBar>

		<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" />

	</e:window>
</e:ui>

