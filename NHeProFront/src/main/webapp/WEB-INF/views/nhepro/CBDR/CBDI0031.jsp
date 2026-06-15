<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var grid;
	    var eventRowId = 0;
	    var isDetailView = ('${param.detailView}' === 'true' ? true : false);
		var baseUrl = "/nhepro/CBDR/";
		var maxProgressCd;

	    function init() {

            grid = EVF.C("grid");

            grid.cellClickEvent(function(rowIdx, colIdx, value) {

				eventRowId = rowIdx;

                if (colIdx == 'EV_INCO_REASON') {

                	if(isDetailView) {
						var param = {
							title: "${CBDI0031_T006}",
							message: grid.getCellValue(rowIdx, 'EV_INCO_REASON')
						};
						everPopup.commonTextView(param);
					} else {
						var param = {
							title: "${CBDI0031_T006}",
							message: grid.getCellValue(rowIdx, 'EV_INCO_REASON'),
							callbackFunction: 'setRMK',
							detailView : (isDetailView == true ? true : (${havePermission} == true ? false : true)),
							rowIdx: rowIdx
						};
						everPopup.commonTextInput(param);
					}
                }
                if(colIdx == "EV_ATT_FILE_CNT") {
                    var param = {
                        attFileNum: grid.getCellValue(rowIdx, 'EV_ATT_FILE_NUM'),
                        rowIdx: rowIdx,
                        callBackFunction: 'setFileAttach',
                        bizType: 'CBDR',
                        detailView : (isDetailView == true ? true : (${havePermission} == true ? false : true))
                    };
                    everPopup.fileAttachPopup(param);
                }
			});

	        if(${!havePermission}) {
	        	EVF.C('Confirm').setDisabled(true);
	    	} else {
				EVF.C('Confirm').setDisabled(false);
	    	}
	        
			grid.setProperty('shrinkToFit', true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
        	doSearchDT();
	    }

	    function doSearchDT() {

	    	var store = new EVF.Store();
	    	store.setGrid([grid]);
	        store.load(baseUrl + 'cbdi0031_doSearch.so', function() {
	        	if(grid.getRowCount() > 0){
                    grid.checkAll(true);
                    grid.setColIconify("EV_INCO_REASON", "EV_INCO_REASON", "comment", false);
	        	}
	        });
	    }

	    function doConfirm() {

	    	var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};

            grid.checkAll(true);

	    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	    	if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

            EVF.confirm("${CBDI0031_T004 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'cbdi0031_doConfirm.so', function(){

                    EVF.alert(this.getResponseMessage(), function() {
                        if(popupFlag) {
                            <%-- opener.endConfirm(EVF.V("CONT_TYPE2")); --%>
                            opener.doSearch();
                            doClose();
                        }
                    });
                });
            });
		}

        function setFileAttach(rowIdx, fileId, fileCnt) {
            grid.setCellValue(rowIdx, 'EV_ATT_FILE_CNT', fileCnt);
            grid.setCellValue(rowIdx, 'EV_ATT_FILE_NUM', fileId);
        }

        function setRMK(data) {
            grid.setCellValue(data.rowIdx, "EV_INCO_REASON", data.message);
            grid.setColIconify("EV_INCO_REASON", "EV_INCO_REASON", "comment", false);
        }
        
        function doTechResult() {
        	var buyerCd = EVF.C("BUYER_CD").getValue();
        	var bidNum  = EVF.C("BID_NUM").getValue();
        	var bidCnt  = EVF.C("BID_CNT").getValue();
        	//var voteCnt = grid.getCellValue(rowIdx, 'VOTE_CNT');
            var param = {
                    'BUYER_CD' : buyerCd,
                    'BID_NUM' : bidNum,
                    'BID_CNT' : bidCnt,
                    //'VOTE_CNT' : voteCnt,
                    'popupFlag' : true,
                    'detailView' : true
                };
                everPopup.openWindowPopup("/nhepro/CBDR/CBDI0035/view.so", 1100, 600, param, "openDocument", true);
        }

	    function doClose() {
			EVF.closeWindow();
        }

    </script>
	<e:window id="CBDI0031" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
		<e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
		<e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
    	<e:inputHidden id="BID_STATUS" name="BID_STATUS" value="${formData.BID_STATUS}" />
    	<e:inputHidden id="BID_USER_ID" name="BID_USER_ID" value="${formData.BID_USER_ID}" />
    	<e:inputHidden id="CONT_TYPE1" name="CONT_TYPE1" value="${formData.CONT_TYPE1}" />
    	<e:inputHidden id="CONT_TYPE2" name="CONT_TYPE2" value="${formData.CONT_TYPE2}" />
    	<e:inputHidden id="CONT_TYPE3" name="CONT_TYPE3" value="${formData.CONT_TYPE3}" />

		<%-- 입찰공고 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDI0031_T001 }</div>
		</div>
		<e:searchPanel id="form1" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
				<e:field>
					<e:text> ${formData.ANN_NO } </e:text>
				</e:field>
				<e:label for="ANN_DATE" title="${form_ANN_DATE_N}"/>
				<e:field>
					<e:text> ${formData.ANN_DATE } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.ANN_ITEM } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CONT_TYPE_TXT" title="${form_CONT_TYPE_TXT_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.CONT_TYPE_TXT } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BID_USER_NM" title="${form_BID_USER_NM_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.BID_USER_NM } </e:text>
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 규격평가등록결과 --%>
		<%-- <div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDI0031_T002 }</div>
		</div> --%>
		<e:buttonBar width="100%" align="right" title="${CBDI0031_T002 }">
			<e:button id="TechResult" name="TechResult" label="${TechResult_N}" onClick="doTechResult" disabled="${TechResult_D}" visible="${TechResult_V}"/>
		</e:buttonBar>
		<e:gridPanel id="grid" name="grid" width="100%" height="305px" gridType="${_gridType}" readOnly="${param.detailView}" />

		<e:buttonBar id="buttonBar" align="right" width="100%" title="${form_CAPTION3_N }">
			<e:button id="Confirm" name="Confirm" label="${Confirm_N }" disabled="${Confirm_D }" visible="${Confirm_V}" onClick="doConfirm" />
			<e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
		</e:buttonBar>

	</e:window>
</e:ui>