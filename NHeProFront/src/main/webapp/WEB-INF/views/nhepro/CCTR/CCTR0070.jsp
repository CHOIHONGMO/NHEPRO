<%--
  Date: 2020-06-10
  Time: 15:01:18
  Scrren ID : CCTR0070
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>

<%
	String ozSchedulerIp = PropertiesManager.getString("oz.scheduler.ip");
	String ozSchedulerPort = PropertiesManager.getString("oz.scheduler.port");
%>

<c:set var="ozExportUrl" value="<%=ozExportUrl%>" />
<c:set var="ozUrl" value="<%=ozUrl%>" />
<c:set var="ozServer" value="<%=ozServer%>" />
<c:set var="ozSchedulerIp" value="<%=ozSchedulerIp%>" />
<c:set var="ozSchedulerPort" value="<%=ozSchedulerPort%>" />

<%-- 위임장을 전자서명 및 반려할 수 있는 상태(전자서명대기(W), 임시저장(T) --%>
<c:set var="editableStatus" value="${form.PROGRESS_CD eq 'T'}" />
                                     
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
  <script>

    var grid;
    var baseUrl = '/nhepro/CCTR/CCTR0070';

    function init() {
    	grid = EVF.C("grid");
    	grid.setProperty("shrinkToFit", true);
		grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
		grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
		grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
		grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
		grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
		grid.setProperty("multiSelect", ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
		grid.setProperty("singleSelect", ${singleSelect});
		
        if( ${!param.detailView} ){
	        grid.delRowEvent(function() {
	            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				grid.delRow();
			});
        }
        
        grid.dupRowEvent(function(rowId) {
			EVF.alert(rowId);
        }, ["ENTRST_COMP_CD", "ENTRST_OFCE_CD"]);
        
        // Grid Excel Event
        grid.excelExportEvent({
          allItems : "${excelExport.allCol}",
          fileName : "${screenName }"
        });
        
    	// 버튼 처리
    	setButtons();
    	
    	// Detail 조회
    	if( '${param.REQ_NUM}' != '' ) {
        	doSearch();
    	}
    	<c:if test="${!param.detailView}">
			grid.addRowEvent(function () {
					getBuyerCd();
			});
		</c:if>
    }
    
	
	function getBuyerCd() {

		var param = {
			'callBackFunction': 'setBuyerCd',
			'READONLY': 'Y',	//팝업 조회조건 변경불가
			'CORP_TYPE': '2',	//지역농축협(2) : NH0002
			'multiYN': 'Y',		//멀티팝업여부
			'detailView': false,
			'WORK_TYPE': 1
		};
		everPopup.openPopupByScreenId("CCDU0030", 1000, 700, param);
	}
	
	function setBuyerCd(data) {
		
		var setData = valid.equalPopupValid(JSON.stringify(data), grid, "VENDOR_NM");
		
		var rowIds = grid.getAllRowId();
		for(var s in setData) {
			var cnt = 0;
			for(var i in setData) {
				if(setData[s].VENDOR_NM == setData[i].VENDOR_NM) {
					cnt++;
				}
				if(cnt > 1) {
					return EVF.alert("동일한 농축협 정보가 존재합니다.");
				}
			}
		}
		callBackCUST_CD(setData);
		//for(var s in setData) {
		//	grid.addRow(setData[s]);
		//}
	}
	
    function setButtons() {
		if( ${!param.detailView} ){
			EVF.C('doSave').setVisible(true); // 임시저장
			EVF.C('doRequest').setVisible(true); // 요청
			<c:if test="${editableStatus}">
				EVF.C('doCancel').setVisible(true); // 취소
			</c:if>
			EVF.C('openCustomer').setVisible(true); // 위임회사 검색
		} else {
			EVF.C('doSave').setVisible(false); // 임시저장
			EVF.C('doRequest').setVisible(false); // 요청
			EVF.C('doCancel').setVisible(false); // 취소
			EVF.C('openCustomer').setVisible(false); // 위임회사 검색
		}
	}
    
 	// 조회
    function doSearch() {
      var store = new EVF.Store();
      store.setGrid([grid]);
      store.load(baseUrl+'/doSearch.so', function() {
      });
    }
 	
    // 임시저장
    function doSave() {
    	doApproval("T");
    }

    // 요청 (요청전에는 위임장이 생성되어야 한다.)
    function doRequest() {
    	doApproval("W");
    }
    
    function doApproval(val) {
      var store = new EVF.Store();

      // form validation Check
      if(!store.validate()) return;
      
      if(grid.getRowCount() == 0){
		return EVF.alert("${CCTR0070_0004}");
	  }
      
      if( val == 'W') {
    	if( !confirm("${CCTR0070_0001}") ) return;
      }
      
   	  store.doFileUpload(function() {
	      store.setGrid([grid]);
	      store.getGridData(grid, 'all');
	      store.setParameter('PROGRESS_CD', val);
	      // >, <, ' 치환 - 한글에서 기호 눌러서 유사한 기호 가져옴
	      var contentClob = EVF.V("CONTENTS_CLOB").replace(/&gt;/g,"＞").replace(/&lt;/g,"＜").replace(/&#39;/g,"＇");
	      EVF.V("CONTENTS_CLOB", contentClob);
	      
	      store.load(baseUrl+'/doSave.so', function() {
	    	  var buyerCd = this.getParameter('BUYER_CD');
	    	  var reqNum  = this.getParameter('REQ_NUM');
	    	  
	          EVF.alert(this.getResponseMessage(), function() {
	              if(opener) {
	                  opener.doSearch();
	            	  if( val == "W" ) { // 서명요청
	            		  doClose();
	            	  } else {
	    	        	  var param = {
	    	        			'BUYER_CD': buyerCd,
								'REQ_NUM': reqNum,
								'detailView': false,
								'popupFlag': true
						  };
	    	        	  document.location.href = '/nhepro/CCTR/CCTR0070/view.so?' + $.param(param);
    	        	  }
	              } else {
	                  document.location.href = "/nhepro/CCTR/CCTR0070/view.so?";
	              }
	          });
	      });
      });
    }
	
    // 취소
	function doCancel() {

		var store = new EVF.Store();
		var progressCd = EVF.V("PROGRESS_CD") == ""?"T":EVF.V("PROGRESS_CD");
		if( progressCd == "T" ){
			EVF.confirm("${CCTR0070_0002}", function() {
				store.load(baseUrl + "/doCancel.so", function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        if(opener) {
                            opener.doSearch();
                            doClose();
                        } else {
                            document.location.href = "/nhepro/CCTR/CCTR0070/view.so?";
                        }
                    });
                });
		    });
		}
	}
	
    // eform으로 위임장 템플릿 보기
    function opEntrustForm(param){
    	
    	if(EVF.V("REQ_NUM")== null || EVF.V("REQ_NUM")=='' ){
    		return EVF.alert("${CCTR0070_0006}");
    	} 
    	
    	var param = {
    			ozrName: "CCTA0070",
    			odiName: "CCTA0070",
    			BUYER_CD: EVF.V("BUYER_CD"),
    			USER_ID: EVF.V("REQ_USER_ID"),
    			REQ_NUM: EVF.V("REQ_NUM"),
    			REQ_SEQ : "${param.REQ_SEQ}" == null ? '1' : "${param.REQ_SEQ}"  ,
    			exportFormat: "ozr",
    			SUB_FORM_FILE_NM: ""
    		};
	    var url = "${ozUrl}" + "/ozhviewer_canvas_eform.jsp";
    	everPopup.openWindowPopup(url, 1085, 900, param, 'eform');
	}
    
    function checkTelNo() { 

        if(!everString.isTel(EVF.V("REQ_USER_TEL_NUM"))) {
            EVF.V("REQ_USER_TEL_NUM", "");
            EVF.C('REQ_USER_TEL_NUM').setFocus();
            EVF.alert("${msg.M0128}");
        }
    }
    
    // 창닫기
    function doClose() {
        EVF.closeWindow();
    }
    
    function openCustomer() {
    	var param = {
				'callBackFunction': 'callBackCUST_CD',
				'READONLY': 'Y',	//팝업 조회조건 변경불가
				'RELAT_YN': '0',	//농협(0), 비농협(1) : NH0005
				'CORP_TYPE': '2',	//지역농축협(2) : NH0002
				'multiYN': 'Y',		//멀티팝업여부
				'viewFlag': 'EN',	//화면구분(EN:위임장)
				'detailView': false
		};
		everPopup.openPopupByScreenId("CCDU0030", 1000, 700, param);
    }

    
    function callBackCUST_CD(paramData) {
    	var data = customEqualPopupValid(JSON.stringify(paramData), grid, "CHECK_DUP");
    	for(var idx in data) {
            var rowIdx = grid.addRow(data[idx]);
            grid.setCellValue(rowIdx, "ENTRST_IRS_NO",  data[idx].IRS_NUM);
            grid.setCellValue(rowIdx, "ENTRST_COMP_CD", data[idx].CUST_CD);
            grid.setCellValue(rowIdx, "ENTRST_COMP_NM", data[idx].CUST_NM);
            grid.setCellValue(rowIdx, "ENTRST_OFCE_CD", data[idx].DEPT_CD);
            grid.setCellValue(rowIdx, "ENTRST_OFCE_NM", data[idx].DEPT_NM);
            grid.setCellValue(rowIdx, "VENDOR_PIC_USER_NM", data[idx].VENDOR_PIC_USER_NM);
            grid.setCellValue(rowIdx, "VENDOR_PIC_USER_EMAIL", data[idx].VENDOR_PIC_USER_EMAIL);
            grid.setCellValue(rowIdx, "VENDOR_PIC_USER_CELL_NUM", data[idx].VENDOR_PIC_USER_CELL_NUM);
        }
    }
    
    
    // valid.equalPopupValid 의 alert 데이터 수정 
    function customEqualPopupValid(data, addGrid, column) {
    	data = JSON.parse(data);
        // 동일코드 여부 확인
        var grdhStr = "";
        var rowCount = addGrid.getRowCount();
        if(rowCount > 0) {
            for(var i = 0; i < rowCount; i++) {
                for(var idx in data ) {
                    if(addGrid.getCellValue(i, "ENTRST_COMP_NM") == data[idx]["CUST_NM"]) {
                        grdhStr +=  data[idx]["CUST_NM"]+"\n";

                        // 동일 데이터 삭제
                        data.splice(idx,1);
                    }
                }
            }

            if(grdhStr != "")
                EVF.alert("동일한 농축협이 존재하여, 이를 제외합니다. \n제외 농축협명 : \n\n"+grdhStr.substring(0, grdhStr.length -1));
                return data;
        } else {
                return data;
        }
    }
    
  </script>

  <e:window id="CCTR0070" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
    <!-- Button 영역 -->
  	<e:buttonBar width="100%" align="right" title="위임내용">
      <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
      <e:button id="doRequest" name="doRequest" label="${doRequest_N}" onClick="doRequest" disabled="${doRequest_D}" visible="${doRequest_V}"/>
      <e:button id="doCancel" name="doCancel" label="${doCancel_N}" onClick="doCancel" disabled="${doCancel_D}" visible="${doCancel_V}"/>
      <e:button id="opEntrustForm" name="opEntrustForm" label="${opEntrustForm_N}" onClick="opEntrustForm" disabled="${opEntrustForm_D}" visible="${opEntrustForm_V}"/>
    </e:buttonBar>
  	
  	<!-- 조회조건 영역 -->
    <e:searchPanel id="form" title="${form_CAPTION_N}" labelWidth="135" width="100%" columnCount="3" useTitleBar="false" onEnter="">
      <e:inputHidden id='BUYER_CD' name='BUYER_CD' value='${empty form.BUYER_CD ? ses.companyCd : form.BUYER_CD}'/>
      <e:inputHidden id='REQ_SEQ' name='REQ_SEQ' value='${form.REQ_SEQ}'/>
      <e:inputHidden id='PROGRESS_CD' name='PROGRESS_CD' value='${form.PROGRESS_CD}'/>
      <e:inputHidden id='REQ_USER_DEPT_CD' name='REQ_USER_DEPT_CD' value='${empty form.REQ_USER_DEPT_CD ? ses.deptCd : form.REQ_USER_DEPT_CD}'/>
      <e:inputHidden id='REQ_USER_ID' name='REQ_USER_ID' value='${empty form.REQ_USER_ID ? ses.userId : form.REQ_USER_ID}'/>
      <e:inputHidden id='EFORM_ID' name='EFORM_ID' value='${form.EFORM_ID}'/>	<%-- 위임장 작성 EFORM ID --%>
      <%--
      <e:inputHidden id="CONT_TEXT_NUM" name="CONT_TEXT_NUM" value="${form.CONT_TEXT_NUM_NUM }" />
      --%>
      
      <e:row>
		<e:label for="REQ_NUM" title="${form_REQ_NUM_N}" />
		<e:field>
			<e:inputText id="REQ_NUM" name="REQ_NUM" value="${form.REQ_NUM}" width="100%" maxLength="${form_REQ_NUM_M}" disabled="${form_REQ_NUM_D}" readOnly="${form_REQ_NUM_RO}" required="${form_REQ_NUM_R}" style="${imeMode}" maskType="${form_REQ_NUM_MT}"/>
		</e:field>
		<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
		<e:field><e:text>${form.PROGRESS_CD_LOC}</e:text></e:field>
		<e:label for="CONT_DATE" title="${form_CONT_DATE_N}"/>
		<e:field>
			<e:inputDate id="CONT_DATE" name="CONT_DATE" value="${form.CONT_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_CONT_DATE_R}" disabled="${form_CONT_DATE_D}" readOnly="${form_CONT_DATE_RO}" />
		</e:field>
      </e:row>
      <e:row>
      	<e:label for="BUYER_NM" title="${form_BUYER_NM_N}" />
		<e:field>
			<e:inputText id="BUYER_NM" name="BUYER_NM" value="${empty form.BUYER_NM ? ses.companyNm : form.BUYER_NM}" width="100%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}"/>
		</e:field>
		<e:label for="REQ_TYPE_CD" title="${form_REQ_TYPE_CD_N}"/>
		<e:field>
			<e:select id="REQ_TYPE_CD" name="REQ_TYPE_CD" value="${form.REQ_TYPE_CD}" options="${reqTypeCdOptions}" width="100%" disabled="${form_REQ_TYPE_CD_D}" readOnly="${form_REQ_TYPE_CD_RO}" required="${form_REQ_TYPE_CD_R}" placeHolder="" maskType="${form_REQ_TYPE_CD_MT}" />
		</e:field>
		<e:label for="RCV_REQ_DATE" title="${form_RCV_REQ_DATE_N}"/>
		<e:field>
			<e:inputDate id="RCV_REQ_DATE" name="RCV_REQ_DATE" value="${empty form.RCV_REQ_DATE ? defaultToDate : form.RCV_REQ_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_RCV_REQ_DATE_R}" disabled="${form_RCV_REQ_DATE_D}" readOnly="${form_RCV_REQ_DATE_RO}" />
		</e:field>
      </e:row>
      <e:row>
      	<e:label for="REQ_USER_DEPT_NM" title="${form_REQ_USER_DEPT_NM_N}" />
		<e:field colSpan="5">
			<e:inputText id="REQ_USER_DEPT_NM" name="REQ_USER_DEPT_NM" value="${empty form.REQ_USER_DEPT_NM ? ses.deptNm : form.REQ_USER_DEPT_NM}" width="100%" maxLength="${form_REQ_USER_DEPT_NM_M}" disabled="${form_REQ_USER_DEPT_NM_D}" readOnly="${form_REQ_USER_DEPT_NM_RO}" required="${form_REQ_USER_DEPT_NM_R}" style="${imeMode}" maskType="${form_REQ_USER_DEPT_NM_MT}"/>
		</e:field>
      </e:row>
      <e:row>
      	<e:label for="REQ_USER_NM" title="${form_REQ_USER_NM_N}" />
		<e:field>
			<e:inputText id="REQ_USER_NM" name="REQ_USER_NM" value="${empty form.REQ_USER_NM ? ses.userNm : form.REQ_USER_NM}" width="100%" maxLength="${form_REQ_USER_NM_M}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}" style="${imeMode}" maskType="${form_REQ_USER_NM_MT}"/>
		</e:field>
		<e:label for="REQ_USER_TEL_NUM" title="${form_REQ_USER_TEL_NUM_N}" />
		<e:field>
			<e:inputText id="REQ_USER_TEL_NUM" name="REQ_USER_TEL_NUM" value="${empty form.REQ_USER_TEL_NUM ? ses.telNum : form.REQ_USER_TEL_NUM}" width="100%" placeHolder="${CCTR0070_INPUT_TEL}" maxLength="${form_REQ_USER_TEL_NUM_M}" disabled="${form_REQ_USER_TEL_NUM_D}" readOnly="${form_REQ_USER_TEL_NUM_RO}" required="${form_REQ_USER_TEL_NUM_R}" style="${imeMode}" maskType="${form_REQ_USER_TEL_NUM_MT}" onChange="checkTelNo" data="TEL_NUM"/>
		</e:field>
		<e:label for="REF_DOC_NO" title="${form_REF_DOC_NO_N}" />
		<e:field>
			<e:inputText id="REF_DOC_NO" name="REF_DOC_NO" value="${form.REF_DOC_NO}" width="100%" maxLength="${form_REF_DOC_NO_M}" disabled="${form_REF_DOC_NO_D}" readOnly="${form_REF_DOC_NO_RO}" required="${form_REF_DOC_NO_R}" style="${imeMode}" maskType="${form_REF_DOC_NO_MT}"/>
		</e:field>
      </e:row>
      <e:row>
      	<e:label for="SUBJECT" title="${form_SUBJECT_N}" />
		<e:field colSpan="5">
			<e:inputText id="SUBJECT" name="SUBJECT" value="${form.SUBJECT}" width="100%" maxLength="100" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
		</e:field>
      </e:row>
      <e:row>
		<e:label for="CONTENTS_CLOB" title="${form_CONTENTS_CLOB_N }" />
		<e:field colSpan="5">
            <e:richTextEditor id="CONTENTS_CLOB" name="CONTENTS_CLOB" width="100%" height="380px" value="${form.CONTENTS_CLOB }" required="${form_CONTENTS_CLOB_R }" readOnly="${form_CONTENTS_CLOB_RO }" disabled="${form_CONTENTS_CLOB_D }" useToolbar="${!param.detailView}" />
		</e:field>
	  </e:row>
	  <%--
      <e:row>
      	<e:label for="CONTENTS" title="${form_CONTENTS_N}"/>
		<e:field colSpan="5">
			<e:textArea id="CONTENTS" name="CONTENTS" value="${form.CONTENTS}" height="100px" width="100%" maxLength="200" disabled="${form_CONTENTS_D}" readOnly="${form_CONTENTS_RO}" required="${form_CONTENTS_R}" />
		</e:field>
      </e:row>
       --%>
       <e:row>
         <e:label for="ATT_CONTENTS" title="${form_ATT_CONTENTS_N}" />
		 <e:field colSpan="5">
			<e:textArea id="ATT_CONTENTS" name="ATT_CONTENTS" value="${form.ATT_CONTENTS}" height="100px" width="100%" maxLength="4000" disabled="${form_ATT_CONTENTS_D}" readOnly="${form_ATT_CONTENTS_RO}" required="${form_ATT_CONTENTS_R}" />
		 </e:field>
	  </e:row>
      <e:row>
		<e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}"/>
		<e:field colSpan="5">
			<e:fileManager id="ATT_FILE_NUM" height="100" width="100%" fileId="${form.ATT_FILE_NUM}" readOnly="${form_ATT_FILE_NUM_RO}" bizType="EN" required="${form_ATT_FILE_NUM_R}"/>
		</e:field>
      </e:row>
      <e:row>
      	<e:label for="RMKS" title="${form_RMKS_N}"/>
		<e:field colSpan="5">
			<e:textArea id="RMKS" name="RMKS" value="${form.RMKS}" height="100px" width="100%" maxLength="4000" disabled="${form_RMKS_D}" readOnly="${form_RMKS_RO}" required="${form_RMKS_R}" />
		</e:field>
      </e:row>
    </e:searchPanel>
    
    
    <!-- 위수탁체결현황 그리드 처럼 변경. 담당자 이메일, 핸드폰주소 등 필요 21.05.14 
  	<e:buttonBar width="100%" align="right">
      <e:button id="openCustomer" name="openCustomer" label="${openCustomer_N}" onClick="openCustomer" disabled="${openCustomer_D}" visible="${openCustomer_V}"/>
    </e:buttonBar>
     -->
    <e:gridPanel id="grid" name="grid"  gridType="${_gridType}" width="100%" height="400px"/>
  </e:window>
</e:ui>
