<%--
  Date: 2020-06-10
  Time: 15:01:18
  Scrren ID : CCTR0080
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
  <script>

    var grid;
    var baseUrl = '/nhepro/CCTR/CCTR0080';

    function init() {

      grid = EVF.C('grid');
      grid.setProperty('shrinkToFit', false);		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
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
				// Header의 진행상태
				var progressCd = grid.getCellValue(rowIdx, "HD_PROGRESS_CD");
				param = {
					callBackFunction: 'doSearch',
					BUYER_CD: buyerCd,
					REQ_NUM: reqNum,
					REQ_SEQ: reqSeq
				};

				if (progressCd == '' || progressCd == 'T') { <%-- 위임장 작성중 --%>
					param["detailView"] = (isAuthUser ? false : true);
				} else {
					param["detailView"] = true;
				}

				url = '/nhepro/CCTR/CCTR0070/view.so';
				everPopup.openWindowPopup(url, 1200, 900, param, 'openBuyerContract');

				break;
			case "ENTRST_OFCE_NM":
				// Header의 진행상태
				var progressCd = grid.getCellValue(rowIdx, "HD_PROGRESS_CD");
				if (progressCd == '' || progressCd == 'T') { <%-- 위임장 작성중 --%>
				return EVF.alert("${CCTR0080_0003}");
				}
				param = {
					callBackFunction : 'doSearch',
					BUYER_CD: buyerCd,
					REQ_NUM: reqNum,
					REQ_SEQ: reqSeq,
					detailView : true
				};
				url = '/nhepro/CCTR/CCTR0071/view.so';
				everPopup.openWindowPopup(url, 1200, 730, param, 'openEntrustContract');
				
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
			case "CANCEL_RMK":
				if(value != "") {
					param = {
						title : '위임장요청 취소사유',
						message: value,
						detailView : true
					};
					everPopup.commonTextInput(param);
				}
				
				break;
		}
      });

      grid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {});
      
      setType();
      
      // 2020.12.02 자동조회 추가
      doSearch();
    }
	
	// PROGRESS_ CD : 진행상태 MultiSelect
    function setType() {
		var proNm = "";
		$('input[name=multiselect_PROGRESS_CD]').each(function (k, v) {
			if( v.value == "" ) {
				$(v).parent().remove();
			} else {
				proNm += v.title + ", ";
				v.checked = true;
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
        if(grid.getRowCount() == 0) {
          return EVF.alert('${msg.M0002}');
        }
        else {
        	grid.setColIconify("REJECT_RMK", "REJECT_RMK", "comment", false);
        	grid.setColIconify("CANCEL_RMK", "CANCEL_RMK", "comment", false);
        }
      });
    }

    // 위임장요청취소
    function doCancel() {

      if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
      if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }

      var selRowId = grid.getSelRowId();
	  for(var i in selRowId) {
	    if (grid.getCellValue(selRowId[i], "REQ_USER_ID") != "${ses.userId}") {
			return EVF.alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
		}
		if (grid.getCellValue(selRowId[i], "PROGRESS_CD") != 'T' && grid.getCellValue(selRowId[i], "PROGRESS_CD") != "W") {
			return EVF.alert("${CCTR0080_0002}"); // 전자서명대기인 건만 취소 가능합니다.
		}
	  }
	
      EVF.confirm("${CCTR0080_0001}", function() {
         var store = new EVF.Store();
         store.setGrid([grid]);
         store.getGridData(grid, 'sel');
         store.load(baseUrl + '/doCancel.so', function() {
             EVF.alert(this.getResponseMessage(), function() {
                 doSearch();
             });
         });
      });
    }

    // 위임장요청 작성
    function doNew() {
		var param = {
			detailView: false
		};
		everPopup.openPopupByScreenId('CCTR0070', 1200, 900, param);
	}
    
    // 위임회사 조회
    function getEntrustBuyer() {
		var param = {
			callBackFunction: "setEntrustBuyer"
		};
		everPopup.openCommonPopup(param, "SP0066");
	}

	function setEntrustBuyer(data) {
		EVF.V("ENTRUST_COMP_CD", data.CUST_CD);
		EVF.V("ENTRUST_COMP_NM", data.CUST_NM);
	}
	
	// 수임회사 조회
    function getAcceptBuyer() {
		var param = {
			callBackFunction: "setAcceptBuyer"
		};
		everPopup.openCommonPopup(param, "SP0066");
	}

	function setAcceptBuyer(data) {
		EVF.V("BUYER_CD", data.CUST_CD);
		EVF.V("BUYER_NM", data.CUST_NM);
	}

  </script>

  <e:window id="CCTR0080" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
  	<!-- 조회조건 영역 -->
    <e:searchPanel id="form" title="${msg.M9999}" labelWidth="135" width="100%" columnCount="3" useTitleBar="true" onEnter="doSearch">
      <e:row>
      	<e:label for="REQ_DATE_FROM" title="${form_REQ_DATE_FROM_N}"/>
		<e:field>
			<e:inputDate id="REQ_DATE_FROM" name="REQ_DATE_FROM" value="${fromDate}" width="${inputDateWidth}" datePicker="true" required="${form_REQ_DATE_FROM_R}" disabled="${form_REQ_DATE_FROM_D}" readOnly="${form_REQ_DATE_FROM_RO}" />
			<e:text>~</e:text>
			<e:inputDate id="REQ_DATE_TO" name="REQ_DATE_TO" value="${toDate}" width="${inputDateWidth}" datePicker="true" required="${form_REQ_DATE_TO_R}" disabled="${form_REQ_DATE_TO_D}" readOnly="${form_REQ_DATE_TO_RO}" />
		</e:field>
      	<e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
		<e:field>
			<e:search id="BUYER_CD" name="BUYER_CD" value="${ses.companyCd}" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'getAcceptBuyer'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
			<e:inputText id="BUYER_NM" name="BUYER_NM" value="${ses.companyNm}" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
		</e:field>
      	<e:label for="ENTRUST_COMP_CD" title="${form_ENTRUST_COMP_CD_N}"/>
		<e:field>
			<e:search id="ENTRUST_COMP_CD" name="ENTRUST_COMP_CD" value="" width="40%" maxLength="${form_ENTRUST_COMP_CD_M}" onIconClick="${form_ENTRUST_COMP_CD_RO ? 'everCommon.blank' : 'getEntrustBuyer'}" disabled="${form_ENTRUST_COMP_CD_D}" readOnly="${form_ENTRUST_COMP_CD_RO}" required="${form_ENTRUST_COMP_CD_R}" maskType="${form_ENTRUST_COMP_CD_MT}" placeHolder="회사코드" />
			<e:inputText id="ENTRUST_COMP_NM" name="ENTRUST_COMP_NM" value="" width="60%" maxLength="${form_ENTRUST_COMP_NM_M}" disabled="${form_ENTRUST_COMP_NM_D}" readOnly="${form_ENTRUST_COMP_NM_RO}" required="${form_ENTRUST_COMP_NM_R}" style="${imeMode}" maskType="${form_ENTRUST_COMP_NM_MT}" placeHolder="회사명"/>
		</e:field>
      </e:row>
      <e:row>
		<e:label for="SUBJECT" title="${form_SUBJECT_N}" />
		<e:field>
			<e:inputText id="SUBJECT" name="SUBJECT" value="" width="100%" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
		</e:field>
		<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
		<e:field>
			<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="100%" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" useMultipleSelect="true"/>
		</e:field>
		<e:label for="REQ_USER_NM" title="${form_REQ_USER_NM_N}" />
		<e:field>
			<e:inputText id="REQ_USER_NM" name="REQ_USER_NM" value="" width="100%" maxLength="${form_REQ_USER_NM_M}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}" style="${imeMode}" maskType="${form_REQ_USER_NM_MT}"/>
		</e:field>
      </e:row>
    </e:searchPanel>
    
    <!-- Button 영역 -->
    <e:buttonBar width="100%" align="right">
      <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
      <e:button id="doNew" name="doNew" label="${doNew_N}" onClick="doNew" disabled="${doNew_D}" visible="${doNew_V}"/>
      <e:button id="doCancel" name="doCancel" label="${doCancel_N}" onClick="doCancel" disabled="${doCancel_D}" visible="${doCancel_V}"/>
    </e:buttonBar>
    
    <!-- Grid 영역 -->
    <e:gridPanel id="grid" name="grid"  gridType="${_gridType}" width="100%" height="fit"/>
    
  </e:window>
</e:ui>
