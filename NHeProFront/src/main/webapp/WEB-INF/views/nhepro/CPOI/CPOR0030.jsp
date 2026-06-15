<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/CPOI/";
        var havePermission = ("${havePermission}" == "true");
        
        function init() {
            grid = EVF.C("grid");
			
            grid.setProperty("shrinkToFit", ${shrinkToFit});
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			
         	// Grid Excel Event
			grid.excelExportEvent({
				allItems: "${excelExport.allCol}",
				fileName: "${sreenName }"
			});
            
            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                if(colIdx == "PO_NUM") {
                	if( value == "" ) return;
                    param = {
                        callbackFunction: "",
                        PO_NUM: value,
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CPOI0010", 1200, 750, param);
                }
                else if(colIdx == "ITEM_CD") {
                	if( value == "" ) return;
                    param = {
                        ITEM_CD: value,
                        STD_ITEM_CD: value,
                        popupFlag: true,
                        detailView: true,
                        manageFlag: "0"
                    };
                    everPopup.openPopupByScreenId("CITR0041", 1150, 663, param);
                }
                else if(colIdx == "VENDOR_CD") {
                	if( value == "" ) return;
                    param = {
                        VENDOR_CD: value,
                        detailView: true,
                        popupFlag: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
                }
                else if(colIdx == "CTRL_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "CTRL_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "CTRL_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
                else if(colIdx == "INSPECT_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "INSPECT_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "INSPECT_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
                else if(colIdx == "PR_NUM") {
                	if( value == "" ) return;
                    param = {
                        prNum: value,
                        buyerCd : grid.getCellValue(rowIdx, "PB_BUYER_CD"),
                        popupFlag: true,
                        detailView : true
                    };
                    everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
                }
                else if(colIdx == "CONT_NUM") {
                	if( value == "" ) return;
                    param = {
                        callbackFunction: "",
                        url: '/nhepro/CCTR/CCTA0030/view.so',
                        CONT_NUM: value,
                        CONT_CNT: grid.getCellValue(rowIdx, "CONT_CNT"),
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openContractChangeInformation(param);
                }
            });

            EVF.C("PROGRESS_CD").removeOption("5100");   // 발주대기
            EVF.C("SEL_DATE").removeOption("DUEQ");
            EVF.C("SEL_DATE").removeOption("INV");
            EVF.C("SEL_DATE").removeOption("REG");
            EVF.C("SEL_DATE").removeOption("DUEY");
            EVF.C("SEL_DATE").removeOption("REQI");
            EVF.C("SEL_DATE").removeOption("INVI");
            EVF.C("SEL_DATE").removeOption("AP");
            EVF.V("SEL_DATE", "PO");
            EVF.C("SEL_BUYER").removeOption("PY");
            EVF.V("SEL_BUYER", "PO");
		    
		    //2021.04.19 추가
            // 구매담당자, 계약담당자, 관리자직무인 경우 검수담당자 조회조건 변경이 가능함
            if( !havePermission ) {
            	EVF.C("CTRL_USER_ID").setValue("");
            	EVF.C("CTRL_USER_NM").setValue("");
            	EVF.C("INSPECT_USER_ID").setValue("${ses.userId}");
            	EVF.C("INSPECT_USER_NM").setValue("${ses.userNm}");
            	
            	EVF.C("INSPECT_USER_ID").setReadOnly(true);
            	EVF.C("INSPECT_USER_ID").setDisabled(true);
            	EVF.C("INSPECT_USER_NM").setReadOnly(true);
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
		    grid.setRowFooter("ITEM_AMT", distVal);
		    grid.setRowFooter("GR_QT", distVal);
		    grid.setRowFooter("GR_ITEM_AMT", distVal);
		    grid.setRowFooter("GR_UN_QT", distVal);
		    grid.setRowFooter("GR_UN_ITEM_AMT", distVal);
		    // ===========================================================
		    
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
					'callBackFunction': 'callBackCTRL_USER_ID',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR030',	// 구매담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackCTRL_USER_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("CTRL_USER_ID", data.USER_ID);
	            EVF.V("CTRL_USER_NM", data.USER_NM);
        	}
        }
        
        function onIconClickINSPECT_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackINSPECT_USER_ID',
					'READONLY': 'N',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR020',	//검수/입고 담당자권한(=기본권한으로 변경)
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackINSPECT_USER_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("INSPECT_USER_ID", data.USER_ID);
	            EVF.V("INSPECT_USER_NM", data.USER_NM);
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

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.setParameter("SEL_DATE", $("#SEL_DATE").val());
            store.setParameter("SEL_BUYER", $("#SEL_BUYER").val());
            store.load(baseUrl + "cpor0030_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

    </script>

    <e:window id="CPOR0030" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="SEL_DATE" title="">
                    <e:select id="SEL_DATE" name="SEL_DATE" value="" options="${selDateOptions}" width="${form_SEL_DATE_W}" disabled="${form_SEL_DATE_D}" readOnly="${form_SEL_DATE_RO}" required="${form_SEL_DATE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_SEL_DATE_MT}" />
                </e:label>
                <e:field>
                    <e:inputDate id="FROM_DATE" name="FROM_DATE" toDate="TO_DATE" value="${FROM_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_DATE_R}" disabled="${form_FROM_DATE_D}" readOnly="${form_FROM_DATE_RO}" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="TO_DATE" name="TO_DATE" fromDate="FROM_DATE" value="${TO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_TO_DATE_R}" disabled="${form_TO_DATE_D}" readOnly="${form_TO_DATE_RO}" />
                </e:field>
                <e:label for="PURCHASE_TYPE" title="${form_PURCHASE_TYPE_N}"/>
                <e:field>
                    <e:select id="PURCHASE_TYPE" name="PURCHASE_TYPE" value="" options="${purchaseTypeOptions}" width="${form_PURCHASE_TYPE_W}" disabled="${form_PURCHASE_TYPE_D}" readOnly="${form_PURCHASE_TYPE_RO}" required="${form_PURCHASE_TYPE_R}" placeHolder="선택" maskType="${form_PURCHASE_TYPE_MT}" />
                </e:field>
                <e:label for="PO_NUM" title="${form_PO_NUM_N}" />
                <e:field>
                    <e:inputText id="PO_NUM" name="PO_NUM" value="" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" style="${imeMode}" maskType="${form_PO_NUM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="VENDOR_NM" title="${form_VENDOR_NM_N}"/>
                <e:field>
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="${form_VENDOR_NM_W}" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}"/>
                </e:field>
                <e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
                <e:field>
                    <e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="선택" maskType="${form_PROGRESS_CD_MT}" />
                </e:field>
                <e:label for="CONT_NUM" title="${form_CONT_NUM_N}" />
                <e:field>
                    <e:inputText id="CONT_NUM" name="CONT_NUM" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="SEL_BUYER" title="">
                    <e:select id="SEL_BUYER" name="SEL_BUYER" value="" options="${selBuyerOptions}" width="${form_SEL_BUYER_W}" disabled="${form_SEL_BUYER_D}" readOnly="${form_SEL_BUYER_RO}" required="${form_SEL_BUYER_R}" placeHolder="" usePlaceHolder="false" maskType="${form_SEL_BUYER_MT}" />
                </e:label>
                <e:field>
                    <e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickBUYER_CD'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
                </e:field>
                <e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}"/>
                <e:field>
                    <e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="${ses.userId}" width="40%" maxLength="${form_CTRL_USER_ID_M}" onIconClick="${form_CTRL_USER_ID_RO ? 'everCommon.blank' : 'onIconClickCTRL_USER_ID'}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" maskType="${form_CTRL_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="${ses.userNm}" width="60%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}" placeHolder="성명"/>
                </e:field>
                <e:label for="INSPECT_USER_ID" title="${form_INSPECT_USER_ID_N}"/>
                <e:field>
                    <e:search id="INSPECT_USER_ID" name="INSPECT_USER_ID" value="${INSPECT_USER_ID}" width="40%" maxLength="${form_INSPECT_USER_ID_M}" onIconClick="${form_INSPECT_USER_ID_RO ? 'everCommon.blank' : 'onIconClickINSPECT_USER_ID'}" disabled="${form_INSPECT_USER_ID_D}" readOnly="${form_INSPECT_USER_ID_RO}" required="${form_INSPECT_USER_ID_R}" maskType="${form_INSPECT_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="INSPECT_USER_NM" name="INSPECT_USER_NM" value="${INSPECT_USER_NM}" width="60%" maxLength="${form_INSPECT_USER_NM_M}" disabled="${form_INSPECT_USER_NM_D}" readOnly="${form_INSPECT_USER_NM_RO}" required="${form_INSPECT_USER_NM_R}" style="${imeMode}" maskType="${form_INSPECT_USER_NM_MT}" placeHolder="성명"/>
                </e:field>
            </e:row>
            
            <e:row>
                <e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}" />
                <e:field>
                    <e:inputText id="ITEM_DESC" name="ITEM_DESC" value="" width="${form_ITEM_DESC_W}" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}" style="${imeMode}" maskType="${form_ITEM_DESC_MT}"/>
                </e:field>
                <e:label for="" title=""/>
				<e:field> </e:field>
                <e:label for="" title=""/>
				<e:field> </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
<%--            <e:button id="doClosing" name="doClosing" label="${doClosing_N}" onClick="doClosing" disabled="${doClosing_D}" visible="${doClosing_V}"/>--%>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
