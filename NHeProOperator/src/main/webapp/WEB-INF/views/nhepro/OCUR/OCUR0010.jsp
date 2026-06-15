<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var grid;
        var baseUrl = "/nhepro/OCUR/";

        function init() {
            grid = EVF.C("grid");

            grid.cellClickEvent(function(rowIdx, colIdx) {
                var param;

                if (colIdx == "CUST_CD") {
                    param = {
                        'CUST_CD': grid.getCellValue(rowIdx, 'CUST_CD'),
                        'detailView': false,
                        'popupFlag': true
                    };
                    everPopup.openPopupByScreenId("OCUR0011", 1100, 700, param);
                }
                <%--
                if (colIdx == "CHANGE_CNT") {
                    if( Number(grid.getCellValue(rowIdx, 'CHANGE_CNT')) > 0 ) {
                        param = {
                            'CUST_CD': grid.getCellValue(rowIdx, 'CUST_CD'),
                            'CUST_NM': grid.getCellValue(rowIdx, 'CUST_NM'),
                            'detailView': true,
                            'popupFlag': true
                        };
                        everPopup.openPopupByScreenId("BS01_001P", 800, 450, param);
                    }
                }
                --%>
            });

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', false);		            // [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
        }

        function doSearch() {

            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.load(baseUrl + 'ocur0010_doSearch.so', function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doInsert() {
            var param = {
                'CUST_CD': '',
                'detailView': false,
                'popupFlag': true
            };
            everPopup.openPopupByScreenId("OCUR0011", 1100, 700, param);
        }

        function searchCust() {
            var param = {
                callBackFunction : "selectCust"
            };
            everPopup.openCommonPopup(param, 'SP0066');
        }

        function selectCust(dataJsonArray) {
            EVF.V("CUST_CD", dataJsonArray.CUST_CD);
            EVF.V("CUST_NM", dataJsonArray.CUST_NM);
        }

        function clearCust() {
            EVF.V("CUST_CD", "");
        }

    </script>

    <e:window id="OCUR0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${msg.M9999 }" columnCount="3" labelWidth="${labelWidth }" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <e:label for="CUST_CD" title="${form_CUST_CD_N}"/>
                <e:field>
                    <e:search id="CUST_CD" name="CUST_CD" value="" width="40%" maxLength="${form_CUST_CD_M}" onIconClick="${form_CUST_CD_D ? 'everCommon.blank' : 'searchCust'}" disabled="${form_CUST_CD_D}" readOnly="${form_CUST_CD_RO}" required="${form_CUST_CD_R}" maskType="${form_CUST_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="CUST_NM" name="CUST_NM" value="" width="60%" maxLength="${form_CUST_NM_M}" disabled="${form_CUST_NM_D}" readOnly="${form_CUST_NM_RO}" required="${form_CUST_NM_R}"  maskType="${form_CUST_NM_MT}" placeHolder="회사명" />
                </e:field>
				<e:label for="COMPANY_TYPE" title="${form_COMPANY_TYPE_N}"/>
				<e:field>
					<e:select id="COMPANY_TYPE" name="COMPANY_TYPE" value="" options="${companyTypeOptions}" width="${form_COMPANY_TYPE_W}" disabled="${form_COMPANY_TYPE_D}" readOnly="${form_COMPANY_TYPE_RO}" required="${form_COMPANY_TYPE_R}" placeHolder="" maskType="${form_COMPANY_TYPE_MT}"/>
				</e:field>
				<e:label for="CORP_TYPE" title="${form_CORP_TYPE_N}"/>
				<e:field>
					<e:select id="CORP_TYPE" name="CORP_TYPE" value="" options="${corpTypeOptions}" width="${form_CORP_TYPE_W}" disabled="${form_CORP_TYPE_D}" readOnly="${form_CORP_TYPE_RO}" required="${form_CORP_TYPE_R}" placeHolder="" maskType="${form_CORP_TYPE_MT}"/>
				</e:field>
            </e:row>
            <e:row>
                <e:label for="RELAT_YN" title="${form_RELAT_YN_N}"/>
                <e:field>
                    <e:select id="RELAT_YN" name="RELAT_YN" value="" options="${relatYnOptions }" width="${form_RELAT_YN_W}" disabled="${form_RELAT_YN_D}" readOnly="${form_RELAT_YN_RO}" required="${form_SH_VALUE_COMBO_R}" placeHolder="" maskType="${form_RELAT_YN_MT}"/>
                </e:field>
                <e:label for="IRS_NO" title="${form_IRS_NO_N}"/>
                <e:field>
                    <e:inputText id="IRS_NO" name="IRS_NO" value="" width="100%" maxLength="${form_IRS_NO_M}" disabled="${form_IRS_NO_D}" readOnly="${form_IRS_NO_RO}" required="${form_IRS_NO_R}"  maskType="${form_IRS_NO_MT}" />
                </e:field>
                <e:label for="CEO_USER_NM" title="${form_CEO_USER_NM_N}"/>
                <e:field>
                    <e:inputText id="CEO_USER_NM" name="CEO_USER_NM" value="" width="100%" maxLength="${form_CEO_USER_NM_M}" disabled="${form_CEO_USER_NM_D}" readOnly="${form_CEO_USER_NM_RO}" required="${form_CEO_USER_NM_R}"  maskType="${form_CEO_USER_NM_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
            <e:button id="Insert" name="Insert" label="${Insert_N }" disabled="${Insert_D }" visible="${Insert_V}" onClick="doInsert" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>