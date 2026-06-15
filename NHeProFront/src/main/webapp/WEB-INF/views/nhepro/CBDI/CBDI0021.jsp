<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var grid;
	    var eventRowId = 0;
	    var isDetailView = ('${param.detailView}' === 'true' ? true : false);
		var baseUrl = "/nhepro/CBDI/";
		var maxProgressCd;

	    function init() {

            grid = EVF.C("grid");
            grid.cellClickEvent(function(rowIdx, colIdx, value) {
				eventRowId = rowIdx;
				var bidStatus = Number(EVF.V("BID_STATUS"));
                if(colIdx == "APP_ATT_FILE_CNT") {
	        		if(!EVF.isEmpty(grid.getCellValue(rowIdx, 'APP_ATT_FILE_CNT'))) {
	                    var param = {
	                            attFileNum: grid.getCellValue(rowIdx, 'APP_ATT_FILE_NUM'),
	                            rowIdx: rowIdx,
	                            callBackFunction: '',
	                            bizType: 'BID',
	                            detailView : true
	                        };
	                        everPopup.fileAttachPopup(param);
	        		}
                }
                if(colIdx == "GUAR_CNT") {
	        		if(!EVF.isEmpty(grid.getCellValue(rowIdx, 'GUAR_CNT'))) {
	                    var param = {
	                            attFileNum: grid.getCellValue(rowIdx, 'GUAR_ATT_FILE_NUM'),
	                            rowIdx: rowIdx,
	                            callBackFunction: '',
	                            bizType: 'BID',
	                            detailView : true
	                        };
	                        everPopup.fileAttachPopup(param);
	        		}
                }
                if (colIdx == 'INCO_REASON') {
                    var param = {
                        title: "${CBDI0021_T006}",
                        message: grid.getCellValue(rowIdx, 'INCO_REASON'),
                        callbackFunction: 'setRMK',
                        detailView : (isDetailView == true ? true : (${havePermission} == true ? (bidStatus >= 2350 ? true : false) : true)),
                        rowIdx: rowIdx
                    };
                    everPopup.commonTextInput(param);
                }
                if(colIdx == "ATT_FILE_CNT") {
                    var param = {
                        attFileNum: grid.getCellValue(rowIdx, 'ATT_FILE_NUM'),
                        rowIdx: rowIdx,
                        callBackFunction: 'setFileAttach',
                        bizType: 'CBDI',
                        detailView : (isDetailView == true ? true : (${havePermission} == true ? (bidStatus >= 2350 ? true : false) : true))
                    };
                    everPopup.fileAttachPopup(param);
                }
			});

	        if(${!havePermission}) {
	        	EVF.C('BidClose').setDisabled(true);
    			EVF.C('FailBidding').setDisabled(true);
    			EVF.C('ReAnn').setDisabled(true);
	    	} else {
	        	if(Number(EVF.V("BID_STATUS")) >= 2350) {
					EVF.C('BidClose').setDisabled(true);
					EVF.C('FailBidding').setDisabled(true);
					EVF.C('ReAnn').setDisabled(true);
				} else {
					EVF.C('BidClose').setDisabled(false);
					EVF.C('FailBidding').setDisabled(false);
					EVF.C('ReAnn').setDisabled(false);
				}
	    	}

			grid.setProperty('shrinkToFit', ${shrinkToFit});					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
			// 2020.12.07 추가
			// 입찰 참가신청 결과등록 그룹화
			// 2023.09.18 추가
			// 낙찰자결정방법이 협상에의한낙찰자선정(NE)인 경우 사업예산초과여부(협력업체의 1차입찰금액이 예산금액 초과여부) 항목을 보여줌
			// 2024.05.31 추가
			// 낙찰자결정방법이 협상에의한낙찰자선정(NE)인 경우 예정가격초과여부(협력업체의 1차입찰금액이 예정가격 초과여부) 항목을 보여줌
			if('${formData.CONT_TYPE2}' == 'NE') {
				grid.setColGroup([
	                {
	                    "groupName": '구매사 입찰결과 등록',
	                    "columns": ['UNT_FLAG', 'PR_AMT_OVER_FLAG', 'ESTM_AMT_OVER_FLAG', 'ACHV_FLAG', 'FINAL_FLAG', 'INCO_REASON', 'ATT_FILE_CNT']
	                }
	            ],50);
			} else {
				grid.setColGroup([
	                {
	                    "groupName": '구매사 입찰결과 등록',
	                    "columns": ['UNT_FLAG', 'ACHV_FLAG', 'FINAL_FLAG', 'INCO_REASON', 'ATT_FILE_CNT']
	                }
	            ],50);
				
				grid.hideCol('PR_AMT_OVER_FLAG', true);
				grid.hideCol('PR_AMT_OVER_FLAG', true);
			}
			
        	doSearchDT();
        	setLinkStyle(); 
	    }

	    function setLinkStyle() {
	    	grid.setColFontColor("GUAR_NUM", "#FF0000");
        }
	    
	    function doSearchDT() {

	    	var store = new EVF.Store();
	    	store.setGrid([grid]);
	        store.load(baseUrl + 'cbdi0021_doSearch.so', function() {
	        	if(grid.getRowCount() > 0){

                    grid.checkAll(true);
                    grid.setColIconify("INCO_REASON", "INCO_REASON", "comment", false);

                    var nonValidCnt = 0;
					var rowIds = grid.getAllRowId();
					for(var i = 0; i < rowIds.length; i++) {
						if(grid.getCellValue(rowIds[i], 'APP_DATETIME') == "-") {
							grid.setCellValue(rowIds[i], 'FINAL_FLAG', "600");
							grid.setCellReadOnly(rowIds[i], 'FINAL_FLAG', true);
						}
						if(grid.getCellValue(rowIds[i], 'CHECK_CERTV') == "N") {
							nonValidCnt++;
						}
					}
					if(nonValidCnt > 0) {
						EVF.C('BidClose').setDisabled(true);
						return EVF.alert("${CBDI0021_T010}");
					}
	        	}
	        });
	    }

	    function doBidClose() {

	    	var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};

            grid.checkAll(true);

	    	if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

	    	var validCnt = 0;
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'FINAL_FLAG') == "600" && EVF.isEmpty(grid.getCellValue(rowIds[i], 'INCO_REASON'))) {
					return EVF.alert("${CBDI0021_T005}");
				}

				if(grid.getCellValue(rowIds[i], 'FINAL_FLAG') == "500") {
					validCnt++;
				}
			}
			
			// 2021.05.24 적합한 협력사 1개 이상인 경우에만 마감할 수 있도록 함
			if(validCnt < 1) {
				return EVF.alert("${CBDI0021_T011}");
			}
			
            EVF.confirm("${CBDI0021_T004 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'cbdi0021_doBidClose.so', function(){

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
                            <%-- window.location.href = '/nhepro/CBDI/CBDI0021/view.so?' + $.param(param); --%>
							doClose();
                        }
                        else { document.location.href = '/nhepro/CBDI/CBDI0021/view.so?' + $.param(param); }
                    });
                });
            });
		}

	    function doFailBidding() {

	    	var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};

            EVF.confirm("${CBDI0021_T009 }", function () {
                var store = new EVF.Store();
                store.load(baseUrl + 'cbdi0021_doFailBidding.so', function(){

                    EVF.alert(this.getResponseMessage(), function() {
                        if(popupFlag) {
                            opener.doSearch();
                        }
						doClose();
					});
                });
            });
		}

        function doReAnn() {

	        <%-- 이전 공고를 '유찰'시킨 후, 새로운 공고를 작성하기 위한 Popup창을 띄운다. --%>
            var store = new EVF.Store();
            EVF.confirm("${CBDI0021_T012 }", function () {
            	// 2021.04.22 변경
                // 기존 유찰 처리 => 재공고 가능 진행상태 체크로 변경
            	//store.load('/nhepro/CBDR/cbdr0033_doFailBid.so', function(){
            	store.load('/nhepro/CBDR/cbdr0033_doCheckWithReAnn.so', function(){
                    var param = {
                        'buyerCd' : EVF.V('BUYER_CD'),
                        'bidNum' : EVF.V('BID_NUM'),
                        'bidCnt' : EVF.V('BID_CNT'),
                        'preBidNum' : EVF.V('BID_NUM'),
                        'preBidCnt' : EVF.V('BID_CNT'),
                        'preVoteCnt' : EVF.V('VOTE_CNT'),
                        'baseDataType': "ReBID",
                        'callbackFunction': "doCallBackFunction",
                        'popupFlag' : true,
                        'detailView' : false
                    };

                    everPopup.openWindowPopup("/nhepro/CBDI/CBDI0011/view.so", 1300, 800, param, "modBidNotice", true);
                });
            });
        }

        function doCallBackFunction() {
            var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
            if(popupFlag) {
                opener.doSearch();
                doClose();
            }
        }

        function setFileAttach(rowIdx, fileId, fileCnt) {
            grid.setCellValue(rowIdx, 'ATT_FILE_CNT', fileCnt);
            grid.setCellValue(rowIdx, 'ATT_FILE_NUM', fileId);
        }

        function setRMK(data) {
            grid.setCellValue(data.rowIdx, "INCO_REASON", data.message);
            grid.setColIconify("INCO_REASON", "INCO_REASON", "comment", false);
        }

	    function doClose() {
			EVF.closeWindow();
        }

    </script>
	<e:window id="CBDI0021" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
		<e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
		<e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
		<e:inputHidden id="VOTE_CNT" name="VOTE_CNT" value="${formData.VOTE_CNT}" />
		<e:inputHidden id="CONT_TYPE1" name="CONT_TYPE1" value="${formData.CONT_TYPE1}" />
		<e:inputHidden id="CONT_TYPE2" name="CONT_TYPE2" value="${formData.CONT_TYPE2}" />
    	<e:inputHidden id="CONT_TYPE3" name="CONT_TYPE3" value="${formData.CONT_TYPE3}" />
    	<e:inputHidden id="BID_STATUS" name="BID_STATUS" value="${formData.BID_STATUS}" />
    	<e:inputHidden id="EI_NUM" name="EI_NUM" value="${formData.EI_NUM}" />

		<%-- 입찰공고 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDI0021_T001 }</div>
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
		</e:searchPanel>

		<%-- 입찰등록결과 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDI0021_T002 }</div>
		</div>
		<e:gridPanel id="grid" name="grid" width="100%" height="305px" gridType="${_gridType}" readOnly="${param.detailView}" />

		<e:buttonBar id="buttonBar" align="right" width="100%" title="${form_CAPTION3_N }">
			<e:button id="BidClose" name="BidClose" label="${BidClose_N }" disabled="${BidClose_D }" visible="${BidClose_V}" onClick="doBidClose" />
			<e:button id="FailBidding" name="FailBidding" label="${FailBidding_N }" disabled="${FailBidding_D }" visible="${FailBidding_V}" onClick="doFailBidding" />
            <e:button id="ReAnn" name="ReAnn" label="${ReAnn_N }" disabled="${ReAnn_D }" visible="${ReAnn_V}" onClick="doReAnn" />
			<e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
		</e:buttonBar>

	</e:window>
</e:ui>