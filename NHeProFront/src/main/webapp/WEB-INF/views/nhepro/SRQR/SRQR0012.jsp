<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl  = "/nhepro/SRQR/";
        var RFX_TYPE = "${formData.RFX_TYPE}";

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
                
                if('${ses.userType}' == 'B') {	// 고객사에서 견적서 대행시
		        	if(colIdx == "ITEM_CD") {
		        		var param = {
				           		itemCd : grid.getCellValue(rowIdx, "ITEM_CD")
				            };
			            everPopup.openItemDetailInformation(param);
					}
	        	}
                if(colIdx == "ATT_FILE_NUM_CNT") {
                	if( value > 0 ) {
	                    var param = {
		                        attFileNum: grid.getCellValue(rowIdx, "ATT_FILE_NUM"),
		                        rowIdx: rowIdx,
		                        callBackFunction: "callbackATT_FILE_NUM_CNT",
		                        bizType: "PR",
		                        detailView: true
		                    };
	                    everPopup.fileAttachPopup(param);
                	}
                }
                else if(colIdx == "ITEM_RMK") {
                	if(value != "") {
                		var param = {
	    						title : '비고',
	    						message: value,
	    						detailView : true
	    					};
    					everPopup.commonTextInput(param);
    				}
                }
            });
            
			doSearchRQDT();
        }

        function doSearchRQDT() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "srqr0012_doSearchRQDT.so", function() {
            	if (grid.getRowCount() == 0) {
                    EVF.alert("${msg.M0002 }");
                } else {
                	grid.setColIconify("ITEM_RMK", "ITEM_RMK", "comment", false);
                }
            });
        }

        function doClose() {
            EVF.closeWindow();
        }
        
    </script>

    <e:window id="SRQR0012" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id='BUYER_CD' name="BUYER_CD" value="${formData.BUYER_CD}" />
        <e:inputHidden id="SETTLE_TYPE" name="SETTLE_TYPE" value="${formData.SETTLE_TYPE }" />
        <e:inputHidden id='SIGN_STATUS' name="SIGN_STATUS" value="${formData.SIGN_STATUS}" />
        <e:inputHidden id="RMK_TEXT_NUM" name="RMK_TEXT_NUM" value="${formData.RMK_TEXT_NUM }" />

        <e:buttonBar width="100%" align="right">
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2" onEnter="doSearch">
            <e:row>
                <e:label for="RFX_NUM" title="${form_RFX_NUM_N}" />
                <e:field>
                    <e:inputText id="RFX_NUM" name="RFX_NUM" value="${formData.RFX_NUM}" width="${form_RFX_NUM_W}" maxLength="${form_RFX_NUM_M}" disabled="${form_RFX_NUM_D}" readOnly="${form_RFX_NUM_RO}" required="${form_RFX_NUM_R}" style="${imeMode}" maskType="${form_RFX_NUM_MT}"/>
                    <e:text>${formData.RFX_NUM} / ${formData.RFX_CNT}</e:text>
                    <e:inputNumber id="RFX_CNT" name="RFX_CNT" value="${formData.RFX_CNT}" width="${form_RFX_CNT_W}" maxValue="${form_RFX_CNT_M}" decimalPlace="${form_RFX_CNT_NF}" disabled="${form_RFX_CNT_D}" readOnly="${form_RFX_CNT_RO}" required="${form_RFX_CNT_R}" onNumberKr="${form_RFX_CNT_KR}" currencyText="${form_RFX_CNT_CT}"/>
                </e:field>
				<e:label for="RFX_TYPE" title="${form_RFX_TYPE_N}"/>
				<e:field>
					<e:select id="RFX_TYPE" name="RFX_TYPE" value="${formData.RFX_TYPE}" options="${rfxTypeOptions}" width="${form_RFX_TYPE_W}" disabled="${form_RFX_TYPE_D}" readOnly="${form_RFX_TYPE_RO}" required="${form_RFX_TYPE_R}" placeHolder="" maskType="${form_RFX_TYPE_MT}" />
                    <e:text>[${form_RFX_LIMIT_NUM_N}]</e:text>
                    <e:inputText id="RFX_LIMIT_NUM" name="RFX_LIMIT_NUM" value="${formData.RFX_LIMIT_NUM}" width="${form_RFX_LIMIT_NUM_W}" maxLength="${form_RFX_LIMIT_NUM_M}" disabled="${form_RFX_LIMIT_NUM_D}" readOnly="${form_RFX_LIMIT_NUM_RO}" required="${form_RFX_LIMIT_NUM_R}" style="${imeMode}" maskType="${form_RFX_LIMIT_NUM_MT}"/>
				</e:field>
            </e:row>
            <e:row>
                <e:label for="RFX_SUBJECT" title="${form_RFX_SUBJECT_N}" />
                <e:field colSpan="3">
                	<e:text>${formData.RFX_SUBJECT}</e:text>
                </e:field>
            </e:row>
            <e:row>
            	<%--
                <e:label for="SETTLE_TYPE" title="${form_SETTLE_TYPE_N}"/>
                <e:field>
                    <e:select id="SETTLE_TYPE" name="SETTLE_TYPE" value="${formData.SETTLE_TYPE}" onChange="onChangeSETTLE_TYPE" options="${settleTypeOptions}" width="${form_SETTLE_TYPE_W}" disabled="${form_SETTLE_TYPE_D}" readOnly="${form_SETTLE_TYPE_RO}" required="${form_SETTLE_TYPE_R}" placeHolder="" maskType="${form_SETTLE_TYPE_MT}" />
                </e:field>
                --%>
                <e:label for="CUR" title="${form_CUR_N}"/>
                <e:field>
                    <e:text> ${formData.CUR} / </e:text>
                    <e:select id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE}" options="${vatTypeOptions}" width="${form_VAT_TYPE_W}" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="" maskType="${form_VAT_TYPE_MT}" />
                </e:field>
                <e:label for="AMT_TYPE" title="${form_AMT_TYPE_N}"/>
                <e:field>
                    <e:select id="AMT_TYPE" name="AMT_TYPE" value="${formData.AMT_TYPE}" options="${amtTypeOptions}" width="${form_AMT_TYPE_W}" disabled="${form_AMT_TYPE_D}" readOnly="${form_AMT_TYPE_RO}" required="${form_AMT_TYPE_R}" placeHolder="" maskType="${form_AMT_TYPE_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="RFX_START_DATE" title="${form_RFX_START_DATE_N}"/>
                <e:field>
                    <e:text> ${formData.RFX_START_DATE} ${formData.RFX_START_HOUR}:${formData.RFX_START_MIN} ~ ${formData.RFX_END_DATE} ${formData.RFX_END_HOUR}:${formData.RFX_END_MIN}</e:text>
                </e:field>
                <e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}" />
                <e:field>
                    <e:text> ${formData.CTRL_USER_NM} </e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="RMK_TEXT_NUM" title="${form_RMK_TEXT_NUM_N}" />
                <e:field colSpan="3">
                    <e:richTextEditor id="RMK_TEXT" name="RMK_TEXT" value="${formData.RMK_TEXT}" width="${form_RMK_TEXT_NUM_W}" height="150px" disabled="${form_RMK_TEXT_NUM_D}" readOnly="${form_RMK_TEXT_NUM_RO}" required="${form_RMK_TEXT_NUM_R}" style="${imeMode}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}" />
                <e:field colSpan="3">
                    <e:fileManager id="ATT_FILE_NUM" width="${form_ATT_FILE_NUM_W}" height="100px" fileId="${formData.ATT_FILE_NUM}" bizType="RFQ" readOnly="${form_ATT_FILE_NUM_RO}" required="${form_ATT_FILE_NUM_R}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

    </e:window>
</e:ui>
