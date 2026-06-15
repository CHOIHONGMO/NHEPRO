<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

        var grid1 = {};
        var grid2 = {};
    	var addParam = [];
    	var baseUrl = "/eversrm/manager/system/";

		function init() {

			grid1 = EVF.C('grid1');

	        grid1.cellClickEvent(function(rowIdx, colIdx, value) {

	        	if(colIdx === "COMMON_ID") {
                    var param = {
                        COMMON_ID : grid1.getCellValue (rowIdx,'COMMON_ID')
                       ,DATABASE_CD : grid1.getCellValue(rowIdx,'DATABASE_CD')
                       ,detailView : false
                       ,POPUPFLAG : 'Y'
                    };
                    everPopup.openPopupByScreenId('MSYB0010', 900, 700, param);
	            }
			});

            grid1.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid1.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid1.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid1.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid1.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid1.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid1.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            grid1.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            grid1.showCheckBar(false);
        }

        function search() {

            var store = new EVF.Store();
        	store.setGrid([grid1]);
            store.load(baseUrl + 'MSYA0010/doSearch.so', function() {
                if(grid1.getRowCount() == 0){
                	EVF.alert("${msg.M0002 }");
                }
            });
        }

    </script>
    <e:window id="MSYA0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${msg.M9999}" labelWidth="${labelWidth}" width="100%" columnCount="3" onEnter="search"  useTitleBar="false">
           <e:row>
               <e:label for="TYPE" title="${form_TYPE_N }" />
                <e:field>
               	 	<e:select id="TYPE" name="TYPE" value="" readOnly="${form_TYPE_RO }" options="${typeOptions}" width="100%" required="${form_TYPE_R }" disabled="${form_TYPE_D }" onFocus="onFocus"  maskType="${form_TYPE_MT}"/>
                </e:field>
               <e:label for="COMMON_ID" title="${form_COMMON_ID_N }" />
                <e:field>
                    <e:inputText id="COMMON_ID" name="COMMON_ID"  readOnly="${form_COMMON_ID_RO }"   maxLength="${form_COMMON_ID_M}"  value=""  width="100%" required="${form_COMMON_ID_R }" disabled="${form_COMMON_ID_D }"   maskType="${form_COMMON_ID_MT}" />
                </e:field>
                <e:label for="COMMON_DESC" title="${form_COMMON_DESC_N }" />
                <e:field>
                    <e:inputText id="COMMON_DESC" name="COMMON_DESC"  readOnly="${form_COMMON_DESC_RO }"  maxLength="${form_COMMON_DESC_M}"  value="" width="100%" required="${form_COMMON_DESC_R }" disabled="${form_COMMON_DESC_D }"  maskType="${form_COMMON_DESC_MT}" />
                </e:field>
 		    </e:row>
            <e:row>
               <e:label for="DATABASE" title="${form_DATABASE_N }" />
                <e:field>
               	 	<e:select id="DATABASE" name="DATABASE"  value=""  readOnly="${form_DATABASE_RO }"  options="${databaseOptions}" width="100%" required="${form_DATABASE_R }" disabled="${form_DATABASE_D }" onFocus="onFocus"  maskType="${form_DATABASE_MT}"/>
                </e:field>
               <e:label for="SQL_TEXT" title="${form_SQL_TEXT_N }" />
                <e:field>
                    <e:inputText id="SQL_TEXT" name="SQL_TEXT" value=""  readOnly="${form_SQL_TEXT_RO }"   maxLength="${form_SQL_TEXT_M}"  width="100%" required="${form_SQL_TEXT_R }" disabled="${form_SQL_TEXT_D }"   maskType="${form_SQL_TEXT_MT}" />
                </e:field>
                <e:label for="USE_FLAG" title="${form_USE_FLAG_N}"/>
                <e:field>
                    <e:select id="USE_FLAG" name="USE_FLAG" value="" options="${useFlagOptions}" width="${form_USE_FLAG_W}" disabled="${form_USE_FLAG_D}" readOnly="${form_USE_FLAG_RO}" required="${form_USE_FLAG_R}" placeHolder=""  maskType="${form_USE_FLAG_MT}"/>
                </e:field>
 			</e:row>
		</e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N }" disabled="${doSearch_D }" onClick="search" />
        </e:buttonBar>

    	<e:gridPanel gridType="${_gridType}" id="grid1" name="grid1" width="100%" height="fit"  readOnly="${param.detailView}"/>

    </e:window>
</e:ui>