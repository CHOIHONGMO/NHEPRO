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
        var baseUrl = "/nhepro/CPOR/";
        var changeFlag = false;
        var havePermission = ("${havePermission}" == "true");
        
        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", ${shrinkToFit});
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;

                if(colIdx == "multiSelect") {
                    if(value == "1") {
                        grid.checkEqualRow(["INV_NUM"], [grid.getCellValue(rowIdx, "INV_NUM")]);
                    } else {
                        grid.checkNotEqualRow(["INV_NUM"], [grid.getCellValue(rowIdx, "INV_NUM")]);
                    }
                } else if(colIdx == "INV_NUM") {
                    param = {
                        callbackFunction: "",
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        INV_NUM: value,
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CPOR0071", 1200, 750, param);
                } else if(colIdx == "PO_NUM") {
                    param = {
                        callbackFunction: "",
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        PO_NUM: value,
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CPOI0010", 1200, 750, param);
                } else if(colIdx == "VENDOR_CD") {
                    param = {
                        VENDOR_CD: value,
                        detailView: true,
                        popupFlag: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
                } else if(colIdx == "ITEM_CD") {
                    param = {
                        ITEM_CD: value,
                        STD_ITEM_CD: value,
                        popupFlag: true,
                        detailView: true,
                        manageFlag: "0"
                    };
                    everPopup.openPopupByScreenId("CITR0041", 1150, 663, param);
                } else if(colIdx == "CTRL_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "CTRL_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "CTRL_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                } else if(colIdx == "INSPECT_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "INSPECT_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "INSPECT_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                } else if(colIdx == "PR_NUM") {
                	if( value == "" ) return;
                    param = {
                        prNum: value,
                        buyerCd : grid.getCellValue(rowIdx, "BUYER_CD"),
                        popupFlag: true,
                        detailView : true
                    };
                    everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
                } else if(colIdx == "CONT_NUM") {
                	if( value == "" ) return;
                    param = {
                        callbackFunction: "",
                        url: '/nhepro/CCTR/CCTA0030/view.so',
                        CONT_NUM: value,
                        CONT_CNT: grid.getCellValue(rowIdx, "CONT_CNT"),
                        BUYER_CD : grid.getCellValue(rowIdx, "BUYER_CD"),
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openContractChangeInformation(param);
                }
            });

            grid.cellChangeEvent(function (rowIdx, colIdx, iRow, iCol, value, oldValue) {
                if(colIdx == "GR_QT") {
                    var SUM_GR_QT =  grid.getCellValue(rowIdx, "SUM_GR_QT");
                    var INV_QT =  grid.getCellValue(rowIdx, "INV_QT");
                    var PO_QT =  grid.getCellValue(rowIdx, "PO_QT");

                    if(value > INV_QT || value + SUM_GR_QT > PO_QT) {
                        grid.setCellValue(rowIdx, colIdx, oldValue);
                        return EVF.alert("${CPOR0070_003}");
                    }

                    grid.setCellValue(rowIdx, "GR_ITEM_AMT", value * grid.getCellValue(rowIdx, "GR_UNIT_PRICE"));
                }
            });
			
         	// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
		    if("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
		    	changeFlag = true;
            }
            
		 	// 2021.02.08 : 관리자직무, 고객사_기본권한인 경우 검수담당자 변경 가능
           	if(changeFlag || "${ses.ctrlCd}".indexOf("BR020") > -1) {
                EVF.C("doUpdateChange").setDisabled(false);
            } else {
                EVF.C("doUpdateChange").setDisabled(true);
            }
			
          	//2021.03.17 추가
            // 구매담당자, 계약담당자, 관리자직무인 경우 검수담당자 조회조건 변경이 가능함
            if( !havePermission ) {
            	EVF.C("GR_USER_ID").setReadOnly(true);
            	EVF.C("GR_USER_ID").setDisabled(true);
            	EVF.C("GR_USER_NM").setReadOnly(true);
            }
            
         	// 검수담당자 변경
            EVF.C("PIC_USER_NM").setReadOnly(true);
          	
            EVF.C("SEL_DATE").removeOption("DUE");
            EVF.C("SEL_DATE").removeOption("REG");
            EVF.C("SEL_DATE").removeOption("DUEY");
            EVF.C("SEL_DATE").removeOption("REQI");
            EVF.C("SEL_DATE").removeOption("INVI");
            EVF.C("SEL_DATE").removeOption("AP");
            EVF.V("SEL_DATE", "INV");
            
         	// 체결/의뢰고객사 조회조건
            EVF.C("SEL_BUYER").removeOption("PY");
            EVF.V("SEL_BUYER", "PO");
            
            // 2021.01.29 진행상태 추가
            EVF.C("PROGRESS_CD").removeOption("100");
            EVF.C("PROGRESS_CD").removeOption("300");
            EVF.V("PROGRESS_CD", "200");
            
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
		    grid.setRowFooter("BUYER_DEPT_NM", footer);

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
		    grid.setRowFooter("PO_QT", distVal);
		    grid.setRowFooter("SUM_GR_QT", distVal);
		    grid.setRowFooter("INV_QT", distVal);
		    grid.setRowFooter("GR_QT", distVal);
		    grid.setRowFooter("GR_APP_QT", distVal);
		    grid.setRowFooter("GR_ITEM_AMT", distVal);
		    
		    // 2020.12.02 자동조회 추가
		    doSearch();
        }

        function onIconClickVENDOR_CD() {
            var param = {
                callBackFunction: "callBackVENDOR_CD",
                BUYER_CD: "${ses.companyCd}"
            };
            everPopup.openCommonPopup(param, "SP0123");
        }

        function callBackVENDOR_CD(data) {
            EVF.V("VENDOR_CD", data.VENDOR_CD);
            EVF.V("VENDOR_NM", data.VENDOR_NM);
        }

        function onIconClickCTRL_USER_ID() {
            var param = {
                callBackFunction: "callBackCTRL_USER_ID"
            };
            everPopup.openCommonPopup(param, 'SP0040');
        }

        function callBackCTRL_USER_ID(data) {
            EVF.V("CTRL_USER_ID", data.CTRL_USER_ID);
            EVF.V("CTRL_USER_NM", data.CTRL_USER_NM);
        }

        function onIconClickGR_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackGR_USER_ID',
					'READONLY': 'N',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR020',	//검수/입고 담당자권한(=기본권한으로 변경)
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackGR_USER_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("GR_USER_ID", data.USER_ID);
	            EVF.V("GR_USER_NM", data.USER_NM);
        	}
        }

        function onIconClickPIC_USER_NM() {
        	var param = {
					'callBackFunction': 'callBackPIC_USER_NM',
					'READONLY': 'N',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR020',	//검수/입고 담당자권한(=기본권한으로 변경)
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackPIC_USER_NM(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("PIC_USER_ID", data.USER_ID);
	            EVF.V("PIC_USER_NM", data.USER_NM);
        	}
        }

        function onIconClickBUYER_CD() {
            var param = {
                callBackFunction: "callBackBUYER_CD"
            };
            everPopup.openCommonPopup(param, "SP0066");
        }

        function callBackBUYER_CD(data) {
            EVF.V("BUYER_CD", data.CUST_CD);
            EVF.V("BUYER_NM", data.CUST_NM);
        }

        function doUpdateChange() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            if(EVF.V("PIC_USER_ID") == "") { return EVF.alert("${CPOR0070_001}"); }
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var selRowValue = grid.getSelRowValue();

            for(var i in selRowValue) {
                var rowData = selRowValue[i];

                if(rowData.GR_DATE != "") {
                    return EVF.alert("${CPOR0070_009}");
                }
				
             	// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
                if(!changeFlag) {
	                if(rowData.INSPECT_USER_ID != "${ses.userId}") {
	                    return EVF.alert("${CPOR0070_018}");
	                }
                }
            }

            EVF.confirm("${CPOR0070_005}", function () {
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "cpor0070_doUpdateChange.so", function() {
                    doSearch();
                    EVF.alert(this.getResponseMessage());
                });
            });
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }

            store.setGrid([grid]);
            store.setParameter("SEL_DATE", $("#SEL_DATE").val());
            store.setParameter("SEL_BUYER", $("#SEL_BUYER").val());
            store.load(baseUrl + "cpor0070_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                } else {
                    var allRowId = grid.getAllRowId();

                    for(var i in allRowId) {
                        var row = allRowId[i];

                        if(grid.getCellValue(row, "GR_APP_QT") > 0) {
                            grid.setCellValue(row, "GR_QT", grid.getCellValue(row, "GR_APP_QT"), false);
                        } else {
                            grid.setCellValue(row, "GR_QT", grid.getCellValue(row, "INV_QT"), false);
                        }

                        grid.setCellValue(row, "GR_ITEM_AMT", grid.getCellValue(row, "GR_QT") * grid.getCellValue(row, "GR_UNIT_PRICE"), false);
                    }
                }
            });
        }

        function doApprovalPop() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var selRowValue = grid.getSelRowValue();
            var gridSel = [];

            for(var i in selRowValue) {
                var rowData = selRowValue[i];

                for(var j in selRowValue) {
                    if(rowData.INV_NUM != selRowValue[j].INV_NUM) {
                        return EVF.alert("${CPOR0070_014}");
                    }
                }
				
                // 300(검수완료), 400(반려)
                if(rowData.PROGRESS_CD == "300" || rowData.PROGRESS_CD == "400" || rowData.SIGN_STATUS == "E" || rowData.SIGN_STATUS == "P") {
                    return EVF.alert("${CPOR0070_006}");
                }

                if(rowData.INSPECT_USER_ID != "${ses.userId}") {
                    return EVF.alert("${CPOR0070_002}");
                }

                if(rowData.EXEC_AUTH == '0') {
                    return  EVF.alert("${CPOR0070_015}")
                }

                gridSel.push({
                    BUYER_CD: rowData.BUYER_CD,
                    DEPT_CD: rowData.DEPT_CD,
                    INV_NUM: rowData.INV_NUM,
                    INV_SQ: rowData.INV_SQ,
                    GR_QT: rowData.GR_QT
                });
            }

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            var param = {
                callbackFunction: "",
                gridSel: JSON.stringify(gridSel),
                detailView: false,
                buttonView: true
            };
            everPopup.openPopupByScreenId("CPOR0071", 1200, 750, param);
        }

    </script>

    <e:window id="CPOR0070" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${longLabelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="SEL_DATE" title="">
                    <e:select id="SEL_DATE" name="SEL_DATE" value="" options="${selDateOptions}" width="${form_SEL_DATE_W}" disabled="${form_SEL_DATE_D}" readOnly="${form_SEL_DATE_RO}" required="${form_SEL_DATE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_SEL_DATE_MT}" />
                </e:label>
                <e:field>
                    <e:inputDate id="FROM_DATE" name="FROM_DATE" toDate="TO_DATE" value="${FROM_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_DATE_R}" disabled="${form_FROM_DATE_D}" readOnly="${form_FROM_DATE_RO}" />
                    <e:inputDate id="TO_DATE" name="TO_DATE" fromDate="FROM_DATE" value="${TO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_TO_DATE_R}" disabled="${form_TO_DATE_D}" readOnly="${form_TO_DATE_RO}" />
                </e:field>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
                <e:field>
                    <e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" onIconClick="${form_VENDOR_CD_RO ? 'everCommon.blank' : 'onIconClickVENDOR_CD'}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" maskType="${form_VENDOR_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}" placeHolder="회사명"/>
                </e:field>
                <e:label for="PURCHASE_TYPE" title="${form_PURCHASE_TYPE_N}"/>
                <e:field>
                    <e:select id="PURCHASE_TYPE" name="PURCHASE_TYPE" value="" options="${purchaseTypeOptions}" width="${form_PURCHASE_TYPE_W}" disabled="${form_PURCHASE_TYPE_D}" readOnly="${form_PURCHASE_TYPE_RO}" required="${form_PURCHASE_TYPE_R}" placeHolder="선택" maskType="${form_PURCHASE_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PO_NUM" title="${form_PO_NUM_N}" />
                <e:field>
                    <e:inputText id="PO_NUM" name="PO_NUM" value="" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" style="${imeMode}" maskType="${form_PO_NUM_MT}"/>
                </e:field>
                <e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}" />
                <e:field>
                    <e:inputText id="ITEM_DESC" name="ITEM_DESC" value="" width="${form_ITEM_DESC_W}" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}" style="${imeMode}" maskType="${form_ITEM_DESC_MT}"/>
                </e:field>
				<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
				<e:field>
					<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" />
				</e:field>
            </e:row>

            <e:row>
            	<e:label for="CONT_NUM" title="${form_CONT_NUM_N}" />
                <e:field>
                    <e:inputText id="CONT_NUM" name="CONT_NUM" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
                </e:field>
                <e:label for="SEL_BUYER" title="">
                    <e:select id="SEL_BUYER" name="SEL_BUYER" value="" options="${selBuyerOptions}" width="${form_SEL_BUYER_W}" disabled="${form_SEL_BUYER_D}" readOnly="${form_SEL_BUYER_RO}" required="${form_SEL_BUYER_R}" placeHolder="" usePlaceHolder="false" maskType="${form_SEL_BUYER_MT}" />
                </e:label>
                <e:field>
                    <e:search id="BUYER_CD" name="BUYER_CD" value="" width="${form_BUYER_CD_W}%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickBUYER_CD'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="${form_BUYER_NM_W}%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
                </e:field>
                <e:label for="GR_USER_ID" title="${form_GR_USER_ID_N}"/>
                <e:field>
                    <e:search id="GR_USER_ID" name="GR_USER_ID" value="${ses.userId}" width="40%" maxLength="${form_GR_USER_ID_M}" onIconClick="${form_GR_USER_ID_RO ? 'everCommon.blank' : 'onIconClickGR_USER_ID'}" disabled="${form_GR_USER_ID_D}" readOnly="${form_GR_USER_ID_RO}" required="${form_GR_USER_ID_R}" maskType="${form_GR_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="GR_USER_NM" name="GR_USER_NM" value="${ses.userNm}" width="60%" maxLength="${form_GR_USER_NM_M}" disabled="${form_GR_USER_NM_D}" readOnly="${form_GR_USER_NM_RO}" required="${form_GR_USER_NM_R}" style="${imeMode}" maskType="${form_GR_USER_NM_MT}" placeHolder="성명"/>
            	</e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="left">
        	<e:text style="color: blue;font-weight: bold;">■ ${form_PIC_USER_NM_N} : </e:text>
            <e:inputText id="PIC_USER_ID" name="PIC_USER_ID" value="" width="${form_PIC_USER_ID_W}" maxLength="${form_PIC_USER_ID_M}" disabled="${form_PIC_USER_ID_D}" readOnly="${form_PIC_USER_ID_RO}" required="${form_PIC_USER_ID_R}" style="${imeMode}" maskType="${form_PIC_USER_ID_MT}"/>
            <e:search id="PIC_USER_NM" name="PIC_USER_NM" value="" width="${form_PIC_USER_NM_W}" maxLength="${form_PIC_USER_NM_M}" onIconClick="${form_PIC_USER_NM_RO ? 'everCommon.blank' : 'onIconClickPIC_USER_NM'}" disabled="${form_PIC_USER_NM_D}" readOnly="${form_PIC_USER_NM_RO}" required="${form_PIC_USER_NM_R}" maskType="${form_PIC_USER_NM_MT}" />
            <e:text> </e:text>
            <e:button id="doUpdateChange" name="doUpdateChange" align="left" label="${doUpdateChange_N}" onClick="doUpdateChange" disabled="${doUpdateChange_D}" visible="${doUpdateChange_V}"/>

            <div style="float: right;">
                <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
                <e:button id="doApprovalPop" name="doApprovalPop" label="${doApprovalPop_N}" onClick="doApprovalPop" disabled="${doApprovalPop_D}" visible="${doApprovalPop_V}"/>
            </div>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
