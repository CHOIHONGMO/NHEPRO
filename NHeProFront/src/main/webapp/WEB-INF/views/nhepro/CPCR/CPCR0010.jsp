<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>

<!-- 2021.02.08 : "관리자직무"를 갖는 사람은 담당자 변경 가능 -->
<% String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd"); %>
<c:set var="ManagerCd" value="<%=ManagerCd%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/CPCR/";
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

            });
			
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }

            store.setGrid([grid]);
            store.load(baseUrl + "cpcr0010_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

    </script>

    <e:window id="CPCR0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2" onEnter="doSearch">
            <e:row>
            	<e:label for="PAY_FROM_DATE" title="${form_PAY_FROM_DATE_N}"/>
				<e:field>
					<e:inputDate id="PAY_FROM_DATE" toDate="PAY_FROM_DATE" name="PAY_FROM_DATE" value="${payFromDate }" width="${inputTextDate }" required="${form_PAY_FROM_DATE_R }" readOnly="${form_PAY_FROM_DATE_RO }" disabled="${form_PAY_FROM_DATE_D }" datePicker="true" />
					<e:text>~</e:text>
					<e:inputDate id="PAY_TO_DATE" fromDate="PAY_TO_DATE" name="PAY_TO_DATE" value="${payToDate }" width="${inputTextDate }" required="${form_PAY_TO_DATE_R }" readOnly="${form_PAY_TO_DATE_RO }" disabled="${form_PAY_TO_DATE_D }" datePicker="true" />
				</e:field>
				 <e:label for="PAY_TYPE" title="${form_PAY_TYPE_N}"/>
				<e:field>
                    <e:select id="PAY_TYPE" name="PAY_TYPE" value="" options="${payTypeOptions}" width="${form_PAY_TYPE_W}" disabled="${form_PAY_TYPE_D}" readOnly="${form_PAY_TYPE_RO}" required="${form_PAY_TYPE_R}" placeHolder="선택" maskType="${form_PAY_TYPE_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
        	<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
