<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/OVNR/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", ${shrinkToFit});
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;

                if(colIdx == "VENDOR_CD") {
                    param = {
                        VENDOR_CD: value,
                        detailView: true,
                        popupFlag: true
                    };
                    everPopup.openPopupByScreenId("OVNR0011", 1000, 730, param);
                }
                else if(colIdx == "BLOCK_REASON") {

                	if (grid.getCellValue(rowIdx, 'BLOCK_FLAG') == '1') {
	                	param = {
	                            title: "${OVNR0010_002}",
	                            message: grid.getCellValue(rowIdx, 'BLOCK_REASON'),
	                            detailView: true
	                    };
	                    everPopup.commonTextInput(param);
                	} 
                } 
                else {
                	return;
                }
            });
            
            EVF.V("BLOCK_FLAG", "0");
        }

        function onIconClickVENDOR_CD() {
            var param = {
                callBackFunction: "callBackVENDOR_CD"
            };
            everPopup.openCommonPopup(param, "SP0063");
        }

        function callBackVENDOR_CD(data) {
            EVF.V("VENDOR_CD", data.VENDOR_CD);
            EVF.V("VENDOR_NM", data.VENDOR_NM);
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

            var flag = false;

            if(EVF.V("REG_TYPE") == "" && EVF.V("VENDOR_CD") == "" && EVF.V("VENDOR_NM") == "" && EVF.V("REG_FROM_DATE") == "" && EVF.V("REG_TO_DATE") == "" &&
                EVF.V("CEO_USER_NM") == "" && EVF.V("IRS_NO") == "") {
                flag = true;
            }

            if(flag) {
                return EVF.alert("${OVNR0010_001}");
            }


            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.load(baseUrl + "ovnr0010_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
                grid.setColIconify("BLOCK_REASON", "BLOCK_REASON", "comment", false);
            });
        }
        
        function doBlock() {
        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
        	
        	var selRowValue = grid.getSelRowValue();
        	
        	var block_chk = false;
        	
        	for(var i in selRowValue) {
                var row = selRowValue[i];
                
	            if( row.BLOCK_FLAG == "1" ) {
	            	block_chk = true;
	            }
            }

            if(block_chk) {
                return EVF.alert("${OVNR0010_005}");
            }
            
        	var param = {
                    title: "${OVNR0010_002}",
                    message: EVF.V("BLOCK_REASON"),
                    callbackFunction: "callbackBlock",
                    rowIdx: ""
                };

                everPopup.commonTextInput(param);
        }
        
        function callbackBlock(data) {
        	if(data.message == "") {
                EVF.alert("${OVNR0010_003}");
            } else {
                EVF.V("BLOCK_REASON", data.message);

                EVF.confirm("${OVNR0010_004}", function () {
                    var store = new EVF.Store();
                    store.setGrid([grid]);
                    store.getGridData(grid, "sel");
                    store.load(baseUrl + "ovnr0010_doBlock.so", function() {
                        EVF.alert(this.getResponseMessage());
                        doSearch();
                    });
                });
            }
        }
        
        function doBlockRemove() {
        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
        	
        	var selRowValue = grid.getSelRowValue();
        	
        	var block_chk = false;
        	
        	for(var i in selRowValue) {
                var row = selRowValue[i];
				
	            if( row.BLOCK_FLAG != "1" ) {
	            	block_chk = true;
	            }
            }

            if(block_chk) {
                return EVF.alert("${OVNR0010_006}");
            }
            
            EVF.confirm("${OVNR0010_007}", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "ovnr0010_doBlockRemove.so", function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }
        
    </script>

    <e:window id="OVNR0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="BLOCK_REASON" name="BLOCK_REASON"/>
        
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="REG_TYPE" title="${form_REG_TYPE_N}"/>
                <e:field>
                    <e:select id="REG_TYPE" name="REG_TYPE" value="" options="${regTypeOptions}" width="${form_REG_TYPE_W}" disabled="${form_REG_TYPE_D}" readOnly="${form_REG_TYPE_RO}" required="${form_REG_TYPE_R}" placeHolder="" maskType="${form_REG_TYPE_MT}" />
                </e:field>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
                <e:field>
                    <e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" onIconClick="${form_VENDOR_CD_RO ? 'everCommon.blank' : 'onIconClickVENDOR_CD'}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" maskType="${form_VENDOR_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}" placeHolder="회사명"/>
                </e:field>
                <e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
                <e:field>
                    <e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickBUYER_CD'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="CEO_USER_NM" title="${form_CEO_USER_NM_N}" />
                <e:field>
                    <e:inputText id="CEO_USER_NM" name="CEO_USER_NM" value="" width="${form_CEO_USER_NM_W}" maxLength="${form_CEO_USER_NM_M}" disabled="${form_CEO_USER_NM_D}" readOnly="${form_CEO_USER_NM_RO}" required="${form_CEO_USER_NM_R}" style="${imeMode}" maskType="${form_CEO_USER_NM_MT}"/>
                </e:field>
                <e:label for="IRS_NO" title="${form_IRS_NO_N}" />
                <e:field>
                    <e:inputText id="IRS_NO" name="IRS_NO" value="" width="${form_IRS_NO_W}" maxLength="${form_IRS_NO_M}" disabled="${form_IRS_NO_D}" readOnly="${form_IRS_NO_RO}" required="${form_IRS_NO_R}" style="${imeMode}" maskType="${form_IRS_NO_MT}"/>
                </e:field>
                <e:label for="REG_FROM_DATE" title="${form_REG_FROM_DATE_N}"/>
                <e:field>
                    <e:inputDate id="REG_FROM_DATE" name="REG_FROM_DATE" toDate="REG_TO_DATE" value="" width="${inputDateWidth}" datePicker="true" required="${form_REG_FROM_DATE_R}" disabled="${form_REG_FROM_DATE_D}" readOnly="${form_REG_FROM_DATE_RO}" />
                    <e:text>&nbsp;~&nbsp;</e:text>
                    <e:inputDate id="REG_TO_DATE" name="REG_TO_DATE" fromDate="REG_FROM_DATE" value="" width="${inputDateWidth}" datePicker="true" required="${form_REG_TO_DATE_R}" disabled="${form_REG_TO_DATE_D}" readOnly="${form_REG_TO_DATE_RO}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="BLOCK_FLAG" title="${form_BLOCK_FLAG_N}"/>
                <e:field>
                    <e:select id="BLOCK_FLAG" name="BLOCK_FLAG" value="" options="${blockFlagOptions}" width="${form_BLOCK_FLAG_W}" disabled="${form_BLOCK_FLAG_D}" readOnly="${form_BLOCK_FLAG_RO}" required="${form_BLOCK_FLAG_R}" placeHolder="" maskType="${form_BLOCK_FLAG_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doBlock" name="doBlock" label="${doBlock_N}" onClick="doBlock" disabled="${doBlock_D}" visible="${doBlock_V}"/>
        	<e:button id="doBlockRemove" name="doBlockRemove" label="${doBlockRemove_N}" onClick="doBlockRemove" disabled="${doBlockRemove_D}" visible="${doBlockRemove_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
