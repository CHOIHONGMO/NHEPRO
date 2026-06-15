<%--
  Date: 2020-04-10
  Time: 13:25:26
  Scrren ID : CPRR0020
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
  <script>

    var grid;
    var baseUrl = '/nhepro/CPRI/CPRR0020';

    function init() {

      grid = EVF.C('grid');
      grid.setProperty('shrinkToFit', false);				// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
      grid.setProperty('rowNumbers', ${rowNumbers});	    // 로우의 번호 표시 여부를 지정한다. [true/false]
      grid.setProperty('sortable', ${sortable});		    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
      grid.setProperty('panelVisible', ${panelVisible});    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
      grid.setProperty('enterToNextRow', ${enterToNextRow});// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
      grid.setProperty('acceptZero', ${acceptZero});	    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
      grid.setProperty('multiSelect', ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
      grid.setProperty('singleSelect', true);			    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

      // Grid AddRow Event
      grid.addRowEvent(function() {
        grid.addRow();
      });

      // Grid Excel Event
      grid.excelExportEvent({
        allItems : "${excelExport.allCol}",
        fileName : "${screenName }"
      });

      grid.cellClickEvent(function(rowIdx, colIdx, value) {
      	// cell one click
		if (colIdx == "PR_NUM") {
			param = {
				prNum: grid.getCellValue(rowIdx, "PR_NUM"),
				buyerCd : grid.getCellValue(rowIdx, "BUYER_CD"),
				popupFlag: true,
				detailView : true
			};
			everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
		}
		// IT포탈의 이전계약번호 링크 추가
		if (colIdx == "PRE_CONT_NUM") {
			if( value == "" ) return;
			param = {
					callBackFunction: '',
					BUYER_CD: grid.getCellValue(rowIdx, "PRE_BUYER_CD"),
					CONT_NUM: value,
					CONT_CNT: grid.getCellValue(rowIdx, "PRE_CONT_CNT"),
					url: "/nhepro/CCTR/CCTA0030/view.so",
					detailView: true,
					popupFlag: true
				};
			everPopup.openContractChangeInformation(param);
		}
      });
	  
      // ======================그리드 합계 구하기=======================
      var val = {"visible": true, "count": 1, "height": 15};
      grid.setProperty('footerVisible', val);

      var footer = {
          "styles": {
              "textAlignment": "center",
              "fontBold": true,
              "fontFmaily": "Nanum Gothic",
          },
          "text": "합   계"
      };
      grid.setRowFooter("BUYER_NM", footer);

      var distVal = {
          "styles": {
              "textAlignment": "far",
              "numberFormat" : "#,###.###",
              "fontFmaily": "Nanum Gothic",
              "paddingRight": 5,
              "fontBold": true
          },
          "expression": ["sum"],
          "groupExpression": "sum"
      };
      grid.setRowFooter("PR_AMT_SUM", distVal);
      grid.setRowFooter("SUB_ITEM_CNT", distVal);
      // ===========================================================
      
      grid.setColGroup([
	  	{
			"groupName": '인터페이스정보(IT포탈)',
			"columns": ['PRE_CONT_NUM', 'PRE_CONT_CNT', 'CM_REQ_ID', 'IF_TYPE']
       	}
      ],50);
      
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

    function doModify() {

    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

    	var prNum = ""; var prCnt = ""; var buyerCd = "";
    	var rowIds = grid.getSelRowId();

    	// 한 건만 수정가능합니다.
    	if( rowIds.length > 1){
    		return EVF.alert('${CPRR0020_0004}');
    	}

    	for(var i in rowIds) {
    		prNum = grid.getCellValue(rowIds[i], 'PR_NUM');
    		buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');


       		if (
       			   grid.getCellValue(rowIds[i], 'IF_TYPE') == 'ITA'
           		|| grid.getCellValue(rowIds[i], 'IF_TYPE') == 'ITB'
       		) {
				return EVF.alert('${CPRR0020_0005}');
    		}


    		// 작성중인 건만 수정가능합니다.
    		if (
    				 grid.getCellValue(rowIds[i], 'SIGN_STATUS') == 'E'
        			|| grid.getCellValue(rowIds[i], 'SIGN_STATUS') == 'P'
    		) {
				return EVF.alert('${CPRR0020_0002}');
    		}
    		// 본인 건만 수정가능합니다.
    		if (grid.getCellValue(rowIds[i], 'REG_USER_ID') != '${ses.userId}') {
				return EVF.alert('${CPRR0020_0003}');
    		}

		}

    	var param = {
			'prNum': prNum,
			'buyerCd': buyerCd,
			'detailView': false,
			'popupFlag': true
		};
		everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
    }

    function doSearchUser() {
        var userType = "${ses.userType}";
        var custCd = "${ses.companyCd}";

        if(userType == "O") {
            everPopup.openCommonPopup({
                callBackFunction: 'selectUser'
            }, 'SP0012');
        } else {
            param = {
					'callBackFunction': 'selectUser',
					'multiYN' : 'N',         //멀티팝업여부
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }
    }

    function selectUser(data) {
    	if(data!=null){
    		data = JSON.parse(data);

    		EVF.V("REQ_USER_ID", data.USER_ID);
    		EVF.V("REQ_USER_NM", data.USER_NM);
    	}
    }

    function getEcBuyerCd() {
		param = {
				'callBackFunction': 'ecBuyerNmCallback',
				'detailView': false,
				callBackFunction: "setEcBuyerCd"
			};
			everPopup.openCommonPopup(param, "SP0119");
	}
	function setEcBuyerCd(data) {

		EVF.V("EC_BUYER_NM", data.BUYER_NM + ' ' +data.DEPT_NM);
		EVF.V("EC_BUYER_CD", data.BUYER_CD);
		EVF.V("EC_DEPT_CD", data.DEPT_CD);

	}

  </script>

  <e:window id="CPRR0020" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
    <e:searchPanel id="form" columnCount="3" labelWidth="${labelWidth }" onEnter="doSearch" useTitleBar="false">
	    <e:row>
	      	<!-- 요청 일자 -->
	        <e:label for="REQ_DATE_FROM" title="${form_REQ_DATE_FROM_N}"/>
			<e:field>
				<e:inputDate id="REQ_DATE_FROM" name="REQ_DATE_FROM" value="${fromDate}" width="${inputDateWidth}" datePicker="true" required="${form_REQ_DATE_FROM_R}" disabled="${form_REQ_DATE_FROM_D}" readOnly="${form_REQ_DATE_FROM_RO}" />
				<e:text>~</e:text>
				<e:inputDate id="REQ_DATE_TO" name="REQ_DATE_TO" value="${toDate}" width="${inputDateWidth}" datePicker="true" required="${form_REQ_DATE_TO_R}" disabled="${form_REQ_DATE_TO_D}" readOnly="${form_REQ_DATE_TO_RO}" />
			</e:field>
			<!-- 의뢰번호/명 -->
	        <e:label for="PR_NUM" title="${form_PR_NUM_N}"/>
			<e:field>
				<e:inputText id="PR_NUM" name="PR_NUM" value="${form.PR_NUM}" width="${form_PR_NUM_W}" maxLength="${form_PR_NUM_M}" disabled="${form_PR_NUM_D}" readOnly="${form_PR_NUM_RO}" required="${form_PR_NUM_R}"  maskType="${form_PR_NUM_MT}" />
			</e:field>
	        <e:label for="PR_SUBJECT" title="${form_PR_SUBJECT_N}"/>
			<e:field>
				<e:inputText id="PR_SUBJECT" name="PR_SUBJECT" value="${form.PR_SUBJECT}" width="${form_PR_SUBJECT_W}" maxLength="${form_PR_SUBJECT_M}" disabled="${form_PR_SUBJECT_D}" readOnly="${form_PR_SUBJECT_RO}" required="${form_PR_SUBJECT_R}"  maskType="${form_PR_SUBJECT_MT}" />
			</e:field>
	    </e:row>
	    <e:row>
	    	<!-- 진행상태 -->
	    	<e:label for="SIGN_STATUS" title="${form_SIGN_STATUS_N}"/>
			<e:field>
				<e:select id="SIGN_STATUS" name="SIGN_STATUS" value="" options="${signStatusOptions}" width="${form_SIGN_STATUS_W}" disabled="${form_SIGN_STATUS_D}" readOnly="${form_SIGN_STATUS_RO}" required="${form_SIGN_STATUS_R}" placeHolder="" maskType="${form_SIGN_STATUS_MT}" />
			</e:field>
			<!-- 요청자 -->
			<e:label for="REQ_USER_NM" title="${form_REQ_USER_NM_N}"/>
			<e:field>
	            <e:search id="REQ_USER_ID" name="REQ_USER_ID" value="${ses.userId}"  width="40%" maxLength="${form_REQ_USER_NM_M}" onIconClick="${form_REQ_USER_NM_D ? 'everCommon.blank' : 'doSearchUser'}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}" placeHolder="개인번호" onKeyUp="removeUserId" maskType="${form_REQ_USER_NM_MT}" />
				<e:inputText id="REQ_USER_NM" name="REQ_USER_NM" value="${ses.userNm}" width="60%" maxLength="${form_REQ_USER_NM_M}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}" style="${imeMode}" maskType="${form_REQ_USER_NM_MT}" placeHolder="성명"/>
			</e:field>
			<e:label for="CM_REQ_ID" title="${form_CM_REQ_ID_N}" />
			<e:field>
				<e:inputText id="CM_REQ_ID" name="CM_REQ_ID" value="" width="${form_CM_REQ_ID_W}" maxLength="${form_CM_REQ_ID_M}" disabled="${form_CM_REQ_ID_D}" readOnly="${form_CM_REQ_ID_RO}" required="${form_CM_REQ_ID_R}" style="${imeMode}" maskType="${form_CM_REQ_ID_MT}"/>
			</e:field>
	    </e:row>
    </e:searchPanel>

    <e:buttonBar id="buttonBar" align="right" width="100%">
		<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
		<e:button id="doModify" name="doModify" label="${doModify_N}" onClick="doModify" disabled="${doModify_D}" visible="${doModify_V}"/>
	</e:buttonBar>
    <e:gridPanel id="grid" name="grid"  gridType="${_gridType}" width="100%" height="fit"/>
  </e:window>
</e:ui>
