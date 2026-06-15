<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript">

	var grid = {};
	var baseUrl = "/eversrm/manager/batch";

	function init() {

		grid = EVF.C('grid');

		grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
		grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
		grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
		grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
		grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
		grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
		grid.setProperty('multiSelect', false); 		// [선택] 컬럼의 사용여부를 지정한다. [true/false]

		grid.excelExportEvent({
			allItems : "${excelExport.allCol}",
			fileName : "${screenName }"
		});
		
		EVF.C('JOB_ID').removeOption('BNH0001');
	    EVF.C('JOB_ID').removeOption('BNH0010');
	    EVF.C('JOB_ID').removeOption('BNH0011');
	    EVF.C('JOB_ID').removeOption('BNH0012');
	    EVF.C('JOB_ID').removeOption('BNH0013');
	    EVF.C('JOB_ID').removeOption('BNH0014');
	    EVF.C('JOB_ID').removeOption('BNH0015');
	    EVF.C('JOB_ID').removeOption('BNH0016');
	    EVF.C('JOB_ID').removeOption('BNH0017');
	    EVF.C('JOB_ID').removeOption('BNH0018');
	    EVF.C('JOB_ID').removeOption('BNH0019');
	    EVF.C('JOB_ID').removeOption('BNH0020');
	    EVF.C('JOB_ID').removeOption('BNH0021');
	    EVF.C('JOB_ID').removeOption('UserMig');
	    EVF.C('JOB_ID').removeOption('CustMig');
    }

    function doSearch() {

    	var store = new EVF.Store();
        if(!store.validate()) return;
        store.setGrid([grid]);
        store.load(baseUrl + '/MBTB0030/doSearch.so', function() {
            if(grid.getRowCount() == 0){
            	EVF.alert("${msg.M0002 }");
            }
        });
    }
	
    function execSql() {
    	var param = {};
		everPopup.openPopupByScreenId("EXECSQL", 1200, 700, param);
    }
    
    function execDir() {
    	var param = {};
		everPopup.openPopupByScreenId("EXECFILEDOWN", 1200, 700, param);
    }
    
    </script>

	<e:window id="MBTB0030" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

		<e:searchPanel id="form" title="${msg.M9999 }" columnCount="3" labelWidth="${labelWidth }" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="JOB_DATE_FROM" title="${form_JOB_DATE_FROM_N}" />
				<e:field>
					<e:inputDate id="JOB_DATE_FROM" name="JOB_DATE_FROM" value="${fromDate}" width="${inputDateWidth}" datePicker="true" required="${form_JOB_DATE_FROM_R}" disabled="${form_JOB_DATE_FROM_D}" readOnly="${form_JOB_DATE_FROM_RO}" />
					<e:text> ~ </e:text>
					<e:inputDate id="JOB_DATE_TO" name="JOB_DATE_TO" value="${toDate}" width="${inputDateWidth}" datePicker="true" required="${form_JOB_DATE_FROM_R}" disabled="${form_JOB_DATE_FROM_D}" readOnly="${form_JOB_DATE_FROM_RO}" />
				</e:field>
				<e:label for="JOB_ID" title="${form_JOB_ID_N}" />
				<e:field>
					<e:select id="JOB_ID" name="JOB_ID" value="" options="${jobIdOptions }" width="${form_JOB_ID_W}" disabled="${form_JOB_ID_D}" readOnly="${form_JOB_ID_RO}" required="${form_JOB_ID_R}" placeHolder=""  maskType="${form_JOB_ID_MT}"/>
				</e:field>
				<e:label for="JOB_RLT" title="${form_JOB_RLT_N}" />
				<e:field>
					<e:select id="JOB_RLT" name="JOB_RLT" value="" options="${jobRltOptions }" width="${form_JOB_RLT_W}" disabled="${form_JOB_RLT_D}" readOnly="${form_JOB_RLT_RO}" required="${form_JOB_RLT_R}" placeHolder=""  maskType="${form_JOB_RLT_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="JOB_KEY" title="${form_JOB_KEY_N}" />
				<e:field>
					<e:select id="JOB_KEY" name="JOB_KEY" value="" options="${jobKeyOptions }" width="${form_JOB_KEY_W}" disabled="${form_JOB_KEY_D}" readOnly="${form_JOB_KEY_RO}" required="${form_JOB_KEY_R}" placeHolder=""  maskType="${form_JOB_KEY_MT}"/>
				</e:field>
				<e:label for="" title="" />
				<e:field>
				</e:field>
				<e:label for="" title="" />
				<e:field>
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}" />
		</e:buttonBar>

		<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" readOnly="${param.detailView}"/>
		
		<!-- SQL로그/디렉토리검색 -->
		<div align="right">
			<a href="javascript:execSql();">&nbsp;&nbsp;</a>
			<a href="javascript:execDir();">&nbsp;&nbsp;</a>
		</div>
	</e:window>
</e:ui>
