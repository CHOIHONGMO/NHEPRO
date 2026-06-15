<%--
  Date: 2020-06-10
  Time: 15:01:18
  Scrren ID : TEST0020P10
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
  <script>

    var grid;
    var baseUrl = '/nhepro/TEST/TEST0020P10';

    function init() {
    	grid = EVF.C('grid');
        grid.setProperty('shrinkToFit', true);		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
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
    	grid.delRowEvent(function () {
			grid.delRow();
		
		});
    	
    	
    }
      
    // 조회
    function doSearch() {
      var store = new EVF.Store();

      // form validation Check
      if(!store.validate()) return;

      store.setGrid([grid]);
      store.load(baseUrl+'/test0020P10_doSearch.so', function() {
        if(grid.getRowCount() == 0) {
          return EVF.alert('${msg.M0002}');
        }
        else {
        	grid.setColIconify("REJECT_RMK", "REJECT_RMK", "comment", false);
        	grid.setColIconify("CANCEL_RMK", "CANCEL_RMK", "comment", false);
        }
      });
    }
    
    
    function doInsertRow(){
    	
    	grid.addRow()
    //	grid.setCellReadOnly(grid.getRowCount() - 1, 'ITEM_DESC', false); 	
    	
    }
    
    
    
    function doSave(){
    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); } 
    	
    	EVF.confirm("저장 하시겠습니까?", function () {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.getGridData(grid, "sel");
            store.load(baseUrl+'/test0020P10_doSave.so', function() {
                EVF.alert(this.getResponseMessage());
                //doSearch();
            });
        });
    	
    }
    
    function doDelete(){
    	
    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
    	
    	EVF.confirm("${msg.M0013 }", function () {
			var store = new EVF.Store();
			store.setGrid([grid]);
			store.getGridData(grid, "sel");
			store.load(baseUrl + "/test0020P10_doDelete.so", function () {
				EVF.alert("${msg.M0017}", function () {
					doSearch();
				});
			});
		});

		
    	
    }

  </script>

  <e:window id="TEST0020P10" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
  	<!-- 조회조건 영역 -->
    
    <!-- Button 영역 -->
    <e:buttonBar width="100%" align="right" title="">
      <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
      <e:button id="doInsertRow" name="doInsertRow" label="${doInsertRow_N}" onClick="doInsertRow" disabled="${doInsertRow_D}" visible="${doInsertRow_V}"/>
      <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
      <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
    </e:buttonBar>
    
    <!-- Grid 영역 -->
    
    <e:gridPanel id="grid" name="grid"  gridType="${_gridType}" width="100%" height="fit"/>
    
  </e:window>
</e:ui>
