<%--
  Date: 2020-06-10
  Time: 15:01:18
  Scrren ID : CCTR0110
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
  <script>

    var grid;
    var baseUrl = '/nhepro/CCTR/CCTR0110';

    function init() {

      grid = EVF.C('grid');
      grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
      grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
      grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
      grid.setProperty('panelVisible', ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
      grid.setProperty('enterToNextRow', ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
      grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
      grid.setProperty('multiSelect', ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
      grid.setProperty('singleSelect', ${singleSelect});	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

      // Grid AddRow Event
      grid.addRowEvent(function() {
        grid.addRow();
      });

      // Grid Excel Event
      grid.excelExportEvent({
        allItems : "${excelExport.allCol}",
        fileName : "${screenName }"
      });

      grid.cellClickEvent(function(rowIdx, celName, value) {

      });

      grid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {});
    }

    // 조회
    function doSearch() {
      var store = new EVF.Store();

      // form validation Check
      if(!store.validate()) return;

      store.setGrid([grid]);
      store.load(baseUrl+'/doSearch.so', function() {
        if(grid.getRowCount() == 0) {
          return EVF.alert('${msg.M0002}');
        }
      });
    }

    // 계약서 작성
    function doOpenContract() {
		var param = {
			detailView: false
		};
		everPopup.openPopupByScreenId('CCTI0090', 1200, 700, param);
	}

  </script>

  <e:window id="CCTR0110" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
  	<!-- 조회조건 영역 -->
    <e:searchPanel id="form" title="${msg.M9999}" labelWidth="130" width="100%" columnCount="3" useTitleBar="true" onEnter="doSearch">
      <e:row>
		<e:label for="SRH_DATE_FROM" title="${form_SRH_DATE_FROM_N}"/>
		<e:field>
			<e:inputDate id="SRH_DATE_FROM" name="SRH_DATE_FROM" value="" width="${inputDateWidth}" datePicker="true" required="${form_SRH_DATE_FROM_R}" disabled="${form_SRH_DATE_FROM_D}" readOnly="${form_SRH_DATE_FROM_RO}" />
			<e:text>~</e:text>
			<e:inputDate id="SRH_DATE_TO" name="SRH_DATE_TO" value="" width="${inputDateWidth}" datePicker="true" required="${form_SRH_DATE_TO_R}" disabled="${form_SRH_DATE_TO_D}" readOnly="${form_SRH_DATE_TO_RO}" />
		</e:field>
      </e:row>
    </e:searchPanel>
    <!-- Button 영역 -->
    <e:buttonBar id="buttonBar" align="right" width="100%">
		<e:text style="color: blue;font-weight: bold;">■ 계약담당자 : </e:text>
		<e:inputHidden id="CHNG_USER_ID" name="CHNG_USER_ID" />
		<e:search id="CHNG_USER_NM" name="CHNG_USER_NM" value="" width="140" maxLength="${form_CHNG_USER_NM_M}" onIconClick="getDrafter" disabled="${form_CHNG_USER_NM_D}" readOnly="${form_CHNG_USER_NM_RO}" required="${form_CHNG_USER_NM_R}" />
		<e:button id="doChangeManager" name="doChangeManager" label="${doChangeManager_N}" onClick="doChangeManager" disabled="${doChangeManager_D}" visible="${doChangeManager_V}" align="left" style="padding-left: 3px;"/>

		<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
      	<e:button id="doOpenContract" name="doOpenContract" label="${doOpenContract_N}" onClick="doOpenContract" disabled="${doOpenContract_D}" visible="${doOpenContract_V}"/>
	</e:buttonBar>
    <!-- Grid 영역 -->
    <e:gridPanel id="grid" name="grid"  gridType="${_gridType}" width="100%" height="fit"/>
  </e:window>
</e:ui>
