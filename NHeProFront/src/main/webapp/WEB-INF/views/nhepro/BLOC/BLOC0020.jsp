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
    var baseUrl = '/nhepro/BLOC/BLOC0020';

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

    // Search
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

 // Search
    function doSearchUser() {
    	var param = {};
		everPopup.openPopupByScreenId("BLOC0030", 1100, 700, param);
    }

 
    function getSearchUserPopup() {
		var param = {
				'callBackFunction': 'setUser',
				'READONLY': 'Y',		//팝업 조회조건 변경불가
				'multiYN' : 'N',        //멀티팝업여부
				'CTRL_CD' : "BR100",	// 관리자
				'detailView': false
		};
		everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
	}

    function setUser(data) {
		if(data!=null){
			data = JSON.parse(data);
			EVF.V("USER_ID", data.USER_ID);
			EVF.V("USER_NM", data.USER_NM);
		}
	}

  </script>

  <e:window id="BLOC0020" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
	
	<e:text style="font-weight: bold; font-size: 14px; color: #222222" >■ 블록체인 사설인증서 발급 권한 소유자 &nbsp;&nbsp;&nbsp;</e:text>
    <e:br/>
    <e:text id="">
		&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;직무관리자 권한 소유자는 블록체인 사설인증서를 발급할 수 있습니다 <e:br/>
    </e:text>
	<e:button id="doSearchUser" name="doSearchUser" label="${doSearchUser_N}" onClick="doSearchUser" disabled="${doSearchUser_D}" visible="${doSearchUser_V}"/>
     <e:br/>
     <e:br/>
    
    <e:searchPanel id="form" title="${msg.M9999}" labelWidth="100" width="100%" columnCount="3" useTitleBar="true" onEnter="doSearch">
      <e:row>
      	<%-- 발급일자 --%>
        <e:label for="BEFORE_DATE_FROM" title="${form_BEFORE_DATE_FROM_N}"/>
		<e:field>
			<e:inputDate id="BEFORE_DATE_FROM" name="BEFORE_DATE_FROM" value="" width="${inputDateWidth}" datePicker="true" required="${form_BEFORE_DATE_FROM_R}" disabled="${form_BEFORE_DATE_FROM_D}" readOnly="${form_BEFORE_DATE_FROM_RO}" />
			<e:text>~</e:text>
			<e:inputDate id="BEFORE_DATE_TO" name="BEFORE_DATE_TO" value="" width="${inputDateWidth}" datePicker="true" required="${form_BEFORE_DATE_TO_R}" disabled="${form_BEFORE_DATE_TO_D}" readOnly="${form_BEFORE_DATE_TO_RO}" />
		</e:field>
		<%-- 상태 --%>
		<e:label for="CERT_STATUS" title="${form_CERT_STATUS_N}"/>
		<e:field>
			<e:select id="CERT_STATUS" name="CERT_STATUS" value="validity" options="${certStatusOptions}" width="${form_CERT_STATUS_W}" disabled="${form_CERT_STATUS_D}" readOnly="${form_CERT_STATUS_RO}" required="${form_CERT_STATUS_R}" placeHolder="" maskType="${form_CERT_STATUS_MT}" />
		</e:field>
		<%-- 발급자 명 --%>
		<e:label for="USER_ID" title="${form_USER_ID_N}" />
		<e:field>
			<e:search id="USER_ID" name="USER_ID" value="" width="40%"  onIconClick="${form_USER_ID_RO ? 'everCommon.blank' : 'getSearchUserPopup'}" maxLength="${form_USER_ID_M}" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}" style="${imeMode}" maskType="${form_USER_ID_MT}"/>
			<e:inputText id="USER_NM" name="USER_NM" value="" width="60%" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" style="${imeMode}" maskType="${form_USER_NM_MT}"/>
		</e:field>
        
      </e:row>
    </e:searchPanel>
    <e:buttonBar width="100%" align="right">
      <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
    </e:buttonBar>
    <e:gridPanel id="grid" name="grid"  gridType="${_gridType}" width="100%" height="fit" readOnly="${param.detailView}"/>
  </e:window>
</e:ui>
