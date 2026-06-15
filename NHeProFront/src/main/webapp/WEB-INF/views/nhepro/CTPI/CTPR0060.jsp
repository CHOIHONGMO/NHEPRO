<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
  <script type="text/javascript">
	
  	var grid;
    var baseUrl = '/nhepro/CTPI/CTPR0060';

    function init() {
    	  grid = EVF.C('grid');
    	  console.log(grid);
      
          // Grid AddRow Event
          grid.addRowEvent(function() {
            grid.addRow();
          });

          
          grid.setProperty('shrinkToFit', true);		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
          grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
          grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
          grid.setProperty('panelVisible', ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
          grid.setProperty('enterToNextRow', ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
          grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
          grid.setProperty('multiSelect', false);		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
          grid.setProperty('singleSelect', ${singleSelect});	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

          
          doSearch();
    }
    

    function doSearch() {
        var store = new EVF.Store();
        if(!store.validate()) return;
        store.setGrid([grid]);
        store.load(baseUrl+'/CTPR0060_doSearch.so', function() {
          if(grid.getRowCount() == 0) {
            return EVF.alert('${msg.M0002}');
          }
        });
      }
	
	
  </script>

  <e:window id="CTPR0060" initData="${initData}" onReady="init" title="${screenName }" breadCrumbs="${breadCrumb }">
    <e:searchPanel id="form" title="${msg.M9999}" labelWidth="200" width="100%" columnCount="2" useTitleBar="true" onEnter="doSearch">
    	<e:row>
	    	<e:label for="SEARCH_DSC" title="${form_SEARCH_DSC_N}"/>
			<e:field>
				<e:select id="SEARCH_DSC" name="SEARCH_DSC" value="00" options="${searchDscOptions}" width="${form_SEARCH_DSC_W}" disabled="${form_SEARCH_DSC_D}" readOnly="${form_SEARCH_DSC_RO}" required="${form_SEARCH_DSC_R}" placeHolder="" maskType="${form_SEARCH_DSC_MT}" />
			</e:field>
		</e:row>
		<e:row>
	    	<e:label for="ST_DT" title="${form_ST_DT_N}"/>
	    	<e:field>
				<e:inputDate id="ST_DT" name="ST_DT" value="${ST_DT}" width="${inputDateWidth}" datePicker="true" required="${form_ST_DT_R}" disabled="${form_ST_DT_D}" readOnly="${form_ST_DT_RO}" />
				<e:text>~</e:text>
				<e:inputDate id="ED_DT" name="ED_DT" value="${ED_DT}" width="${inputDateWidth}" datePicker="true" required="${form_ED_DT_R}" disabled="${form_ED_DT_D}" readOnly="${form_ED_DT_RO}" />
			</e:field>
			<e:label for="CORP_NO" title="${form_CORP_NO_N}"/>
			<e:field>
				<e:inputText id="CORP_NO" name="CORP_NO" value="${CORP_NO}" width="${form_CORP_NO_W}" maxLength="${form_CORP_NO_M}" disabled="${form_CORP_NO_D}" readOnly="${form_CORP_NO_RO}" required="${form_CORP_NO_R}" style="${imeMode}" maskType="${form_CORP_NO_MT}"/>
			</e:field>
		</e:row>
    </e:searchPanel>
    
    <e:buttonBar width="100%" align="right">
    	<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
    </e:buttonBar>
    
      <e:gridPanel id="grid" name="grid"  gridType="${_gridType}" width="100%" height="fit"/>
  </e:window>
</e:ui>
