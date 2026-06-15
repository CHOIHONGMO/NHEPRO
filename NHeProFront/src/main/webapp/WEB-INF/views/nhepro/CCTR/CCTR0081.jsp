<%--
  Date: 2020-06-10
  Time: 15:01:18
  Scrren ID : CCTR0081
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
  <script>

    var grid;
    var baseUrl = '/nhepro/CCTR/CCTR0081';

    function init() {

      grid = EVF.C('grid');
      grid.setProperty('shrinkToFit', false);		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
      grid.setProperty('multiSelect', false);		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
      grid.setProperty('singleSelect', false);	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

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
		var contUserId = grid.getCellValue(rowIdx, 'REQ_USER_ID');
		var isAuthUser = false;

		if(contUserId == "${ses.userId}" || "${ses.superUserFlag}" == "1") {
			isAuthUser = true;
		}
		
		var buyerCd = grid.getCellValue(rowIdx, "BUYER_CD");
		var reqNum  = grid.getCellValue(rowIdx, "REQ_NUM");
		var reqSeq  = grid.getCellValue(rowIdx, "REQ_SEQ");
		
    	switch (celName) {
			case "multiSelect":
				// grid.checkEqualRow(["CONT_NUM", "CONT_CNT"], [grid.getCellValue(rowIdx, "CONT_NUM"), grid.getCellValue(rowIdx, "CONT_CNT")]);
				break;
			case "REQ_NUM":
				var progressCd = grid.getCellValue(rowIdx, "PROGRESS_CD");
				param = {
					callBackFunction: 'doSearch',
					BUYER_CD: buyerCd,
					REQ_NUM: reqNum,
					REQ_SEQ: reqSeq
				};

				if (progressCd == 'W') { <%-- 위임장서명대기 --%>
					param["detailView"] = false;
				} else { <%-- 서명완료, 반려 --%>
					param["detailView"] = true;
				}

				url = '/nhepro/CCTR/CCTR0071/view.so';
				everPopup.openWindowPopup(url, 1200, 730, param, 'openBuyerContract');

				break;
			case "ATT_FILE_CNT":
				if(value != 0) {
					var url = "/common/file/fileAttach/viewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=" + grid.getCellValue(rowIdx, 'ATT_FILE_NUM');
					window.open(url, "eform", "width=850,height=960,scrollbars=yes,resizeable=no,left=0,top=0");
					
					/* param = {
						bizType: 'ET',
						attFileNum: grid.getCellValue(rowIdx, 'ATT_FILE_NUM'),
						detailView: true
					};
					everPopup.fileAttachPopup(param); */
				}
				
				break;
			case "REJECT_RMK":
				if(value != "") {
					param = {
						title : '위임장 반려사유',
						message: value,
						detailView : true
					};
					everPopup.commonTextInput(param);
				}
				
				break;
		}
      });

      grid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {});
      
      EVF.C('PROGRESS_CD').removeOption('T');
      EVF.C('PROGRESS_CD').removeOption('C');
      
      // 진행상태 세팅
      setType();
      
      // 조회
      doSearch();
    }
	
	// PROGRESS_ CD : 진행상태 MultiSelect
    function setType() {
		var proNm = "";
		$('input[name=multiselect_PROGRESS_CD]').each(function (k, v) {
			if( v.value == "" ) {
				$(v).parent().remove();
			} else {
				if( v.value == "W" ) {
					proNm += v.title + ", ";
					v.checked = true;
				}
			}
		});
		$("#PROGRESS_CD").next().find("span, .e-select-text").text(proNm.substr(0, proNm.length - 2));
	}
    
    // 조회
    function doSearch() {
      var store = new EVF.Store();

      // form validation Check
      if(!store.validate()) return;

      store.setGrid([grid]);
      store.load(baseUrl+'/doSearch.so', function() {
    	  if(grid.getRowCount() == 0){
              EVF.alert("${msg.M0002 }");
          }
		  else {
          	  grid.setColIconify("REJECT_RMK", "REJECT_RMK", "comment", false);
          }
      });
    }

  </script>

  <e:window id="CCTR0081" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
  	<!-- 조회조건 영역 -->
    <e:searchPanel id="form" title="${msg.M9999}" labelWidth="135" width="100%" columnCount="3" useTitleBar="true" onEnter="doSearch">
      <e:row>
      	<e:label for="REQ_DATE_FROM" title="${form_REQ_DATE_FROM_N}"/>
		<e:field>
			<e:inputDate id="REQ_DATE_FROM" name="REQ_DATE_FROM" value="${fromDate}" width="${inputDateWidth}" datePicker="true" required="${form_REQ_DATE_FROM_R}" disabled="${form_REQ_DATE_FROM_D}" readOnly="${form_REQ_DATE_FROM_RO}" />
			<e:text>~</e:text>
			<e:inputDate id="REQ_DATE_TO" name="REQ_DATE_TO" value="${toDate}" width="${inputDateWidth}" datePicker="true" required="${form_REQ_DATE_TO_R}" disabled="${form_REQ_DATE_TO_D}" readOnly="${form_REQ_DATE_TO_RO}" />
		</e:field>
		<e:label for="SUBJECT" title="${form_SUBJECT_N}" />
		<e:field>
			<e:inputText id="SUBJECT" name="SUBJECT" value="" width="100%" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
		</e:field>
		<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
		<e:field>
			<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="100%" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" useMultipleSelect="true"/>
		</e:field>
      </e:row>
    </e:searchPanel>
    
    <!-- Button 영역 -->
    <e:buttonBar width="100%" align="right">
      <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
    </e:buttonBar>
    
    <!-- Grid 영역 -->
    <e:gridPanel id="grid" name="grid"  gridType="${_gridType}" width="100%" height="fit"/>
    
  </e:window>
</e:ui>
