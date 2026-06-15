<%--
  Date: 2021-05-11
  Time: 13:52:59
  Scrren ID : IPRONET
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
  <script>

    var grid;
    var baseUrl = '/nhepro/BLOC/BLOC0030';

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
        // cell one click

      });

      grid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {});
      
      doSearch();
    }

    function doSearch(){
    	var store = new EVF.Store();

        store.setGrid([grid]);
        store.load(baseUrl+'/doSearch.so', function() {
          if(grid.getRowCount() == 0) {
            return EVF.alert('${msg.M0002}');
          }
        });
    }


  </script>

  <e:window id="BLOC0030" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
    
    <e:gridPanel id="grid" name="grid"  gridType="${_gridType}" width="100%" height="fit" readOnly="${param.detailView}"/>
  </e:window>
</e:ui>
