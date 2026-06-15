<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var gridEU;
	    var eventRowId = 0;
	    var isDetailView = ('${param.detailView}' === 'true' ? true : false);
		var baseUrl = "/nhepro/CBDI/";
		var maxProgressCd;

	    function init() {

	    	gridEU = EVF.C("gridEU");

			if(${havePermission}) {

				gridEU.addRowEvent(function() {
					if(Number(maxProgressCd) == 100) {
						var addParam = [
							{"EU_TYPE": "20"}
						];
						gridEU.addRow(addParam);
					} else { EVF.alert("${CBDR0015_T003}"); }
				});

				gridEU.delRowEvent(function() {
					if(Number(maxProgressCd) == 100) {
						if (gridEU.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
						gridEU.delRow();
					} else { EVF.alert("${CBDR0015_T003}"); }
				});
			}

			gridEU.cellClickEvent(function(rowIdx, colIdx, value) {

				eventRowId = rowIdx;

				if(Number(maxProgressCd) == 100) {
					if(colIdx == "EU_USER_ID") {
						var param = {
							callBackFunction : "setEvaluatorGrid"
						};
						everPopup.openCommonPopup(param, 'SP0090');
					}
				} else { EVF.alert("${CBDR0015_T003}"); }
			});

			gridEU.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {

				if (colIdx == "EU_EMAIL") {
					if(!everString.isValidEmail(gridEU.getCellValue(rowIdx, 'EU_EMAIL'))) {
						gridEU.setCellValue(rowIdx, 'EU_EMAIL', '');
						return EVF.alert("${msg.EMAIL_INVALID}");
					}
				}
				if (colIdx == "EU_PHONE_NUM") {
					var CellNum = gridEU.getCellValue(rowIdx, 'EU_PHONE_NUM');
					var rgEx = /(01[016789])[-](\d{4}|\d{3})[-]\d{4}$/g;
					var chkFlg = rgEx.test(CellNum);
					if(!chkFlg){
						gridEU.setCellValue(rowIdx, 'EU_PHONE_NUM', '');
						return EVF.alert("${msg.CELL_NUM_INVALID}");
					}
				}
			});

	        if(${!havePermission}) {
	        	EVF.C('Eval').setDisabled(true);
    			EVF.C('SearchEvaluator').setDisabled(true);
	    	} else {
				EVF.C('Eval').setDisabled(false);
				EVF.C('SearchEvaluator').setDisabled(false);
	    	}

			gridEU.setProperty('shrinkToFit', true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			gridEU.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridEU.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridEU.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridEU.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridEU.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridEU.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			gridEU.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

	        if( ("${formData.BID_NUM }" != null && "${formData.BID_NUM }" != "") || ("${formData.BID_CNT }" != null && "${formData.BID_CNT }" != "")) {
	        	doSearchDT();
	   		}
	    }

	    function doSearchDT() {

	    	var store = new EVF.Store();
	    	store.setGrid([gridEU]);
	        store.load(baseUrl + 'cbdr0015_doSearchEU.so', function() {
	        	if(gridEU.getRowCount() > 0){

					gridEU.checkAll(true);

					var rowIds = gridEU.getAllRowId();
					for(var i in rowIds) {
						maxProgressCd = gridEU.getCellValue(rowIds[i], 'MAX_PROGRESS_CD');
					}
					if(Number(maxProgressCd) > 100) {
						EVF.C('SearchEvaluator').setDisabled(true);
						EVF.C('Eval').setDisabled(true);
					}
	        	}
	        });
	    }

	    function doEval() {

	    	var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};

            gridEU.checkAll(true);

	    	if (gridEU.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	    	if (!gridEU.validate().flag) { return EVF.alert(gridEU.validate().msg); }

	    	if(maxProgressCd != "100") {
	    	    return EVF.alert("${CBDR0015_T003}");
            }

            EVF.confirm("${CBDR0015_T004 }", function () {
                var store = new EVF.Store();
                store.setGrid([gridEU]);
                store.getGridData(gridEU, 'sel');
                store.load(baseUrl + 'cbdr0015_doEval.so', function(){

                    EVF.alert(this.getResponseMessage(), function() {
                        var param = {
                            'buyerCd' : "${param.buyerCd}",
                            'bidNum' : "${param.bidNum}",
                            'bidCnt' : "${param.bidCnt}",
                            'popupFlag' : true,
                            'detailView' : false
                        };
                        if(popupFlag) {
                            opener.doSearch();
                            window.location.href = '/nhepro/CBDI/CBDR0015/view.so?' + $.param(param);
                        }
                        else { document.location.href = '/nhepro/CBDI/CBDR0015/view.so?' + $.param(param); }
                    });
                });
            });
		}

	    function doSearchEvaluator() {
			var param = {
				callBackFunction : "setEvaluator",
				custCd : "${ses.companyCd}"
			};
			everPopup.openCommonPopup(param, 'MP0005');
	    }

	    function setEvaluator(data) {
			if(data.length != 0) {
				for(var v in data) {
					if(data.hasOwnProperty(v)){
						if(!EVF.isEmpty(data[v].USER_ID)) {
							var addParam = [{
								 "EU_TYPE" : "10"
								,"EU_USER_ID" : data[v].USER_ID
								,"EU_USER_NM" : data[v].USER_NM
								,"EU_EMAIL" : data[v].EMAIL
								,"EU_PHONE_NUM" : data[v].CELL_NUM
								,"BUYER_CD" : data[v].COMPANY_CD
								,"EI_NUM" : ''
								,"EU_SQ" : ''
							}];
							var validData = valid.equalPopupValid(JSON.stringify(addParam), gridEU, "EU_USER_ID");
							gridEU.addRow(validData);
						}
					}
				}
			}
	    }

		function setEvaluatorGrid(dataJsonArray) {
			gridEU.setCellValue(eventRowId, 'EU_USER_ID', dataJsonArray.USER_ID);
			gridEU.setCellValue(eventRowId, 'EU_USER_NM', dataJsonArray.USER_NM);
			gridEU.setCellValue(eventRowId, 'EU_EMAIL', dataJsonArray.EMAIL);
			gridEU.setCellValue(eventRowId, 'EU_PHONE_NUM', dataJsonArray.CELL_NUM);
			gridEU.setCellValue(eventRowId, 'BUYER_CD', dataJsonArray.COMPANY_CD);
		}

	    function doClose() {
			EVF.closeWindow();
        }

    </script>
	<e:window id="CBDR0015" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
		<e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
		<e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
		<e:inputHidden id="CONT_TYPE1" name="CONT_TYPE1" value="${formData.CONT_TYPE1}" />
		<e:inputHidden id="CONT_TYPE2" name="CONT_TYPE2" value="${formData.CONT_TYPE2}" />
    	<e:inputHidden id="CONT_TYPE3" name="CONT_TYPE3" value="${formData.CONT_TYPE3}" />
    	<e:inputHidden id="BID_STATUS" name="BID_STATUS" value="${formData.BID_STATUS}" />
    	<e:inputHidden id="EI_NUM" name="EI_NUM" value="${formData.EI_NUM}" />

		<%-- 입찰공고 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDR0015_T001 }</div>
		</div>
		<e:searchPanel id="form1" labelWidth="${longLabelWidth}" width="100%" columnCount="2" useTitleBar="false">
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
				<e:label for="APP_END_DATE" title="${form_APP_END_DATE_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.APP_END_DATE } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="LIMIT_CRIT" title="${form_LIMIT_CRIT_N}" />
				<e:field colSpan="3">
					<e:textArea id="LIMIT_CRIT" name="LIMIT_CRIT" width="100%" height="160px" value="${formData.LIMIT_CRIT }" maxLength="${form_LIMIT_CRIT_M}" disabled="${form_LIMIT_CRIT_D}" readOnly="${form_LIMIT_CRIT_RO}" required="${form_LIMIT_CRIT_R}" style="${imeMode}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PROM_CRIT" title="${form_PROM_CRIT_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.PROM_CRIT } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="" title="${CBDR0015_T002}"/>
				<e:field colSpan="3">

					<e:buttonBar id="evalBtnBar" align="right" width="100%" title="${form_CAPTION_N }">
						<e:button id="SearchEvaluator" name="SearchEvaluator" label="${SearchEvaluator_N }" disabled="${SearchEvaluator_D }" visible="${SearchEvaluator_V}" onClick="doSearchEvaluator" />
					</e:buttonBar>

					<e:gridPanel id="gridEU" name="gridEU" width="100%" height="245px" gridType="${_gridType}" readOnly="${param.detailView}" />

				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%" title="${form_CAPTION3_N }">
			<e:button id="Eval" name="Eval" label="${Eval_N }" disabled="${Eval_D }" visible="${Eval_V}" onClick="doEval" />
			<e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
		</e:buttonBar>

	</e:window>
</e:ui>