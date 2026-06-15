<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/CPOR/";
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

                if(colIdx == "INV_NUM") {
                    param = {
                        callbackFunction: "",
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        INV_NUM: value,
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CPOR0051", 1200, 750, param);
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
                } else if(colIdx == "CONT_NUM") {
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
                }
            });
			
          	//2021.03.17 추가
            // 구매담당자, 계약담당자, 관리자직무인 경우 검수담당자 조회조건 변경이 가능함
            if( !havePermission ) {
            	EVF.C("INSPECT_USER_ID").setReadOnly(true);
            	EVF.C("INSPECT_USER_ID").setDisabled(true);
            	EVF.C("INSPECT_USER_NM").setReadOnly(true);
            }
          	
         	// 체결/의뢰고객사 조회조건
            EVF.C("SEL_BUYER").removeOption("PY");
            EVF.V("SEL_BUYER", "PO");
            
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
		    grid.setRowFooter("PAY_AMT", distVal);
		    grid.setRowFooter("INV_AMT", distVal);
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
                callBackFunction: "callBackCTRL_USER_ID"
            };
            everPopup.openCommonPopup(param, 'SP0040');
        }

        function callBackCTRL_USER_ID(data) {
            EVF.V("CTRL_USER_ID", data.CTRL_USER_ID);
            EVF.V("CTRL_USER_NM", data.CTRL_USER_NM);
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

        function onIconClickPIC_USER_NM() {
            var param = {
                callBackFunction: "callBackPIC_USER_NM"
            };
            everPopup.openCommonPopup(param, "SP0124");
        }

        function callBackPIC_USER_NM(data) {
            EVF.V("PIC_USER_ID", data.CTRL_USER_ID);
            EVF.V("PIC_USER_NM", data.CTRL_USER_NM);
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }

            store.setGrid([grid]);
            store.setParameter("SEL_BUYER", $("#SEL_BUYER").val());
            store.load(baseUrl + "cpor0060_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doUpdateCancel() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var selRowValue = grid.getSelRowValue();

            for(var i in selRowValue) {
                var rowData = selRowValue[i];

                if(rowData.PIC_USER_ID != "${ses.userId}") {
                    return EVF.alert("${CPOR0060_002}");
                }

                if(rowData.AP_NUM != "") {
                    return EVF.alert("${CPOR0060_015}");
                }
            }

            EVF.confirm("${CPOR0060_001}", function () {
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "cpor0060_doUpdateCancel.so", function() {
                    EVF.alert(this.getResponseMessage(), function () {
                        doSearch();
                    });
                });
            });
        }
    </script>

    <e:window id="CPOR0060" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="FROM_DATE" title="${form_FROM_DATE_N}"/>
                <e:field>
                    <e:inputDate id="FROM_DATE" name="FROM_DATE" toDate="TO_DATE" value="${FROM_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_DATE_R}" disabled="${form_FROM_DATE_D}" readOnly="${form_FROM_DATE_RO}" />
                    <e:inputDate id="TO_DATE" name="TO_DATE" fromDate="FROM_DATE" value="${TO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_TO_DATE_R}" disabled="${form_TO_DATE_D}" readOnly="${form_TO_DATE_RO}" />
                </e:field>
                <e:label for="INSPECT_USER_ID" title="${form_INSPECT_USER_ID_N}"/>
                <e:field>
                    <e:search id="INSPECT_USER_ID" name="INSPECT_USER_ID" value="${PIC_USER_ID}" width="40%" maxLength="${form_INSPECT_USER_ID_M}" onIconClick="${form_INSPECT_USER_ID_RO ? 'everCommon.blank' : 'onIconClickINSPECT_USER_ID'}" disabled="${form_INSPECT_USER_ID_D}" readOnly="${form_INSPECT_USER_ID_RO}" required="${form_INSPECT_USER_ID_R}" maskType="${form_INSPECT_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="INSPECT_USER_NM" name="INSPECT_USER_NM" value="${PIC_USER_NM}" width="60%" maxLength="${form_INSPECT_USER_NM_M}" disabled="${form_INSPECT_USER_NM_D}" readOnly="${form_INSPECT_USER_NM_RO}" required="${form_INSPECT_USER_NM_R}" style="${imeMode}" maskType="${form_INSPECT_USER_NM_MT}" placeHolder="성명"/>
                </e:field>
                <e:label for="PO_NUM" title="${form_PO_NUM_N}" />
                <e:field>
                    <e:inputText id="PO_NUM" name="PO_NUM" value="" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" style="${imeMode}" maskType="${form_PO_NUM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
            	<e:label for="CONT_NUM" title="${form_CONT_NUM_N}" />
                <e:field>
                    <e:inputText id="CONT_NUM" name="CONT_NUM" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
                </e:field>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
                <e:field>
                    <e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" onIconClick="${form_VENDOR_CD_RO ? 'everCommon.blank' : 'onIconClickVENDOR_CD'}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" maskType="${form_VENDOR_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}" placeHolder="회사명"/>
                </e:field>
                <e:label for="SEL_BUYER" title="">
                    <e:select id="SEL_BUYER" name="SEL_BUYER" value="" options="${selBuyerOptions}" width="${form_SEL_BUYER_W}" disabled="${form_SEL_BUYER_D}" readOnly="${form_SEL_BUYER_RO}" required="${form_SEL_BUYER_R}" placeHolder="" usePlaceHolder="false" maskType="${form_SEL_BUYER_MT}" />
                </e:label>
                <e:field>
                    <e:search id="BUYER_CD" name="BUYER_CD" value="" width="${form_BUYER_CD_W}%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickBUYER_CD'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="${form_BUYER_NM_W}%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doUpdateCancel" name="doUpdateCancel" label="${doUpdateCancel_N}" onClick="doUpdateCancel" disabled="${doUpdateCancel_D}" visible="${doUpdateCancel_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>