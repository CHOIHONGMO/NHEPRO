<%--
  Date: 2020-04-17
  Time: 13:15:36
  Scrren ID : CCTR0020
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script>

		var grid;
		var baseUrl = "/nhepro/CCTR/CCTR0020";

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
				fileName: "${screenName }"
			});

			grid.cellClickEvent(function (rowIdx, celName, value) {
				var param;
				switch (celName) {
					// 2021.05.12 추가
					// 동일한 이전계약번호, 이전계약차수는 한꺼번에 선택되도록 한다.
					case "multiSelect":
						if( grid.getCellValue(rowIdx, 'PRE_CONT_NUM') != '' ) {
							if(value == "1") {
		                        grid.checkEqualRow(["PRE_CONT_NUM", "PRE_CONT_CNT"], [grid.getCellValue(rowIdx, "PRE_CONT_NUM"), grid.getCellValue(rowIdx, "PRE_CONT_CNT")]);
		                    } else {
		                        grid.checkNotEqualRow(["PRE_CONT_NUM", "PRE_CONT_CNT"], [grid.getCellValue(rowIdx, "PRE_CONT_NUM"), grid.getCellValue(rowIdx, "PRE_CONT_CNT")]);
		                    }
						}
						break;
					case "EXEC_NUM":
						if( value == "" ) return;
						param = {
							'execNum': grid.getCellValue(rowIdx, 'EXEC_NUM'),
							'buyerCd': grid.getCellValue(rowIdx, 'BUYER_CD'),
							'tcoFlag': null,
							'popupFlag': true,
							'detailView': true
						};
						everPopup.openWindowPopup("/nhepro/CBDR/CBDI0061/view.so", 1400, 800, param, "createCN", true);
						break;
					case "PR_NUM":
						if( value == "" ) return;
						param = {
							prNum: grid.getCellValue(rowIdx, "PR_NUM"),
							buyerCd : grid.getCellValue(rowIdx, "PB_BUYER_CD"),
							popupFlag: true,
							detailView : true
						};
						everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
						break;
					case "PRE_CONT_NUM":
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
						break;
				}
			});

			grid.cellChangeEvent(function (rowIdx, colIdx, iRow, iCol, value, oldValue) {
			});
			
			grid.setColGroup([
				{
                    "groupName": '선정품의정보',
                    "columns": ['VENDOR_CD', 'VENDOR_NM', 'EXEC_AMT', 'CUR', 'VAT_TYPE', 'CONT_TYPE3', 'EXEC_DATE']
                }
				,{
                    "groupName": '인터페이스정보(IT포탈)',
                    "columns": ['PRE_CONT_NUM', 'PRE_CONT_CNT', 'CM_REQ_ID', 'IF_TYPE']
                }
            ],50);
			
			// 2020.12.02 자동조회 추가
			doSearch();
		}

		// Search
		function doSearch() {
			var store = new EVF.Store();

			// form validation Check
			if (!store.validate()) return;

			store.setGrid([grid]);
			store.load(baseUrl + "/doSearch.so", function () {
				if (grid.getRowCount() == 0) {
					return EVF.alert('${msg.M0002}');
				}
			});
		}

		// 수기계약이관
		function doMnuTransfer() {
			
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var exec_num_sq = "";	// 품의번호 + 품목항번
			var oriRowId = grid.getSelRowId()[0];
			var selRowId = grid.getSelRowId();
			for (var i in selRowId) {
				var rowIdx = selRowId[i];
				// 2021.05.12 추가
				// 계약구분이 변경(20)인 경우 "전자계약서"만 작성할 수 있음
				if( grid.getCellValue(rowIdx, "PR_TYPE") == "20" ) {
					return EVF.alert("계약구분이 [변경]인 건은 '수기계약서'를 작성할 수 없습니다.");
				}
				
				if( !(grid.getCellValue(oriRowId, "VENDOR_CD")  == grid.getCellValue(rowIdx, "VENDOR_CD")
				   && grid.getCellValue(oriRowId, "CUR")        == grid.getCellValue(rowIdx, "CUR")
				   && grid.getCellValue(oriRowId, "VAT_TYPE")   == grid.getCellValue(rowIdx, "VAT_TYPE")
				   && grid.getCellValue(oriRowId, "CONT_TYPE3") == grid.getCellValue(rowIdx, "CONT_TYPE3")
				   && grid.getCellValue(oriRowId, "IF_FLAG")    == grid.getCellValue(rowIdx, "IF_FLAG")) )
				{
						return EVF.alert("동일한 [협력업체, 통화, 부가세구분, 금액구분, I/F구분]인 경우에만 수기계약서 작성이 가능합니다.");
				}
				else {
					if( (Number(i) + 1) == selRowId.length ) {
						exec_num_sq += grid.getCellValue(rowIdx, "EXEC_NUM") + grid.getCellValue(rowIdx, "EXEC_SQ");
					} else {
						exec_num_sq += grid.getCellValue(rowIdx, "EXEC_NUM") + grid.getCellValue(rowIdx, "EXEC_SQ") + ",";
					}
				}
			}
			
			var store = new EVF.Store();
			EVF.confirm("${CCTR0020_001}", function () {
				store.setParameter('EXEC_NUM_SQ', exec_num_sq);
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + '/doTransferContract.so', function () {
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
			EVF.V("BUYER_CD", data.CUST_CD);
			EVF.V("BUYER_NM", data.CUST_NM);
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

		function getCtrlUser() {
			var param = {
					'callBackFunction': 'setCtrlUser',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : "BR030,BR040,BR050",	// 구매담당자,계약담당자,계약체결자 권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		function setCtrlUser(data) {
			if(data!=null){
				data = JSON.parse(data);
				EVF.V("CTRL_USER_ID", data.USER_ID);
				EVF.V("CTRL_USER_NM", data.USER_NM);
			}
		}

		function doApproval() {

			if (grid.getSelRowCount() == 0) {return EVF.alert("${msg.M0004}");}
			
			var oriRowId = grid.getSelRowId()[0];
			var selRowId = grid.getSelRowId();
			
			// 계약서 기본정보 셋팅
			var prType = grid.getCellValue(oriRowId, "PR_TYPE");
			var cur = grid.getCellValue(oriRowId, "CUR");
			var vat_type = grid.getCellValue(oriRowId, "VAT_TYPE");
			var amt_type = grid.getCellValue(oriRowId, "CONT_TYPE3");
			var vendor_cd = grid.getCellValue(oriRowId, "VENDOR_CD");
			var vendor_nm = grid.getCellValue(oriRowId, "VENDOR_NM");
			var vendor_pic_user_nm = grid.getCellValue(oriRowId, "VENDOR_PIC_USER_NM");
			var vendor_pic_user_cell_num = grid.getCellValue(oriRowId, "VENDOR_PIC_USER_CELL_NUM");
			var vendor_pic_user_email = grid.getCellValue(oriRowId, "VENDOR_PIC_USER_EMAIL");
			
			// 이전계약번호가 존재하는 경우 동일한 이전계약번호로 계약서를 작성할 수 있음
			var pre_buyer_cd = grid.getCellValue(oriRowId, "PRE_BUYER_CD");
			var pre_cont_num = grid.getCellValue(oriRowId, "PRE_CONT_NUM");
			var pre_cont_cnt = grid.getCellValue(oriRowId, "PRE_CONT_CNT");
			if( prType != "20" && prType != "30" ) {
				pre_buyer_cd = "";
				pre_cont_num = "";
				pre_cont_cnt = "";
			}
			
			var exec_num_sq = "";
			for (var i in selRowId) {
				var rowIdx = selRowId[i];
				// 이전 계약번호가 존재하는지 보고 존재 시 공백이 아닐 때 값이 다른지 체크
				if( pre_cont_num != "" && (pre_cont_num != grid.getCellValue(rowIdx, "PRE_CONT_NUM") || pre_cont_cnt != grid.getCellValue(rowIdx, "PRE_CONT_CNT")) ) {
					return EVF.alert("계약구분이 [변경]인 경우 동일한 '이전계약번호 및 차수'로 전자계약서 작성이 가능합니다.\n확인하여 주시기 바랍니다.");
				}
				
				if( !(grid.getCellValue(oriRowId, "VENDOR_CD")  == grid.getCellValue(rowIdx, "VENDOR_CD")
				   && grid.getCellValue(oriRowId, "CUR")        == grid.getCellValue(rowIdx, "CUR")
				   && grid.getCellValue(oriRowId, "VAT_TYPE")   == grid.getCellValue(rowIdx, "VAT_TYPE")
				   && grid.getCellValue(oriRowId, "CONT_TYPE3") == grid.getCellValue(rowIdx, "CONT_TYPE3")
				   && grid.getCellValue(oriRowId, "IF_FLAG")    == grid.getCellValue(rowIdx, "IF_FLAG")) )
				{
					return EVF.alert("동일한 [협력업체, 통화, 부가세구분, 금액구분, I/F구분]인 경우에만 전자계약서 작성이 가능합니다.");
				}
				else {
					if ((Number(i) + 1) == selRowId.length) {
						exec_num_sq += grid.getCellValue(rowIdx, "EXEC_NUM") + grid.getCellValue(rowIdx, "EXEC_SQ");
					} else {
						exec_num_sq += grid.getCellValue(rowIdx, "EXEC_NUM") + grid.getCellValue(rowIdx, "EXEC_SQ") + ",";
					}
				}
			}
			var prFlag = true;
			var autoExtend = '';
			var msg = "계약서 작성을 하시겠습니까?";
			if( pre_cont_num != "" && prType == "20" ) {
				msg = "선택한 건은 변경계약서 요청건입니다.\n\n변경계약서를 작성 하시겠습니까?";
				prFlag = false;
				autoExtend = '0';
			} else if(pre_cont_num != "" && prType == "30" ) {
				msg = "선택한 건은 연장계약서 요청건입니다.\n\n연장계약서를 작성 하시겠습니까?";
				prFlag = false;
				autoExtend = '1';
			}
			
			var store = new EVF.Store();
			// 구매의뢰(pr), 선정품의(stoccnhd)를 기준으로 계약서 작성 : copyFlag=true
			EVF.confirm(msg, function () {
				if(prFlag){
					var param = {
							url: "/nhepro/CCTR/CCTA0030/view.so",
							CUR: cur,
							VAT_TYPE: vat_type,
							AMT_TYPE: amt_type,
							VENDOR_CD: vendor_cd,
							VENDOR_NM: vendor_nm,
							//2023.02.03 계약담당자가 계약서 작성 시 "협력업체 담당자", "협력업체 담당자 이메일", "협력업체 담당자 전화번호"를 직접 입력 하도록 변경
							//2023.08.22 계약대기현황에서 전자계약서 작성 시 입찰참가 및 견적서 제출시 입력한 담당자 정보를 계약서에 자동 셋팅되도록 변경
							VENDOR_PIC_USER_NM: vendor_pic_user_nm,
							VENDOR_PIC_USER_CELL_NUM: vendor_pic_user_cell_num,
							VENDOR_PIC_USER_EMAIL: vendor_pic_user_email, 
							EXEC_NUM_SQ: exec_num_sq,
							PRE_BUYER_CD: pre_buyer_cd,
							PRE_CONT_NUM: pre_cont_num,
							PRE_CONT_CNT: pre_cont_cnt,
							CONT_REQ_CD: prType,
							copyFlag: "true",
							detailView: false,
							popupFlag : true
						};
					everPopup.openContractChangeInformation(param);
				} else {
					store.setGrid([grid]);
					store.getGridData(grid, "sel");
					store.load(baseUrl+'/cctr0020_doResume.so', function() {
						if( this.getResponseMessage() != null && this.getResponseMessage() == '1' ){
							EVF.alert("이미 진행중인 건이 있습니다. 다시 확인하세요.");
						} else {
							var param = {
									url: "/nhepro/CCTR/CCTA0030/view.so",
									CUR: cur,
									VAT_TYPE: vat_type,
									AMT_TYPE: amt_type,
									VENDOR_CD: vendor_cd,
									VENDOR_NM: vendor_nm,
									//2023.02.03 계약담당자가 계약서 작성 시 "협력업체 담당자", "협력업체 담당자 이메일", "협력업체 담당자 전화번호"를 직접 입력 하도록 변경
									//2023.08.22 계약대기현황에서 전자계약서 작성 시 입찰참가 및 견적서 제출시 입력한 담당자 정보를 계약서에 자동 셋팅되도록 변경
									VENDOR_PIC_USER_NM: vendor_pic_user_nm,
									VENDOR_PIC_USER_CELL_NUM: vendor_pic_user_cell_num,
									VENDOR_PIC_USER_EMAIL: vendor_pic_user_email, 
									EXEC_NUM_SQ: exec_num_sq,
									PRE_BUYER_CD: pre_buyer_cd,
									PRE_CONT_NUM: pre_cont_num,
									PRE_CONT_CNT: pre_cont_cnt,
									CONT_REQ_CD: prType,
									copyFlag: "true",
									autoExtend: autoExtend, 
									detailView: false,
									popupFlag : true
								};
							everPopup.openContractChangeInformation(param);
						}
					});
				}
			});
		}
	</script>

	<e:window id="CCTR0020" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999}" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="true" onEnter="doSearch">
			<e:row>
                <%-- 품의일자 --%>
                <e:label for="EXEC_FROM_DATE" title="${form_EXEC_FROM_DATE_N}"/>
                <e:field>
                    <e:inputDate id="EXEC_FROM_DATE" name="EXEC_FROM_DATE" value="${defaultFromDate}" width="${inputDateWidth}" datePicker="true" required="${form_EXEC_FROM_DATE_R}" disabled="${form_EXEC_FROM_DATE_D}" readOnly="${form_EXEC_FROM_DATE_RO}" />
                    <e:text>~</e:text>
                    <e:inputDate id="EXEC_TO_DATE" name="EXEC_TO_DATE" value="${defaultToDate}" width="${inputDateWidth}" datePicker="true" required="${form_EXEC_TO_DATE_R}" disabled="${form_EXEC_TO_DATE_D}" readOnly="${form_EXEC_TO_DATE_RO}" />
                </e:field>
                <%-- 협력업체 --%>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
                <e:field>
                    <e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" onIconClick="${form_VENDOR_CD_RO ? 'everCommon.blank' : 'getVendor'}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" maskType="${form_VENDOR_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}" placeHolder="회사명"/>
                </e:field>
                <%-- 고객사 --%>
                <e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
                <e:field>
                    <e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'getBuyer'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 품의번호 --%>
                <e:label for="EXEC_NUM" title="${form_EXEC_NUM_N}" />
                <e:field>
                  <e:inputText id="EXEC_NUM" name="EXEC_NUM" value="" width="${form_EXEC_NUM_W}" maxLength="${form_EXEC_NUM_M}" disabled="${form_EXEC_NUM_D}" readOnly="${form_EXEC_NUM_RO}" required="${form_EXEC_NUM_R}" style="${imeMode}" maskType="${form_EXEC_NUM_MT}"/>
                </e:field>
                <%-- 품의명 --%>
                <e:label for="EXEC_SUBJECT" title="${form_EXEC_SUBJECT_N}" />
                <e:field>
                  <e:inputText id="EXEC_SUBJECT" name="EXEC_SUBJECT" value="" width="${form_EXEC_SUBJECT_W}" maxLength="${form_EXEC_SUBJECT_M}" disabled="${form_EXEC_SUBJECT_D}" readOnly="${form_EXEC_SUBJECT_RO}" required="${form_EXEC_SUBJECT_R}" style="${imeMode}" maskType="${form_EXEC_SUBJECT_MT}"/>
                </e:field>
                <%-- 구매담당자 --%>
                <e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}"/>
                <e:field>
                  <e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="${ses.userId }" width="40%" maxLength="${form_CTRL_USER_ID_M}" onIconClick="${form_CTRL_USER_ID_RO ? 'everCommon.blank' : 'getCtrlUser'}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" maskType="${form_CTRL_USER_ID_MT}" placeHolder="개인번호" />
                  <e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="${ses.userNm }" width="60%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}" placeHolder="성명"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="PRE_CONT_NUM" title="${form_PRE_CONT_NUM_N}" />
				<e:field>
					<e:inputText id="PRE_CONT_NUM" name="PRE_CONT_NUM" value="" width="${form_PRE_CONT_NUM_W}" maxLength="${form_PRE_CONT_NUM_M}" disabled="${form_PRE_CONT_NUM_D}" readOnly="${form_PRE_CONT_NUM_RO}" required="${form_PRE_CONT_NUM_R}" style="${imeMode}" maskType="${form_PRE_CONT_NUM_MT}"/>
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
		<e:buttonBar width="100%" align="right">
			<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
			<e:button id="doApproval" name="doApproval" label="${doApproval_N}" onClick="doApproval" disabled="${doApproval_D}" visible="${doApproval_V}"/>
			<e:button id="doMnuApproval" name="doMnuApproval" label="${doMnuApproval_N}" onClick="doMnuTransfer" disabled="${doMnuApproval_D}" visible="${doMnuApproval_V}"/>
		</e:buttonBar>
		<e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="100%" height="fit"/>
	</e:window>
</e:ui>
