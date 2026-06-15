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
				
				//2021.09.03 첨부파일 클릭 시 평가담당자 본인이 아닌경우 detailView true로 설정 적용
				var evUserId = EVF.C("EV_USER_ID").getValue();
				var isAuthUser = false;
				if(evUserId == '${ses.userId}') {
					isAuthUser = true;
				}
				
                if (colIdx == 'TECH_RMK') {
                    var param = {
                        title: "${CBDI0035_T006}",
                        message: grid.getCellValue(rowIdx, 'TECH_RMK'),
                        callbackFunction: 'setRMK',
                        rowIdx: rowIdx
                    };
                    everPopup.commonTextInput(param);
                }
                if(colIdx == "TECH_ATT_FILE_CNT") {
                    var param = {
                        attFileNum: grid.getCellValue(rowIdx, 'TECH_ATT_FILE_NUM'),
                        rowIdx: rowIdx,
                        callBackFunction: 'setFileAttach',
                        bizType: 'CBDR',
                        detailView: (isAuthUser ? false : true)
                    };
                    everPopup.fileAttachPopup(param);
                }
			});

			grid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {

				if (colIdx == "TECH_SCORE") {

		            var contType2     = EVF.C("CONT_TYPE2").getValue();
					var docTechScore  = Number(EVF.V("TECH_SCORE"));
					var thisTechScore = Number(grid.getCellValue(rowIdx, 'TECH_SCORE'));

					if(contType2 != "NE") {
						docTechScore = 100;
					}

					if(!EVF.isEmpty(thisTechScore) && thisTechScore >= 0) {
						if(docTechScore < thisTechScore) {
							grid.setCellValue(rowIdx, 'TECH_SCORE', null);
							return EVF.alert("${CBDI0035_T007}" + " '" + docTechScore + "'" + "${CBDI0035_T008}");
						}
					}
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
	        store.load(baseUrl + 'cbdi0035_doSearch.so', function() {
	        	if(grid.getRowCount() > 0){
                    grid.checkAll(true);
                    grid.setColIconify("TECH_RMK", "TECH_RMK", "comment", false);
	        	}
	        });
	    }

	    function doConfirm() {

	    	var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};

            grid.checkAll(true);

	    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	    	if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

            var contType2 = EVF.C("CONT_TYPE2").getValue();
	    	var docTechScore = Number(EVF.V("TECH_SCORE"));

	    	var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(contType2 == "NE") {
					if(Number(grid.getCellValue(rowIds[i], 'TECH_SCORE')) > docTechScore) {
						return EVF.alert("${CBDI0035_T007}" + " '" + docTechScore + "'" + "${CBDI0035_T008}");
					}
				}
				if(Number(grid.getCellValue(rowIds[i], 'TECH_SCORE')) < 0) {
					return EVF.alert("${CBDI0035_T009}");
				}
			}

            EVF.confirm("${CBDI0035_T004 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'cbdi0035_doConfirm.so', function(){

                    EVF.alert(this.getResponseMessage(), function() {
                        if(popupFlag) {
                        	if(contType2 == "NE") {
                            	opener.doSearch();
                        	} else {
                                opener.doOpenEvSpec(EVF.C("BUYER_CD").getValue(), EVF.C("BID_NUM").getValue(), EVF.C("BID_CNT").getValue(), contType2);
                        	}
                            doClose();
                        }
                    });
                });
            });
		}

        function setFileAttach(rowIdx, fileId, fileCnt) {
            grid.setCellValue(rowIdx, 'TECH_ATT_FILE_CNT', fileCnt);
            grid.setCellValue(rowIdx, 'TECH_ATT_FILE_NUM', fileId);
        }

        function setRMK(data) {
            grid.setCellValue(data.rowIdx, "TECH_RMK", data.message);
            grid.setColIconify("TECH_RMK", "TECH_RMK", "comment", false);
        }

	    function doClose() {
			EVF.closeWindow();
        }

    </script>
	<e:window id="CBDI0035" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
		<e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
		<e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
		<e:inputHidden id="CONT_TYPE2" name="CONT_TYPE2" value="${formData.CONT_TYPE2}" />
		<e:inputHidden id="VOTE_CNT" name="VOTE_CNT" value="${formData.VOTE_CNT}" />
    	<e:inputHidden id="BID_STATUS" name="BID_STATUS" value="${formData.BID_STATUS}" />
    	<e:inputHidden id="BID_USER_ID" name="BID_USER_ID" value="${formData.BID_USER_ID}" />
    	<e:inputHidden id="EV_USER_ID" name="EV_USER_ID" value="${formData.EV_USER_ID}" />
    	<e:inputHidden id="TECH_SCORE" name="TECH_SCORE" value="${formData.TECH_SCORE}" />

		<%-- 입찰공고 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDI0035_T001 }</div>
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
				<e:label for="EV_USER_NM" title="${form_EV_USER_NM_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.EV_USER_NM } </e:text>
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 규격평가등록결과 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDI0035_T002 }</div>
		</div>
		<e:gridPanel id="grid" name="grid" width="100%" height="305px" gridType="${_gridType}" readOnly="${param.detailView}" />

		<e:buttonBar id="buttonBar" align="right" width="100%" title="${form_CAPTION3_N }">
			<e:button id="Confirm" name="Confirm" label="${Confirm_N }" disabled="${Confirm_D }" visible="${Confirm_V}" onClick="doConfirm" />
			<e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
		</e:buttonBar>

	</e:window>
</e:ui>